//
//  OFPacketDetailController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketDetailController.h"
#import "OFPacketDetailLogic.h"
#import "OFPacketDetailCell.h"
#import "OFPacketDetailHeaderView.h"
#import "OFNavView.h"
#import "OFRedPacketSectionView.h"
#import "OFPacketDetailSendView.h"
#import "OFShareManager.h"

#define kDetailHeaderHeight ([self.logic isShowReceivedReward] ? (kScreenWidth * 0.79 + Nav_Height - 64): (kScreenWidth * 0.59 + Nav_Height - 64))
#define kSendViewHeaderHeight  ([self.logic canSendAgain] ? kTabbar_Height : 0.f )

@interface OFPacketDetailController ()<BaseLogicDelegate, PacketDetailSendViewDelegate>

@property (nonatomic, strong) OFPacketDetailLogic *logic;
@property (nonatomic, strong) OFPacketDetailHeaderView *headerView;
@property (nonatomic, strong) OFNavView *navView;
@property (nonatomic, strong) OFRedPacketSectionView *sectionView;
@property (nonatomic, strong) OFPacketDetailSendView *sendView;

@end

@implementation OFPacketDetailController

- (instancetype)initWithPacket:(OFRedPacketModel *)packet
{
    self = [super init];
    if (self) {
        self.logic.packet = packet;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.n_isHiddenNavBar = YES;
    UIView *container = [[UIView alloc] initWithFrame:self.headerView.bounds];
    container.backgroundColor = [UIColor colorWithRGB:0xe25d4c];
    [container addSubview:self.headerView];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.sendView.height);
    self.tableView.tableHeaderView = container;
    self.tableView.mj_header = nil;
    self.tableView.backgroundColor = OF_COLOR_BACKGROUND;
    [self.tableView registerClass:OFPacketDetailCell.class forCellReuseIdentifier:OFPacketDetailCellIdentifier];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navView];
    [self.view addSubview:self.sendView];
}

- (void)initData
{
    [self.logic getFirstScreen];
}

- (void)updateUI
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = CGRectMake(0, kScreenHeight - kSendViewHeaderHeight, kScreenWidth, kSendViewHeaderHeight);
        self.sendView.frame = frame;
        frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kSendViewHeaderHeight);
        self.tableView.frame = frame;
    }];
}

#pragma mark - Refresh
- (void)footerRereshing
{
    [self.logic loadMorePacketDetail];
}

#pragma mark - PacketDetailSendViewDelegate
- (void)packetDetailSendViewDidClick:(OFPacketDetailSendView *)sendView
{
    [OFShareManager sharedToWeChatWithModel:[self.logic shareInfo] controller:self];
}

#pragma mark - BaseLogicDelegate
- (void)requestDataSuccess
{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer resetNoMoreData];
    [self.headerView updateInfo:[self.logic headerInfo]
                   isShowReward:[self.logic isShowReceivedReward]
                      isExpired:[self.logic isExpired]];
    [self.sectionView updateInfo:[self.logic sectionTitle]];
    [self updateUI];
    [self.tableView reloadData];
}

- (void)requesetNomoreDataSuccess
{
     [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.headerView updateInfo:[self.logic headerInfo]
                   isShowReward:[self.logic isShowReceivedReward]
                      isExpired:[self.logic isExpired]];
    [self.sectionView updateInfo:[self.logic sectionTitle]];
    [self updateUI];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [MBProgressHUD showToast:errMessage toView:self.view];
}

#pragma mark - UITableViewDelegate
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
    OFPacketDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:OFPacketDetailCellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFPacketDetailCell *detailCell = (OFPacketDetailCell *)cell;
    OFPacketDetailModel *model = [self.logic itemAtIndex:indexPath];
    [detailCell updateInfo:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.logic heightForRowAtIndexPath:indexPath];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.sectionView.height;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self tableViewUpdateLayout:scrollView.contentOffset.y];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)tableViewUpdateLayout:(CGFloat)top
{
    if (top <= 0) {
        CGFloat topHeight = kDetailHeaderHeight;
        self.headerView.frame = CGRectMake(0, top, kScreenWidth, topHeight - top);
    }
}

#pragma mark - lazy load
- (OFPacketDetailLogic *)logic
{
    if (!_logic) {
        _logic = [[OFPacketDetailLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (OFPacketDetailHeaderView *)headerView
{
    if (!_headerView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kDetailHeaderHeight);
        _headerView = [[OFPacketDetailHeaderView alloc] initWithFrame:frame];
    }
    return _headerView;
}

- (OFNavView *)navView{
    if (!_navView) {
        _navView = [[OFNavView alloc]initWithTitle:@"红包详情"];
        _navView.frame = CGRectMake(0, 0, kScreenWidth, Nav_Height);
        [_navView setNavBackgroundColor: OF_COLOR_RED];
        [_navView setNavTitleColor:OF_COLOR_WHITE];
        [_navView setNavElementColor:OF_COLOR_WHITE];
        [_navView setShadowHidden:YES];
    }
    return _navView;
}

- (OFRedPacketSectionView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [[OFRedPacketSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KWidthFixed(35))];
    }
    return _sectionView;
}

- (OFPacketDetailSendView *)sendView
{
    if (!_sendView) {
        CGRect frame = CGRectMake(0, kScreenHeight - kSendViewHeaderHeight, kScreenWidth, kSendViewHeaderHeight);
        _sendView = [[OFPacketDetailSendView alloc] initWithFrame:frame];
        _sendView.delegate = self;
    }
    return _sendView;
}

@end
