//
//  OFAllMiningCell.h
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFBaseCell.h"

extern CGFloat const kAllMiningCellHeight;
extern NSString *const kAllMiningCellIdentifier;

@class OFPoolModel;
@interface OFAllMiningCell : OFBaseCell

@property (nonatomic, copy) void (^joinCallback)(OFPoolModel *model);

- (void)setModel:(OFPoolModel *)model;

@end
