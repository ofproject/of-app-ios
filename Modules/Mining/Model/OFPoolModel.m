//
//  OFPoolModel.m
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFPoolModel.h"

@implementation OFPoolModel

- (void)update:(OFPoolModel *)model
{
    if (self != model) {
        _cid = model.cid;
        _count = model.count;
        _name = model.name;
        _logoUrl = model.logoUrl;
        _managerName = model.managerName;
        _managerId = model.managerId;
        _createTime = model.createTime;
        _lastBlock = model.lastBlock;
        _active = model.active;
        _reward = model.reward;
    }
}

- (BOOL)isNoobPool
{
    if ([_level isEqualToString:@"1"]) {
        return YES;
    }
    return NO;
}

- (NSString *)logoUrl
{
    if (!_logoUrl) {
        _logoUrl = @"mining_pool_icon";
    }
    return _logoUrl;
}

- (NSString *)active
{
    if (!_active || _active.length < 1) {
        _active = @"0";
    }
    return [NSString stringWithFormat:@"%@%%",_active];
}

- (NSString *)reward
{
    if (!_reward || _reward.length < 1) {
        return @"0";
    }
    return [NDataUtil convertAmountStr:_reward];
}

- (NSString *)managerName
{
    if (!_managerName || _managerName.length < 1) {
        return @"— —";
    }
    return _managerName;
}

- (NSString *)lastBlock
{
    if (!_lastBlock || _lastBlock.length < 1) {
        return @"— —";
    }
    return _lastBlock;
}

- (NSString *)originReward
{
    return _reward;
}

#pragma mark - class method
+ (BOOL)isMyPool:(OFPoolModel *)pool
{
    if (pool && [pool.cid isEqualToString: KcurUser.community.cid]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isManagedPool:(OFPoolModel *)pool
{
    if (pool && [pool.managerId isEqualToString: KcurUser.uid.stringValue]) {
        return YES;
    }
    return NO;
}

@end
