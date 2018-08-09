//
//  OFProfileCell.h
//  OFBank
//
//  Created by 胡堃 on 2018/1/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"

extern CGFloat const kOFProfileCellHeight;
extern NSString *const kOFProfileCellIdentifier;

typedef NS_ENUM(NSInteger, ProfileCellType) {
    ProfileCellTypeSingle,
    ProfileCellTypeTop,
    ProfileCellTypeMiddle,
    ProfileCellTypeBottom,
};

typedef NS_ENUM(NSInteger, ProfileTargetType) {
    ProfileTargetTypeController,    //本地controller
    ProfileTargetTypeWeb,           //Web页面
    ProfileTargetTypeSchema,        //Schema跳转
};

@interface OFProfileItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *detailText;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *rightIcon;
@property (nonatomic, assign) ProfileCellType type;

@property (nonatomic, assign) ProfileTargetType targetType;
@property (nonatomic, strong) NSString *targetCalss;

@end

@interface OFProfileCell : OFBaseCell

- (void)update:(OFProfileItem *)item;

@end
