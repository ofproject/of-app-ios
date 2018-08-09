//
//  OFPoolSettingVC.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/26.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPoolSettingVC.h"
#import "OFBaseCell.h"
#import "OFPoolSettingLogic.h"
#import "OFPoolModel.h"
#import "OFCommonCell.h"
#import "OFPoolSettingCell.h"
#import "OFPoolFundVC.h"
#import "UIViewController+ChoosePhoto.h"
#import "OFPoolAnnounceController.h"

@interface OFPoolSettingVC ()<OFPoolSettingCellDelegate, BaseLogicDelegate>

@property (nonatomic, strong) OFPoolSettingLogic *logic;
@property (nonatomic, strong) UIButton *disband;

@end

@implementation OFPoolSettingVC

- (instancetype)initWithPool:(OFPoolModel *)pool
{
    self = [super init];
    if (self) {
        self.logic.pool = pool;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)initUI
{
    self.title = @"矿池管理";
    [self.tableView registerClass:[OFCommonCell class] forCellReuseIdentifier:OFCommonCellReuseIdentifier];
    [self.tableView registerClass:[OFPoolSettingCell class] forCellReuseIdentifier:OFPoolSettingCellReuseIdentifier];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.disband];
}

- (void)initData
{
    
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
    [self.logic updateCommunityLogo:imageData];
}

- (void)disbandPool
{
    WEAK_SELF;
    NSString *message = [NSString stringWithFormat:@"矿池解散后不可恢复，矿池基金将全部清零，确认要解散%@吗",KcurUser.community.name];
    [self AlertWithTitle:@"提示" message:message andOthers:@[@"我再想想",@"立即解散"] animated:YES action:^(NSInteger index) {
        if (index == 1) {
            [weakSelf.logic disbandCommunityFinished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
                if (success) {
                    [weakSelf.navigationController popToRootViewControllerAnimated:YES];
                }
            }];
        }
    }];
}

#pragma mark - BaseLogicDelegate
- (void)requestDataSuccess
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.tableView reloadData];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [MBProgressHUD showError:errMessage];
}

#pragma mark - OFPoolSettingCellDelegate
- (void)settingCell:(OFPoolSettingCell *)settingCell model:(OFPoolSettingModel *)model didEditNickname:(NSString *)nickName
{
    [self.logic updateCommunityName:nickName];
}

#pragma mark - UITableViewDelegate & DataSource
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
    }else {
        OFCommonCell *commonCell = (OFCommonCell *)cell;
        [commonCell update:model];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.logic heightForRowAtIndexPath:indexPath];
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
        }else if (setting.type == OFPoolSettingCellTypeAnnounce) {
            OFPoolAnnounceController *controller = [[OFPoolAnnounceController alloc] initWithLogic:self.logic];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if ([model isKindOfClass: [OFCommonCellModel class]]) {
        OFCommonCellModel *common = (OFCommonCellModel *)model;
        if ([common.target isEqualToString:@"OFPoolFundVC"]) {
            OFPoolFundVC *controller = [[OFPoolFundVC alloc] initWithLogic:self.logic];
            [self.navigationController pushViewController:controller animated:YES];
        }else if([common.target isEqualToString:@"OFPoolLogo"]) {
            WEAK_SELF;
            [self ActionSheetWithTitle:nil message:nil destructive:nil destructiveAction:nil andOthers:@[@"取消",@"相册",@"相机"] animated:YES action:^(NSInteger index) {
                [weakSelf changeLogo:index];
            }];
        }
    }
}

#pragma mark - lazy load
- (OFPoolSettingLogic *)logic
{
    if (!_logic) {
        _logic = [[OFPoolSettingLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (UIButton *)disband
{
    if (!_disband) {
        _disband = [UIButton buttonWithTitle:@"解散矿池" titleColor:OF_COLOR_DETAILTITLE backgroundColor:[UIColor colorWithRGB:0xd0d0d0] font:FixFont(15) target:self action:@selector(disbandPool)];
        CGRect frame = CGRectMake(kScreenWidth * 0.2, kScreenHeight * 0.75, kScreenWidth * 0.6, KWidthFixed(40));
        _disband.frame = frame;
        _disband.layer.cornerRadius = 5.f;
        _disband.layer.masksToBounds = YES;
    }
    return _disband;
}

@end
