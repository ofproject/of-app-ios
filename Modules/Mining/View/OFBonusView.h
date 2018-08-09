//
//  OFBonusView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFPoolModel;
@class OFBonusView;
@protocol OFBonusViewDelegate <NSObject>

- (void)bonusViewSaveSetting:(OFBonusView *)bonusView bonusPercentage:(NSString *)bonusPercentage;

@end

@interface OFBonusView : UIScrollView

@property (nonatomic, weak) id<OFBonusViewDelegate> bonusDelegate;

- (void)updateFundInfo:(OFPoolModel *)pool;

@end
