//
//  OFPersonalInfoCell.h
//  OFBank
//
//  Created by xiepengxiang on 12/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFBaseCell.h"

extern CGFloat const kOFPersonalInfoCellHeight;
extern NSString *const kOFPersonalInfoCellIdentifier;

typedef NS_ENUM(NSInteger, PersonalInfoCellType) {
    PersonalInfoCellName,
    PersonalInfoCellAvatar,
};

@class OFPersonalInfoCell;
@protocol OFPersonalInfoCellDelegate <NSObject>

- (void)infoCell:(OFPersonalInfoCell *)infoCell didEditNickname:(NSString *)nickName;

@end

@interface OFPersonalInfoItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, strong) NSString *detailTitle;
@property (nonatomic, assign) PersonalInfoCellType type;

@end

@interface OFPersonalInfoCell : OFBaseCell

@property (nonatomic, weak) id<OFPersonalInfoCellDelegate> delegate;

- (void)setItem:(OFPersonalInfoItem *)item;

- (void)becomeResponder;

@end
