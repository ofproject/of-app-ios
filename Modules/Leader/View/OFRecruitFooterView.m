//
//  OFRecruitFooterView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRecruitFooterView.h"
#import "OFPoolModel.h"

#define kMargin_Border  KWidthFixed(15)
#define KMargin_Top     KWidthFixed(18)

@interface OFRecruitFooterView ()

@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *protocolBtn;
@property (nonatomic, strong) UIButton *poolButton;

@end

@implementation OFRecruitFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupLayout];
    }
    return self;
}

- (void)updateInfo:(OFPoolModel *)pool
{
    if (pool) {
        [self.poolButton setTitle:@"邀请好友加入矿池" forState:UIControlStateNormal];
        self.agreeBtn.hidden = YES;
        self.protocolBtn.hidden = YES;
    }else {
        [self.poolButton setTitle:@"启动矿池" forState:UIControlStateNormal];
        self.agreeBtn.hidden = NO;
        self.protocolBtn.hidden = NO;
    }
}

- (void)setupLayout
{
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(KMargin_Top);
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Border);
        make.width.mas_equalTo(KWidthFixed(40));
    }];
    
    [self.protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agreeBtn.mas_right);
        make.centerY.mas_equalTo(self.agreeBtn.mas_centerY);
    }];
    
    [self.poolButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(kScreenWidth * 0.6);
        make.height.mas_equalTo(KWidthFixed(40));
    }];
}

#pragma mark - Action
- (void)agreeProtocol
{
    _agreeBtn.selected = !_agreeBtn.selected;
}

- (void)protocolClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(footerViewDidClickProtocol:)]) {
        [self.delegate footerViewDidClickProtocol:self];
    }
}

- (void)poolLaunch
{
    if (self.protocolBtn.hidden) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(footerViewDidSharePool:)]) {
            [self.delegate footerViewDidSharePool:self];
        }
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(footerViewDidLanuchPool:)]) {
            [self.delegate footerViewDidLanuchPool:self];
        }
    }
}

#pragma mark - 查询
- (BOOL)seeAboutProtocolAgreeStatus
{
    return self.agreeBtn.selected;
}

#pragma mark - lazy load
- (UIButton *)agreeBtn
{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithTitle:@"同意" titleColor:OF_COLOR_DETAILTITLE backgroundColor:nil font:FixFont(13) target:self action:@selector(agreeProtocol)];
        [_agreeBtn setImage:IMAGE_NAMED(@"leader_recruit_normal") forState:UIControlStateNormal];
        [_agreeBtn setImage:IMAGE_NAMED(@"leader_recruit_selected") forState:UIControlStateSelected];
        [_agreeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, -5)];
        [_agreeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        _agreeBtn.selected = YES;
        [self addSubview:_agreeBtn];
    }
    return _agreeBtn;
}

- (UIButton *)protocolBtn
{
    if (!_protocolBtn) {
        _protocolBtn = [UIButton buttonWithTitle:@"《OF领主协议》" titleColor:OF_COLOR_MAIN_THEME backgroundColor:nil font:FixFont(13) target:self action:@selector(protocolClick)];
        [self addSubview:_protocolBtn];
    }
    return _protocolBtn;
}

- (UIButton *)poolButton
{
    if (!_poolButton) {
        _poolButton = [UIButton buttonWithTitle:@"启动矿池" titleColor:OF_COLOR_WHITE backgroundColor:nil font:FixFont(15) target:self action:@selector(poolLaunch)];
        _poolButton.layer.cornerRadius = 5.f;
        _poolButton.layer.masksToBounds = YES;
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_poolButton setBackgroundImage:image forState:UIControlStateNormal];
        [self addSubview:_poolButton];
    }
    return _poolButton;
}

@end
