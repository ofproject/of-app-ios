//
//  OFRecruitLeaderController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRecruitLeaderController.h"
#import "OFRecruitLogic.h"
#import "OFCommonCell.h"
#import "OFPoolSettingCell.h"
#import "OFRecruitHeaderView.h"
#import "OFRecruitFooterView.h"
#import "OFWalletChooseView.h"
#import "OFRecruitFinishCell.h"
#import "UIViewController+ChoosePhoto.h"
#import "OFWebViewController.h"
#import "OFMyMiningLogic.h"
#import "OFShareAppView.h"
#import "OFPoolModel.h"

@interface OFRecruitLeaderController ()<OFPoolSettingCellDelegate,recruitFinishCellDelegate,OFRecruitFooterViewDelegate,OFRecruitHeaderViewDelegate,BaseLogicDelegate>

@property (nonatomic, strong) OFRecruitLogic *logic;
@property (nonatomic, strong) OFMyMiningLogic *shareLogic;
@property (nonatomic, strong) OFRecruitHeaderView *headerView;
@property (nonatomic, strong) OFRecruitFooterView *footerView;

@end

@implementation OFRecruitLeaderController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.n_isWhiteStatusBar = YES;
    self.isOpenIQKeyBoardManager = YES;
    self.n_isHiddenNavBar = YES;
    self.tableView.backgroundColor = OF_COLOR_BACKGROUND;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    [self.tableView registerClass:[OFCommonCell class] forCellReuseIdentifier:OFCommonCellReuseIdentifier];
    [self.tableView registerClass:[OFPoolSettingCell class] forCellReuseIdentifier:OFPoolSettingCellReuseIdentifier];
    [self.tableView registerClass:[OFRecruitFinishCell class] forCellReuseIdentifier:OFRecruitFinishCellIdentifier];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

- (void)initData
{
    [self.logic getFristScreen];
    [self.shareLogic getShareInfo];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRefreshWallet object:nil];
}

#pragma mark - Action
- (void)changeLogo:(NSInteger)index
{
    NSLog(@"%ld", index);
    if (index == 1) {
        [self photoChoose];
    }else if (index == 2) {
        [self cameraChoose];
    }
}

- (void)choosePhotoData:(NSData *)imageData
{
    NSLog(@"%@", imageData);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.logic updatePoolLogo:imageData];
}

- (void)showWalletAlert
{
    WEAK_SELF;
    [OFWalletChooseAlert showChooseAlertToView:self.view title:nil callback:^(NSString *walletAddress, NSString *password) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [weakSelf.logic launchPoolWithWalletAddress:walletAddress passphare:[NDataUtil md5:password]];
    }];
}

#pragma mark - 展示分享弹窗
- (void)showShareView{
    if (self.shareLogic.shareInfo) {
        OFSharedModel *model = [[OFSharedModel alloc]init];
        model.sharedType = OFSharedTypeUrl;
        model.urlString = self.shareLogic.shareInfo[@"url"];
        model.thumbImage = IMAGE_NAMED(@"AppIcon");
        model.title = self.shareLogic.shareInfo[@"shareTitle"];
        model.descript = self.shareLogic.shareInfo[@"shareContent"];
        model.cid = self.logic.finishPool.cid;
        OFShareAppView *shareAppView = [OFShareAppView loadFromXib];
        [shareAppView showShareAppViewToView:self.view shareType:1 poolName:self.logic.finishPool.name shareModel:model];
    }else{
        [self.shareLogic getShareInfo];
        [MBProgressHUD showError:@"分享信息拉取失败，请重试"];
    }
}

#pragma mark - BaseLogicDelegate
- (void)requestDataSuccess
{
    [MBProgressHUD hideHUDForView:self.view];
    [self.headerView updateInfo:[self.logic headerInfo] alreadyManager:self.logic.alreadyManager];
    [self.footerView updateInfo:[self.logic finishPool]];
    [self.tableView reloadData];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [MBProgressHUD hideHUDForView:self.view];
    [MBProgressHUD showError:errMessage];
}

#pragma mark - OFRecruitHeaderViewDelegate
- (void)recruitHeaderView:(OFRecruitHeaderView *)headerView didApplyRule:(OFRecruitHeaderViewModel *)model
{
    // 申请规则
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = @"申请规则";
    webVC.urlString = model.applyRuleUrl;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)recruitHeaderViewDidSelectedNavBack:(OFRecruitHeaderView *)headerView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - OFPoolSettingCellDelegate
