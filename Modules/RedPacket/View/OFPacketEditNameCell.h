//
//  OFPacketEditNameCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"
#import "OFBaseModel.h"

extern NSString *const OFPacketEditNameCellIdentifier;

@interface OFPacketEditNameModel : OFBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *placeHolder;

@end

@interface OFPacketEditNameCell : OFBaseCell

- (void)updateInfo:(OFPacketEditNameModel *)model;

- (void)becomeResponder;

@end
