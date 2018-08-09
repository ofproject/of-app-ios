//
//  OFRedPacketPasswordAlert.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFRedPacketPasswordView : UIView

@end

@interface OFRedPacketPasswordAlert : UIView

+ (OFRedPacketPasswordAlert *)showPasswordAlertToView:(UIView *)view callback:(void(^)(NSString *password))callback;

@end
