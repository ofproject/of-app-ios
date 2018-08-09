//
//  OFPoolFundVC.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/26.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseTableViewController.h"

@class OFPoolSettingLogic;
@interface OFPoolFundVC : OFBaseTableViewController

- (instancetype)initWithPool:(OFPoolModel *)pool;

- (instancetype)initWithLogic:(OFPoolSettingLogic *)logic;

@end
