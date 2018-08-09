//
//  OFPoolSettingCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"
#import "OFBaseModel.h"

extern NSString *const OFPoolSettingCellReuseIdentifier;

typedef NS_ENUM(NSInteger, OFPoolSettingCellType) {
    OFPoolSettingCellTypeName,
    OFPoolSettingCellTypeAnnounce,
};

@class OFPoolSettingCell;
@class OFPoolSettingModel;
@protocol OFPoolSettingCellDelegate <NSObject>
@optional
- (void)settingCell:(OFPoolSettingCell *)settingCell model:(OFPoolSettingModel *)model didEditNickname:(NSString *)nickName;

@end

@interface OFPoolSettingModel : OFBaseModel

@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, assign) OFPoolSettingCellType type;
@property (nonatomic, copy) BOOL (^checkText)(NSString *text);
@property (nonatomic, assign) UIKeyboardType keyboardType;

@end

@interface OFPoolSettingCell : OFBaseCell

@property (nonatomic, weak) id<OFPoolSettingCellDelegate> delegate;

- (void)update:(OFPoolSettingModel *)model;

- (void)becomeResponder;

+ (CGFloat)rowHeight:(OFPoolSettingModel *)model;

@end
