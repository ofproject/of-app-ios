//
//  OFShareAppView.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OFShareManager.h"

@interface OFShareAppView : UIView


/**
 分享页面

 @param view 添加到的view
 @param shareType 分享类型，0 首页，1矿池
 @param poolName 矿池名字
 @param shareModel shareModle
 */
-(void)showShareAppViewToView:(UIView *)view shareType:(NSInteger)shareType poolName:(NSString *)poolName shareModel:(OFSharedModel *)shareModel;
@end
