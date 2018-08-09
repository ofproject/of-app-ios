//
//  OFPacketWalletCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/9.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"

extern NSString *const OFPacketWalletCellIdentifier;

@class OFPacketPayModel;
@interface OFPacketWalletCell : OFBaseCell

- (void)updateInfo:(OFPacketPayModel *)model;

@end
