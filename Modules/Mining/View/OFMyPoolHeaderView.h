//
//  OFMyPoolHeaderView.h
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFMyPoolHeaderView;
@protocol OFMyPoolHeaderViewDelegate <NSObject>
@optional
- (void)poolHeaderViewSelected:(OFMyPoolHeaderView *)headerView isQuit:(BOOL)isQuit;

- (void)poolHeaderNoobSelected:(OFMyPoolHeaderView *)headerView;

- (void)poolHeaderQrcodeShareSelected:(OFMyPoolHeaderView *)headerView;

- (void)poolHeaderAnnounceSelected:(OFMyPoolHeaderView *)headerView;

@end

@class OFPoolModel;
@interface OFMyPoolHeaderView : UIView

@property (nonatomic, weak) id<OFMyPoolHeaderViewDelegate> delegate;

- (void)setPoolModel:(OFPoolModel *)model;

@end
