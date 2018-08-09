//
//  OFPoolFundVC.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/26.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPoolFundVC.h"
#import "OFBonusView.h"
#import "OFPoolSettingLogic.h"
#import "OFPoolBonusListController.h"

@interface OFPoolFundVC ()<OFBonusViewDelegate>

@property (nonatomic, strong) OFPoolSettingLogic *logic;
@property (nonatomic, strong) OFBonusView *bonusView;

@end

@implementation OFPoolFundVC

- (instancetype)initWithPool:(OFPoolModel *)pool
{
    self = [super init];
    if (self) {
        self.logic.pool = pool;
    }
    return self;
}

- (instancetype)initWithLogic:(OFPoolSettingLogic *)logic
{
    self = [super init];
    if (self) {
        self.logic = logic;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.title = @"基金分红";
    [self addNavigationItemWithTitles:@[@"分红记录"] isLeft:NO target:self action:@selector(bonusRecord) tags:nil];
    
    [self.bonusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

- (void)initData
{
    [self.bonusView updateFundInfo:self.logic.pool];
}

#pragma mark - OFBonusViewDelegate
- (void)bonusViewSaveSetting:(OFBonusView *)bonusView bonusPercentage:(NSString *)bonusPercentage
{
    WEAK_SELF;
    [self.logic updateCommunityBonusPercentage:bonusPercentage finish:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
}

#pragma mark - Action
- (void)bonusRecord
{
    NSLog(@"基金分红");
    OFPoolBonusListController *controller = [[OFPoolBonusListController alloc] initWithPool:self.logic.pool];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - lazy load
- (OFPoolSettingLogic *)logic
{
    if (!_logic) {
        _logic = [[OFPoolSettingLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (OFBonusView *)bonusView
{
    if (!_bonusView) {
        _bonusView = [[OFBonusView alloc] initWithFrame: CGRectZero];
        _bonusView.bonusDelegate = self;
        [self.view addSubview:_bonusView];
    }
    return _bonusView;
}

@end
