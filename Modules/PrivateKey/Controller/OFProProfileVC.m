//
//  OFProProfileVC.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//  pro版本个人中心

#import "OFProProfileVC.h"
#import "OFProfileCell.h"
#import "UIImage+reDraw.h"
#import <AVFoundation/AVFoundation.h>


#import "OFProfileHeaderView.h"
#import "OFProProfileLogic.h"
#import "OFPersonalInfoVC.h"


#import "OFAccountSafeVC.h"
#import "OFAboutUS.h"
#import "OFProWalletListVC.h"

#import "OFHelpCenterVC.h"

static NSString *const headerIcon = @"headerIconName";

@interface OFProProfileVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) OFProfileHeaderView *headerView;
@property (nonatomic, strong) OFProProfileLogic *logic;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIAlertController *alert;

@end

@implementation OFProProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = OF_COLOR_BACKGROUND;
    self.n_isHiddenNavBar = YES;
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.headerView bindData];
}

- (void)initUI
{
    [self.view addSubview:self.tableView];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, KHeightFixed(50), 0);
    UIView *container = [[UIView alloc] initWithFrame:self.headerView.bounds];
    [container addSubview:self.headerView];
    self.tableView.tableHeaderView = container;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = YES;
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

#pragma mark - Action
- (void)changePersonalInfo
{
    OFPersonalInfoVC *personalVC = [[OFPersonalInfoVC alloc] init];
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.logic numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.logic itemCountOfSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OFProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:kOFProfileCellIdentifier];
    OFProfileItem *item = [self.logic itemAtIndex:indexPath];
    [cell update:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        
        OFProWalletListVC *vc = [[OFProWalletListVC alloc]init];
        
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
        
    }else if(indexPath.section == 1){
        OFAccountSafeVC *vc = [[OFAccountSafeVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }else if(indexPath.section == 2)  {
        
        if (indexPath.row == 0) {
            // 帮助中心
            
            OFHelpCenterVC *vc = [[OFHelpCenterVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        
        if (indexPath.row == 1) {
            // 关于我们
            OFAboutUS *vc = [OFAboutUS new];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }else if (indexPath.section == 3) {
        
        // 领主
        [[OFJumpManager sharedOFJumpManager] jumpWithType:OFJumpTypeSegueNative urlStr:URL_Native_ApplyLaird title:nil paramStr:nil];
        
        
    }
    
    
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.f;
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
        CGFloat topHeight = KHeightFixed(215) - 64 + Nav_Height;
        self.headerView.frame = CGRectMake(0, top, kScreenWidth, topHeight - top);
    }
}

#pragma mark - lazy load

- (OFProfileHeaderView *)headerView
{
    CGFloat topHeight = KHeightFixed(215) - 64 + Nav_Height;
    if (!_headerView) {
        _headerView = [[OFProfileHeaderView alloc] initWithFrame:(CGRect){0, 0, kScreenWidth, topHeight}];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changePersonalInfo)];
        [_headerView addGestureRecognizer:tap];
    }
    return _headerView;
}

- (OFProProfileLogic *)logic
{
    if (!_logic) {
        _logic = [[OFProProfileLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[OFProfileCell class] forCellReuseIdentifier:kOFProfileCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 62;
        _tableView.sectionHeaderHeight = 15;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorColor= [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

@end
