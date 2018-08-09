//
//  OFCodeAlertView.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/6.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFCodeAlertView : UIView

/**
 展示二维码

 @param toView 目标view
 @param block 回调
 */
-(void)show:(UIView *)toView btnblock:(void(^)(NSString *codeStr))block;

-(void)close;

@end
