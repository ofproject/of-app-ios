//
//  OFRecruitHeaderView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRecruitHeaderView.h"

#define kMargin_Top (kStatusBar_Height + KWidthFixed(10))

@implementation OFRecruitHeaderViewModel

@end

@interface OFRecruitHeaderView ()
{
    OFRecruitHeaderViewModel *_model;
}
@property (nonatomic, strong) UIImageView *backImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIImageView *miners;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *ruleBtn;

@end

@implementation OFRecruitHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout
{
    [self.backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-KWidthFixed(20));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(KWidthFixed(20));
    }];
    
    [self.miners mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(KWidthFixed(13));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kMargin_Top);
        make.left.mas_equalTo(self.mas_left).offset(KWidthFixed(10));
        make.height.mas_equalTo(self.ruleBtn.mas_height);
    }];
    
    [self.ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(kMargin_Top);
        make.right.mas_equalTo(self.mas_right).offset(-KWidthFixed(10));
    }];
}

- (void)updateInfo:(OFRecruitHeaderViewModel *)model alreadyManager:(BOOL)alreadyManager
{
    _model = model;
    if (model.communityCount.length < 1 || alreadyManager) {
        _detailLabel.hidden = YES;
    }else {
        _detailLabel.hidden = YES;
        NSString *text = [NSString stringWithFormat:@"当前有%@名矿工参与领主招募", model.communityCount];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
        NSRange range = [[attrText string] rangeOfString:model.communityCount];
        [attrText addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:range];
        _detailLabel.attributedText = attrText;
    }
    
}

#pragma mark - Action
- (void)backNavigation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recruitHeaderViewDidSelectedNavBack:)]) {
        [self.delegate recruitHeaderViewDidSelectedNavBack:self];
    }
}

- (void)applyRule
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recruitHeaderView:didApplyRule:)]) {
        [self.delegate recruitHeaderView:self didApplyRule:_model];
    }
}

#pragma mark - lazy load
- (UIImageView *)backImage
{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] initWithImage: IMAGE_NAMED(@"leader_background")];
        _backImage.contentMode = UIViewContentModeScaleAspectFill;
        _backImage.layer.masksToBounds = YES;
        [self addSubview:_backImage];
    }
    return _backImage;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixFont(30)
                                   textColor:[UIColor colorWithRGB:0xf5f6f8]
                              textAlignement:NSTextAlignmentCenter
                                        text:@"领主招募令"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:FixFont(12) textColor:[UIColor colorWithRGB:0xf5f6f8] textAlignement:NSTextAlignmentCenter text:@"当前有700名矿工参与领主招募"];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

- (UIImageView *)miners
{
    if (!_miners) {
        _miners = [[UIImageView alloc] initWithImage: IMAGE_NAMED(@"leader_miners")];
        [self addSubview:_miners];
    }
    return _miners;
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
        [self addSubview:_backButton];
    }
    return _backButton;
}

- (UIButton *)ruleBtn
{
    if (!_ruleBtn) {
        _ruleBtn = [UIButton buttonWithTitle:@"规则" titleColor:[UIColor colorWithRGB:0xf5f6f8] backgroundColor:nil font:FixFont(14)];
        [_ruleBtn addTarget:self action:@selector(applyRule) forControlEvents:UIControlEventTouchUpInside];
        _ruleBtn.hidden = YES;
        [self addSubview:_ruleBtn];
    }
    return _ruleBtn;
}

@end
