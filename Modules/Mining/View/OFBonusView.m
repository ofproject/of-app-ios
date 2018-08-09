//
//  OFBonusView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBonusView.h"
#import "NSlider.h"
#import "OFPoolModel.h"

#define kMargin_Border  KWidthFixed(15.f)
#define kMargin_Top     KWidthFixed(30.f)
#define kButton_Height  KWidthFixed(40.f)

@interface OFBonusView ()
{
    OFPoolModel *_pool;
}
@property (nonatomic, strong) UILabel *fundTip;
@property (nonatomic, strong) UILabel *fundNum;

@property (nonatomic, strong) UIView *separator;

@property (nonatomic, strong) UILabel *bonusTip;
@property (nonatomic, strong) UILabel *bonusScale;
@property (nonatomic, strong) NSlider *slider;
@property (nonatomic, strong) UIView *sliderCenter;
@property (nonatomic, strong) UILabel *miner;
@property (nonatomic, strong) UILabel *minerBonusScale;
@property (nonatomic, strong) UILabel *leader;
@property (nonatomic, strong) UILabel *leaderBonusScale;

@property (nonatomic, strong) UILabel *declare;

@property (nonatomic, strong) UIButton *save;
@property (nonatomic, strong) UILabel *rightLabel;

@end

@implementation OFBonusView

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
    [self.fundTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Border);
        make.top.mas_equalTo(self.mas_top).offset(kMargin_Top);
    }];
    
    [self.fundNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fundTip.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-kMargin_Border);
    }];
    
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Border);
        make.top.mas_equalTo(self.fundTip.mas_bottom).offset(kMargin_Top);
        make.right.mas_equalTo(self.mas_right).offset(-kMargin_Border);
        make.width.mas_equalTo(kScreenWidth - kMargin_Border * 2);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.bonusTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Border);
        make.top.mas_equalTo(self.separator.mas_bottom).offset(kMargin_Top);
    }];
    
    [self.bonusScale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bonusTip.mas_right).offset(kMargin_Border * 0.5);
        make.top.mas_equalTo(self.separator.mas_bottom).offset(kMargin_Top);
    }];
    
    [self.sliderCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWidthFixed(1));
        make.height.mas_equalTo(KWidthFixed(3));
        make.centerX.mas_equalTo(self.slider.mas_centerX);
        make.centerY.mas_equalTo(self.slider.mas_centerY).offset(-KWidthFixed(1));
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Border * 2.5);
        make.right.mas_equalTo(self.mas_right).offset(-kMargin_Border * 2.5);
        make.top.mas_equalTo(self.bonusTip.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(40);
    }];
    
    [self.miner mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.slider.mas_left);
        make.top.mas_equalTo(self.slider.mas_bottom).offset(kMargin_Top);
    }];
    
    [self.minerBonusScale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.miner.mas_centerY);
        make.left.mas_equalTo(self.miner.mas_right).offset(KWidthFixed(5));
    }];
    
    [self.leader mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.slider.mas_right).offset(-KWidthFixed(30.f));
        make.top.mas_equalTo(self.slider.mas_bottom).offset(kMargin_Top);
    }];
    
    [self.leaderBonusScale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.slider.mas_right);
        make.top.mas_equalTo(self.slider.mas_bottom).offset(kMargin_Top);
    }];
    
    [self.declare mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.leader.mas_bottom).offset(kMargin_Top * 2);
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Border);
        make.right.mas_equalTo(self.mas_right).offset(-kMargin_Border);
    }];
    
    [self.save mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.declare.mas_bottom).offset(KWidthFixed(100));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(kScreenWidth * 0.6);
        make.height.mas_equalTo(KWidthFixed(41.f));
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.declare.mas_bottom).offset(0);
        make.bottom.mas_equalTo(self.mas_bottom).offset(0);
    }];
}

