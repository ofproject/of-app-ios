//
//  OFBonusModel.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFBonusModel : NSObject

// 领取人数
@property (nonatomic, strong) NSString *personCnt;

// 分配的OF
@property (nonatomic, strong) NSString *ofCnt;

// 分红比例
@property (nonatomic, strong) NSString *bonusPercentage;

// 分红时间
@property (nonatomic, strong) NSString *bonusTime;

@end
