//
//  OFTeamListVC.m
//  OFBank
//
//  Created by hukun on 2018/2/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFTeamListVC.h"
#import "OFNavView.h"
#import "OFTeamCell.h"
#import "OFPoolModel.h"
#import "ToolObject.h"
#import "UIButton+ContentLayout.h"
#import "OFTeamHeadView.h"
#import "UIScrollView+YYAdd.h"
#import "UIView+Empty.h"
#import "OFShareManager.h"

@interface OFTeamListVC ()<UITableViewDataSource,UITableViewDelegate,OFTeamCellDelegate,UITextFieldDelegate>

@property (nonatomic, strong) OFNavView *navView;

@property (nonatomic, strong) UIButton *searchBtn;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, assign) NSInteger searchPage;

@property (nonatomic, assign) NSInteger rankType;

@property (nonatomic, strong) UIRefreshControl *refresh;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *searchDataArray;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *tip1Label;

@property (nonatomic, strong) UILabel *tip2Label;

@property (nonatomic, strong) UILabel *tip3Label;

@property (nonatomic, strong) OFTeamHeadView *teamHeadView;

#pragma mark - 搜索视图
@property (nonatomic, strong) UIView *searchView;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UIButton *menuBtn;

@property (nonatomic, strong) UITextField *searchTextField;

#pragma mark - 菜单视图

@property (nonatomic, strong) UIView *menuView;

@property (nonatomic, strong) UIView *backView;

@property (nonatomic, assign) BOOL isShow;

@end

static NSString *const cellID = @"OFTeamCell";

static const int Tag = 123123;

@implementation OFTeamListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.n_isHiddenNavBar = YES;
    self.n_isWhiteStatusBar = NO;
    
    [self initUI];
    [self layout];
    self.rankType = 3;
    self.searchPage = 1;
    self.page = 1;
    self.view.backgroundColor = BackGround_Color;
    [self.view bringSubviewToFront:self.navView];
    [self.view bringSubviewToFront:self.searchView];
    self.searchView.hidden = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (@available(iOS 10.0, *)) {
        self.tableView.refreshControl = self.refresh;
    } else {
        // Fallback on earlier versions
        [self.tableView addSubview:self.refresh];
    }
    
    self.tableView.contentInset = UIEdgeInsetsMake(Nav_Height + 50, 0, 50, 0);
    self.tableView.contentOffset = CGPointMake(0, -Nav_Height + 50);
    
    
    [self.refresh beginRefreshing];
    
    WEAK_SELF;
    [NUIUtil refreshWithFooter:self.tableView refresh:^{
        [weakSelf getNetWorkHandle:NO];
    }];
    [self getData];
    [self getNetWorkHandle:YES];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (!self.isShow) {
        self.isShow = YES;
        id tempArray = [[OFKVStorage shareStorage] itemForKey:self.className];
        if ([tempArray isKindOfClass:[NSArray class]]) {
            [self.dataArray addObjectsFromArray:tempArray];
            [self.tableView reloadData];
        }
    }
}

- (void)initUI{
    [self.view addSubview:self.navView];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.searchBtn];
//    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.tip1Label];
    [self.bottomView addSubview:self.tip2Label];
    [self.bottomView addSubview:self.tip3Label];
    
    self.tableView.tableFooterView = self.bottomView;
    if (KcurUser.community) {
        self.tableView.tableHeaderView = self.teamHeadView;
    }
    
    // 搜索
    [self.view addSubview:self.searchView];
    [self.searchView addSubview:self.contentView];
    [self.searchView addSubview:self.cancleBtn];
    [self.contentView addSubview:self.menuBtn];
    [self.contentView addSubview:self.searchTextField];
    
}

