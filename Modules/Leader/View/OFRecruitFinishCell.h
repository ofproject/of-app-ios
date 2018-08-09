//
//  OFRecruitFinishCell.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseCell.h"
#import "BaseModel.h"

extern NSString *const OFRecruitFinishCellIdentifier;

@class OFRecruitFinishCellModel;
@class OFPoolModel;
@protocol recruitFinishCellDelegate <NSObject>

- (void)recruitFinishCellEnterPool;

@end

@interface OFRecruitFinishCellModel : BaseModel

@property (nonatomic, strong) OFPoolModel *pool;
@property (nonatomic, strong) NSString *communityCount;

@end

@interface OFRecruitFinishCell : OFBaseCell

@property (nonatomic, weak) id<recruitFinishCellDelegate> delegate;

- (void)updateInfo:(OFRecruitFinishCellModel *)model alreadyManager:(BOOL)alreadyManager;

+ (CGFloat)finishCellHeight;

@end
