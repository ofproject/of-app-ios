//
//  OFMiningInfoModel.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//  挖矿主页model

#import <Foundation/Foundation.h>
@class GlobalDetailModel;
@class RewardModel;
@class OFPoolModel;

@interface OFMiningInfoModel : NSObject
@property (nonatomic, strong) GlobalDetailModel *GlobalDetail;
@property (nonatomic, strong) OFPoolModel *community;
@property (nonatomic, strong) RewardModel *reward;
@property (nonatomic, strong) NSNumber *miningCount;//72小时内活跃节点数
@end

//全球矿池信息
@interface GlobalDetailModel :NSObject
@property (nonatomic, strong) NSNumber *communityNumber;//全球矿池总数
@property (nonatomic, strong) NSNumber *nodesNumber;//全球总节点数

@end

//用户收益数目
@interface RewardModel :NSObject
@property (nonatomic, strong) NSNumber *currentRewaed;//当前可用收益
@property (nonatomic, strong) NSNumber *miningReward;//挖矿收益
@property (nonatomic, strong) NSNumber *totalReward;//总收益
@property (nonatomic, strong) NSNumber *redPacketReward;//红包收益
@end
