//
//  OFPayView.h
//  OFBank
//
//  Created by michael on 2018/3/27.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PayBlock)(NSString *password, NSString *code);

@interface OFPayView : UIView

@property (nonatomic, copy) PayBlock payBlock;

/**
 显示无验证码的密码输入框
 */
+ (void)showPayViewWithoutCode:(PayBlock)payBlock;

/**
 显示有验证码的密码输入框
 */
+ (void)showPayViewWithPayBlock:(PayBlock)payBlock;

+ (void)hiddenPayView;

@end
