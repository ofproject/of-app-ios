//
//  OFCashOutVC.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//  提现到钱包VC

#import "OFBaseTableViewController.h"

typedef NS_ENUM(NSInteger, ProfitType) {
    miningProfit = 0,
    candyProfit = 1,
    redPacket = 2
};

@interface OFCashOutVC :OFBaseTableViewController

@property (nonatomic, assign) ProfitType type;//0 矿池 ，1 糖果  2,红包
@property (nonatomic, copy) NSString *candyReward;
@property (nonatomic, copy) NSString *miningReward;
@property (nonatomic, copy) NSString *redPacketReward;//红包收益
@property (nonatomic, copy) dispatch_block_t candySucBlock;//提现成功block
@property (nonatomic, copy) dispatch_block_t miningSucBlock;//提现成功block
@end
