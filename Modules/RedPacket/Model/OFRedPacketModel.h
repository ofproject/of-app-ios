//
//  OFRedPacketModel.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OFRedPacketType) {
    OFRedPacketTypeReceive = 0,
    OFRedPacketTypeSend = 1,
};

@interface OFRedPacketModel : NSObject

// 红包id
@property (nonatomic, strong) NSString *id;
// 红包token
@property (nonatomic, strong) NSString *token;
// 红包名
@property (nonatomic, strong) NSString *name;
// 红包创建时间
@property (nonatomic, strong) NSString *createTime;
// 红包金额
@property (nonatomic, strong) NSString *redPacketAmount;
// 红包个数
@property (nonatomic, assign) NSInteger redPacketNumber;
// 未领取个数
@property (nonatomic, assign) NSInteger remainingRedPacketNumber;
// 已领取个数
@property (nonatomic, assign) NSInteger receivedRedPacketNumber;
// 红包发送人
@property (nonatomic, strong) NSString *username;
// 红包发送人头像
@property (nonatomic, strong) NSString *userHeaderUrl;
// 红包类型  1 : 拼手气红包
@property (nonatomic, assign) NSInteger redPacketType;
// 红包类型  (我收到的, 我发出的)
@property (nonatomic, assign) OFRedPacketType type;

@end