- (void)updateFundInfo:(OFPoolModel *)pool
{
    _pool = pool;
    self.fundNum.text = [NSString stringWithFormat:@"%.3f OF",pool.originReward.doubleValue];
    NSString *percentage = [NSString stringWithFormat:@"%.0f", pool.minBonusPercentage * 100];
    if ([percentage isEqualToString:@"0"]) {
        self.bonusScale.hidden = YES;
    }else {
        self.bonusScale.hidden = NO;
        self.bonusScale.text = [NSString stringWithFormat:@"(最低%@%%)",percentage];
    }
    
    [_slider setValue:pool.bonusPercentage];
    [self setNum:_slider.value];
    
    _declare.attributedText = [pool.communityBonusDesc getAttributedStringWithLineSpace:8.f kern:0.f];
 
    if ([OFPoolModel isManagedPool:pool]) {
        _slider.userInteractionEnabled = YES;
        [_slider setMinimumTrackTintColor:[UIColor colorWithRGB:0xffa040]];
        [_slider setMaximumTrackTintColor:[[UIColor colorWithRGB:0x0d0408] colorWithAlphaComponent:0.35]];
        _save.hidden = NO;
        _rightLabel.hidden = YES;
    }else {
        _slider.userInteractionEnabled = NO;
        [_slider setMinimumTrackTintColor:[[UIColor colorWithRGB:0x0d0408] colorWithAlphaComponent:0.35]];
        [_slider setMaximumTrackTintColor:[[UIColor colorWithRGB:0x0d0408] colorWithAlphaComponent:0.35]];
        _save.hidden = YES;
        _rightLabel.hidden = NO;
        
        [self layoutIfNeeded];
        
        double bottom = kScreenHeight -Nav_Height - self.contentSize.height - KWidthFixed(55);
        if (bottom>KWidthFixed(40)) {
            [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.declare.mas_bottom).offset(bottom);
                make.bottom.mas_equalTo(self.mas_bottom).offset(- KWidthFixed(55));
            }];
        }else{
            [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.declare.mas_bottom).offset(KWidthFixed(40));
                make.bottom.mas_equalTo(self.mas_bottom).offset(- KWidthFixed(55));
            }];
        }
        
    }
    
}

#pragma mark - Action
- (void)saveSetting
{
    if (self.bonusDelegate && [self.bonusDelegate respondsToSelector:@selector(bonusViewSaveSetting:bonusPercentage:)]) {
        NSString *percentage = [NSString stringWithFormat:@"%.2f",self.slider.value];
        [self.bonusDelegate bonusViewSaveSetting:self bonusPercentage:percentage];
    }
}

#pragma mark - UISlider 代理
- (void) sliderTouchBegin:(UISlider *)sender
{
    [self setNum:sender.value];
}

- (void) sliderValueChanged:(UISlider *)sender
{
    if (sender.value <= _pool.minBonusPercentage) {
        [sender setValue:_pool.minBonusPercentage];
    }
    if (sender.value >= _pool.maxBonusPercentage) {
        [sender setValue:_pool.maxBonusPercentage];
    }
    [self setNum:sender.value];
}

- (void)setNum:(CGFloat)value
{
    NSString *minerText = [NSString stringWithFormat:@"%.0f%%",value * 100];
    self.minerBonusScale.text = minerText;
    NSString *leaderText = [NSString stringWithFormat:@"%.0f%%",(1-value) * 100];
    self.leaderBonusScale.text = leaderText;
}

- (void) sliderTouchEnd:(UISlider *)sender
{
    [self setNum:sender.value];
}

#pragma mark - lazy load
- (UILabel *)fundTip
{
    if (!_fundTip) {
        _fundTip = [UILabel labelWithFont:FixFont(15) textColor:OF_COLOR_TITLE textAlignement:NSTextAlignmentLeft text:@"矿池基金"];
        [self addSubview:_fundTip];
    }
    return _fundTip;
}

- (UILabel *)fundNum
{
    if (!_fundNum) {
        _fundNum = [UILabel labelWithFont:FixFont(14) textColor:OF_COLOR_MAIN_THEME textAlignement:NSTextAlignmentRight text:@"fundNum"];
        [self addSubview:_fundNum];
    }
    return _fundNum;
}

- (UIView *)separator
{
    if (!_separator) {
        _separator = [[UIView alloc] init];
        _separator.backgroundColor = OF_COLOR_SEPARATOR;
        [self addSubview:_separator];
    }
    return _separator;
}

