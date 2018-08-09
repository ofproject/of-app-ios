//
//  OFRedPacketSectionView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRedPacketSectionView.h"

#define kMargin_Left    KWidthFixed(15.f)

@interface OFRedPacketSectionView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorLine;

@end

@implementation OFRedPacketSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        self.backgroundColor = OF_COLOR_WHITE;
    }
    return self;
}

- (void)setupUI
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Left);
    }];
    
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom);
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.mas_right).offset(-kMargin_Left);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)updateInfo:(NSString *)title
{
    self.titleLabel.text = title;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixFont(11) textColor:OF_COLOR_DETAILTITLE textAlignement:NSTextAlignmentLeft text:@"title"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIView *)separatorLine
{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = OF_COLOR_SEPARATOR;
        [self addSubview:_separatorLine];
    }
    return _separatorLine;
}

@end
