//
//  OFProWalletVC.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//  pro版本首页

#import "OFProWalletVC.h"
#import "OFProWalletCell.h"

#import "OFProWalletHeaderView.h"

#import "OFGetMoneyVC.h"
#import "OFWalletModel.h"
#import "OFTokenModel.h"
#import "OFProWelcomeVC.h"
#import "OFCipherManager.h"
#import "OFProWalletAPI.h"
#import "OFProGetMoneyVC.h"

#import "OFProWalletHeaderCell.h"

#import "OFProWalletLogic.h"
#import "OFProWalletDetailVC.h"

#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>

@interface OFProWalletVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BaseLogicDelegate,UICollectionViewDelegate,UICollectionViewDataSource>



@property (nonatomic, strong) UIPageControl *pageView;



//@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSArray<OFTokenModel *> *tokens;

@property (nonatomic, strong) OFProWalletLogic *walletLogic;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString *const cellID = @"OFProWalletCell";
static NSString *const itemID = @"OFProWalletHeaderCell";

@implementation OFProWalletVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"钱包";
    
    self.n_isHiddenNavBar = YES;
    
    __block NSInteger index = 0;
    if (!KcurUser.currentProWallet){
        
        if (KcurUser.proWallets.count != 0){
            KcurUser.currentProWallet = KcurUser.proWallets.firstObject;
        }
    }else{
        // current存在.
        
        [KcurUser.proWallets enumerateObjectsUsingBlock:^(OFProWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([obj.address isEqualToString:KcurUser.currentProWallet.address]) {
                KcurUser.currentProWallet = obj;
                index = idx;
            }
        }];
    }
    
    self.walletLogic = [[OFProWalletLogic alloc]initWithDelegate:self];
    [self.walletLogic getToken];
    [self initUI];
    [self layout];
//    [self initData];
    
//    [self.collectionView reloadData];
    
    self.pageView.numberOfPages = KcurUser.proWallets.count;
    self.pageView.currentPage = index;
    [self.collectionView layoutIfNeeded];
    [self.collectionView setContentOffset:CGPointMake(kScreenWidth * index, 0) animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(proAddressChange:) name:OF_PRO_ADDRESS_NOTI object:nil];
    
    
    if (KcurUser.proWallets.count == 0) {
        NSLog(@"%@",KcurUser);
        
        OFProWelcomeVC *vc = [[OFProWelcomeVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    
//    [self getBalance];
#if defined(Dev)
    NSLog(@"开发版");
#elif defined(Test)
    NSLog(@"测试版");
#endif
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.walletLogic getBalance];
    
}

- (void)initUI{
    
    [self.tableView registerNib:[OFProWalletCell nib] forCellReuseIdentifier:cellID];
    self.tableView.mj_footer = nil;
    self.tableView.rowHeight = KWidthFixed(62.5);
    
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageView];
}

- (void)layout{
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(235);
    }];
    
    [self.pageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.right.mas_equalTo(self.view.mas_right).offset(-25);
        make.bottom.mas_equalTo(self.collectionView.mas_bottom);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(10);
    }];
}

- (void)initData{
    
    
    
    
    /*
    [self.scrollView removeAllSubviews];
    
    if (KcurUser.proWallets.count == 1) {
        self.pageView.hidden = YES;
    }
    
    for (int i = 0;i < KcurUser.proWallets.count; i++) {
        
        OFProWalletHeaderView *headerView = [[OFProWalletHeaderView alloc]initWithFrame:CGRectMake(kScreenWidth * i, 0, kScreenWidth, 235)];
        
        [self.scrollView addSubview:headerView];
        
        OFProWalletModel *model = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:i];
        headerView.model = model;
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * KcurUser.proWallets.count, 0);
    self.pageView.numberOfPages = KcurUser.proWallets.count;
    self.pageView.currentPage = 0;
    self.scrollView.contentOffset = CGPointMake(0, 0);
    
    
    
    
    if (KcurUser.currentProWallet){
        
        for (int i = 0; i < KcurUser.proWallets.count; i++) {
            OFProWalletModel *model = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:i];
            
            if ([model.address isEqualToString:KcurUser.currentProWallet.address]){
                self.pageView.currentPage = i;
                self.scrollView.contentOffset = CGPointMake(kScreenWidth * i, 0);
                return;
            }
            
        }
    }
    */
}

