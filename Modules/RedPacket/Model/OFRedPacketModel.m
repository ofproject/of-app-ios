//
//  OFRedPacketModel.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRedPacketModel.h"

@implementation OFRedPacketModel

- (NSString *)name
{
    if (_type == OFRedPacketTypeSend) {
        return @"拼手气红包";
    }
    return _username;
}

- (NSInteger)receivedRedPacketNumber
{
    return _redPacketNumber - _remainingRedPacketNumber;
}

@end
