//
//  OFWalletViewController.m
//  OFCion
//
//  Created by liyangwei on 2018/1/9.
//  Copyright © 2018年 liyangwei. All rights reserved.
//

#import "OFWalletViewController.h"
#import "OFWalletCell.h"

#import "OFNavigationController.h"

#import "OFRecordViewController.h"
#import "OFGetMoneyVC.h"
#import "OFTransferVC.h"
#import "NWebService.h"
#import "OFCreatAddressVC.h"

#import "OFNetWorkHandle.h"

#import "OFWalletModel.h"

#import "Config.h"
#import "OFTextVC.h"
#import "OFActivityViewModel.h"
#import "NSDate+Additions.h"
#import "UIButton+ContentLayout.h"
#import "OFAdvertView.h"

#import "OFNoticeModel.h"
#import "OFWalletLogic.h"

#import "OFCreateWalletController.h"

static NSString *const cellID = @"OFWalletCell";

@interface OFWalletViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,BaseLogicDelegate>{
    CGFloat _top;
    
}


@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *balanceLabel;

@property (nonatomic, strong) UIButton *moneyEyeBtn;

//@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSIndexPath *indexPath;



#pragma mark - 按钮视图
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) UIView *buttonSuperView;
@property (nonatomic, strong) UIButton *transferBtn;
@property (nonatomic, strong) UIButton *chargeBtn;

@property (nonatomic, strong) UILabel *loveLabel;
//@property (nonatomic, strong) UILabel *tip1Label;


@property (nonatomic, strong) OFWalletLogic *logic;


@end

@implementation OFWalletViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(loginStateChange:)
                                                     name:KNotificationLoginStateChange
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBalance) name:KNotificationRefreshWallet object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"钱包页面");
    self.n_isHiddenNavBar = YES;
    self.n_isWhiteStatusBar = YES;
    [self initUI];
    [self layout];
    [self setTableViewHeaderView];
    [self setTotalMoney];
    
    [self getBalance];
    [self setTipsInfo];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(advertViewHiden) name:@"OFAdvertViewHiden"
                                              object:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getBalance];
    
}

// 新版本
- (void)initUI{
    [self.tableView registerNib:[OFWalletCell nib] forCellReuseIdentifier:cellID];
    self.tableView.mj_footer = nil;
    self.tableView.rowHeight = KWidthFixed(62.5);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backImageView];
//    [self.backImageView addSubview:self.titleLabel];
    [self.backImageView addSubview:self.iconView];
    [self.backImageView addSubview:self.balanceLabel];
    [self.backImageView addSubview:self.loveLabel];
}

// 新版本
- (void)layout{
    
    CGFloat top = 35;
    if (IS_IPHONE_X) {
        top = 50;
    }
    CGFloat topHeight = KHeightFixed(180) - 64 + Nav_Height;
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.top.mas_equalTo(0);
        make.height.mas_equalTo(topHeight);
    }];
    
//    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo([NUIUtil fixedHeight:top]);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo([NUIUtil fixedHeight:top]);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [self.loveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right);
        make.bottom.mas_equalTo(self.iconView.mas_bottom);
        //        make.centerY.mas_equalTo(self.iconView.mas_centerY);
        make.right.mas_equalTo(-15);
    }];

    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset([NUIUtil fixedHeight:40]);
        make.right.mas_equalTo(-15);
    }];



    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-kTabbar_Height);
        make.top.mas_equalTo(self.backImageView.mas_bottom);
    }];
}

- (void)setTableViewHeaderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 200, 40)];
    label.text = @"我的钱包";
    label.font = [NUIUtil fixedFont:14];
    label.textColor = OF_COLOR_DETAILTITLE;
    label.numberOfLines = 1;
    [view addSubview:label];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, 44, view.width-30, 0.5)];
    lineView.backgroundColor = Line_Color;
    [view addSubview:lineView];
    
    self.tableView.tableHeaderView = view;
}

- (void)creatAddress{
    if ([KUserManager isCreatAddressState]) {
        NSLog(@"有地址。 已经登录");
    }else{
        NSLog(@"无地址。");
        OFCreatAddressVC *vc = [[OFCreatAddressVC alloc]init];
        vc.hiddenBack = YES;
        OFNavigationController *nav = [[OFNavigationController alloc]initWithRootViewController:vc];
        
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)getBalance{
    [self setTipsInfo];
    if (KcurUser.wallets.count == 0) {
        if (!KcurUser.currentWallet) {
            [self creatAddress];
            BLYLogWarn(@"没有地址");
            return;
        }
        [KcurUser.wallets addObject:KcurUser.currentWallet];
    }
    
    [self.logic getBalance];
}

- (void)setTipsInfo{
    NSString *title = [self.logic tipTitle];
//    self.tip1Label.hidden = !title.length;
    self.loveLabel.hidden = NO;
//    if (!self.tip1Label.hidden) {
    self.loveLabel.text = NSStringFormat(@" -- %@",[NDataUtil stringWith:title valid:@""]);
//    }
}

- (void)setTotalMoney{
    self.balanceLabel.text = [self.logic totalMoney];
}

#pragma mark - 登录状态改变 重新获取钱包余额
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {
        [self.logic forceGetBalance];
    }
}

