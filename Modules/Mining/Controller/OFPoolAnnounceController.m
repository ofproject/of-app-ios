//
//  OFPoolAnnounceController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPoolAnnounceController.h"
#import "OFPoolSettingLogic.h"
#import "OFPoolModel.h"
#import <YYKit/YYTextView.h>

#define kMargin_Border KWidthFixed(17)

@interface OFPoolAnnounceController ()<YYTextViewDelegate>

@property (nonatomic, strong) OFPoolSettingLogic *logic;

@property (nonatomic, strong) UIButton *navItem;

@property (nonatomic, strong) UIView *poolInfoView;
@property (nonatomic, strong) UIImageView *poolLogo;
@property (nonatomic, strong) UILabel *poolLeader;
@property (nonatomic, strong) UILabel *poolTime;
@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) YYTextView *textView;

@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation OFPoolAnnounceController

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
    self.title = @"公告消息";
    
    NSArray *items = [self addNavigationItemWithTitles:@[@"发布"] isLeft:NO target:self action:@selector(changeAnnounce) tags:nil];
    _navItem = items.firstObject;
    
    [self.poolInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(KWidthFixed(100));
    }];
    
    [self.poolLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWidthFixed(50));
        make.height.mas_equalTo(KWidthFixed(50));
        make.centerY.mas_equalTo(self.poolInfoView.mas_centerY);
        make.left.mas_equalTo(self.poolInfoView.mas_left).offset(kMargin_Border);
    }];
    
    [self.poolLeader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.poolLogo.mas_right).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.poolLogo.mas_centerY).offset(-KWidthFixed(15));
    }];
    
    [self.poolTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.poolLogo.mas_right).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.poolLogo.mas_centerY).offset(KWidthFixed(15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.poolInfoView.mas_left);
        make.bottom.mas_equalTo(self.poolInfoView.mas_bottom);
        make.right.mas_equalTo(self.poolInfoView.mas_right);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Border);
        make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Border);
        make.top.mas_equalTo(self.poolInfoView.mas_bottom).offset(KWidthFixed(30));
        make.height.mas_equalTo(KWidthFixed(200));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-KWidthFixed(50));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
}

- (void)updateLayout
{
    if ([OFPoolModel isManagedPool:self.logic.pool]) {
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).offset(KWidthFixed(30));
            make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Border);
            make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Border);
            make.height.mas_equalTo(KWidthFixed(200));
        }];
    }else {
        [self.textView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.poolInfoView.mas_bottom).offset(KWidthFixed(30));
            make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Border);
            make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Border);
            make.height.mas_equalTo(KWidthFixed(200));
        }];
    }
}

- (void)initData
{
    if (!self.logic.pool) {
        self.logic.pool = KcurUser.community;
    }
    [self.poolLogo sd_setImageWithURL: [NSURL URLWithString:self.logic.pool.logoUrl] placeholderImage:IMAGE_NAMED(@"mining_miner_icon")];
    self.poolLeader.text = self.logic.pool.managerName;
    self.poolTime.text = self.logic.pool.announcementPublishTime;
    self.textView.text = self.logic.pool.announcement;
    if ([OFPoolModel isManagedPool:self.logic.pool]) {
        self.textView.userInteractionEnabled = YES;
        [self.textView becomeFirstResponder];
        _navItem.hidden = NO;
        self.poolInfoView.hidden = YES;
        self.rightLabel.hidden = YES;
    }else {
        self.textView.userInteractionEnabled = NO;
        _navItem.hidden = YES;
        self.poolInfoView.hidden = NO;
        self.rightLabel.hidden = NO;
    }
    [self updateLayout];
    [self updateNavItemStatus];
    [self updateManagerInfo];
}

- (void)updateNavItemStatus
{
    NSString *tempText = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tempText.length > 0 && KcurUser.isPoolManager) {
        _navItem.hidden = NO;
    }else {
        _navItem.hidden = YES;
    }
}

- (void)updateManagerInfo
{
    WEAK_SELF;
    [self.logic getManagerInfoFinish:^(BOOL success, OFUserModel *obj, NSError *error, NSString *messageStr) {
        if (success) {
            [weakSelf.poolLogo sd_setImageWithURL: [NSURL URLWithString:obj.profileUrl] placeholderImage:IMAGE_NAMED(@"mining_miner_icon")];
        }
    }];
}

#pragma mark - Action
- (void)changeAnnounce
{
    NSString *tempText = [self.textView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (tempText.length < 1) {
        [MBProgressHUD showToast:@"请先编辑公告" toView:[JumpUtil currentVC].view];
        return;
    }
    WEAK_SELF;
    [self.logic updateCommunityAnnouncement:self.textView.text finish:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
            [MBProgressHUD showToast:messageStr toView:weakSelf.view];
        }
    }];
}

#pragma mark - YYTextViewDelegate
- (void)textViewDidChange:(YYTextView *)textView
{
    [self updateNavItemStatus];
}

#pragma mark - lazy load

- (OFPoolSettingLogic *)logic
{
    if (!_logic) {
        _logic = [[OFPoolSettingLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (UIView *)poolInfoView
{
    if (!_poolInfoView) {
        _poolInfoView = [[UIView alloc] init];
        [self.view addSubview:_poolInfoView];
    }
    return _poolInfoView;
}

- (UIImageView *)poolLogo
{
    if (!_poolLogo) {
        _poolLogo = [[UIImageView alloc] init];
        _poolLogo.layer.cornerRadius = 5.f;
        _poolLogo.layer.masksToBounds = YES;
        [self.poolInfoView addSubview:_poolLogo];
    }
    return _poolLogo;
}

- (UILabel *)poolLeader
{
    if (!_poolLeader) {
        _poolLeader = [UILabel labelWithFont:FixFont(15) textColor:OF_COLOR_DETAILTITLE textAlignement:NSTextAlignmentLeft text:@"leader"];
        [self.poolInfoView addSubview:_poolLeader];
    }
    return _poolLeader;
}

- (UILabel *)poolTime
{
    if (!_poolTime) {
        _poolTime = [UILabel labelWithFont:FixFont(12) textColor:OF_COLOR_MINOR textAlignement:NSTextAlignmentLeft text:@"time"];
        [self.poolInfoView addSubview:_poolTime];
    }
    return _poolTime;
}

- (UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = OF_COLOR_SEPARATOR;
        [self.poolInfoView addSubview:_line];
    }
    return _line;
}

- (YYTextView *)textView
{
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.font = FixFont(15);
        _textView.textColor = OF_COLOR_TITLE;
        _textView.placeholderText = @"暂无公告信息";
        _textView.placeholderTextColor = OF_COLOR_DETAILTITLE;
        _textView.delegate = self;
        [self.view addSubview:_textView];
    }
    return _textView;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel labelWithFont:FixFont(12) textColor:OF_COLOR_MINOR textAlignement:NSTextAlignmentCenter text:@""];
        _rightLabel.text = @"──────   仅领主可编辑   ──────";
        [self.view addSubview:_rightLabel];
    }
    return _rightLabel;
}

@end
