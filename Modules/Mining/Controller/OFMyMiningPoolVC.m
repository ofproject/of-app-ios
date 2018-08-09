//
//  OFMyMiningPoolVC.m
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFMyMiningPoolVC.h"
#import "OFMyPoolHeaderView.h"
#import "ofMyMiningLogic.h"
#import "OFMyMiningCell.h"
#import "OFMinerModel.h"
#import "OFPoolModel.h"
#import "OFShareManager.h"
#import "NLocalUtil.h"
#import "OFShareAppView.h"
#import "OFJoinPoolAlertView.h"
#import "OFMyPoolSectionView.h"
#import "OFMyPoolNavView.h"
#import "OFPoolSettingVC.h"
#import "OFPoolFundAlertView.h"
#import "OFPoolAnnounceController.h"
#import "OFPoolFundVC.h"
#import "OFReceiveProfitVC.h"

@interface OFMyMiningPoolVC () <OFMyPoolHeaderViewDelegate,OFMyPoolNavViewDelegate,OFMyMiningDelegate,OFPartMenuDelegate>

@property (nonatomic, strong) OFMyPoolNavView *navView;
@property (nonatomic, strong) OFMyPoolHeaderView *poolHeaderView;
@property (nonatomic, strong) UILabel *footerView;
@property (nonatomic, strong) OFMyMiningLogic *logic;
@property (nonatomic, strong) OFMyPoolSectionView *sectionView;
@property (nonatomic, strong) UIImageView *poolFundImgView;//矿池分红图标
@property (nonatomic, strong) UIImageView *arrowImgView;//右箭头图标

@end

@implementation OFMyMiningPoolVC

- (instancetype)initWithPool:(OFPoolModel *)pool
{
    self = [super init];
    if (self) {
        self.logic.pool = pool;
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
    [self requestDataSuccess];
}

- (void)initUI
{
    self.n_isHiddenNavBar = YES;
    _poolHeaderView = [[OFMyPoolHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.35 + Nav_Height)];
    _poolHeaderView.delegate = self;
    self.partMenu.delegate = self;
    self.partMenu.frame = CGRectMake(0, kScreenWidth * 0.35 + Nav_Height, kScreenWidth, kScreenWidth * 0.2);
//    self.partMenu.backgroundColor = KRedColor;
    self.arrowImgView.frame = CGRectMake(self.partMenu.width - KWidthFixed(20) - KWidthFixed(19/2.0), self.partMenu.height/2.0 - KWidthFixed(31/2.0)/2.0, KWidthFixed(19/2.0), KWidthFixed(31/2.0));
    [self.partMenu addSubview:self.arrowImgView];
    self.headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.55 + Nav_Height + 10);
    [self.headerView addSubview:_poolHeaderView];
    [self.headerView addSubview:self.partMenu];
    
    [self.tableView registerClass:[OFMyMiningCell class] forCellReuseIdentifier:kMyMiningCellIdentifier];
    self.tableView.tableHeaderView = self.headerView;
    
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
    
    [self.view addSubview:self.poolFundImgView];
    [self.poolFundImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(56);
        make.height.mas_equalTo(58);
        make.bottom.mas_equalTo(49 - kTabbar_Height-55);
        make.right.mas_equalTo(-17);
    }];
    
    [self.view addSubview:self.navView];
}

- (void)initData
{
    if (!self.logic.pool) {
        OFPoolModel *model = KcurUser.community;
        self.logic.pool = model;
    }
    self.title = [self.logic navTitle];
    self.n_isWhiteStatusBar = YES;
    [self.logic getFirstScreen];
    [self.navView setPoolModel:self.logic.pool];
    [_poolHeaderView setPoolModel:self.logic.pool];
    [self.partMenu setDataArr:[self.logic partMenus]];
    //获取是否有矿池分红
    [self.logic getPoolFundCount];
}

#pragma mark - 矿池分红回调
-(void)getPoolFuntCallBack:(BOOL)isHas{
    if (isHas) {
        //显示领取图标
        self.poolFundImgView.hidden = NO;
    }else{
        //隐藏领取图标
        self.poolFundImgView.hidden = YES;
    }
}

#pragma mark - 领取基金分红回调 弹窗
-(void)receivedPoolFuntCallBack:(float)ofcnt{
    self.poolFundImgView.hidden = YES;
    if (ofcnt >0.001) {
        WEAK_SELF;
        OFPoolFundAlertView *alertView = [OFPoolFundAlertView loadFromXib];
        alertView.frame = self.view.bounds;
        [alertView showPoolFundAlertView:self.view withRewardValue:ofcnt WithBlock:^{
            OFReceiveProfitVC *vc = [OFReceiveProfitVC new];
            vc.type = miningProfit;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }];
    }
}

#pragma mark - override
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offset = scrollView.contentOffset.y;
    [self.navView updateScrollViewContentOffSet:offset range:self.poolHeaderView.height];
    if (offset < self.poolHeaderView.height) {
        self.n_isWhiteStatusBar = YES;
    }else {
        self.n_isWhiteStatusBar = NO;
    }
}

