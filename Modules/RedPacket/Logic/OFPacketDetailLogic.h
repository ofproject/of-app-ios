//
//  OFPacketDetailLogic.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"
#import "OFTableViewProtocol.h"

@class OFRedPacketModel, PacketDetailHeaderModel,OFSharedModel;
@interface OFPacketDetailLogic : OFBaseLogic <OFTableViewProtocol>

@property (nonatomic, strong) OFRedPacketModel *packet;

- (PacketDetailHeaderModel *)headerInfo;
- (NSString *)sectionTitle;
-(OFSharedModel *)shareInfo;
- (BOOL)canSendAgain;
- (BOOL)isShowReceivedReward;
- (BOOL)isExpired;

- (void)getFirstScreen;

- (void)loadMorePacketDetail;

@end