- (void)layout{
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(Nav_Height);
    }];
    
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(-35);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(Nav_Height + 10);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView.mas_centerX);
        make.top.mas_equalTo(50);
    }];
    
    [self.tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.bottomView.mas_centerX);
        make.top.mas_equalTo(self.tip1Label.mas_bottom).offset(10);
    }];
    
    [self.tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tip2Label.mas_left);
        make.top.mas_equalTo(self.tip2Label.mas_bottom).offset(8);
    }];
    
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.top.mas_equalTo(Nav_Height + 10);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
//        make.centerY.mas_equalTo(self.searchView.mas_centerY);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.cancleBtn.mas_left).offset(-12);
        make.height.mas_equalTo(30);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(7);
        make.top.bottom.mas_equalTo(0);
    }];
    
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.menuBtn.mas_right).offset(10);
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
    }];
}

- (void)getData{
    
    
    if (!KcurUser.community) {
        return;
    }
    
    NSString *cid = KcurUser.community.cid;
    if (cid.length < 1) {
        return;
    }
    WEAK_SELF;
    [OFNetWorkHandle getMyCommunityWithCid:cid success:^(NSDictionary *dict) {
        
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        
        if (status == 200) {
            NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
            
            OFPoolModel *model = [OFPoolModel modelWithJSON:data];
            model.cid = cid;
            KcurUser.community = model;
            [KUserManager saveUserInfo];
            [weakSelf.teamHeadView setupInfo];
        }else{
            
        }
        
    } failure:^(NSError *error) {
        BLYLogWarn(@"获得矿池信息错误 cid = %@ - %@",KcurUser.community.cid,error);
    }];

}

//- (void)getData{
//
//    WEAK_SELF;
//    [OFNetWorkHandle getAllCommunitiesWithSuccess:^(NSDictionary *dict) {
//        [weakSelf.refresh endRefreshing];
//        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
//
//        if (status == 200) {
//            NSArray *array = [NDataUtil arrayWith:dict[@"data"]];
//            NSMutableArray *tempArray = [OFPoolModel mj_objectArrayWithKeyValuesArray:array];
//            [tempArray enumerateObjectsUsingBlock:^(OFPoolModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                if ([obj.cid isEqualToString:KcurUser.community.cid]) {
//                    [tempArray removeObject:obj];
//                }
//            }];
//
//            [weakSelf.dataArray addObjectsFromArray:tempArray];
//            //            [weakSelf.dataArray addObjectsFromArray:[OFPoolModel mj_objectArrayWithKeyValuesArray:array]];
//            NSLog(@"获取了数据");
//
//            [weakSelf.tableView reloadData];
//        }
//    } failure:^(NSError *error) {
//        [weakSelf.refresh endRefreshing];
//        NSString *errStr = [NSString stringWithFormat:@"code=%zd,%@",error.code,error.domain];
//        [MBProgressHUD showError:errStr];
//    }];
//}

- (void)getNetWorkHandle:(BOOL)head{
    if (self.searchTextField.text.length < 1) {
        [self getNetWork:head];
    }else{
        [self searchData:head];
    }
}

