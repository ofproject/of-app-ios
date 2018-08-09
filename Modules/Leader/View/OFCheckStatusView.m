//
//  OFCheckStatusView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFCheckStatusView.h"


#pragma mark - OFCheckButton
@interface OFCheckButton : UIControl

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end

@implementation OFCheckButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayout];
    }
    return self;
}

- (void)resetStatus
{
    self.titleLabel.textColor = OF_COLOR_MINOR;
    self.detailLabel.textColor = OF_COLOR_MINOR;
}

- (void)render:(uint32_t)rgb
{
    UIColor *color = [UIColor colorWithRGB:rgb];
    self.titleLabel.textColor = color;
    self.detailLabel.textColor = color;
}

- (void)setupLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerX);
        make.centerY.mas_equalTo(self.centerY).offset(-KWidthFixed(20));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.centerX);
        make.centerY.mas_equalTo(self.centerY).offset(KWidthFixed(20));
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixFont(11) textColor:OF_COLOR_MINOR textAlignement:NSTextAlignmentCenter text:@"1"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [UILabel labelWithFont:FixFont(11) textColor:OF_COLOR_MINOR textAlignement:NSTextAlignmentCenter text:@"check"];
        [self addSubview:_detailLabel];
    }
    return _detailLabel;
}

@end


#pragma mark - OFCheckStatusView
@interface OFCheckStatusView ()

@property (nonatomic, strong) NSArray *btnArr;

@end

@implementation OFCheckStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}



@end
