//
//  OFPacketDetailCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"
#import "OFBaseModel.h"

extern NSString *const OFPacketDetailCellIdentifier;

@interface OFPacketDetailModel : OFBaseModel

@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, assign) BOOL isMax;
@property (nonatomic, strong) NSString *redPacketAmount;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *userHeaderUrl;
@property (nonatomic, strong) NSString *username;

@end

@interface OFPacketDetailCell : OFBaseCell

- (void)updateInfo:(OFPacketDetailModel *)model;

@end
