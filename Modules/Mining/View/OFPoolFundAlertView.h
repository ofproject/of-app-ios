//
//  OFPoolFundAlertView.h
//  OFBank
//
//  Created by Xu Yang on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFPoolFundAlertView : UIView

-(void)showPoolFundAlertView:(UIView *)toView withRewardValue:(double)rewardValue WithBlock:(dispatch_block_t)block;
@end