- (UILabel *)bonusTip
{
    if (!_bonusTip) {
        _bonusTip = [UILabel labelWithFont:FixFont(15) textColor:OF_COLOR_TITLE textAlignement:NSTextAlignmentLeft text:@"矿工分红比例"];
        [self addSubview:_bonusTip];
    }
    return _bonusTip;
}

- (UILabel *)bonusScale
{
    if (!_bonusScale) {
        _bonusScale = [UILabel labelWithFont:FixFont(14) textColor:OF_COLOR_DETAILTITLE textAlignement:NSTextAlignmentRight text:@"最低20%"];
        [self addSubview:_bonusScale];
    }
    return _bonusScale;
}

- (NSlider *)slider
{
    if (!_slider) {
        _slider = [[NSlider alloc]init];
        [_slider setMinimumTrackTintColor:[UIColor colorWithRGB:0xffa040]];
        [_slider setMaximumTrackTintColor:[[UIColor colorWithRGB:0x0d0408] colorWithAlphaComponent:0.35]];
        [_slider addTarget:self action:@selector(sliderTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(sliderTouchEnd:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.enabled = YES;
        [self addSubview:_slider];
        
    }
    return _slider;
}

- (UIView *)sliderCenter
{
    if (!_sliderCenter) {
        _sliderCenter = [[UIView alloc] init];
        _sliderCenter.backgroundColor = OF_COLOR_DETAILTITLE;
        [self addSubview:_sliderCenter];
    }
    return _sliderCenter;
}

- (UILabel *)miner
{
    if (!_miner) {
        _miner = [UILabel labelWithFont:FixFont(14) textColor:OF_COLOR_DETAILTITLE textAlignement:NSTextAlignmentRight text:@"矿工"];
        [self addSubview:_miner];
    }
    return _miner;
}

- (UILabel *)minerBonusScale
{
    if (!_minerBonusScale) {
        _minerBonusScale = [UILabel labelWithFont:FixFont(14) textColor:OF_COLOR_MAIN_THEME textAlignement:NSTextAlignmentRight text:@"20%"];
        [self addSubview:_minerBonusScale];
    }
    return _minerBonusScale;
}

- (UILabel *)leader
{
    if (!_leader) {
        _leader = [UILabel labelWithFont:FixFont(14) textColor:OF_COLOR_DETAILTITLE textAlignement:NSTextAlignmentLeft text:@"领主"];
        [self addSubview:_leader];
    }
    return _leader;
}

- (UILabel *)leaderBonusScale
{
    if (!_leaderBonusScale) {
        _leaderBonusScale = [UILabel labelWithFont:FixFont(14) textColor:OF_COLOR_MAIN_THEME textAlignement:NSTextAlignmentRight text:@"20%"];
        [self addSubview:_leaderBonusScale];
    }
    return _leaderBonusScale;
}

- (UILabel *)declare
{
    if (!_declare) {
        _declare = [UILabel labelWithFont:FixFont(12) textColor:OF_COLOR_MINOR textAlignement:NSTextAlignmentLeft text:@""];
        NSString *text = @"说明:\n 矿池基金分红比例由领主分配设置\n 分红时间为每周五晚上8点";
        _declare.text = text;
        _declare.numberOfLines = 0;
        [self addSubview:_declare];
    }
    return _declare;
}

- (UIButton *)save
{
    if (!_save) {
        _save = [UIButton buttonWithTitle:@"保存设置" titleColor:OF_COLOR_WHITE backgroundColor:nil font:FixFont(15)];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_save setBackgroundImage:image forState:UIControlStateNormal];
        [_save addTarget:self action:@selector(saveSetting) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_save];
        _save.layer.cornerRadius = 5.f;
        _save.layer.masksToBounds = YES;
    }
    return _save;
}

- (UILabel *)rightLabel
{
    if (!_rightLabel) {
        _rightLabel = [UILabel labelWithFont:FixFont(12) textColor:OF_COLOR_MINOR textAlignement:NSTextAlignmentCenter text:@""];
        _rightLabel.text = @"──────   仅领主可编辑   ──────";
        [self addSubview:_rightLabel];
    }
    return _rightLabel;
}

@end
