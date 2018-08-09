//
//  OFPoolAnnounceController.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//  公告发布、查看

#import "OFViewController.h"

@class OFPoolSettingLogic;
@class OFPoolModel;
@interface OFPoolAnnounceController : OFViewController

- (instancetype)initWithPool:(OFPoolModel *)pool;

- (instancetype)initWithLogic:(OFPoolSettingLogic *)logic;

@end
