//
//  OFPoolSectionView.h
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OFPoolHeaderStyle) {
    OFPoolHeaderStyleDefault,
    OFPoolHeaderStyleLeft,
};

@class OFPoolSectionView;
@class OFPoolSectionSearchView;
@protocol OFPoolSectionViewDelegate <NSObject>

- (void)sectionView:(OFPoolSectionView *)sectionView didSelectedButtonIndex:(NSUInteger)index;

@optional
- (void)sectionSearchViewDidSearch:(OFPoolSectionSearchView *)sectionView;

@end

@interface OFPoolSectionView : UIView

@property (nonatomic, assign) OFPoolHeaderStyle style;

@property (nonatomic, weak) id<OFPoolSectionViewDelegate> delegate;

- (void)setDataArr:(NSArray<NSString *> *)dataArr;


- (void)setSeparatorLineHidden:(BOOL)isHidden;
- (void)setSelectedLineColor:(UIColor *)color;
- (void)setSelectedTitleColor:(UIColor *)titleColor;
- (void)setSelectedItemAtIndex:(NSInteger)index;


@end

@interface OFPoolSectionSearchView : UIView

@property (nonatomic, weak) id<OFPoolSectionViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate;

- (void)setDataArr:(NSArray<NSString *> *)dataArr;

@end

