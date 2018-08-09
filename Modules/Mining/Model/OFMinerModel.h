//
//  OFMinerModel.h
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFMinerModel : NSObject

// 矿工属性
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *profileUrl;
@property (nonatomic, strong) NSString *miningTime;
@property (nonatomic, strong) NSString *miningReward;

@end
