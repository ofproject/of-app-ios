//
//  OFMyPoolNavView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFMyPoolNavView.h"
#import "OFPoolModel.h"

#define kNavBack_Width      KWidthFixed(20.f)
#define kMargin_Left        KWidthFixed(31.f)
#define kMargin_Bottom      KWidthFixed(15.f);
#define kSubview_Spacing_1  KWidthFixed(11.f)
#define kSubview_Spacing_2  KWidthFixed(5.f)

@interface OFMyPoolNavView ()
{
    OFPoolModel *_pool;
}
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *poolButton;
@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIView *seperator;

@end

@implementation OFMyPoolNavView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.backView];
        [self addSubview:self.backButton];
        [self addSubview:self.poolButton];
        [self addSubview:self.settingButton];
        [self.backView addSubview:self.titleLabel];
        [self.backView addSubview:self.seperator];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kSubview_Spacing_1);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kSubview_Spacing_1);
        make.width.mas_equalTo(kNavBack_Width);
        make.height.mas_equalTo(kNavBack_Width);
    }];
    
    [_poolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-KWidthFixed(15));
    }];
    
    [self.settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.backButton.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-KWidthFixed(15));
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(kSubview_Spacing_1 * 4);
        make.right.mas_equalTo(self.backView.mas_right).offset(-kSubview_Spacing_1 * 4);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-kSubview_Spacing_1);
    }];
    
    [_seperator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left);
        make.right.mas_equalTo(self.backView.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)setPoolModel:(OFPoolModel *)model
{
    _pool = model;
    self.titleLabel.text = model.name;
    if ([OFPoolModel isManagedPool:model]) {
        self.poolButton.hidden = YES;
        self.settingButton.hidden = NO;
    }else {
        self.poolButton.hidden = NO;
        self.settingButton.hidden = YES;
        if ([OFPoolModel isMyPool:model]) {
            [self.poolButton setTitle:@"退出矿池" forState:UIControlStateNormal];
        }else {
            [self.poolButton setTitle:@"加入矿池" forState:UIControlStateNormal];
        }
    }
}

- (void)updateScrollViewContentOffSet:(CGFloat)offset range:(CGFloat)range
{
    if (offset <= 0) {
        self.backView.hidden = YES;
        self.backView.alpha = 0.f;
        [self.backButton setTintColor:OF_COLOR_WHITE];
        [self.poolButton setTintColor:OF_COLOR_WHITE];
        [self.settingButton setTintColor:OF_COLOR_WHITE];
    }else if (offset <= range){
        self.backView.hidden = NO;
        self.backView.alpha = offset / range;
        CGFloat rate = 1 - offset / range;
        UIColor *tint = [UIColor colorWithRed:rate green:rate blue:rate alpha:1];
        [self.backButton setTintColor:tint];
        [self.poolButton setTintColor:tint];
        [self.settingButton setTintColor:tint];
    }else {
        self.backView.hidden = NO;
        self.backView.alpha = 1.f;
        [self.backButton setTintColor:OF_COLOR_BLACK];
        [self.poolButton setTintColor:OF_COLOR_BLACK];
        [self.settingButton setTintColor:OF_COLOR_BLACK];
    }
}

#pragma mark - action
- (void)backNavigation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navViewDidSelectedNavBack:)]) {
        [self.delegate navViewDidSelectedNavBack:self];
    }
}

- (void)poolJoinOrQuit
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navView:isQuit:)]) {
        [self.delegate navView:self isQuit:[OFPoolModel isMyPool:_pool]];
    }
}

- (void)poolSetting
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(navViewDidSelectedSetting:)]) {
        [self.delegate navViewDidSelectedSetting:self];
    }
}

#pragma mark - lazy load
- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
        _backView.backgroundColor = OF_COLOR_WHITE;
        _backView.hidden = YES;
    }
    return _backView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixBoldFont(16)
                                   textColor:OF_COLOR_TITLE textAlignement:NSTextAlignmentCenter text:@"title"];
    }
    return _titleLabel;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithTitle:nil
                                     titleColor:OF_COLOR_WHITE
                                backgroundColor:OF_COLOR_CLEAR
                                           font:FixFont(10)];
        UIImage *image = [IMAGE_NAMED(@"nav_back_normal") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_backButton setImage:image forState: UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backNavigation) forControlEvents:UIControlEventTouchUpInside];
        [_backButton setTintColor:OF_COLOR_WHITE];
    }
    return _backButton;
}

- (UIButton *)poolButton
{
    if (!_poolButton) {
        _poolButton = [UIButton buttonWithTitle:@"poolButton" titleColor:OF_COLOR_WHITE backgroundColor:OF_COLOR_CLEAR font:FixFont(15)];
        [_poolButton addTarget:self action:@selector(poolJoinOrQuit) forControlEvents:UIControlEventTouchUpInside];
        [_poolButton setTintColor:OF_COLOR_WHITE];
    }
    return _poolButton;
}

- (UIButton *)settingButton
{
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *image = [IMAGE_NAMED(@"mining_mypool_setting") imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_settingButton setImage:image forState: UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(poolSetting) forControlEvents:UIControlEventTouchUpInside];
        [_settingButton setTintColor:OF_COLOR_WHITE];
    }
    return _settingButton;
}

- (UIView *)seperator
{
    if (!_seperator) {
        _seperator = [[UIView alloc] init];
        _seperator.backgroundColor = OF_COLOR_MINOR;
    }
    return _seperator;
}

@end
