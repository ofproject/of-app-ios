//
//  OFAllMiningPoolVC.m
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFAllMiningPoolVC.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "OFAllMiningLogic.h"
#import "OFAllMiningCell.h"
#import "OFMyMiningPoolVC.h"
#import "OFSearchResultView.h"
#import "OFMiningSearchLogic.h"
#import "OFWebViewController.h"
#import "OFBannerModel.h"
#import "OFMyMiningLogic.h"
#import "OFPoolModel.h"
#import "OFRecruitLeaderController.h"

@interface OFAllMiningPoolVC ()<OFAllMiningLogicDelegate,SDCycleScrollViewDelegate,OFSearchResultViewDelegate,OFMiningSearchLogicDelegate>

@property (nonatomic, strong) SDCycleScrollView *bannerView;
@property (nonatomic, strong) OFPoolSectionSearchView *sectionSearchView;
@property (nonatomic, strong) UILabel *footerView;
@property (nonatomic, strong) OFAllMiningLogic *logic;
@property (nonatomic, strong) OFSearchResultView *searchResultView;
@property (nonatomic, strong) OFMiningSearchLogic *searchLogic;
@property (nonatomic, strong) OFMyMiningLogic *myMiningLogic;

@end

@implementation OFAllMiningPoolVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

- (void)initUI
{
    self.title = @"全球矿池";
    
    if (!KcurUser.isPoolManager) {
        [self addNavigationItemWithTitles:@[@"申请领主"] isLeft:NO target:self action:@selector(applyLeader) tags:nil];
    }
    
    _bannerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, KWidthFixed(150))
                                                     delegate:self
                                             placeholderImage:nil];
    _bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _bannerView.autoScrollTimeInterval = 5;
    
    [self.tableView registerClass:[OFAllMiningCell class] forCellReuseIdentifier:kAllMiningCellIdentifier];
    self.tableView.tableHeaderView = self.bannerView;
    self.bannerView.imageURLStringsGroup = [self.logic bannerUrls];
    
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
    
    WEAK_SELF;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 下拉刷新
        [weakSelf.logic refreshCommunities];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        // 上拉加载
        [weakSelf.logic loadMoreCommunities];
    }];
    
    [self.view addSubview:self.searchResultView];
    
    [self.searchResultView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

- (void)initData
{
    [self.logic getFirstScreen];
    
    [self.partMenu setDataArr:[self.logic partMenus]];
    [self.sectionSearchView setDataArr:[self.logic defaultSectionItems]];
}

#pragma mark - action
- (void)poolClick
{
    if ([self.myMiningLogic isMyPool]) {
        [self quitPool];
    }else {
        [self joinPool];
    }
}

- (void)joinPool
{
    if (KcurUser.community) {
        NSString *title = [NSString stringWithFormat:@"您当前在%@矿池, 确定要加入%@？", KcurUser.community.name, self.myMiningLogic.pool.name];
        [self AlertWithTitle:nil message:title andOthers:@[@"取消", @"确定"] animated:YES action:^(NSInteger index) {
            if (index == 1) {
                NSLog(@"-----强制加入矿池----");
                [self joinOrQuitPool:NO];
            }
        }];
    }else {
        [self joinOrQuitPool:NO];
    }
}

- (void)quitPool
{
    WEAK_SELF;
    NSString *title = @"退出矿池会清空当前所在矿池的贡献值，确定退出吗？";
    [self AlertWithTitle:nil message:title andOthers:@[@"取消",@"确定"] animated:YES action:^(NSInteger index) {
        if (index == 1) {
            [weakSelf joinOrQuitPool:YES];
        }
    }];
}

- (void)joinOrQuitPool:(BOOL)isQuit
{
    WEAK_SELF;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.myMiningLogic joinOrLeaveCommunity:isQuit finished:^(BOOL success, id obj, NSError *error, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (success) {
            [MBProgressHUD showSuccess:message];
        }else {
            [MBProgressHUD showError:message];
        }
        [weakSelf.tableView reloadData];
        [weakSelf.searchResultView.tableView reloadData];
    }];
}

- (void)applyLeader
{
    [[OFJumpManager sharedOFJumpManager] jumpWithType:OFJumpTypeSegueNative urlStr:URL_Native_ApplyLaird title:nil paramStr:nil];
}

#pragma mark - TableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.logic numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logic itemCountOfSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFAllMiningCell *cell = [tableView dequeueReusableCellWithIdentifier:kAllMiningCellIdentifier];
    OFPoolModel *model = [self.logic itemAtIndex:indexPath];
    [cell setModel:model];
    [cell showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:15.f trailingOffset:15.f];
    WEAK_SELF;
    cell.joinCallback = ^(OFPoolModel *model) {
        weakSelf.myMiningLogic.pool = model;
        [weakSelf poolClick];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionSearchView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.logic isEmptyData]) {
        return self.footerView;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAllMiningCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.sectionSearchView.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.logic isEmptyData]) {
        return KHeightFixed(60);
    }
    return 10.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    OFPoolModel *model = [self.logic itemAtIndex:indexPath];
    OFMyMiningPoolVC *myPoolVC = [[OFMyMiningPoolVC alloc] initWithPool:model];
    [self.navigationController pushViewController:myPoolVC animated:YES];
}

#pragma mark - OFSearchResultViewDelegate
- (void)searchRessultView:(OFSearchResultView *)searchRestuleView searchKeyword:(NSString *)keyword
{
    [self.searchLogic searchFromAllMiningPool:keyword];
}

- (void)searchRessultViewLoadMore:(OFSearchResultView *)searchRestuleView
{
    [self.searchLogic loadMoreCommunities];
}

