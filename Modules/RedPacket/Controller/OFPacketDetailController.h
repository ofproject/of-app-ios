//
//  OFPacketDetailController.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseTableViewController.h"

@class OFRedPacketModel;
@interface OFPacketDetailController : OFBaseTableViewController

- (instancetype)initWithPacket:(OFRedPacketModel *)packet;

@end
