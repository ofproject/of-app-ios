//
//  OFPacketSendLogic.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"
#import "OFTableViewProtocol.h"

@class OFSharedModel, OFRedPacketModel, RewardModel;
@protocol OFPacketSendLogicDelegate <BaseLogicDelegate>

- (void)redPacketCreateSuccess:(OFSharedModel *)shareModel title:(NSString *)title detailText:(NSString *)detail packet:(OFRedPacketModel *)packet;
- (void)redPacketCreateFailure:(NSString *)message;
- (void)redPacketCreateFailureWithLastIsNoOK:(NSString *)message;//上个红包没有打包上链，不能继续发，此时报错用alert弹窗
- (void)requestRedPacketRewardSuccess;

@end

@interface OFPacketSendLogic : OFBaseLogic <OFTableViewProtocol>

@property (nonatomic, strong) RewardModel *rewardModel;

- (NSString *)minRedPacketAmount;
- (void)getConfigInfo;
- (void)getRedPacketReward;
- (BOOL)checkEditInfo;
- (BOOL)needPayPassphare;
- (void)sendRedPacket:(NSString *)passphare;
- (void)updateWalletInfo:(OFWalletModel *)wallet;
- (void)resetInputInfo;

@end
