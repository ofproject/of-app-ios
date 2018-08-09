//
//  OFPoolModel.h
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFPoolModel : NSObject

// 矿池 id
@property (nonatomic, strong) NSString *cid;
// 节点数
@property (nonatomic, strong) NSString *count;
// 名字
@property (nonatomic, strong) NSString *name;
// 头像
@property (nonatomic, strong) NSString *logoUrl;
// 领主
@property (nonatomic, strong) NSString *managerName;
// 领主 id
@property (nonatomic, strong) NSString *managerId;
// 创建时间
@property (nonatomic, strong) NSString *createTime;
// 上一次出块时间
@property (nonatomic, strong) NSString *lastBlock;
// 活跃度
@property (nonatomic, strong) NSString *active;
// 基金
@property (nonatomic, strong) NSString *reward;
// 矿池类别  0 正常矿池  1 新手矿池
@property (nonatomic, strong) NSString *level;
// 分红比例
@property (nonatomic, assign) float bonusPercentage;
// 最大分红比例
@property (nonatomic, assign) float maxBonusPercentage;
// 最小分红比例
@property (nonatomic, assign) float minBonusPercentage;
// 矿池公告
@property (nonatomic, strong) NSString *announcement;
// 矿池公告发布时间
@property (nonatomic, strong) NSString *announcementPublishTime;
// 基金红包数量
@property (nonatomic, strong) NSString *bonusCnt;
// 基金分红说明
@property (nonatomic, strong) NSString *communityBonusDesc;

// 基金原始值
@property (nonatomic, strong) NSString *originReward;


// 更新矿池信息
- (void)update:(OFPoolModel *)model;

// 是否为新手矿池
- (BOOL)isNoobPool;

// 是否为我所在的矿池
+ (BOOL)isMyPool:(OFPoolModel *)pool;

// 是否为我的矿池(即当前用户是否为矿池领主)
+ (BOOL)isManagedPool:(OFPoolModel *)pool;

@end
