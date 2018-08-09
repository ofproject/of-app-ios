//
//  OFCandySucAlertView.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/26.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFShareManager.h"

@interface OFCandySucAlertView : UIView


-(void)show:(UIView *)toView withTitle:(NSString *)titleStr WithDes:(NSString *)desString shareBlock:(dispatch_block_t)shareBlock;

@end
