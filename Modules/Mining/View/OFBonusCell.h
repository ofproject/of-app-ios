//
//  OFBonusCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"
#import "OFBaseModel.h"

extern NSString *const kOFBonusCellReuseIdentifier;
extern CGFloat const kkOFBonusCellHeight;

@class OFBonusModel;
@interface OFBonusCell : OFBaseCell

- (void)setModel:(OFBonusModel *)model;

@end
