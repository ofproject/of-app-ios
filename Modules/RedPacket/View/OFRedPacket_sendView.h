//
//  OFRedPacket_sendView.h
//  OFBank
//
//  Created by Xu Yang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//  弹出的发红包视图

#import <UIKit/UIKit.h>

@interface OFRedPacket_sendView : UIView


/**
 红包已准备好弹窗

 @param toView 目标视图
 @param titleStr 标题
 @param contentStr 内容
 @param block “发”按钮回调事件
 */
-(void)showRedPackedSendView:(UIView *)toView withTiltle:(NSString *)titleStr WithContentStr:(NSString *)contentStr WithBlock:(dispatch_block_t)block withCloseCallback:(dispatch_block_t)closeCallback;
@end
