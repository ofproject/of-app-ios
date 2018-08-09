//
//  OFPacketSendController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketSendController.h"
#import "OFPacketWalletCell.h"
#import "OFPacketEditCell.h"
#import "OFPacketEditNameCell.h"
#import "OFPacketSendLogic.h"
#import "OFPacketSendFooterView.h"
#import "OFPacketPayController.h"
#import "OFRedPacketPasswordAlert.h"
//#import "OFRedPacket_sendView.h"
#import "OFShareManager.h"
#import "OFPacketPayModel.h"
#import "OFRedPacketController.h"
#import "OFMiningInfoModel.h"


@interface OFPacketSendController ()<OFPacketSendFooterViewDelegate, OFPacketSendLogicDelegate, PacketPayControllerDelegate>

@property (nonatomic, strong) OFPacketSendLogic *logic;
@property (nonatomic, strong) OFPacketSendFooterView *footerView;
@property (nonatomic, assign) BOOL canSendPacket;
@property (nonatomic, assign) BOOL isNeedAutoKeyboard;//是否自动适配键盘

@end

@implementation OFPacketSendController

- (instancetype)initWithReward:(RewardModel *)reward
{
    self = [super init];
    if (self) {
        self.logic.rewardModel = reward;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
    [self addNoti];
}

- (void)initUI
{
    [self addNavigationItemWithTitles:@[@"取消"] isLeft:YES target:self action:@selector(returnBack) tags:nil];
    [self addNavigationItemWithTitles:@[@"红包记录"] isLeft:NO target:self action:@selector(gotoPacketList) tags:nil];
    self.isNeedAutoKeyboard = YES;
    self.n_isPop = NO;//这时候就不要让他侧滑返回了
    self.isOpenIQKeyBoardManager = NO;
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.backgroundColor = OF_COLOR_BACKGROUND;
    [self.tableView registerClass:[OFPacketWalletCell class] forCellReuseIdentifier:OFPacketWalletCellIdentifier];
    [self.tableView registerClass:[OFPacketEditCell class] forCellReuseIdentifier:OFPacketEditCellIdentifier];
    [self.tableView registerClass:[OFPacketEditNameCell class] forCellReuseIdentifier:OFPacketEditNameCellIdentifier];
    [self.view addSubview:self.tableView];
}

- (void)initData
{
    self.title = @"发红包";
    self.canSendPacket = YES;
    [self.logic getConfigInfo];
}

#pragma mark - 添加键盘内容改变通知
- (void)addNoti{
    //    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    if (self.isNeedAutoKeyboard == NO) {
        return;
    }
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect f = [self.footerView convertRect:self.footerView.sendBtn.frame toView:self.view];
    
    CGFloat top = self.view.height - (f.origin.y + f.size.height) - keyBoardFrame.size.height + Nav_Height;
    if (top > 0) return;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.top = top;
    }];
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    if (self.isNeedAutoKeyboard == NO) {
        return;
    }
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect f = [self.footerView convertRect:self.footerView.sendBtn.frame toView:self.view];
    
    CGFloat top = self.view.height - (f.origin.y + f.size.height) - keyBoardFrame.size.height;
    if (top > 0) return;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.top = Nav_Height;
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - Action
- (void)popBackController:(BOOL)animated
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(packetSendPopBack)]) {
        [self.delegate packetSendPopBack];
    }
    [self.navigationController popViewControllerAnimated:animated];
}

- (void)gotoPacketList
{
    OFRedPacketController *controller = [[OFRedPacketController alloc] initWithReward:self.logic.rewardModel.redPacketReward.stringValue];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - OFPacketSendFooterViewDelegate
- (void)packetSendFooterDidSelectedSend:(OFPacketSendFooterView *)footer
{
    [self.view endEditing:YES];
    // 发红包
    NSLog(@"发红包");
    if (![self.logic checkEditInfo]) return;
    if (![self.logic needPayPassphare] && self.canSendPacket) {
        self.canSendPacket = NO;
        [self.logic sendRedPacket:@""];
        return;
    }
    
    WEAK_SELF;
    [OFRedPacketPasswordAlert showPasswordAlertToView:self.view callback:^(NSString *password) {
        NSLog(@"%@",password);
        if (weakSelf.canSendPacket) {
            weakSelf.canSendPacket = NO;
            [weakSelf.logic sendRedPacket:password];
        }
    }];
}

#pragma mark - PacketPayControllerDelegate
- (void)packetPayControllerChooseWallet:(OFWalletModel *)wallet
{
    [self.logic updateWalletInfo:wallet];
}

#pragma mark - OFPacketSendLogicDelegate
- (void)requestDataSuccess
{
    [self.tableView reloadData];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [MBProgressHUD showError:errMessage];
}

- (void)redPacketCreateSuccess:(OFSharedModel *)model title:(NSString *)title detailText:(NSString *)detail packet:(OFRedPacketModel *)packet
{
    self.canSendPacket = YES;
     WEAK_SELF;
    [OFShareManager sharedToWeChatWithModel:model controller:weakSelf selected:^(OFSharedWay shareWay) {
        [weakSelf.logic resetInputInfo];
    } completed:^(OFSharedWay shareWay, bool isSuccess) {
        [weakSelf popBackController:NO];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(packetSendControlerToDetail:)]) {
            [weakSelf.delegate packetSendControlerToDetail:packet];
        }
    }];
}

- (void)redPacketCreateFailure:(NSString *)message
{
    self.canSendPacket = YES;
    [MBProgressHUD showError:message];
}

-(void)redPacketCreateFailureWithLastIsNoOK:(NSString *)message{
    WEAK_SELF;
    [self AlertWithTitle:@"提示" message:message andOthers:@[@"确定"] animated:YES action:^(NSInteger index) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)requestRedPacketRewardSuccess
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
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
    UITableViewCell *cell = nil;
    if ([model isKindOfClass: OFPacketEditModel.class]) {
        cell = [tableView dequeueReusableCellWithIdentifier:OFPacketEditCellIdentifier];
    }else if([model isKindOfClass:OFPacketPayModel.class]){
        cell = [tableView dequeueReusableCellWithIdentifier:OFPacketWalletCellIdentifier];
    }else if([model isKindOfClass:OFPacketEditNameModel.class]){
        cell = [tableView dequeueReusableCellWithIdentifier:OFPacketEditNameCellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.logic itemAtIndex:indexPath];
    if ([cell respondsToSelector:@selector(updateInfo:)]) {
        [cell performSelector:@selector(updateInfo:) withObject:model];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.logic heightForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.footerView.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self.logic itemAtIndex:indexPath];
    if ([model isKindOfClass: OFPacketEditModel.class]) {
        OFPacketEditCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == 1) {
            self.isNeedAutoKeyboard = NO;
        }else{
            self.isNeedAutoKeyboard = YES;
        }
        [cell becomeResponder];
    }else if([model isKindOfClass:OFPacketPayModel.class]){
        OFPacketPayController *controller = [[OFPacketPayController alloc] initWithMinRedPacketAmount:self.logic.minRedPacketAmount];
        controller.delegate = self;
        [self.navigationController pushViewController:controller animated:YES];
    }else if([model isKindOfClass:OFPacketEditNameModel.class]){
        OFPacketEditNameCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.isNeedAutoKeyboard = YES;
        [cell becomeResponder];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - lazy load
- (OFPacketSendLogic *)logic
{
    if (!_logic) {
        _logic = [[OFPacketSendLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (OFPacketSendFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[OFPacketSendFooterView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KWidthFixed(200))];
        _footerView.delegate = self;
    }
    return _footerView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