- (void)getNetWork:(BOOL)head{
    if (head) {
        self.page = 1;
    }
    WEAK_SELF;
    [OFNetWorkHandle getCommunitiesWithRankType:self.rankType page:self.page success:^(NSDictionary *dict) {
        
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        [weakSelf.refresh endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (status == 200) {
            NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
            NSArray *tempArray = [NDataUtil arrayWith:data[@"pageData"]];
            
            if (tempArray.count < 1) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                if (weakSelf.dataArray.count < 1) {
                    [weakSelf.view setupEmptyViewlabel:@"暂时没有矿池，请稍后重试"];
                }
                return ;
            }
            NSArray *array = [NSArray modelArrayWithClass:[OFPoolModel class] json:tempArray];
            
            if (weakSelf.page == 1) {
                [weakSelf.dataArray removeAllObjects];
                [[OFKVStorage shareStorage] saveItem:array forKey:self.className];
            }
            
            weakSelf.page++;
            
            NSMutableArray *tempArray2 = [NSMutableArray array];
            if (array.count) {
                [tempArray2 addObjectsFromArray:array];
            }
            
            [tempArray2 enumerateObjectsUsingBlock:^(OFPoolModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.cid isEqualToString:KcurUser.community.cid]) {
                    KcurUser.community = obj;
                    [KUserManager saveUserInfo];
                    [tempArray2 removeObject:obj];
                }
            }];
            
            [weakSelf.dataArray addObjectsFromArray:tempArray2];
            
            [weakSelf.tableView reloadData];
            [weakSelf.view removeEmptyView];
        }else{
            NSString *message = [NDataUtil stringWith:dict[@"message"] valid:@""];
            NSLog(@"%zd - %@",status,message);
            BLYLogWarn(@"%zd - %@",status,message);
        }
    } failure:^(NSError *error) {
        [weakSelf.refresh endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
}

- (void)searchData:(BOOL)head{
    
    if (self.searchTextField.text.length < 1) {
        return;
    }
    
    if (head) {
        self.searchPage = 1;
    }
    
    NSLog(@"%@",self.searchTextField.text);
    WEAK_SELF;
    [OFNetWorkHandle searchCommunityWithKey:self.searchTextField.text page:self.searchPage success:^(NSDictionary *dict) {
//        NSLog(@"%@",dict);
        [weakSelf.refresh endRefreshing];
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        
        if (status == 200) {
            
            NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
            NSArray *tempArray = [NDataUtil arrayWith:data[@"pageData"]];
            NSLog(@"返回 %zd 个",tempArray.count);
            
            if (tempArray.count < 1) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                if (weakSelf.searchDataArray.count < 1) {
                    [weakSelf.view setupEmptyViewlabel:@"抱歉，没搜索到您要的矿池"];
                }
                [weakSelf.tableView reloadData];
                return ;
            }
            if (weakSelf.searchPage == 1) {
                [weakSelf.dataArray removeAllObjects];
            }
            weakSelf.searchPage++;

            
            NSArray *array = [NSArray modelArrayWithClass:[OFPoolModel class] json:tempArray];
            
            NSMutableArray *tempArray2 = [NSMutableArray array];
            if (array.count) {
                [tempArray2 addObjectsFromArray:array];
            }
            
            [tempArray2 enumerateObjectsUsingBlock:^(OFPoolModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.cid isEqualToString:KcurUser.community.cid]) {
                    [tempArray2 removeObject:obj];
                }
            }];
            
            [weakSelf.searchDataArray addObjectsFromArray:tempArray2];
            
            [weakSelf.tableView reloadData];
            [weakSelf.view removeEmptyView];
        }else{
            NSString *errStr = [NSString stringWithFormat:@"code=%zd",status];
            [MBProgressHUD showError:errStr];
        }
    } failure:^(NSError *error) {
        [weakSelf.refresh endRefreshing];
        NSString *errStr = [NSString stringWithFormat:@"code=%zd,%@",error.code,error.domain];
        [MBProgressHUD showError:errStr];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField.text.length < 1) {
        return YES;
    }
    [self searchData:YES];
    [self cancleBtnClick];
    [self.refresh beginRefreshing];
    
    return YES;
}

- (void)searchBtnClick{
    NSLog(@"点击。。。。");
    self.searchView.hidden = NO;
    self.searchView.alpha = 1.0;
    [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Nav_Height - 44);
    }];
    self.tableView.hidden = YES;
    self.searchBtn.hidden = YES;
    
    self.tableView.tableHeaderView = nil;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        [self.searchTextField becomeFirstResponder];
    }];
}

- (void)cancleBtnClick{
    NSLog(@"取消");
    [self.view endEditing:YES];
    [self.searchView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Nav_Height);
    }];
    
    if (KcurUser.community) {
        self.tableView.tableHeaderView = self.teamHeadView;
        [self.teamHeadView setupInfo];
    }
    self.tableView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.searchView.alpha = 0.0;
    } completion:^(BOOL finished) {
        
        self.searchBtn.hidden = NO;
        self.searchView.hidden = YES;
    }];
}

