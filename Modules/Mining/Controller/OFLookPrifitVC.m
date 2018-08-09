//
//  OFLookPrifitVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/2/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//  见证收益

#import "OFLookPrifitVC.h"
#import "OFNavView.h"
#import "OFPrifitCell.h"
#import "OFLookPrifitLogic.h"
#import "OFReceiveProfitVC.h"
#import "OFPrifitHeaderView.h"

@interface OFLookPrifitVC ()<BaseLogicDelegate>

@property (nonatomic, strong) OFLookPrifitLogic *logic;
@property (nonatomic, strong) OFPrifitHeaderView *headView;

@end

static NSString *const cellID = @"OFPrifitCell";

@implementation OFLookPrifitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logic = [[OFLookPrifitLogic alloc] initWithDelegate:self];
    self.title = @"见证收益";
    self.view.backgroundColor = BackGround_Color;
    self.tableViewStyle = UITableViewStylePlain;
    [self initUI];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 数据拉取成功
- (void)requestDataSuccess{
    [self.tableView.mj_header endRefreshing];
    if (_logic.nextPage == NO) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.tableView.mj_footer endRefreshing];
    }
    [self.tableView reloadData];
    if (self.logic.dataArray.count == 0) {
        if (![self.view viewWithTag:123123123]) {
            [self.view setupEmptyViewlabel:@"暂无收益，快去挖矿赚收益吧~"];
        }
    }else{
        if ([self.view viewWithTag:123123123]) {
            [[self.view viewWithTag:123123123] removeFromSuperview];
        }
    }
}

#pragma mark - 数据拉取失败
-(void)requestDataFailure:(NSString *)errMessage{
    [MBProgressHUD showError:errMessage];
}

#pragma mark - 头部底部刷新
-(void)headerRereshing{
    [self.logic getNetwork:YES];
}

-(void)footerRereshing{
    [self.logic getNetwork:NO];
}

#pragma mark - 初始化UI
- (void)initUI{
    
    double h =0;// MAX(75, KHeightFixed(75));
//    if (self.isHideHeadView) {
//        h = 0;
//    }else{
        _headView = [OFPrifitHeaderView loadFromXib];
        _headView.candyReward = self.candyReward;
        _headView.miningReward = self.miningReward;
        [self.view addSubview:_headView];
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_equalTo(0);
            make.width.mas_equalTo(kScreenWidth);
            make.height.mas_equalTo(h);
        }];
//    }
    
    [self.tableView registerClass:[OFPrifitCell class] forCellReuseIdentifier:cellID];
    self.tableView.rowHeight = 62.5;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(h);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - Nav_Height - h);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.logic.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *secionArr = [self.logic.dataArray objectAtIndex:section];
    return secionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OFPrifitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSArray *secionArr = [self.logic.dataArray objectAtIndex:indexPath.section];
    NSDictionary *dict = [NDataUtil dictWithArray:secionArr index:indexPath.row];
    
    [cell update:dict];
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray *secionArr = [self.logic.dataArray objectAtIndex:section];
    NSString *key = [[secionArr.firstObject objectForKey:@"receiveTime"] substringToIndex:10];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    header.backgroundColor = OF_COLOR_BACKGROUND;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, kScreenWidth-14*2, 30)];
    titleLabel.font = FixFont(13);
    titleLabel.textColor = OF_COLOR_TITLE;
    titleLabel.text = key;
    [header addSubview:titleLabel];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)dealloc{
    self.logic.delegate = nil;
}


@end
