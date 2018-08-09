//
//  OFRedPacketHeaderView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFRedPacketHeaderView : UIView

- (instancetype)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)color;

- (void)updateInfo:(NSString *)title;

@end
