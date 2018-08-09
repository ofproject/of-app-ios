//
//  OFRedPacketController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRedPacketController.h"
#import "OFRedPacketCell.h"
#import "OFRedPacketLogic.h"
#import "OFNavView.h"
#import "OFRedPacketHeaderView.h"
#import "OFPoolSectionView.h"
#import "OFRedPacketSectionView.h"
#import "OFPacketSendController.h"
#import "OFPacketDetailController.h"
#import "OFCashOutVC.h"

@interface OFRedPacketController ()<OFRedPacketLogicDelegate, OFPoolSectionViewDelegate,PacketSendControllerDelegate>

@property (nonatomic, strong) OFRedPacketLogic *logic;
@property (nonatomic, strong) OFNavView *navView;
@property (nonatomic, strong) OFRedPacketHeaderView *headerView;
@property (nonatomic, strong) OFPoolSectionView *segmentView;
@property (nonatomic, strong) OFRedPacketSectionView *sectionView;
@property (nonatomic, strong) UIButton *sendPacket;
@property (nonatomic, strong) UILabel *footerView;

@end

@implementation OFRedPacketController

- (instancetype)initWithReward:(NSString *)reward
{
    self = [super init];
    if (self) {
        self.logic.reward = reward;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.logic getRedPacketReward];
}

- (void)initUI
{
    self.n_isHiddenNavBar = YES;
    
    self.tableView.mj_header = nil;
    CGRect containerFrame = CGRectMake(0, 0, kScreenWidth, self.headerView.height + self.segmentView.height);
    UIView *container = [[UIView alloc] initWithFrame: containerFrame];
    [container addSubview:self.headerView];
    self.segmentView.frame = CGRectMake(0, self.headerView.height, kScreenWidth, self.segmentView.height);
    [container addSubview:self.segmentView];
    
    self.tableView.tableHeaderView = container;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.tableView registerClass:[OFRedPacketCell class] forCellReuseIdentifier:OFRedPacketCellIdentifier];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.navView];
}

- (void)initData
{
    [self.segmentView setDataArr:[self.logic defaultSectionItems]];
    [self.logic getFirstScreen];
    [self.sectionView updateInfo: [self.logic sectionTitle]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRefreshWallet object:nil];
}

#pragma mark - Action
- (void)footerRereshing
{
    [self.logic loadMorePacketList];
}

- (void)transferRedPacket
{
    // 红包提现
    OFCashOutVC *vc = [OFCashOutVC new];
    vc.type = redPacket;
    vc.redPacketReward = self.logic.reward;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)sendRedPacket
{
    [self returnBack];
}

- (void)moveToPacketDetail:(OFRedPacketModel *)packet
{
    OFPacketDetailController *controller = [[OFPacketDetailController alloc] initWithPacket:packet];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - PacketSendControllerDelegate
- (void)packetSendControlerToDetail:(OFRedPacketModel *)packet
{
    [self moveToPacketDetail:packet];
}

- (void)packetSendPopBack
{
    [self.segmentView setSelectedItemAtIndex:1];
    [self.logic refreshPacketList];
}

#pragma mark - OFPoolSectionViewDelegate
- (void)sectionView:(OFPoolSectionView *)sectionView didSelectedButtonIndex:(NSUInteger)index
{
    self.logic.rankType = index;
}

#pragma mark - OFRedPacketLogicDelegate
- (void)requestDataSuccess
{
    [self.tableView.mj_footer endRefreshing];
    [self.tableView.mj_footer resetNoMoreData];
    [self.sectionView updateInfo: [self.logic sectionTitle]];
    [self.tableView reloadData];
}

- (void)requesetNomoreDataSuccess
{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];
    [self.sectionView updateInfo: [self.logic sectionTitle]];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [self.tableView.mj_footer endRefreshing];
    [MBProgressHUD showError:errMessage];
}