- (void)refreHeaderData{
    
    [self.collectionView reloadData];
    
    // 更新头部数据
//    for (int i = 0; i < self.scrollView.subviews.count; i++) {
//        OFProWalletHeaderView *headerView = [NDataUtil classWithArray:[OFProWalletHeaderView class] array:self.scrollView.subviews index:i];
//
//        if (headerView.model) {
//
//            [KcurUser.proWallets enumerateObjectsUsingBlock:^(OFProWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                if ([headerView.model.address isEqualToString:obj.address] && headerView.model.balance != obj.balance) {
//
//                    headerView.model = obj;
//                }
//            }];
//
//        }
//    }
}

#pragma mark ————— 下拉刷新 —————
- (void)headerRereshing{
    [self.walletLogic getBalance];
    
}

#pragma mark - BaseLogicDelegate
- (void)requestDataSuccess{
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    self.pageView.numberOfPages = KcurUser.proWallets.count;
}

- (void)requestDataFailure:(NSString *)errMessage{
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
    [self.collectionView reloadData];
    self.pageView.numberOfPages = KcurUser.proWallets.count;
}

#pragma mark ————— colloctView 代理数据源 —————
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger num = KcurUser.proWallets.count;
    NSLog(@"%zd",num);
    return KcurUser.proWallets.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    OFProWalletHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:itemID forIndexPath:indexPath];
    
    cell.model = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    OFProWalletDetailVC *vc = [[OFProWalletDetailVC alloc]init];
    
    OFProWalletModel *model = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:indexPath.row];
    
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark ————— tableView 代理数据源 —————
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.walletLogic itemCountOfSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OFProWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    
    cell.model = [self.walletLogic itemAtIndex:indexPath];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    OFTokenModel *model = [NDataUtil classWithArray:[OFTokenModel class] array:KcurUser.currentProWallet.tokens index:indexPath.row];
    
    OFProGetMoneyVC *vc = [[OFProGetMoneyVC alloc]init];
    
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    
    if (scrollView != self.collectionView) {
        return;
    }
    
    int page = self.collectionView.contentOffset.x / self.collectionView.width;
//    NSLog(@"第 %d 页",page);
//    int page = self.scrollView.contentOffset.x / self.scrollView.width;
    self.pageView.currentPage = page;
    
    OFProWalletModel *model = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:page];
    
    if ([model isEqual:KcurUser.currentProWallet]) {
        return;
    }
    
    KcurUser.currentProWallet = model;
    [self.tableView reloadData];
    [self.walletLogic getBalance];
    
}

- (void)proAddressChange:(NSNotification *)noti{
    
    NSLog(@"%@",noti);
    
    [self initData];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ————— 懒加载 —————
//- (NSArray *)dataArray{
//    if (_dataArray == nil) {
//
//        NSDictionary *dict1 = @{@"name":@"OF",@"icon":@"",@"money":@"1111"};
//        NSDictionary *dict2 = @{@"name":@"Token1",@"icon":@"",@"money":@"2222"};
//        NSDictionary *dict3 = @{@"name":@"Token2",@"icon":@"",@"money":@"3333"};
//        NSDictionary *dict4 = @{@"name":@"Token3",@"icon":@"",@"money":@"4444"};
//
//        _dataArray = @[dict1,dict2,dict3,dict4];
//    }
//    return _dataArray;
//}

- (UIPageControl *)pageView{
    if (!_pageView) {
        _pageView = [[UIPageControl alloc]init];
        _pageView.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageView.pageIndicatorTintColor = [UIColor colorWithRGB:0xd1d1d1];
    }
    return _pageView;
}

- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kScreenWidth, 235);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumLineSpacing = 0;
//        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[OFProWalletHeaderCell class] forCellWithReuseIdentifier:itemID];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
//        _collectionView.scrollEnabled = NO;
    }
    
    return _collectionView;
}

@end
