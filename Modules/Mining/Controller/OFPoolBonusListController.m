//
//  OFPoolBonusListController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPoolBonusListController.h"
#import "OFBonusListLogic.h"
#import "OFPoolModel.h"
#import "OFBonusCell.h"
#import "OFBonusModel.h"

@interface OFPoolBonusListController ()<BaseLogicDelegate>

@property (nonatomic, strong) OFBonusListLogic *logic;
@property (nonatomic, strong) UILabel *emptyView;

@end

@implementation OFPoolBonusListController

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

- (void)initUI
{
    self.title = @"分红记录";
    self.view.backgroundColor = OF_COLOR_BACKGROUND;
    self.tableView.backgroundColor = OF_COLOR_CLEAR;
    [self.tableView registerClass:[OFBonusCell class] forCellReuseIdentifier:kOFBonusCellReuseIdentifier];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.emptyView];
    _emptyView.center = CGPointMake(self.view.center.x, self.view.center.y - KHeightFixed(50.f));
}

- (void)initData
{
    [self.logic getFirstScreen];
}

- (void)updateEmptyView
{
    if ([self.logic itemCountOfSection:0] > 0) {
        self.emptyView.hidden = YES;
    }else {
        self.emptyView.hidden = NO;
    }
}

#pragma mark - TableView Refresh
-(void)headerRereshing
{
    [self.logic refreshCommunityBonusList];
}

-(void)footerRereshing
{
    [self.logic loadMoreCommunityBonusList];
}

- (void)requestDataSuccess
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self updateEmptyView];
    [self.tableView reloadData];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    [self updateEmptyView];
}

#pragma mark - UITableViewDataSource & Delegate
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
    OFBonusCell *cell = [tableView dequeueReusableCellWithIdentifier:kOFBonusCellReuseIdentifier];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kkOFBonusCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFBonusModel *model = [self.logic itemAtIndex:indexPath];
    OFBonusCell *bonusCell = (OFBonusCell *)cell;
    [bonusCell setModel:model];
}

#pragma mark - lazy load
- (OFBonusListLogic *)logic
{
    if (!_logic) {
        _logic = [[OFBonusListLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (UILabel *)emptyView
{
    if (!_emptyView) {
        _emptyView = [UILabel labelWithFont:FixFont(13) textColor:OF_COLOR_DETAILTITLE textAlignement:NSTextAlignmentCenter text:@"暂无分红记录"];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}

@end
