//
//  OFMinerModel.m
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFMinerModel.h"

@implementation OFMinerModel

- (NSString *)avatar
{
    return @"mining_miner_icon";
}

- (NSString *)miningTime
{
    if (!_miningTime) {
        _miningTime = @"0";
    }
    long second = [_miningTime longValue];
    return [NSString stringWithFormat:@"%ld",second / 60];
}

- (NSString *)miningReward
{
    if (!_miningReward) {
        _miningReward = @"0";
    }
    return [NDataUtil convertAmountStr:_miningReward];
}

@end