- (void)settingCell:(OFPoolSettingCell *)settingCell model:(OFPoolSettingModel *)model didEditNickname:(NSString *)nickName
{
    model.detailTitle = nickName;
}

#pragma mark - recruitFinishCellDelegate
- (void)recruitFinishCellEnterPool
{
    NSLog(@"进入矿池");
    [[OFRouter appRouter] routeTo:[OFRouterConfig myPool]];
}

#pragma mark - OFRecruitFooterViewDelegate
- (void)footerViewDidClickProtocol:(OFRecruitFooterView *)footerView
{
    // 领主申请协议
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = @"申请规则";
    webVC.urlString = [self.logic applyProtocolUrl];
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)footerViewDidLanuchPool:(OFRecruitFooterView *)footerView
{
    if(![self.logic checkDataFormat]) return;
    if (![self.logic checkApplyProtocolStatus:[footerView seeAboutProtocolAgreeStatus]]) return;
    [self.view endEditing:YES];
     WEAK_SELF;
    if (KcurUser.community) {
        NSString *message = [NSString stringWithFormat:@"您当前已加入了%@，创建新矿池将自动离开当前矿池。",KcurUser.community.name];
        [self AlertWithTitle:nil message:message andOthers:@[@"我再想想", @"继续创建"] animated:YES action:^(NSInteger index) {
            if (index == 1) {
                [weakSelf showWalletAlert];
            }
        }];
    }else{
        [weakSelf showWalletAlert];
    }
}

- (void)footerViewDidSharePool:(OFRecruitFooterView *)footerView
{
    [self showShareView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.logic numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logic itemCountOfSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.logic itemAtIndex:indexPath];
    if ([model isKindOfClass: [OFPoolSettingModel class]]) {
        OFPoolSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:OFPoolSettingCellReuseIdentifier];
        cell.delegate = self;
        return cell;
    }else if([model isKindOfClass: [OFRecruitFinishCellModel class]]){
        OFRecruitFinishCell *cell = [tableView dequeueReusableCellWithIdentifier:OFRecruitFinishCellIdentifier];
        cell.delegate = self;
        return cell;
    }else {
        OFCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:OFCommonCellReuseIdentifier];
        cell.iconImage.layer.cornerRadius = 5.f;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.logic itemAtIndex:indexPath];
    if ([model isKindOfClass: [OFPoolSettingModel class]]) {
        OFPoolSettingCell *commonCell = (OFPoolSettingCell *)cell;
        [commonCell update:model];
    }else if([model isKindOfClass: [OFRecruitFinishCellModel class]]){
        OFRecruitFinishCell *recruitCell = (OFRecruitFinishCell *)cell;
        [recruitCell updateInfo:model alreadyManager:self.logic.alreadyManager];
    }else {
        OFCommonCell *commonCell = (OFCommonCell *)cell;
        [commonCell update:model];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.logic heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self.logic heightForHeaderAtSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    id model = [self.logic itemAtIndex:indexPath];
    if ([model isKindOfClass: [OFPoolSettingModel class]]){
        OFPoolSettingModel *setting = (OFPoolSettingModel *)model;
        if (setting.type == OFPoolSettingCellTypeName) {
            OFPoolSettingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell becomeResponder];
        }
    }else if ([model isKindOfClass: [OFCommonCellModel class]]) {
        WEAK_SELF;
        [self ActionSheetWithTitle:nil message:nil destructive:nil destructiveAction:nil andOthers:@[@"取消",@"相册",@"相机"] animated:YES action:^(NSInteger index) {
            [weakSelf changeLogo:index];
        }];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - lazy load
- (OFRecruitLogic *)logic
{
    if (!_logic) {
        _logic = [[OFRecruitLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (OFMyMiningLogic *)shareLogic
{
    if (!_shareLogic) {
        _shareLogic = [[OFMyMiningLogic alloc] init];
    }
    return _shareLogic;
}

- (OFRecruitHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[OFRecruitHeaderView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.5)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (OFRecruitFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[OFRecruitFooterView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.5)];
        _footerView.delegate = self;
    }
    return _footerView;
}

@end