#pragma mark - 广告通知
- (void)advertViewHiden{
    [[OFActivityViewModel sharedInstance] showActivityView];
    [self getBalance];
    [self setTipsInfo];
}


#pragma mark - 按钮点击事件
- (void)moneyEyeBtnClick{
    NSLog(@"总资产。。");
        
    KcurUser.canSeeMoney = !KcurUser.canSeeMoney;
    [KUserManager updateCanseeState];
    [self setTotalMoney];
    NSString *imageName = KcurUser.canSeeMoney ? @"wallet_eye_open" : @"wallet_eye_closed";
    
    [self.moneyEyeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

// 转出
- (void)transferBtnClick{
    
    [self.transferBtn setBackgroundColor:[UIColor colorWithRGB:0xff9f4e]];
    [self.transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.chargeBtn setBackgroundColor:[UIColor whiteColor]];
    [self.chargeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
    
    OFTransferVC *vc = [[OFTransferVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 接收
- (void)chargeBtnClick{
    //    OFTextVC *vc = [[OFTextVC alloc]init];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    [self.chargeBtn setBackgroundColor:[UIColor colorWithRGB:0xff9f4e]];
    [self.chargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.transferBtn setBackgroundColor:[UIColor whiteColor]];
    [self.transferBtn setTitleColor:Black_Color forState:UIControlStateNormal];
    
    OFGetMoneyVC *vc = [[OFGetMoneyVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 下拉刷新
-(void)headerRereshing{
    [self getBalance];
    [self setTipsInfo];
}

#pragma mark - BaseLogicDelegate
- (void)requestDataSuccess{
    [self setTotalMoney];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)requestDataFailure:(NSString *)errMessage
{
    [self.tableView.mj_header endRefreshing];
//    [MBProgressHUD showError:errMessage];
}

#pragma mark - tableView 代理数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.logic itemCountOfSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OFWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OFWalletModel *model = [self.logic itemAtIndex:indexPath];
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    OFCreateWalletController *controller = [[OFCreateWalletController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
//    return;
    
    OFWalletModel *model = [self.logic itemAtIndex:indexPath];
    KcurUser.currentWallet = model;
    [self chargeBtnClick];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (OFWalletLogic *)logic
{
    if (_logic == nil) {
        _logic = [[OFWalletLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"of_wallet_logo"];
    }
    return _iconView;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        _backImageView.image = image;
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}

- (UILabel *)balanceLabel{
    if (_balanceLabel == nil) {
        _balanceLabel = [[UILabel alloc]init];
        _balanceLabel.textColor = [UIColor whiteColor];
        _balanceLabel.font = FixFont(40);
        _balanceLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _balanceLabel;
}

//- (UILabel *)titleLabel{
//    if (!_titleLabel) {
//        _titleLabel = [[UILabel alloc]init];
//        _titleLabel.text = @"OF总资产";
//        _titleLabel.font = FixFont(17);
//        _titleLabel.textColor = [UIColor whiteColor];
//    }
//    return _titleLabel;
//}

- (UIButton *)moneyEyeBtn{
    if (!_moneyEyeBtn) {
        _moneyEyeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moneyEyeBtn setTitle:@"总资产(枚)" forState:UIControlStateNormal];
        
        NSString *imageName = KcurUser.canSeeMoney ? @"wallet_eye_open" : @"wallet_eye_closed";
        
        [_moneyEyeBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        
        [_moneyEyeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _moneyEyeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [_moneyEyeBtn layoutButtonWithEdgeInsetsStyle:OFButtonEdgeInsetsStyleRight imageTitleSpace:18];
        
        [_moneyEyeBtn addTarget:self action:@selector(moneyEyeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [_moneyEyeBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
        
    }
    return _moneyEyeBtn;
}


- (UIView *)buttonView {
    if (_buttonView == nil) {
        _buttonView = [[UIView alloc]init];
        _buttonView.backgroundColor = [UIColor whiteColor];
        _buttonView.layer.cornerRadius = 5;
        _buttonView.layer.masksToBounds = YES;
    }
    return _buttonView;
}

- (UIView *)buttonSuperView{
    if (!_buttonSuperView) {
        _buttonSuperView = [[UIView alloc]init];
        _buttonSuperView.backgroundColor = [UIColor clearColor];
        _buttonSuperView.layer.shadowColor = [UIColor colorWithRGB:0xde6c0b].CGColor;
        // 范围
        _buttonSuperView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        // 扩散范围
        _buttonSuperView.layer.shadowRadius = 1.0;
        // 不透明度
        _buttonSuperView.layer.shadowOpacity = 0.5;
    }
    return _buttonSuperView;
}

- (UIButton *)transferBtn{
    if (_transferBtn == nil) {
        _transferBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        NSString *title = NSLocalizedString(@"Turn out", nil);
        [_transferBtn setTitle:@"转账" forState:UIControlStateNormal];
        [_transferBtn setBackgroundColor:[UIColor colorWithRGB:0xff9f4e]];
        [_transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_transferBtn addTarget:self action:@selector(transferBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _transferBtn.titleLabel.font = [NUIUtil fixedFont:18];
        //        _transferBtn.layer.cornerRadius = 5;
        //        _transferBtn.layer.masksToBounds = YES;
        
        CGFloat width = kScreenWidth - 30 * 2;
        CGRect frame = CGRectMake(0, 0, width, 40);
        CGSize cornerSize = CGSizeMake(5, 5);
        UIRectCorner corners = UIRectCornerTopLeft | UIRectCornerBottomLeft;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:cornerSize];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = frame;
        maskLayer.path = maskPath.CGPath;
        _transferBtn.layer.mask = maskLayer;
        
        _transferBtn.layer.shadowRadius = 3.0;
        _transferBtn.layer.shadowOpacity = 0.3;
        _transferBtn.layer.shadowColor = [UIColor colorWithRGB:0xd16b14].CGColor;
        _transferBtn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        
    }
    return _transferBtn;
}

- (UIButton *)chargeBtn{
    if (_chargeBtn == nil) {
        _chargeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        NSString *title = NSLocalizedString(@"Turn in", nil);
        [_chargeBtn setTitle:@"收款" forState:UIControlStateNormal];
        [_chargeBtn setBackgroundColor:[UIColor whiteColor]];
        _chargeBtn.titleLabel.font = [NUIUtil fixedFont:18];
        [_chargeBtn setTitleColor:Black_Color forState:UIControlStateNormal];
        [_chargeBtn addTarget:self action:@selector(chargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //        _chargeBtn.layer.cornerRadius = 5;
        //        _chargeBtn.layer.masksToBounds = YES;
        
        CGFloat width = kScreenWidth - 30 * 2;
        
        CGRect frame = CGRectMake(0, 0, width, 40);
        CGSize cornerSize = CGSizeMake(5, 5);
        UIRectCorner corners = UIRectCornerTopRight | UIRectCornerBottomRight;
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:frame byRoundingCorners:corners cornerRadii:cornerSize];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
        maskLayer.frame = frame;
        maskLayer.path = maskPath.CGPath;
        _chargeBtn.layer.mask = maskLayer;
        
        _chargeBtn.layer.shadowRadius = 3.0;
        _chargeBtn.layer.shadowOpacity = 0.3;
        _chargeBtn.layer.shadowColor = [UIColor colorWithRGB:0xd16b14].CGColor;
        _chargeBtn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        
    }
    return _chargeBtn;
}

//- (UILabel *)tip1Label{
//    if (_tip1Label == nil) {
//        _tip1Label = [[UILabel alloc]init];
//
//        _tip1Label.textColor = [UIColor whiteColor];
//        //        _tip1Label.font = [UIFont fontWithName:@"FZHZGBJW--GB1-0" size:41];
//        _tip1Label.font = [UIFont systemFontOfSize:22];
//        _tip1Label.text = @"--";
//    }
//    return _tip1Label;
//}

- (UILabel *)loveLabel {
    if (_loveLabel == nil) {
        _loveLabel = [[UILabel alloc] init];
        _loveLabel.textColor = [UIColor whiteColor];
        // FZHZGBJW--GB1-0
        _loveLabel.font = [UIFont fontWithName:@"FZHZGBJW--GB1-0" size:[NUIUtil fixedFontSize:17]];
//        _loveLabel.font = [NUIUtil fixedFont:17];
        _loveLabel.adjustsFontSizeToFitWidth = YES;
        _loveLabel.minimumScaleFactor = 0.7;
        _loveLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _loveLabel;
}

@end
