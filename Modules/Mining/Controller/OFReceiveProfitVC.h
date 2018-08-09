//
//  OFReceiveProfitVC.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/5.
//  Copyright © 2018年 胡堃. All rights reserved.
//  提现页面

#import "OFBaseTableViewController.h"
#import "OFCashOutVC.h"

@interface OFReceiveProfitVC : OFBaseTableViewController

@property (nonatomic, assign) ProfitType type;//0 矿池 ，1 糖果, 2红包
@property (nonatomic, copy) NSString *candyReward;
@property (nonatomic, copy) NSString *miningReward;
@end
