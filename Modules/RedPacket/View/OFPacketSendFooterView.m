//
//  OFPacketSendFooterView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketSendFooterView.h"

@interface OFPacketSendFooterView ()

@end

@implementation OFPacketSendFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(KWidthFixed(85));
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_equalTo(KWidthFixed(234.f));
        make.height.mas_equalTo(KWidthFixed(41.f));
    }];
}

- (void)sendPacket
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(packetSendFooterDidSelectedSend:)]) {
        [self.delegate packetSendFooterDidSelectedSend:self];
    }
}

- (UIButton *)sendBtn
{
    if (!_sendBtn) {
        _sendBtn = [UIButton buttonWithTitle:@"塞钱进红包"
                                  titleColor:[UIColor colorWithRGB:0xfefefe]
                             backgroundColor:[UIColor colorWithRGB:0xe25d4c]
                                        font:FixFont(15) target:self action:@selector(sendPacket)];
        _sendBtn.layer.masksToBounds = YES;
        _sendBtn.layer.cornerRadius = 5.f;
        [self addSubview:_sendBtn];
    }
    return _sendBtn;
}

@end
