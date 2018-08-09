//
//  OFSearchResultView.h
//  OFBank
//
//  Created by xiepengxiang on 09/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFSearchResultView;
@protocol OFSearchResultViewDelegate <NSObject>

- (void)searchRessultView:(OFSearchResultView *)searchRestuleView searchKeyword:(NSString *)keyword;
- (void)searchRessultViewLoadMore:(OFSearchResultView *)searchRestuleView;
- (void)cancleSearchRessultView:(OFSearchResultView *)searchRestuleView;

- (NSUInteger)numberOfSearchResultSection:(OFSearchResultView *)searchRestuleView;
- (NSUInteger)searchRessultView:(OFSearchResultView *)searchRestuleView numberOfRowInSection:(NSInteger)section;
- (UITableViewCell *)searchRessultView:(OFSearchResultView *)searchRestuleView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)searchRessultView:(OFSearchResultView *)searchRestuleView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)searchRessultView:(OFSearchResultView *)searchRestuleView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface OFSearchResultView : UIView

@property (nonatomic, weak) id<OFSearchResultViewDelegate> searchDelegate;

@property (nonatomic, strong) UITableView *tableView;

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style;

- (void)beginSearch;
- (void)endSearch;

@end
