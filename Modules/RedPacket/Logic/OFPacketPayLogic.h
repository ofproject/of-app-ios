//
//  OFPacketPayLogic.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"
#import "OFTableViewProtocol.h"

@protocol OFPacketPayLogicDelegate <BaseLogicDelegate>

- (void)requestRedPacketRewardSuccess;

@end

@interface OFPacketPayLogic : OFBaseLogic <OFTableViewProtocol>

@property (nonatomic, strong) NSString *minRedPacketAmount;

- (void)getRedPacketReward;

- (BOOL)canSelectedAtIndexPath:(NSIndexPath *)indexPath;

@end
