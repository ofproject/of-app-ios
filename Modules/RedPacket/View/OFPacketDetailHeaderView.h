//
//  OFPacketDetailHeaderView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PacketDetailHeaderModel : NSObject

@property (nonatomic, strong) NSString *userHeaderUrl;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *redPacketDesc;
@property (nonatomic, strong) NSString *redPacketAmount;
// 红包是否过期  0：未过期   1：已过期
@property (nonatomic, assign) BOOL hasExpired;
// 红包是否被领完  0：未领完  1：已领完
@property (nonatomic, assign) BOOL hasFinished;

@end

@interface OFPacketDetailHeaderView : UIView

- (void)updateInfo:(PacketDetailHeaderModel *)model isShowReward:(BOOL)isShowReward isExpired:(BOOL)isExpired;

@end
