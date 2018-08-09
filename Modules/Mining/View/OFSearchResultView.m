//
//  OFSearchResultView.m
//  OFBank
//
//  Created by xiepengxiang on 09/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFSearchResultView.h"

#define kMargin_Left 15
#define kView_Height 50
#define kTop_Padding (IS_IPHONE_X ? 40 : 20)

@interface OFSearchResultView ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) CALayer *searchBackLayer;
@property (nonatomic, strong) UIImageView *searchIcon;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *cancleBtn;

@end

@implementation OFSearchResultView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame]) {
        [self loadTableView:style];
        [self addSubview:self.headerView];
        self.backgroundColor = OF_COLOR_WHITE;
    }
    return self;
}

- (void)beginSearch
{
    [self resetSearchStatus];
    [self.tableView reloadData];
    [self.searchTextField becomeFirstResponder];
}

- (void)endSearch
{
    [self.searchTextField resignFirstResponder];
    [self resetSearchStatus];
}

#pragma mark - callback
- (void)searchKeyword:(NSString *)keyword
{
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchRessultView:searchKeyword:)]) {
        [self.searchDelegate searchRessultView:self searchKeyword:keyword];
    }
}

- (void)loadMore
{
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(searchRessultViewLoadMore:)]) {
        [self.searchDelegate searchRessultViewLoadMore:self];
    }
}

- (void)searchCancle
{
    if (self.searchDelegate && [self.searchDelegate respondsToSelector:@selector(cancleSearchRessultView:)]) {
        [self.searchDelegate cancleSearchRessultView:self];
    }
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.searchDelegate numberOfSearchResultSection:self];
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.searchDelegate searchRessultView:self numberOfRowInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.searchDelegate searchRessultView:self cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.searchDelegate searchRessultView:self heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.searchDelegate searchRessultView:self didSelectedRowAtIndexPath:indexPath];
    [self endSearch];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length < 1) {
        return YES;
    }
    [self searchKeyword:textField.text];
    
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self endEditing:YES];
}

- (void)cancleBtnClick{
    NSLog(@"取消");
    [self endEditing:YES];
    [self searchCancle];
}

- (void)resetSearchStatus
{
    _searchTextField.text = @"";
}

#pragma mark - lazy load
- (void)loadTableView:(UITableViewStyle)style
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:style];
        UIView *header = [[UIView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kTop_Padding + kView_Height}];
        _tableView.tableHeaderView = header;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.0;
        _tableView.backgroundColor = OF_COLOR_BACKGROUND;
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        WEAK_SELF;
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadMore];
        }];
        [self addSubview:_tableView];
    }
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kTop_Padding + kView_Height)];
        _headerView.backgroundColor = OF_COLOR_WHITE;
        [_headerView.layer addSublayer:self.searchBackLayer];
        [_headerView addSubview:self.searchTextField];
        [_headerView addSubview:self.cancleBtn];
        [_headerView addSubview:self.searchIcon];
    }
    return _headerView;
}

- (CALayer *)searchBackLayer
{
    if (!_searchBackLayer) {
        _searchBackLayer = [CALayer layer];
        _searchBackLayer.frame = (CGRect){kMargin_Left, kTop_Padding + kView_Height * 0.25, kScreenWidth * 0.8, kView_Height * 0.5};
        _searchBackLayer.backgroundColor = OF_COLOR_SEPARATOR.CGColor;
        _searchBackLayer.masksToBounds = YES;
        _searchBackLayer.cornerRadius = kView_Height * 0.25;
    }
    return _searchBackLayer;
}

- (UIImageView *)searchIcon
{
    if (!_searchIcon) {
        _searchIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mining_search"]];
        _searchIcon.frame = CGRectMake(kMargin_Left * 2, kTop_Padding + kView_Height * 0.35, kView_Height * 0.3, kView_Height * 0.3);
    }
    return _searchIcon;
}

- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.frame = (CGRect){kMargin_Left * 2.5 + kView_Height * 0.3, kTop_Padding, kScreenWidth * 0.8, kView_Height};
        _searchTextField.placeholder = @"搜索矿池名称";
        _searchTextField.borderStyle = UITextBorderStyleNone;
        _searchTextField.font = [NUIUtil fixedFont:13];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.textColor = OF_COLOR_TITLE;
        _searchTextField.layer.cornerRadius = 25.0 * 0.5;
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancleBtn.frame = (CGRect){kScreenWidth * 0.85, kTop_Padding, kScreenWidth * 0.15, kView_Height};
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:OF_COLOR_TITLE forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [NUIUtil fixedFont:17];
        [_cancleBtn setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_cancleBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [_cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}

@end