#pragma mark - 展示分享弹窗
- (void)showShareView{
    if (self.logic.shareInfo) {
        OFSharedModel *model = [[OFSharedModel alloc]init];
        model.sharedType = OFSharedTypeUrl;
        model.urlString = self.logic.shareInfo[@"url"];
        model.thumbImage = IMAGE_NAMED(@"AppIcon");
        model.title = self.logic.shareInfo[@"shareTitle"];
        model.descript = self.logic.shareInfo[@"shareContent"];
        model.cid = self.logic.pool.cid;
        OFShareAppView *shareAppView = [OFShareAppView loadFromXib];
        [shareAppView showShareAppViewToView:self.view shareType:1 poolName:self.logic.pool.name shareModel:model];
    }else{
        [self.logic getShareInfo];
        [MBProgressHUD showError:@"分享信息拉取失败，请重试"];
    }
}
#pragma mark - 加入/退出矿池操作 action
- (void)poolClick
{
    if ([self.logic isMyPool]) {
        [self quitPool];
    }else {
        [self joinPool];
    }
}

- (void)joinPool
{
    if (KcurUser.community) {
        NSString *title = [NSString stringWithFormat:@"您当前在%@矿池, 确定要加入%@？", KcurUser.community.name, self.logic.pool.name];
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
    [self.logic joinOrLeaveCommunity:isQuit finished:^(BOOL success, id obj, NSError *error, NSString *message) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        if (success) {
            [MBProgressHUD showSuccess:message];
        }else {
            [MBProgressHUD showError:message];
        }
        [weakSelf.navView setPoolModel:weakSelf.logic.pool];
        [weakSelf.poolHeaderView setPoolModel:weakSelf.logic.pool];
        [weakSelf.partMenu setDataArr:[self.logic partMenus]];
    }];
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
    OFMyMiningCell *cell = [tableView dequeueReusableCellWithIdentifier:kMyMiningCellIdentifier];
    OFMinerModel *model = [self.logic itemAtIndex:indexPath];
    [cell setModel:model];
    [cell showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:15.f trailingOffset:15.f];
    return cell;
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
    return kMyMiningCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([self.logic isEmptyData]) {
        return KHeightFixed(60);
    }
    return 0.0001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.sectionView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
}

#pragma mark - BaseLogicDelegate
- (void)requestDataSuccess
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.navView setPoolModel:self.logic.pool];
    [_poolHeaderView setPoolModel:self.logic.pool];
    [_sectionView updateNodeNumber:[self.logic poolNodeCount]];
    [self.partMenu setDataArr:[self.logic partMenus]];
    [self.footerView setText:@"暂无节点在协同挖矿"];
    [self.tableView reloadData];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self.footerView setText:@"网络不给力，请重试"];
}

#pragma mark - OFMyPoolNavViewDelegate
- (void)navViewDidSelectedNavBack:(OFMyPoolNavView *)navView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navViewDidSelectedSetting:(OFMyPoolNavView *)navView
{
    OFPoolSettingVC *controller = [[OFPoolSettingVC alloc] initWithPool:self.logic.pool];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)navView:(OFMyPoolNavView *)navView isQuit:(BOOL)isQuit
{
    [self poolClick];
}

#pragma mark - OFPartMenuDelegate
- (void)partMenu:(OFPartMenu *)menu didSelectedButtonIndex:(NSUInteger)index
{
    OFPoolFundVC *contoller = [[OFPoolFundVC alloc] initWithPool:self.logic.pool];
    [self.navigationController pushViewController:contoller animated:YES];
}

#pragma mark - OFPoolSectionViewDelegate
- (void)sectionView:(OFPoolSectionView *)sectionView didSelectedButtonIndex:(NSUInteger)index
{
    self.logic.rankType = index;
}

#pragma mark - OFMyPoolHeaderViewDelegate
- (void)poolHeaderNoobSelected:(OFMyPoolHeaderView *)headerView
{
    NSString *content = [self.logic noobContent];
    OFJoinPoolAlertView *alertView = [OFJoinPoolAlertView loadFromXib];
    alertView.frame = self.view.bounds;
    [alertView show:self.view title:@"新手联盟" content:content btnblock:^{
        
    }];
}

- (void)poolHeaderQrcodeShareSelected:(OFMyPoolHeaderView *)headerView
{
    [self showShareView];
}

- (void)poolHeaderAnnounceSelected:(OFMyPoolHeaderView *)headerView
{
    OFPoolAnnounceController *controller = [[OFPoolAnnounceController alloc] initWithPool:self.logic.pool];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 领取基金分红
- (void)showPoolAlertView{
    [self.logic receivedPoolFundCount];
}

#pragma mark - lazy load
- (OFMyMiningLogic *)logic
{
    if (!_logic) {
        _logic = [[OFMyMiningLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (OFMyPoolNavView *)navView
{
    if (!_navView) {
        _navView = [[OFMyPoolNavView alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, Nav_Height)];
        _navView.delegate = self;
    }
    return _navView;
}

- (UILabel *)footerView
{
    if (!_footerView) {
        _footerView = [UILabel labelWithFont:Font(16) textColor:[UIColor lightGrayColor] textAlignement:NSTextAlignmentCenter text:@"数据加载中，请稍候"];
        _footerView.frame = CGRectMake(0, KHeightFixed(30), kScreenWidth, KHeightFixed(30));
    }
    return _footerView;
}

- (OFMyPoolSectionView *)sectionView
{
    if (!_sectionView) {
        _sectionView = [[OFMyPoolSectionView alloc] initWithFrame: CGRectZero];
    }
    return _sectionView;
}

-(UIImageView *)poolFundImgView{
    if (!_poolFundImgView) {
        _poolFundImgView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"poolFund_icon")];
        _poolFundImgView.userInteractionEnabled = YES;
        _poolFundImgView.hidden = YES;
        WEAK_SELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf showPoolAlertView];
        }];
        [_poolFundImgView addGestureRecognizer:tap];
    }
    return _poolFundImgView;
}

-(UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"profile_arrow_small")];
    }
    return _arrowImgView;
}

@end
