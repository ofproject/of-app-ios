//
//  OFPacketDetailSendView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/13.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketDetailSendView.h"

@interface OFPacketDetailSendView ()

@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation OFPacketDetailSendView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = OF_COLOR_RED;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(44);
    }];
}

- (void)click
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(packetDetailSendViewDidClick:)]) {
        [self.delegate packetDetailSendViewDidClick:self];
    }
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithTitle:@"继续发送此红包" titleColor:OF_COLOR_WHITE backgroundColor:OF_COLOR_RED font:FixFont(15) target:self action:@selector(click)];
        [self addSubview:_sendButton];
    }
    return _sendButton;
}

@end
