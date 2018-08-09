//
//  OFProfileHeaderView.h
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFProfileHeaderView;
@protocol OFProfileHeaderViewDelegate <NSObject>

- (void)headerView:(OFProfileHeaderView *)headerView didChangeAvatar:(UIImage *)image;

- (void)headerView:(OFProfileHeaderView *)headerView didEditNickname:(NSString *)nickName;

@end

@interface OFProfileHeaderView : UIView

@property (nonatomic, weak) id<OFProfileHeaderViewDelegate> delegate;

- (void)bindData;
@end
