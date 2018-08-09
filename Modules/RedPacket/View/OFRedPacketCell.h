//
//  OFRedPacketCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"

extern NSString *const OFRedPacketCellIdentifier;
extern CGFloat const OFRedPacketCellHeight;

@class OFRedPacketModel;
@interface OFRedPacketCell : OFBaseCell

- (void)updateInfo:(OFRedPacketModel *)model;

@end
