//
//  OFPacketPayCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"

extern NSString *const OFPacketPayCellIdentifier;

@interface OFPacketPayCell : OFBaseCell

- (void)updateInfo:(OFWalletModel *)model canSelected:(BOOL)canSelected;

@end
