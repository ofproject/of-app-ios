//
//  OFTransferDetailVC.m
//  OFBank
//
//  Created by hukun on 2018/3/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFTransferDetailVC.h"
#import "OFNavView.h"
#import "OFTransferDetailCell.h"


@interface OFTransferDetailVC ()<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIRefreshControl *refresh;

@property (nonatomic, assign) NSInteger page;

@end

static NSString *const cellID = @"OFTransferDetailCell";

@implementation OFTransferDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"提现记录";
//    self.fd_prefersNavigationBarHidden = YES;
    self.n_isHiddenNavBar = NO;
    [self initUI];
    [self layout];
    self.page = 1;
    self.view.backgroundColor = BackGround_Color;

    
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = self.refresh;
    } else {
        // Fallback on earlier versions
        [self.tableView addSubview:self.refresh];
        
    }
    
    
    [self getNetwork:YES];
    
    [self.refresh beginRefreshing];
    WEAK_SELF;
    [NUIUtil refreshWithFooter:self.tableView refresh:^{
        [weakSelf getNetwork:NO];
    }];
}

- (void)initUI{
    [self.view addSubview:self.tableView];
}

- (void)layout{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OFTransferDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSDictionary *dict = [NDataUtil dictWithArray:self.dataArray index:indexPath.row];
    
    [cell update:dict];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)refreshAction{
    
    [self getNetwork:YES];
}

- (void)getNetwork:(BOOL)head{
    
    if (head) {
        self.page = 1;
        [self.dataArray removeAllObjects];
    }
    WEAK_SELF;
    [OFNetWorkHandle getDrawTransactionWithIndex:self.page success:^(NSDictionary *dict) {
//        NSLog(@"%@",dict);
        [weakSelf.refresh endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        if (status == 200) {
            weakSelf.page++;
//            NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
            NSArray *tempArray = [NDataUtil arrayWith:dict[@"data"]];
            if (tempArray.count < 1) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                if (weakSelf.dataArray.count < 1) {
                    [weakSelf.tableView removeEmptyView];
                    [weakSelf.tableView setupEmptyViewlabel:@"暂无提现记录~"];
                }
                return;
            }
            [weakSelf.dataArray addObjectsFromArray:tempArray];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView removeEmptyView];
        }
    } failure:^(NSError *error) {
        [weakSelf.refresh endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}



- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[OFTransferDetailCell class] forCellReuseIdentifier:cellID];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 62.5;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorColor= [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
- (UIRefreshControl *)refresh{
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc]init];
        [_refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
