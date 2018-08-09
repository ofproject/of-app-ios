//
//  OFRedPacketLogic.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"
#import "OFTableViewProtocol.h"

@protocol OFRedPacketLogicDelegate <BaseLogicDelegate>

- (void)requestRedPacketRewardSuccess:(NSString *)reward;

@end

@interface OFRedPacketLogic : OFBaseLogic <OFTableViewProtocol>

@property (nonatomic, assign) NSInteger rankType;

@property (nonatomic, strong) NSString *reward;

- (void)getFirstScreen;
- (void)getRedPacketReward;
- (void)refreshPacketList;
- (void)loadMorePacketList;

- (BOOL)isEmptyData;
- (NSString *)sectionTitle;

- (NSArray *)defaultSectionItems;

@end
