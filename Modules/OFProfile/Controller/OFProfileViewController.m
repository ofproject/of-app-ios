//
//  OFProfileViewController.m
//  OFCion
//
//  Created by liyangwei on 2018/1/9.
//  Copyright © 2018年 liyangwei. All rights reserved.
//

#import "OFProfileViewController.h"
#import "OFProfileCell.h"
#import "UIImage+reDraw.h"
#import <AVFoundation/AVFoundation.h>
#import "OFAccountSafeVC.h"
#import "OFWebViewController.h"
#import "OFProfileHeaderView.h"
#import "OFProfileLogic.h"
#import "OFPersonalInfoVC.h"
#import "OFAboutUS.h"
#import "OFRecruitLeaderController.h"
#import "OFPoolModel.h"
#import "OFMyMiningPoolVC.h"
#import "OFRedPacketController.h"
#import "OFRecruitLeaderController.h"

static NSString *const headerIcon = @"headerIconName";

@interface OFProfileViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic, strong) OFProfileHeaderView *headerView;
@property (nonatomic, strong) OFProfileLogic *logic;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIAlertController *alert;

@end

@implementation OFProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = OF_COLOR_BACKGROUND;
    self.n_isHiddenNavBar = YES;
    
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.headerView bindData];
    [self.tableView reloadData];
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
    
    OFProfileItem *item = [self.logic itemAtIndex:indexPath];
    if (item.targetType == ProfileTargetTypeController &&
        item.targetCalss.length > 0) {
        Class class = NSClassFromString(item.targetCalss);
        id controller = [[class alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
    }else if(item.targetType == ProfileTargetTypeWeb &&
             item.urlString.length > 0) {
        NSString *title = item.title;
        NSString *fileName = item.fileName;
        OFWebViewController *webVC = [[OFWebViewController alloc]init];
        webVC.title = title;
        if (item.fileName) {
            NSString *urlString = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
            NSString *htmlString = [NSString stringWithContentsOfFile:urlString encoding:NSUTF8StringEncoding error:nil];
            webVC.htmlStr = htmlString;
        }else if(item.urlString){
            webVC.urlString = item.urlString;
        }
        [self.navigationController pushViewController:webVC animated:YES];
    }else if(item.targetType == ProfileTargetTypeSchema &&
             item.urlString.length > 0) {
        OFRecruitLeaderController *controller = [[OFRecruitLeaderController alloc] init];
        [[JumpUtil currentVC].navigationController pushViewController:controller animated:YES];
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

- (OFProfileLogic *)logic
{
    if (!_logic) {
        _logic = [[OFProfileLogic alloc] initWithDelegate:self];
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
