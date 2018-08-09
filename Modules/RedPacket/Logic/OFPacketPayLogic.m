//
//  OFPacketPayLogic.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketPayLogic.h"
#import "OFMiningAPI.h"
#import "OFMiningInfoModel.h"
#import "OFPacketPayModel.h"

@interface OFPacketPayLogic ()

@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, strong) RewardModel *rewardModel;

@end

@implementation OFPacketPayLogic

- (NSUInteger)numberOfSection
{
    return 1;
}

- (NSUInteger)itemCountOfSection:(NSUInteger)section
{
    return self.dataArr.count;
}

- (id)itemAtIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArr.count) {
        return [self.dataArr objectAtIndex:indexPath.row];
    }
    return nil;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KWidthFixed(65.f);
}

- (BOOL)canSelectedAtIndexPath:(NSIndexPath *)indexPath
{
    OFWalletModel *wallet = [self itemAtIndex:indexPath];
    if (wallet.balance.doubleValue < self.minRedPacketAmount.doubleValue) {
        return NO;
    }
    return YES;
}

- (void)getRedPacketReward
{
    WEAK_SELF;
    [OFMiningAPI getMiningInfo:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if(success){
            NSDictionary *dict = (NSDictionary *)obj;
            NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
            if (status == 200) {
                NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
                [weakSelf fillRedPacketReward:data];
                [weakSelf callbackRedPacketReward];
            }
        }
    }];
}

- (void)fillRedPacketReward:(NSDictionary *)data
{
    OFMiningInfoModel *model = [OFMiningInfoModel modelWithDictionary:data];
    self.rewardModel = model.reward;
    NSString *reward = [NSString stringWithFormat:@"%0.3f",model.reward.redPacketReward.floatValue];
    OFWalletModel *packetWallet = [[OFWalletModel alloc] init];
    packetWallet.name = @"红包余额";
    packetWallet.balance = reward;
    packetWallet.address = @"";
    
    NSMutableArray *mtlArray = [NSMutableArray arrayWithObject:packetWallet];
    [mtlArray addObjectsFromArray:self.dataArr];
    self.dataArr = [self sortWallets:mtlArray];
}

- (NSArray *)sortWallets:(NSArray *)array
{
    NSMutableArray *backArray = [NSMutableArray array];
    for (OFWalletModel *wallet in array) {
        if (wallet.balance.doubleValue < self.minRedPacketAmount.doubleValue) {
            [backArray addObject:wallet];
        }
    }
    NSMutableArray *result = [NSMutableArray arrayWithArray:array];
    [result removeObjectsInArray:backArray];
    [result addObjectsFromArray:backArray];
    
    return result.copy;
}

#pragma mark - callback
- (void)callbackRedPacketReward
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestRedPacketRewardSuccess)]) {
        [self.delegate requestRedPacketRewardSuccess];
    }
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = KcurUser.wallets;
    }
    return _dataArr;
}

@end
