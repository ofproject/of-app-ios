//
//  OFMyPoolNavView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFMyPoolNavView;
@protocol OFMyPoolNavViewDelegate <NSObject>
@optional
- (void)navView:(OFMyPoolNavView *)navView isQuit:(BOOL)isQuit;

- (void)navViewDidSelectedSetting:(OFMyPoolNavView *)navView;

- (void)navViewDidSelectedNavBack:(OFMyPoolNavView *)navView;

@end

@interface OFMyPoolNavView : UIView

@property (nonatomic, weak) id<OFMyPoolNavViewDelegate> delegate;

- (void)setPoolModel:(OFPoolModel *)model;

- (void)updateScrollViewContentOffSet:(CGFloat)offset range:(CGFloat)range;

@end
