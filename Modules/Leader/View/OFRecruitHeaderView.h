//
//  OFRecruitHeaderView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFRecruitHeaderView;
@class OFRecruitHeaderViewModel;
@protocol OFRecruitHeaderViewDelegate <NSObject>

- (void)recruitHeaderViewDidSelectedNavBack:(OFRecruitHeaderView *)headerView;

- (void)recruitHeaderView:(OFRecruitHeaderView *)headerView didApplyRule:(OFRecruitHeaderViewModel *)model;

@end

@interface OFRecruitHeaderViewModel : NSObject

// 社群数量
@property (nonatomic, strong) NSString *communityCount;
// 申请规则
@property (nonatomic, strong) NSString *applyRuleUrl;

@end

@interface OFRecruitHeaderView : UIView

@property (nonatomic, weak) id<OFRecruitHeaderViewDelegate> delegate;

- (void)updateInfo:(OFRecruitHeaderViewModel *)model alreadyManager:(BOOL)alreadyManager;

@end