- (void)backViewClick{
    NSLog(@"背景点击了。。。");
    
    [self.menuView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.menuView = nil;
    self.backView = nil;
    
}

- (void)menuViewBtnClick:(UIButton *)button{
    NSLog(@"%zd",button.tag - Tag);
    
    // 0 默认 1 名称 2 热度
    NSInteger type = button.tag - Tag;
    if (type == 0) {
        self.rankType = 3;
    }else{
        self.rankType = type;
    }
    
    [self getNetWork:YES];
    
    [self.menuBtn setTitle:[button currentTitle] forState:UIControlStateNormal];
    
    [self.menuView removeFromSuperview];
    [self.backView removeFromSuperview];
    self.menuView = nil;
    self.backView = nil;
    
    [self cancleBtnClick];
    [self.refresh beginRefreshing];
    
    
}



- (void)showMenuView{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self.backView];
    
    [window addSubview:self.menuView];
    
    CABasicAnimation *scale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scale.duration = 0.3;
    scale.fromValue = [NSNumber numberWithFloat:0];
    scale.toValue = [NSNumber numberWithFloat:1.0];
    scale.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    // 倒转动画
//    _pulseAnimation.autoreverses = YES;
    // 设置重复次数为无限大
    //    pulseAnimation.repeatCount = FLT_MAX;
    scale.repeatCount = 1;
    scale.removedOnCompletion = YES;
    
    [self.menuView.layer addAnimation:scale forKey:@"transform.scale"];
    
}

- (void)joinTeam:(OFPoolModel *)model{
    
    self.searchTextField.text = @"";
    
    self.tableView.tableHeaderView = self.teamHeadView;
    [self.teamHeadView setupInfo];
    
    if (self.tableView.contentOffset.y <= -(Nav_Height + 40)) {
        if ([self.dataArray containsObject:model]) {
            [self.dataArray removeObject:model];
        }
        [self.tableView reloadData];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.contentOffset = CGPointMake(0, -(Nav_Height + 50));
    } completion:^(BOOL finished) {
        if ([self.dataArray containsObject:model]) {
            [self.dataArray removeObject:model];
        }
        [self.tableView reloadData];
    }];

    
}

- (void)leaveMyTeam{
    [self.teamHeadView.leaveBtn startProgress];
    WEAK_SELF;
    [OFNetWorkHandle leaveCommunitySuccess:^(NSDictionary *dict) {
        
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        //            NSLog(@"%@",dict);
        [weakSelf.teamHeadView.leaveBtn endProgress];
        if (status == 200) {
            
            [weakSelf.dataArray insertObject:KcurUser.community atIndex:0];
            
            weakSelf.tableView.tableHeaderView = nil;
            [weakSelf.tableView reloadData];
            [MBProgressHUD showSuccess:@"已经离开"];
            weakSelf.searchTextField.text = @"";
            KcurUser.community = nil;
//            weakSelf.join = NO;
            [KUserManager saveUserInfo];
        }else{
            NSString *errStr = [NSString stringWithFormat:@"离开失败！code=%zd",status];
            [MBProgressHUD showError:errStr];
        }
    } failure:^(NSError *error) {
        [weakSelf.teamHeadView.leaveBtn endProgress];
        NSString *errStr = [NSString stringWithFormat:@"网络异常,请稍后重试!code=%zd",error.code];
        [MBProgressHUD showError:errStr];
    }];
}

// 好友邀请
- (void)appActivityFriend{

    OFSharedModel *model = [[OFSharedModel alloc]init];
    model.title = @"好友已帮你抢到一个福包！";
//    NSString *temp = [NSString stringWithFormat:@"加入\"%@\",一起挖矿赚翻天",KcurUser.community.Name];
    model.descript = @"点击即可领取\n500000个福包 拉上好友抢抢抢";
    //    NSString *str = self.shareString;
    NSString *cid = [NDataUtil stringWith:KcurUser.community.cid valid:@"0"];
    NSString *url = [NSString stringWithFormat:@"http://www.ofbank.com/join?uid=%@&cid=%@",[NDataUtil stringWith:[KcurUser.uid stringValue] valid:@"0"],cid];
    model.urlString = url;
    model.sharedType = OFSharedTypeUrl;
    model.cannotShareSMS = YES;
    model.thumbImage = [UIImage imageNamed:@"wechat_share_icon"];
    if ([NSThread isMainThread]) {
        [OFShareManager sharedToWeChatWithModel:model controller:self];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [OFShareManager sharedToWeChatWithModel:model controller:self];
        });
    }
}

