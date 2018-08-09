//
//  OFInviteFriendView.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/25.
//  Copyright © 2018年 胡堃. All rights reserved.
//  邀请好友弹窗

#import <UIKit/UIKit.h>
#import "OFShareManager.h"

@interface OFInviteFriendView : UIView


/**
 新用户首矿

 @param toView 目标view
 @param rewardValue 奖励额度
 @param shareBlock 回调
 */
-(void)showFirstReward:(UIView *)toView withRewardValue:(double)rewardValue shareBlock:(dispatch_block_t)shareBlock;


/**
 老用户每日首矿

 @param toView 目标view
 @param rewardValue 奖励额度
 @param shareBlock 回调
 */
-(void)showTodayFirstReward:(UIView *)toView withRewardValue:(double)rewardValue shareBlock:(dispatch_block_t)shareBlock;
@end
