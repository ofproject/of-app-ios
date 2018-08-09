//
//  OFReceiveProfitVC.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/5.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFReceiveProfitVC.h"
#import "OFPrifitCell.h"
#import "OFLookPrifitLogic.h"

@interface OFReceiveProfitVC ()<BaseLogicDelegate,OFGetRewardDelegate>

@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) OFLookPrifitLogic *logic;

/**
 明细
 */
@property (nonatomic, strong) UIButton *detailBtn;

/**
 收益
 */
@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *backBtn;

///**
// 挖矿收益按钮
// */
//@property (nonatomic, strong) UIButton *miningProfitBtn;
//
///**
// 糖果按钮
// */
//@property (nonatomic, strong) UIButton *candyBtn;

/**
 指示器
 */
//@property (nonatomic, strong) UIView *indicatorView;

//@property (nonatomic, strong) UIView *lineView;

/**
 当前选中的按钮
 */
//@property (nonatomic, strong) UIButton *selectedBtn;

//@property (nonatomic, strong) NSIndexPath *indexPath;



@end

static NSString *const cellID = @"OFPrifitCell";


@implementation OFReceiveProfitVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.n_isWhiteStatusBar = YES;
    self.n_isHiddenNavBar = YES;
    self.tableViewStyle = UITableViewStylePlain;
    [self initUI];
    [self layout];
    self.view.backgroundColor = BackGround_Color;
    //默认选中
    if (self.type == miningProfit) {
        self.titleLabel.text = @"矿池收益";
        self.numberLabel.text = NSStringFormat(@"%.3f",MAX(0, [self.miningReward doubleValue]));
        self.logic = [[OFLookPrifitLogic alloc] initWithDelegate:self type:1];
    }else{
        self.titleLabel.text = @"糖果收益";
        self.numberLabel.text = NSStringFormat(@"%.3f",MAX(0, [self.candyReward doubleValue]));
        self.logic = [[OFLookPrifitLogic alloc] initWithDelegate:self type:2];
    }
    self.logic.rewardDelegate = self;
    [self.tableView.mj_header beginRefreshing];
}

- (void)initUI{
//    [self.view addSubview:self.navView];
    
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.numberLabel];

    [self.topView addSubview:self.detailBtn];

//    [self.topView addSubview:self.miningProfitBtn];
//    [self.topView addSubview:self.candyBtn];
//    [self.topView addSubview:self.lineView];
//    [self.topView addSubview:self.indicatorView];
    
    
    [self.tableView registerClass:[OFPrifitCell class] forCellReuseIdentifier:cellID];
    self.tableView.rowHeight = 62.5;
    [self.view addSubview:self.tableView];
//    self.tableView.tableHeaderView = self.headerView;
    [self.view addSubview:self.topView];
    [self.view addSubview:self.backBtn];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //拉取当前收益
    [self.logic getRewardInfo];
}
- (void)layout{
    
    CGFloat height = KHeightFixed(180) - 64 + Nav_Height;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];

    CGFloat top = 25;
    if (IS_IPHONE_X) {
        top = 40;
    }
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(KWidthFixed(44), KWidthFixed(44)));
        make.top.mas_equalTo(top);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(top);
        make.centerX.mas_equalTo(self.topView.mas_centerX);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];

    [self.detailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.top.mas_equalTo(self.self.titleLabel.mas_top);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
        make.right.mas_equalTo(-15);
    }];

    
//
//    self.miningProfitBtn.frame = CGRectMake(0, self.titleLabel.bottom + 25, KWidthFixed(80), 25);
//    self.miningProfitBtn.centerX = self.view.centerX - KWidthFixed(60);
//    self.miningProfitBtn.centerY = top + KHeightFixed(70);
//
//
//    self.candyBtn.frame = CGRectMake(0, self.titleLabel.bottom + 25, KWidthFixed(80), 25);
//    self.candyBtn.centerX = self.view.centerX + KWidthFixed(60);
//    self.candyBtn.centerY = top + KHeightFixed(70);
//
//    self.indicatorView.width = self.miningProfitBtn.width*0.8;
//    self.indicatorView.centerX = self.miningProfitBtn.centerX;
//    self.indicatorView.top = self.miningProfitBtn.bottom+5;
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0).offset(- 64 + Nav_Height + 20 );
        make.centerX.mas_equalTo(self.topView.mas_centerX);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.topView.mas_bottom);
    }];
}

