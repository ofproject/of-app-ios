//
//  OFPacketEditCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"
#import "OFBaseModel.h"

extern NSString *const OFPacketEditCellIdentifier;

@class OFPacketEditModel;
@class OFPacketEditCell;
@protocol OFPacketEditCellDelegate <NSObject>
- (void)packetEditCell:(OFPacketEditCell *)cell model:(OFPacketEditModel *)model didEditCount:(NSString *)count;
@end

@interface OFPacketEditModel : OFBaseModel

@property (nonatomic, strong) NSString *editText;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, copy) BOOL (^checkText)(NSString *text);
@property (nonatomic, assign) UIKeyboardType keyboardType;

@end

@interface OFPacketEditCell : OFBaseCell

@property (nonatomic, weak) id<OFPacketEditCellDelegate> delegate;

- (void)updateInfo:(OFPacketEditModel *)model;

- (void)becomeResponder;;

@end
