//
//  OFPacketSendController.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseTableViewController.h"

@class OFRedPacketModel,RewardModel;
@protocol PacketSendControllerDelegate <NSObject>

- (void)packetSendPopBack;
- (void)packetSendControlerToDetail:(OFRedPacketModel *)packet;

@end

@interface OFPacketSendController : OFBaseTableViewController

@property (nonatomic, weak) id<PacketSendControllerDelegate> delegate;

- (instancetype)initWithReward:(RewardModel *)reward;

@end