#pragma mark - 收益拉取成功
-(void)getRewardCallBack:(OFMiningInfoModel *)model{
    double currentAmount = [model.reward.currentRewaed doubleValue];
    //    vc.money = [NSString stringWithFormat:@"%.3f",currentAmount];
    
    //    CGFloat MiningAmount = [NDataUtil floatWith:self.logic.dataDic[@"MiningAmount"] valid:0.0];
    double MiningAmount = [model.reward.miningReward doubleValue];
    if (MiningAmount < 0.0) {
        MiningAmount = 0.000;
    }
    self.miningReward = [NSString stringWithFormat:@"%.3f",MiningAmount];
    CGFloat candy = currentAmount - MiningAmount;
    if (candy < 0.0) {
        candy = 0.000;
    }
    self.candyReward = [NSString stringWithFormat:@"%.3f",candy];
    
    if (self.type == miningProfit) {
        self.numberLabel.text = NSStringFormat(@"%.3f",MAX(0, [self.miningReward doubleValue]));
    }else{
        self.numberLabel.text = NSStringFormat(@"%.3f",MAX(0, [self.candyReward doubleValue]));
    }
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


- (void)detailBtnClick{
//    OFTransferDetailVC *vc = [[OFTransferDetailVC alloc]init];
    WEAK_SELF;
    OFCashOutVC *vc = [OFCashOutVC new];
    vc.type = self.type;
    vc.candyReward = self.candyReward;
    vc.miningReward = self.miningReward;
    vc.candySucBlock = ^{
        weakSelf.numberLabel.text = @"0.000";
    };
    vc.miningSucBlock = ^{
        weakSelf.numberLabel.text = @"0.000";
    };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIImageView *)topView{
    if (!_topView) {
        _topView = [[UIImageView alloc]init];
        _topView.userInteractionEnabled = YES;
        [_topView setImage:[UIImage makeGradientImageWithRect:CGRectMake(0, 0, kScreenWidth, 100) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2]];
    }
    return _topView;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, KWidthFixed(40))];
        _headerView.backgroundColor = [UIColor whiteColor];
        UILabel *tips = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 80, _headerView.height)];
        tips.font = FixFont(14);
        tips.textColor = OF_COLOR_TITLE;
        tips.text = @"转入钱包";
        [_headerView addSubview:tips];
        
        //转入按钮
        UIButton *turnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        turnBtn.frame = CGRectMake(0, 0, 80, _headerView.height);
        [turnBtn setTitle:@"转入记录" forState:UIControlStateNormal];
        [turnBtn setTitleColor:OF_COLOR_TITLE forState:UIControlStateNormal];
        turnBtn.titleLabel.font = FixFont(14);
        [turnBtn sizeToFit];
        turnBtn.centerY = _headerView.height/2;
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(turnBtn.right, turnBtn.top, KWidthFixed(12), KWidthFixed(12))];
        icon.centerY = turnBtn.centerY;
        [icon setImage:IMAGE_NAMED(@"transferRecord_Icon")];
        icon.right = kScreenWidth - 14;
        turnBtn.right = icon.left-2;
        [_headerView addSubview:icon];
        
        WEAK_SELF;
        [turnBtn n_clickBlock:^(id sender) {
            [weakSelf detailBtnClick];
        }];
        [_headerView addSubview:turnBtn];
    }
    return _headerView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [NUIUtil fixedFont:17];
        _titleLabel.text = @"领取收益";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UIButton *)detailBtn{
    if (!_detailBtn) {
        _detailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_detailBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_detailBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _detailBtn.titleLabel.font = [NUIUtil fixedFont:15];
        WEAK_SELF;
        [_detailBtn n_clickBlock:^(id sender) {
            [weakSelf detailBtnClick];
        }];
        
    }
    return _detailBtn;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        
        _numberLabel.font = [NUIUtil fixedFont:44];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _numberLabel;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_backBtn setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
        [_backBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
        WEAK_SELF;
        [_backBtn n_clickBlock:^(id sender) {
            [weakSelf returnBack];
        }];
        [_backBtn setTintColor:[UIColor whiteColor]];
    }
    return _backBtn;
}

@end