// 好友邀请
//- (void)appActivityFriend{
//    OFSharedModel *model = [[OFSharedModel alloc]init];
//    model.title = @"好友已帮你抢到一个福包！";
//    model.descript = @"点击即可领取\n500000个福包 拉上好友抢抢抢";
//    //    NSString *str = self.shareString;
//    model.urlString = self.shareUrl;
//    model.sharedType = OFSharedTypeUrl;
//    model.cannotShareSMS = YES;
//    model.thumbImage = [UIImage imageNamed:@"wechat_share_icon"];
//    if ([NSThread isMainThread]) {
//        [OFShareManager sharedToWeChatWithModel:model controller:self];
//    }else{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [OFShareManager sharedToWeChatWithModel:model controller:self];
//        });
//    }
//}


#pragma mark - tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
//    NSLog(@"%@",self.searchTextField.text);
    if (self.searchTextField.text.length < 1) {
//        NSLog(@"正常排序 %zd",self.dataArray.count);
        return self.dataArray.count;
    }
//    NSLog(@"搜索排序 %zd",self.searchDataArray.count);
    return self.searchDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OFTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    NSArray *array;
    
    if (self.searchTextField.text.length < 1) {
        array = self.dataArray;
    }else{
        array = self.searchDataArray;
    }
    
    OFPoolModel *model = [NDataUtil classWithArray:[OFPoolModel class] array:array index:indexPath.row];
    cell.model = model;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}





//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
////    NSLog(@"%f",self.tableView.contentOffset.y);
//
////    [self.tableView scrollToTop];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat top = scrollView.contentOffset.y + scrollView.contentInset.top;
    
//    NSLog(@"--- %f",scrollView.contentOffset.y);
    
    if (top > 0) {
        [self.searchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Nav_Height + 10 -top);
        }];
        
    }else{
        [self.searchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(Nav_Height + 10);
        }];
    }
    [self.searchBtn layoutIfNeeded];
    
}

- (void)refreshAction{
//    [self getData];
    [self getNetWorkHandle:YES];
}


- (OFNavView *)navView{
    if (!_navView) {
        _navView = [[OFNavView alloc]initWithTitle:@"矿池"];
    }
    return _navView;
}

- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[OFTeamCell class] forCellReuseIdentifier:cellID];
        
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

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)searchDataArray{
    if (!_searchDataArray) {
        _searchDataArray = [NSMutableArray array];
    }
    return _searchDataArray;
}

- (OFTeamHeadView *)teamHeadView{
    if (!_teamHeadView) {
        _teamHeadView = [[OFTeamHeadView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        [_teamHeadView setupInfo];
        WEAK_SELF;
        _teamHeadView.leaveBlock = ^{
            [weakSelf leaveMyTeam];
        };
        
        _teamHeadView.shareBlock = ^{
            [weakSelf appActivityFriend];
        };
        
    }
    
    return _teamHeadView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UILabel *)tip1Label{
    if (!_tip1Label) {
        _tip1Label = [[UILabel alloc]init];
        _tip1Label.font = [NUIUtil fixedFont:12];
        _tip1Label.textColor = [UIColor colorWithRGB:0x676767];
        _tip1Label.textAlignment = NSTextAlignmentCenter;
        _tip1Label.text = @"创建矿池请联系客服";
    }
    return _tip1Label;
}

- (UILabel *)tip2Label{
    if (!_tip2Label) {
        _tip2Label = [[UILabel alloc]init];
        _tip2Label.font = [NUIUtil fixedFont:9];
        _tip2Label.textColor = OF_COLOR_MAIN_THEME;
        _tip2Label.textAlignment = NSTextAlignmentCenter;
        _tip2Label.attributedText = [ToolObject toString:@"微信1:" prefixColor:[UIColor colorWithRGB:0x626262] suffix:@"OFOFOFCOIN" suffixColor:OF_COLOR_MAIN_THEME];
    }
    return _tip2Label;
}

- (UILabel *)tip3Label{
    if (!_tip3Label) {
        _tip3Label = [[UILabel alloc]init];
        _tip3Label.font = [NUIUtil fixedFont:9];
        _tip3Label.textColor = OF_COLOR_MAIN_THEME;
        _tip3Label.textAlignment = NSTextAlignmentCenter;
        _tip3Label.attributedText = [ToolObject toString:@"微信2:" prefixColor:[UIColor colorWithRGB:0x626262] suffix:@"OFOFOFBANK" suffixColor:OF_COLOR_MAIN_THEME];
    }
    return _tip3Label;
}

- (UIRefreshControl *)refresh{
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc]init];
        [_refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}


- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchBtn setTitle:@"搜索矿池" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithRGB:0xbdbebe] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [NUIUtil fixedFont:13];
        _searchBtn.backgroundColor = [UIColor colorWithRGB:0xeeeeee];
        [_searchBtn setImage:[UIImage imageNamed:@"mining_search"] forState:UIControlStateNormal];
        
        _searchBtn.layer.cornerRadius = 30 / 2;
        _searchBtn.layer.masksToBounds = YES;
        WEAK_SELF;
        [_searchBtn n_clickBlock:^(id sender) {
            [weakSelf searchBtnClick];
        }];
        
    }
    return _searchBtn;
}



- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor colorWithRGB:0x333333] forState:UIControlStateNormal];
        
        _cancleBtn.titleLabel.font = [NUIUtil fixedFont:17];
        
        [_cancleBtn setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        
        [_cancleBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
        WEAK_SELF;
        [_cancleBtn n_clickBlock:^(id sender) {
            [weakSelf cancleBtnClick];
        }];
    }
    return _cancleBtn;
}

- (UIButton *)menuBtn{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_menuBtn setTitle:@"默认" forState:UIControlStateNormal];
        _menuBtn.titleLabel.font = [NUIUtil fixedFont:13];
        [_menuBtn setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateNormal];
        
        [_menuBtn setImage:[UIImage imageNamed:@"mining_arrow_down"] forState:UIControlStateNormal];
        
        [_menuBtn layoutButtonWithEdgeInsetsStyle:OFButtonEdgeInsetsStyleRight imageTitleSpace:8];
        
        [_menuBtn setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        
        [_menuBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        WEAK_SELF;
        [_menuBtn n_clickBlock:^(id sender) {
            [weakSelf showMenuView];
        }];
        
    }
    return _menuBtn;
}

- (UIView *)searchView{
    if (!_searchView) {
        _searchView = [[UIView alloc]init];
        _searchView.backgroundColor = [UIColor whiteColor];
    }
    return _searchView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
        _contentView.backgroundColor = [UIColor colorWithRGB:0xeeeeee];
        _contentView.layer.cornerRadius = 30/2.0;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UITextField *)searchTextField{
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc]init];
        _searchTextField.placeholder = @"搜索";
        _searchTextField.borderStyle = UITextBorderStyleNone;
        _searchTextField.font = [NUIUtil fixedFont:13];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIView *)menuView{
    if (!_menuView) {
        _menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 187 * 0.5, 0)];
        _menuView.backgroundColor = [UIColor whiteColor];
        
        _menuView.layer.cornerRadius = 5.0;
        _menuView.layer.masksToBounds = YES;
        
        NSArray *titles = @[@"默认",@"热度",@"名称"];
        
        for (int i = 0; i < titles.count; i++) {
            
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.width = _menuView.width;
            btn.left = 0;
            btn.height = 37;
            btn.top = i * 37;
            btn.tag = i + Tag;
            btn.tintColor = [UIColor whiteColor];
            NSString *title = titles[i];
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(menuViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [_menuView addSubview:btn];
            
            if ([title isEqualToString:[_menuBtn currentTitle]]) {
                btn.selected = YES;
            }
            
        }
        _menuView.height = 37 * titles.count;
        _menuView.top = Nav_Height - 2;
        _menuView.left = 20;
    }
    return _menuView;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]initWithFrame:self.view.bounds];
        _backView.backgroundColor = [UIColor clearColor];
        WEAK_SELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf backViewClick];
        }];
        [_backView addGestureRecognizer:tap];
    }
    return _backView;
}




@end
