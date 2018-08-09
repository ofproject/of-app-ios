//
//  OFPacketDetailHeaderView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketDetailHeaderView.h"

#define kIconImageWidth KWidthFixed(60.f)

@implementation PacketDetailHeaderModel

@end

@interface OFPacketDetailHeaderView ()

@property (nonatomic, strong) CAShapeLayer *waveLayer;
@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIView *rewardView;
@property (nonatomic, strong) UILabel *reward;
@property (nonatomic, strong) UILabel *unitLabel;
@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UILabel *expiredLabel;

@end

@implementation OFPacketDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRGB:0xf9f9f3];
        [self.layer insertSublayer:self.waveLayer atIndex:0];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.titleLabel.mas_top).offset(-KWidthFixed(15));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.height.mas_equalTo(kIconImageWidth);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.detailLabel.mas_top).offset(-KWidthFixed(15));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.rewardView.mas_top).offset(-KWidthFixed(25));
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.rewardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.rewardView.mas_bottom).offset(-KWidthFixed(14));
        make.height.mas_equalTo(KWidthFixed(20));
        make.centerX.mas_equalTo(self.rewardView.mas_centerX);
    }];
    
    [self.reward mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.tipLabel.mas_top).offset(-KWidthFixed(10));
        make.centerX.mas_equalTo(self.rewardView.mas_centerX);
        make.height.mas_equalTo(KWidthFixed(50));
        make.top.mas_equalTo(self.rewardView.mas_top);
    }];
    
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.reward.mas_bottom);
        make.left.mas_equalTo(self.reward.mas_right).offset(KWidthFixed(10));
    }];
    
    [self.expiredLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-KWidthFixed(6));
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _waveLayer.path = [self loadWavePath].CGPath;
}

- (void)updateLayout:(BOOL)isShowReward isExpired:(BOOL)isExpired
{
    if (isShowReward) {
        self.rewardView.hidden = NO;
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.rewardView.mas_top).offset(-KWidthFixed(5));
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
        
    }else {
        self.rewardView.hidden = YES;
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-KWidthFixed(25));
            make.centerX.mas_equalTo(self.mas_centerX);
        }];
    }
    
    if (isExpired) {
        self.expiredLabel.hidden = NO;
        _expiredLabel.text = @"未领取红包，24小时后自动返回";
    }else {
        self.expiredLabel.hidden = YES;
    }
}

- (void)updateInfo:(PacketDetailHeaderModel *)model isShowReward:(BOOL)isShowReward isExpired:(BOOL)isExpired
{
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.userHeaderUrl] placeholderImage:IMAGE_NAMED(@"mining_miner_icon")];
    self.titleLabel.text = [NSString stringWithFormat:@"%@的OF红包",model.username];
    self.detailLabel.text = model.redPacketDesc;
    self.reward.text = [NSString stringWithFormat:@"%0.3f", model.redPacketAmount.floatValue];
    
    [self updateLayout:isShowReward isExpired:isExpired];
}

#pragma mark - Basic Element
- (UIImageView *)iconImage
{
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kIconImageWidth, kIconImageWidth)];
        _iconImage.contentMode = UIViewContentModeScaleAspectFill;
        _iconImage.layer.cornerRadius = kIconImageWidth * 0.5;
        _iconImage.layer.masksToBounds = YES;
        _iconImage.layer.borderColor = OF_COLOR_WHITE.CGColor;
        _iconImage.layer.borderWidth = 2.f;
        [self addSubview:_iconImage];
    }
    return _iconImage;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixFont(14)
                                   textColor:[UIColor colorWithRGB:0x2f2f2f]
                              textAlignement:NSTextAlignmentCenter
                                        text:@"title"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel= [UILabel labelWithFont:FixFont(11)
                                   textColor:[UIColor colorWithRGB:0x2f2f2f]
                              textAlignement:NSTextAlignmentCenter
                                        text:@"detail"];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

#pragma mark - lazy load
- (CAShapeLayer *)waveLayer
{
    if (!_waveLayer) {
        _waveLayer = [CAShapeLayer layer];
        _waveLayer.fillColor = [UIColor colorWithRGB:0xe25d4c].CGColor;
        _waveLayer.path = [self loadWavePath].CGPath;
    }
    return _waveLayer;
}

- (UIBezierPath *)loadWavePath
{
    CGFloat controlHeight = 40.f;
    CGPoint iconCenter = self.iconImage.center;
    
    CGFloat borderHeight = iconCenter.y - controlHeight;
    CGPoint controlPoint = CGPointMake(iconCenter.x, iconCenter.y + controlHeight);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.width, 0)];
    [path addLineToPoint:CGPointMake(self.width, borderHeight)];
    [path addQuadCurveToPoint:CGPointMake(0, borderHeight) controlPoint:controlPoint];
    [path addLineToPoint:CGPointMake(0, 0)];
    
    return path;
}

- (UIView *)rewardView
{
    if (!_rewardView) {
        _rewardView = [[UIView alloc] init];
        [self addSubview:_rewardView];
    }
    return _rewardView;
}

- (UILabel *)reward
{
    if (!_reward) {
        _reward = [UILabel labelWithFont:FixFont(50) textColor:[UIColor colorWithRGB:0x303030] textAlignement:NSTextAlignmentCenter text:@"0"];
        [self.rewardView addSubview:_reward];
    }
    return _reward;
}

- (UILabel *)unitLabel
{
    if (!_unitLabel) {
        _unitLabel = [UILabel labelWithFont:FixFont(20) textColor:[UIColor colorWithRGB:0x303030] textAlignement:NSTextAlignmentLeft text:@"OF"];
        [self.rewardView addSubview:_unitLabel];
    }
    return _unitLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithFont:FixFont(11) textColor:[UIColor colorWithRGB:0x969696] textAlignement:NSTextAlignmentCenter text:@"已存入钱包, 可直接提现"];
        [self.rewardView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UILabel *)expiredLabel
{
    if (!_expiredLabel) {
        _expiredLabel = [UILabel labelWithFont:FixFont(11) textColor:OF_COLOR_RED textAlignement:NSTextAlignmentCenter text:@"红包已过期，金额已原路返回"];
        _expiredLabel.hidden = YES;
        [self addSubview:_expiredLabel];
    }
    return _expiredLabel;
}

@end
