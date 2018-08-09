//
//  OFMyMiningCell.h
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFBaseCell.h"

extern CGFloat const kMyMiningCellHeight;
extern NSString *const kMyMiningCellIdentifier;

@class OFMinerModel;
@interface OFMyMiningCell : OFBaseCell

- (void)setModel:(OFMinerModel *)model;

@end
