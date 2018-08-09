//
//  OFChooseView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFChooseView;
@protocol OFChooseViewDelegate <NSObject>
@optional
- (void)chooseView:(OFChooseView *)sectionView didSelectedWord:(NSString *)word index:(NSInteger)index;

@end

@interface OFChooseView : UIView

@property (nonatomic, weak) id<OFChooseViewDelegate> delegate;

- (void)setDataArr:(NSArray<NSString *> *)dataArr;

- (CGSize)viewSize;

@end
