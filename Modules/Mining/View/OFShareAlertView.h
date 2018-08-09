//
//  OFShareAlertView.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/6.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFShareManager.h"

@interface OFShareAlertView : UIView


-(void)show:(UIView *)toView withTitle:(NSString *)titleStr WithDes:(NSString *)desString shareModel:(OFSharedModel *)shareModel;

@end