- (void)requestRedPacketRewardSuccess:(NSString *)reward
{
    [self.headerView updateInfo:reward];
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
    OFRedPacketCell *cell = [tableView dequeueReusableCellWithIdentifier:OFRedPacketCellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFRedPacketModel *model = [self.logic itemAtIndex:indexPath];
    OFRedPacketCell *packetCell = (OFRedPacketCell *)cell;
    [packetCell updateInfo:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return OFRedPacketCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.sectionView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if ([self.logic isEmptyData]) {
        return self.footerView;
    }
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.logic isEmptyData]) {
        return KHeightFixed(200);
    }
    return 0.0001f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFRedPacketModel *model = [self.logic itemAtIndex:indexPath];
    [self moveToPacketDetail:model];
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
        CGFloat topHeight = KHeightFixed(180) - 64 + Nav_Height;
        self.headerView.frame = CGRectMake(0, top, kScreenWidth, topHeight - top);
    }
}

#pragma mark - lazy load
- (OFRedPacketLogic *)logic
{
    if (!_logic) {
        _logic = [[OFRedPacketLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (OFNavView *)navView{
    if (!_navView) {
        _navView = [[OFNavView alloc]initWithTitle:@"我的红包"];
        _navView.frame = CGRectMake(0, 0, kScreenWidth, Nav_Height);
        [_navView setNavBackgroundColor: OF_COLOR_RED];
        [_navView setNavTitleColor:OF_COLOR_WHITE];
        [_navView setNavElementColor:OF_COLOR_WHITE];
        [_navView setShadowHidden:YES];
        WEAK_SELF;
        [_navView addRightItemWithTitle:@"提现" titleColor:OF_COLOR_WHITE imageName:nil action:^{
            [weakSelf transferRedPacket];
        }];
    }
    return _navView;
}

- (OFRedPacketHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [[OFRedPacketHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KHeightFixed(180) - 64 + Nav_Height)
                                                   backgroundColor: [UIColor colorWithRGB:0xe25d4c]];
    }
    return _headerView;
}

- (OFPoolSectionView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[OFPoolSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KWidthFixed(50))];
        _segmentView.backgroundColor = OF_COLOR_WHITE;
        _segmentView.delegate = self;
        [_segmentView setSelectedTitleColor:OF_COLOR_TITLE];
        [_segmentView setSeparatorLineHidden:YES];
        [_segmentView setSelectedLineColor:[UIColor colorWithRGB:0xe25d4c]];
    }
    return _segmentView;
}

- (OFRedPacketSectionView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [[OFRedPacketSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, KWidthFixed(35))];
    }
    return _sectionView;
}

- (UIButton *)sendPacket
{
    if (!_sendPacket) {
        _sendPacket = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendPacket.frame = CGRectMake(0, 0, KWidthFixed(37.f), KWidthFixed(51.f));
        [_sendPacket setImage:IMAGE_NAMED(@"redpacket_send") forState:UIControlStateNormal];
        [_sendPacket addTarget:self action:@selector(sendRedPacket) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendPacket;
}

- (UILabel *)footerView
{
    if (!_footerView) {
        _footerView = [UILabel labelWithFont:Font(16) textColor:OF_COLOR_DETAILTITLE textAlignement:NSTextAlignmentCenter text:@""];
        NSString *text = @"列表空空如也, 试着发一个吧>>";
        NSMutableAttributedString *attrText=[[NSMutableAttributedString alloc]initWithString:text];
        NSRange range = [[attrText string]rangeOfString:@">>"];
        [attrText addAttribute:NSForegroundColorAttributeName value:OF_COLOR_RED range:range];
        _footerView.attributedText = attrText;
        _footerView.frame = CGRectMake(0, KHeightFixed(80), kScreenWidth, KHeightFixed(30));
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendRedPacket)];
        [_footerView addGestureRecognizer:tap];
        _footerView.userInteractionEnabled = YES;
    }
    return _footerView;
}

@end