- (void)cancleSearchRessultView:(OFSearchResultView *)searchRestuleView
{
    [UIView animateWithDuration:0.2 animations:^{
        [self.searchResultView endSearch];
        self.searchResultView.hidden = YES;
    }];
    [self.searchLogic resetStatus];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (NSUInteger)numberOfSearchResultSection:(OFSearchResultView *)searchRestuleView
{
    return [self.searchLogic numberOfSection];
}

- (NSUInteger)searchRessultView:(OFSearchResultView *)searchRestuleView numberOfRowInSection:(NSInteger)section
{
    return [self.searchLogic itemCountOfSection:section];
}

- (UITableViewCell *)searchRessultView:(OFSearchResultView *)searchRestuleView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFAllMiningCell *cell = [searchRestuleView.tableView dequeueReusableCellWithIdentifier:kAllMiningCellIdentifier];
    OFPoolModel *model = [self.searchLogic itemAtIndex:indexPath];
    [cell setModel:model];
    [cell showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:15.f trailingOffset:15.f];
    WEAK_SELF;
    cell.joinCallback = ^(OFPoolModel *model) {
        weakSelf.myMiningLogic.pool = model;
        [weakSelf poolClick];
    };
    return cell;
}

- (CGFloat)searchRessultView:(OFSearchResultView *)searchRestuleView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kAllMiningCellHeight;
}

- (void)searchRessultView:(OFSearchResultView *)searchRestuleView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFPoolModel *model = [self.searchLogic itemAtIndex:indexPath];
    OFMyMiningPoolVC *myPoolVC = [[OFMyMiningPoolVC alloc] initWithPool:model];
    [self.navigationController pushViewController:myPoolVC animated:YES];
    
    [self.searchResultView endSearch];
    self.searchResultView.hidden = YES;
    [self.searchLogic resetStatus];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    OFBannerModel *model = [self.logic bannerModelAtIndex:index];
    if (model.h5Url.length > 0 || model.nativeUrl.length > 0) {
        NSString *url = model.h5Url;
        if (model.bannerType == 1) {
            url = model.nativeUrl;
        }
        [[OFJumpManager sharedOFJumpManager] jumpWithType:model.bannerType urlStr:url title:model.name paramStr:nil];
    }
}

#pragma mark - BaseLogicDelegate
- (void)requestBannerSuccess
{
    _bannerView.imageURLStringsGroup = [self.logic bannerUrls];
    [self.partMenu setDataArr:[self.logic partMenus]];
}

- (void)requestBannerFailure:(NSString *)message
{
    
}

- (void)requestDataSuccess
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.tableView reloadData];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - OFPoolSectionViewDelegate
- (void)sectionView:(OFPoolSectionView *)sectionView didSelectedButtonIndex:(NSUInteger)index
{
    // 全球矿池1 活跃度榜 2  节点榜 3  基金榜 4
    if (index != 0) {
        index++;
    }
    self.logic.rankType = index;
}

- (void)sectionSearchViewDidSearch:(OFPoolSectionSearchView *)sectionView
{
    // 搜索内容
    NSLog(@"搜索内容");
    [UIView animateWithDuration:0.2 animations:^{
        self.searchResultView.hidden = NO;
        [self.searchResultView beginSearch];
    }];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

#pragma mark - OFMiningSearchLogicDelegate
- (void)requestSearchResultSuccess
{
    [self.searchResultView.tableView.mj_footer endRefreshing];
    [self.searchResultView.tableView reloadData];
    if ([self.searchLogic isEmptyData]) {
        [MBProgressHUD showToast:@"没有搜索到矿池" toView:self.searchResultView];
    }
}

- (void)requestSearchResultFailure:(NSString *)message
{
    [self.searchResultView.tableView.mj_footer endRefreshing];
}

#pragma mark - lazy load
- (OFAllMiningLogic *)logic
{
    if (!_logic) {
        _logic = [[OFAllMiningLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (OFPoolSectionSearchView *)sectionSearchView
{
    if (!_sectionSearchView) {
        _sectionSearchView = [[OFPoolSectionSearchView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, 95}
                                                                   delegate:self];
        _sectionSearchView.backgroundColor = OF_COLOR_WHITE;
    }
    return _sectionSearchView;
}

- (UILabel *)footerView
{
    if (!_footerView) {
        _footerView = [UILabel labelWithFont:Font(16) textColor:[UIColor lightGrayColor] textAlignement:NSTextAlignmentCenter text:@"数据加载中，请稍候"];
        _footerView.frame = CGRectMake(0, KHeightFixed(30), kScreenWidth, KHeightFixed(30));
    }
    return _footerView;
}

- (OFSearchResultView *)searchResultView
{
    if (!_searchResultView) {
        _searchResultView = [[OFSearchResultView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, kScreenHeight}
                                                                style:UITableViewStyleGrouped];
        _searchResultView.hidden = YES;
        _searchResultView.searchDelegate = self;
        [_searchResultView.tableView registerClass:[OFAllMiningCell class] forCellReuseIdentifier:kAllMiningCellIdentifier];
    }
    return _searchResultView;
}

- (OFMiningSearchLogic *)searchLogic
{
    if (!_searchLogic) {
        _searchLogic = [[OFMiningSearchLogic alloc] initWithDelegate:self];
    }
    return _searchLogic;
}

- (OFMyMiningLogic *)myMiningLogic
{
    if (!_myMiningLogic) {
        _myMiningLogic = [[OFMyMiningLogic alloc] init];
    }
    return _myMiningLogic;
}

@end
