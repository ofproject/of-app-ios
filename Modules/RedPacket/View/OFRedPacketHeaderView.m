//
//  OFRedPacketHeaderView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRedPacketHeaderView.h"

@interface OFRedPacketHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation OFRedPacketHeaderView

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
//        make.centerY.mas_equalTo(self.mas_bottom).offset(-KWidthFixed(58));
        make.centerY.mas_equalTo(0).offset(- 64 + Nav_Height + 20 );
    }];
}

- (void)updateInfo:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixFont(43) textColor:OF_COLOR_WHITE textAlignement:NSTextAlignmentCenter text:@"0.000"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
