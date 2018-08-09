//
//  OFJoinPoolAlertView.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/5.
//  Copyright © 2018年 胡堃. All rights reserved.
//  加入矿池提示

#import <UIKit/UIKit.h>

@interface OFJoinPoolAlertView : UIView

/**
 弹出提示框

 @param toView 目标view
 @param poolCount 全球节点数字
 @param block 按钮回调
 */
-(void)show:(UIView *)toView poolCount:(NSInteger)poolCount btnblock:(dispatch_block_t)block;

/**
 弹出提示框
 
 @param toView      目标view
 @param title       全球节点数字
 @param content     按钮回调
 @param block       按钮回调
 */
- (void)show:(UIView *)toView title:(NSString *)title content:(NSString *)content btnblock:(dispatch_block_t)block;

-(void)close;

@end
