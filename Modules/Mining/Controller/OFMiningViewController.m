//
//  OFMiningViewController.m
//  OFCion
//
//  Created by liyangwei on 2018/1/9.
//  Copyright © 2018年 liyangwei. All rights reserved.
//  挖矿

#import "OFMiningViewController.h"
#import "OFRipplesLayer.h"
#import "GCDSocketManager.h"
#import "OFLookPrifitVC.h"
#import "OFTeamListVC.h"
#import "UIButton+ContentLayout.h"
#import "OFReceiveProfitVC.h"
#import "OFMiningSharedView.h"
#import "OFSharedModel.h"
#import "OFShareManager.h"
#import "OFActivityViewModel.h"
#import "NLocalUtil.h"
#import "OFPoolModel.h"
#import "OFMyMiningPoolVC.h"
#import "OFAllMiningPoolVC.h"
#import "OFMiningLogic.h"
#import "OFJoinPoolAlertView.h"
#import "OFReceiveProfitVC.h"
#import "OFShareAlertView.h"
#import "UILabel+BezierAnimation.h"
#import "WMDragView.h"
#import "OFInviteFriendView.h"
#import "OFCandySucAlertView.h"
#import "OFMiningAnimationIconView.h"
#import "OFUploadUserBehaviorManager.h"
#import "OFShareAppView.h"
#import "OFMyMiningLogic.h"
#import "OFPacketSendController.h"

//#import <RPSDK/RPSDK.h>

@interface OFMiningViewController ()<UIScrollViewDelegate,OFMiningDelegate,OFMyMiningDelegate>

@property (nonatomic, strong) OFMiningLogic *logic;
@property (nonatomic, strong) OFMyMiningLogic *poolLogic;

@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) UIImageView *topBackView;

@property (nonatomic, strong) UIView *infoView;

@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIButton *lookProfitBtn;

@property (nonatomic, strong) UIView *canReceivedOFView;//可领取OF view
@property (nonatomic, strong) UIImageView *OFImgView;//挖矿图标
@property (nonatomic, strong) UILabel *miningRewardLabel;//挖矿收益

@property (nonatomic, strong) UIView *canReceivedTangView;//可领取糖果 view
@property (nonatomic, strong) UIImageView *candyImgView;//糖果图标
@property (nonatomic, strong) UILabel *candyRewardLabel;//糖果收益

/**
 总收益
 */
@property (nonatomic, strong) UILabel *totalNumberLabel;


/**
 我的排名
 */
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UIImageView *arrowIcon1;
//全球矿池
@property (nonatomic, strong) UILabel *worldRankLabel;
@property (nonatomic, strong) UIImageView *arrowIcon2;

/**
 今日累计
 */
//@property (nonatomic, strong) UILabel *todayProfitLabel;

/**
 我的分成
 */
//@property (nonatomic, strong) UILabel *bonusLabel;

@property (nonatomic, strong) UILabel *tipLabel;

//@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIButton *miningBtn;

//所在矿池名称
//@property (nonatomic, strong) UILabel *poolNameLabel;
//当前矿池节点数
@property (nonatomic, strong) UILabel *poolNodesCountLabel;
//挖矿说明
@property (nonatomic, strong) UILabel *declareLabel;

/**
 进入后台的时候记录下当前的挖矿状态 YES代表正在挖矿
 */
@property (nonatomic, assign) BOOL miningStatu;

/**
 按钮是否开启挖矿，点击开始，为YES，点击关闭为NO，其他情况不需要改变
 */
@property (nonatomic, assign) BOOL BtnMiningStatu;

@property (nonatomic, assign) NSInteger miningTime;

@property (nonatomic, strong) UIScrollView *scrollView;


@property (nonatomic, strong) OFRipplesLayer *rippleLayer;

//分享按钮
@property (nonatomic, strong) UIButton *sharedBtn;


/**
 滚屏公告
 */
@property (nonatomic, strong) UILabel *noticeLabel;

@property (nonatomic, strong) UIView *noticeView;

//活动按钮 拖拽 View
//@property (nonatomic, strong) WMDragView *actDragView;
//@property (nonatomic, strong) UIButton *activityBtn;

//新的计时器
@property (nonatomic, strong) UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (nonatomic, assign) BOOL isCounting;//是否在计时
@property (nonatomic, assign)  uint64_t count;
@property (nonatomic, strong)   dispatch_source_t tTimer;  //秒计时器

//限制10秒请求挖矿接口，不成功 不继续调第二次
@property (nonatomic, assign) NSInteger tenM;
@property (nonatomic, assign) BOOL isCanPost;//是否可以发出请求，每次请求结束后计时10S再发出第二次请求
//毫秒计时器
@property (nonatomic, assign)  uint64_t msCount;
@property (nonatomic, strong)   dispatch_source_t msTimer;  //毫秒计时器

@property (nonatomic, assign) NSInteger h;//时
@property (nonatomic, assign) NSInteger m;//分
@property (nonatomic, assign) NSInteger s;//秒

@property (nonatomic, strong) NSMutableArray *noticeArray;//播报数组
@property (nonatomic, assign) BOOL isNoticeing;//是否在播报中，如果在播报中，只需添加到数组
@property (nonatomic, strong) UIButton *redPacketBtn; // 红包入口

@end

static NSString *const FirstShowKey = @"MiningMaskViewFirstShow";

static NSString *const ktotalAmountCanceKey = @"ktotalAmountCance";

@implementation OFMiningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logic = [[OFMiningLogic alloc] initWithDelegate:self];
    self.poolLogic = [[OFMyMiningLogic alloc] initWithDelegate:self];
    self.n_isWhiteStatusBar = YES;
    self.title = @"挖矿";
    self.view.backgroundColor = [UIColor whiteColor];
    self.noticeArray = @[].mutableCopy;
    self.miningTime = 0;
    self.n_isHiddenNavBar = YES;
    [self initUI];
    [self layout];
    [self setup];
    [self setTimeText:@"00:00:00 000"];
    [self addNotification];
    [self registerRouter];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(notificationCome:) name:kReceiveRemoteNotification object:nil];
    
    
    //网络状态监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(netWorkStateChange:)
                                                 name:KNotificationNetWorkStateChange
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginStateChange:)
                                                 name:KNotificationLoginStateChange
                                               object:nil];
    //开始挖矿
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(miningBtnClick)
                                                 name:KNotificationStartMining
                                               object:nil];
    //刷新钱包余额
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRefreshWallet
                                                        object:nil];
    //创建计时器
    [self CreateTimer];
    self.count = -1;
    self.isCanPost = YES;//默认允许初次挖矿请求
    //检测设备是否合法
    [IPhoneTool isJaukBreak];
    [IPhoneTool antiDebugging];
    [IPhoneTool checkBundleID];
    
    //默认开启挖矿
    self.BtnMiningStatu = YES;
    
    //执行任务
    [[OFTaskManager sharedOFTaskManager] runTaskNow];
    if (KcurUser) {
        // 检查用户是否有分享糖果
        [self.logic getCandyInfo];
        [self.logic getRedPacketSwitch];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[OFActivityViewModel sharedInstance] showActivityView];
    //确保已经登录
    if (KcurUser) {
        [self getData];
        if (!self.logic.shareInfo) {
            [self getShareData];
        }
        [self.poolLogic getPoolFundCount];
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (KcurUser) {
        //检查并上报
        [[OFUploadUserBehaviorManager sharedOFUploadUserBehaviorManager] checkAndUpLoad];
        //检查并继续播报
        [self startNotice];
    }
}

#pragma mark - 创建界面
- (void)initUI{
    
    [self.view addSubview:self.scrollView];
    
    //    self.scrollView.backgroundColor = [UIColor grayColor];
    //    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:self.topView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.indicator];
    [self.topView addSubview:self.numberLabel];
    [self.topView addSubview:self.totalNumberLabel];
    [self.topView addSubview:self.lookProfitBtn];
    [self.topView addSubview:self.sharedBtn];
    [self.topView addSubview:self.canReceivedOFView];
    [self.canReceivedTangView addSubview:self.candyRewardLabel];
    [self.canReceivedTangView addSubview:self.candyImgView];
    [self.topView addSubview:self.canReceivedTangView];
    [self.canReceivedOFView addSubview:self.OFImgView];
    [self.canReceivedOFView addSubview:self.miningRewardLabel];
    
    [self.scrollView addSubview:self.infoView];
    [self.infoView addSubview:self.rankLabel];
    [self.infoView addSubview:self.arrowIcon1];
    [self.infoView addSubview:self.worldRankLabel];
    [self.infoView addSubview:self.arrowIcon2];
    //    [self.infoView addSubview:self.bonusLabel];
    
    //    [self.scrollView addSubview:self.tipLabel];
    [self.scrollView addSubview:self.timeLabel];
    [self.scrollView addSubview:self.miningBtn];
    //    [self.scrollView addSubview:self.poolNameLabel];
    [self.scrollView addSubview:self.poolNodesCountLabel];
    [self.scrollView addSubview:self.declareLabel];
//    [self.view addSubview:self.actDragView];
    [self.scrollView addSubview:self.redPacketBtn];
}

- (void)layout{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(self.view.mas_left);
        //        make.top.mas_equalTo(self.view.mas_top);
        //        make.right.mas_equalTo(self.view.mas_right);
        //        make.width.mas_equalTo(SCREEN_WIDTH);
        make.edges.mas_equalTo(0);
    }];
    
    CGFloat top = 35;
    if (IS_IPHONE_X) {
        top = 50;
    }
    
    CGFloat topHeight = KHeightFixed(215) - 64 + Nav_Height;
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(topHeight);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo([NUIUtil fixedHeight:top]);
    }];
    
    [self.indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(13);
        make.centerX.mas_equalTo(self.titleLabel.mas_centerX).offset(-KWidthFixed(50));
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.sharedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo([NUIUtil fixedHeight:top]-5);
    }];

    
//    CGFloat h = [NUIUtil fixedHeight:35];
    
    [self.lookProfitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.topView.mas_centerX);
        //        make.top.mas_equalTo(self.numberLabel.mas_bottom).offset([NUIUtil fixedHeight:22.5]);
        make.bottom.mas_equalTo(self.topView).offset(-KHeightFixed(40));
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.centerY.mas_offset(0).offset(- 64 + Nav_Height);
    }];
    //糖果收益
    [self.canReceivedTangView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-KWidthFixed(10));
//        make.width.mas_equalTo(KWidthFixed(75));
        make.width.mas_greaterThanOrEqualTo(KWidthFixed(70));
        make.height.mas_equalTo(KWidthFixed(22.5));
        make.bottom.mas_equalTo(-KWidthFixed(10));
    }];
    [self.candyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KWidthFixed(22.5));
    }];
    [self.candyRewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.candyImgView.mas_right).offset(5);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-8);
    }];
    
    //OF挖矿收益
    [self.canReceivedOFView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-KWidthFixed(10));
        make.width.mas_equalTo(self.canReceivedTangView);
        make.height.mas_equalTo(KWidthFixed(22.5));
        make.bottom.mas_equalTo(self.canReceivedTangView.mas_top).offset(-KWidthFixed(10));
    }];
    [self.OFImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(KWidthFixed(22.5));
    }];
    
    [self.miningRewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.OFImgView.mas_right).offset(5);
        make.top.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-8);
    }];
    
    
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.left.right.mas_equalTo(self.scrollView);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(KWidthFixed(50));
    }];
    
    [self.worldRankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.arrowIcon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.worldRankLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.worldRankLabel);
        make.width.mas_equalTo(KWidthFixed(10));
        make.height.mas_equalTo(KWidthFixed(14));
    }];
    
    [self.rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.arrowIcon1.mas_right).offset(15);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.arrowIcon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rankLabel.mas_right).offset(5);
        make.centerY.mas_equalTo(self.rankLabel);
        make.width.mas_equalTo(KWidthFixed(10));
        make.height.mas_equalTo(KWidthFixed(14));
    }];
    
    //    [self.bonusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.mas_equalTo(self.infoView).offset(-15);
    //        make.top.mas_equalTo(0);
    //        make.bottom.mas_equalTo(0);
    //    }];
    
    [self.redPacketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.topView.mas_right).offset(-KWidthFixed(15));
        make.top.mas_equalTo(self.topView.mas_bottom).offset(KWidthFixed(20));
        make.width.mas_equalTo(KWidthFixed(49));
        make.height.mas_equalTo(KWidthFixed(50));
    }];
    
    
    [self setTimeText:@"99:99:99 999"];
    [self.timeLabel sizeToFit];
    
    CGFloat timeWidth = self.timeLabel.width;
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(0);
        //        make.right.mas_equalTo(self.view.mas_right);
        //        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.infoView.mas_bottom).offset([NUIUtil fixedHeight:35]);
        make.left.mas_equalTo((kScreenWidth - timeWidth)/2.0);
    }];
    
    CGFloat width = [NUIUtil fixedWidth:135];
    
    [self.miningBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(width, width));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).offset([NUIUtil fixedHeight:40]);
        //        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-100);
    }];
    
    //    [self.poolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(self.miningBtn.mas_bottom).offset([NUIUtil fixedHeight:27.5]);
    //        make.centerX.mas_equalTo(self.view.mas_centerX);
    //    }];
    [self.poolNodesCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.miningBtn.mas_bottom).offset([NUIUtil fixedHeight:35]);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-52);
    }];
    
    [self.declareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.poolNodesCountLabel.mas_bottom).offset(KHeightFixed(10));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(KHeightFixed(15));
    }];
    
//    [self.actDragView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.view).offset(-kTabbar_Height - KWidthFixed(40));
//        make.width.mas_equalTo(KWidthFixed(62.5));
//        make.height.mas_equalTo(KWidthFixed(65));
//        make.right.mas_equalTo(self.view).offset(-23);
//    }];
    
}

- (void)setup{
    self.titleLabel.text = @"OF总收益";
    NSString *currentNum = [self.numberLabel.text stringByReplacingOccurrencesOfString:@"," withString:@""];
    double totalNum = [self.logic.dataModel.reward.totalReward doubleValue] - [currentNum doubleValue];
    if (totalNum>0.1) {
        double duration = 0.001f;
        [self.numberLabel animationFromnum:[currentNum doubleValue] toNum:[self.logic.dataModel.reward.totalReward doubleValue] duration:duration];
    }
    
    if (self.logic.dataModel.community) {
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:NSStringFormat(@"全球%ld个节点正与你协作挖矿",[self.logic.dataModel.miningCount integerValue])];
        [attr addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:NSMakeRange(2, [self.logic.dataModel.miningCount stringValue].length)];
        self.poolNodesCountLabel.attributedText = attr;
    }else{
        self.poolNodesCountLabel.text = @"";
    }
    double candyValue = [self.logic.dataModel.reward.currentRewaed doubleValue] - [self.logic.dataModel.reward.miningReward doubleValue];
    self.miningRewardLabel.text = NSStringFormat(@"%.3f",[self.logic.dataModel.reward.miningReward doubleValue]);
    self.candyRewardLabel.text = NSStringFormat(@"%.3f",MAX(0, candyValue));
}


- (void)setTimeText:(NSString *)timeText{
    
    if (timeText.length < 3) {
        return;
    }
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:timeText];
    [attr addAttribute:NSFontAttributeName value:[NUIUtil fixedFont:17.5] range:NSMakeRange(timeText.length - 3, 3)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0x999999] range:NSMakeRange(timeText.length - 3, 3)];
    self.timeLabel.attributedText = attr;
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat top = scrollView.contentOffset.y;
    if (top <= 0) {
        CGFloat topHeight = KHeightFixed(215) - 64 + Nav_Height;
        self.topBackView.frame = CGRectMake(0, top, kScreenWidth, topHeight - top);
        
        if (top == 0) {
            self.indicator.hidden = YES;
            self.indicator.alpha = 0.f;
        }else {
            self.indicator.hidden = NO;
            self.indicator.alpha = fabs(top) / 50.f > 1.f ? 1.f : fabs(top) / 50.f;
        }
    }
}

- (void)maskViewClick:(UITapGestureRecognizer *)tap{
    
//    NSLog(@"%@",tap.view);
    
    [tap.view removeFromSuperview];
    
//    NSLog(@"maskView点击");
}

#pragma mark - 头部刷新
-(void)headerRereshing{
    [self getData];
    [self getShareData];
}

#pragma mark - 登录成功以后拉取一次数据
- (void)getDataByLoginSuc{
    [self getData];
    [self getShareData];
}
#pragma mark - 默认开始挖矿
- (void)startMiningNormal{
    if (!kAppDelegate.isMining &&
        self.BtnMiningStatu == YES &&
        !kAppDelegate.isAutoMining) {
        kAppDelegate.isAutoMining = YES;
        [self miningBtnClick];
    }
}

#pragma mark - 请求页面数据
- (void)getData{
    [self.indicator startAnimating];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.logic getMiningInfo:NO poolName:nil blockNumber:nil blockReward:nil];
    });
}

#pragma mark - 请求分享数据
- (void)getShareData{
    [self.logic getShareInfo];
}


#pragma mark - 挖矿请求
- (void)sendData{
    [self.logic miningReq];
}


#pragma mark - 挖矿信息获取成功 回调
- (void)requestDataSuccess{
    [self.scrollView.mj_header endRefreshing];
    [self.indicator stopAnimating];
    [self setup];
    [self startMiningNormal];
}

#pragma mark - 计算本次出块 用户收益是否增加，选择播报形式
-(void)miningRewardResult:(double)reward poolName:(NSString *)poolName blockNumber:(NSString *)blockNumber blockReward:(NSString *)blockReward{
    NSString *content = @"";
    if (reward == 0) {
        //常规全球播报
        content = [NSString stringWithFormat:@" 恭喜%@获得%@枚OF奖励，全世界在与你协作", poolName, blockReward];
    }else{
        //个人播报
        content = [NSString stringWithFormat:@" 恭喜%@获得%@枚OF奖励，你参与协作并获得%.3f枚OF奖励",poolName,blockReward,reward];
        //出矿动画
        [self miningSucAnimation];
    }
    [self addNoticeStr:content];
}

//模拟点击出矿
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击空白页上传
    [[OFUploadUserBehaviorManager sharedOFUploadUserBehaviorManager] touchPageUpload];
    
////    //测试代码
//    [self.noticeArray addObject:NSStringFormat(@"%d - 测试播报测试播报测试播报测试播报测试播报测试播报",arc4random()%1000)];
//    [self startNotice];
    
}

#pragma mark - 出矿动画
-(void)miningSucAnimation{
    CGRect f = [self.scrollView convertRect:self.miningBtn.frame toView:self.view];
    f.origin.x = f.origin.x + f.size.width;
    f.origin.y = f.origin.y + f.size.height/2 - KWidthFixed(34)/2;
    
    CGPoint p2 = [self.canReceivedOFView convertPoint:self.OFImgView.center toView:self.view];

    OFMiningAnimationIconView *iconView = [OFMiningAnimationIconView new];
    [iconView showMiningIconToView:self.view WithPoint:f.origin endPoint:p2];
}

#pragma mark - 接口报错 回调
-(void)requestDataFailure:(NSString *)errMessage{
    [self.scrollView.mj_header endRefreshing];
    [self.indicator stopAnimating];
//    [MBProgressHUD showError:errMessage];
    NSLog(@"挖矿接口异常：%@",errMessage);
}


#pragma mark - 挖矿回调
-(void)miningCallBack{
    self.tenM = 0;
    _isCanPost = YES;
    //检查并上报
    [[OFUploadUserBehaviorManager sharedOFUploadUserBehaviorManager] checkAndUpLoad];
    
//    OFInviteFriendView *inviteView = [OFInviteFriendView loadFromXib];
//    inviteView.frame = self.view.bounds;
//    WEAK_SELF;
//    [inviteView showFirstReward:self.view.window withRewardValue:0.001 shareBlock:^{
//        [weakSelf sharedBtnClick];
//    }];
}

/**
 挖矿连续错误十次 回调，停止挖矿
 */
-(void)miningErrorStopCallBack{
    [MBProgressHUD showError:@"网络状态不佳，已暂停挖矿"];
    [self stopMining];
}


#pragma mark - 登录状态改变 开始/停止挖矿
- (void)loginStateChange:(NSNotification *)notification
{
    BOOL loginSuccess = [notification.object boolValue];
    if (loginSuccess) {
        [self startMiningNormal];
        [self getDataByLoginSuc];
    }else{
        kAppDelegate.isAutoMining = NO;
        if (kAppDelegate.isMining) {
            [self stopMining];
        }
    }
}

#pragma mark - 程序通知处理
- (void)addNotification{
    NSNotificationCenter *noti = [NSNotificationCenter defaultCenter];

    // 激活状态
    [noti addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    // 未激活状态
    [noti addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
}
- (void)appBecomeActive{
    NSLog(@"激活状态");
    [self startNotice];
}

- (void)appResignActive{
    NSLog(@"未激活状态");
    //后台以后也继续跑计时任务
    if (kAppDelegate.isMining) {
        UIApplication*   app = [UIApplication sharedApplication];
        __block    UIBackgroundTaskIdentifier bgTask;
        bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid)
                {
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (bgTask != UIBackgroundTaskInvalid)
                {
                    bgTask = UIBackgroundTaskInvalid;
                }
            });
        });
    }
    
//    // 停止挖矿
//    self.miningStatu = kAppDelegate.isMining;
//    if (kAppDelegate.isMining) {
//        [self stopMining];
//    }
}
#pragma mark - 收到长链接推送
- (void)notificationCome:(NSNotification *)noti{
    NSDictionary *dict = [NDataUtil dictWith:noti.object];
    NSLog(@"%@",dict);
    
    NSInteger type = [NDataUtil intWith:dict[@"type"] valid:0];
    
    NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
    NSString *content;
    switch (type) {
        case 1:
        {
            NSString *blockNumber = [NDataUtil stringWith:data[@"blockNumber"] valid:@"*"];
            NSString *name = [NDataUtil stringWith:data[@"name"] valid:@""];
//            NSString *counts = [NDataUtil stringWith:data[@"counts"] valid:@""];
            NSString *cid = [NDataUtil stringWith:data[@"cid"] valid:@""];
            NSString *reward = [NDataUtil stringWith:data[@"reward"] valid:@""];
            if ([cid isEqualToString:KcurUser.community.cid]) {
                //收到出块播报，并且是自己所在的社群，则请求余额是否发生变化，如果＞0则播报 恭喜%@挖到第%@区块，你参与协作并获得1.001个OF奖励
                //如果没变化则播报 恭喜%@挖到第%@区块，全世界在与你协作
                [self.logic getMiningInfo:YES poolName:name blockNumber:blockNumber blockReward:reward];
                return;
            }
            content = [NSString stringWithFormat:@" 恭喜%@获得%@枚OF奖励，全世界在与你协作", name, reward];
//            content = [NSString stringWithFormat:@" 恭喜%@挖到第%@区块，你参与协作并获得1.001个OF奖励",name,blockNumber];
        }
            break;
        case 2:
        {
            NSString *name = [NDataUtil stringWith:data[@"name"] valid:@""];
            NSString *time = [NDataUtil stringWith:data[@"time"] valid:@""];
//            NSString *cid = [NDataUtil stringWith:data[@"cid"] valid:@""];
            content = [NSString stringWithFormat:@" 恭喜%@，在%@拉新人数最多，获取5000OF奖励!",name,time];
        }
            break;
        case 3:
            content = [NDataUtil stringWith:dict[@"content"] valid:@""];
            break;
        case 4:
        {
            NSString *blockNumber = [NDataUtil stringWith:data[@"blockNumber"] valid:@"*"];
            NSString *name = [NDataUtil stringWith:data[@"name"] valid:@""];
            NSString *counts = [NDataUtil stringWith:data[@"counts"] valid:@""];
            NSString *cid = [NDataUtil stringWith:data[@"cid"] valid:@""];
            NSString *reward = [NDataUtil stringWith:data[@"reward"] valid:@""];
            //收到出块播报，并且是自己所在的社群，则请求余额是否发生变化，如果＞0则播报 恭喜%@挖到第%@区块，你参与协作并获得1.001个OF奖励
            //如果没变化则播报 恭喜%@挖到第%@区块，全世界在与你协作
            [self.logic getMiningInfo:YES poolName:name blockNumber:blockNumber blockReward:reward];
            return;
        }
            break;
        default:
            break;
    }
//    [self noticeLabelRun:@" 测试内容...测试内容.测试内容...测试内容测试内容...测试内容测试内容...测试内容测试内容...测试内容"];
    [self addNoticeStr:content];
}

/**
 添加推送内容

 @param content 推送内容
 */
-(void)addNoticeStr:(NSString *)content{
    NSLog(@"%@",content);
    if (content.length < 1) {
        return;
    }
    
    //    [self noticeLabelRun:content];
    [self.noticeArray addObject:content];
    [self startNotice];
}

#pragma mark - 点击事件
/**
 见证收益
 */
- (void)lookProfitBtnClick{    
    OFLookPrifitVC *vc = [[OFLookPrifitVC alloc]init];
    double currentAmount = [self.logic.dataModel.reward.currentRewaed doubleValue];
    //    vc.money = [NSString stringWithFormat:@"%.3f",currentAmount];
    
    //    CGFloat MiningAmount = [NDataUtil floatWith:self.logic.dataDic[@"MiningAmount"] valid:0.0];
    double MiningAmount = [self.logic.dataModel.reward.miningReward doubleValue];
    if (MiningAmount < 0.0) {
        MiningAmount = 0.000;
    }
    vc.miningReward = [NSString stringWithFormat:@"%.3f",MiningAmount];
    CGFloat candy = currentAmount - MiningAmount;
    if (candy < 0.0) {
        candy = 0.000;
    }
    vc.candyReward = [NSString stringWithFormat:@"%.3f",candy];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 开始挖矿按钮点击事件
- (void)miningBtnClick{
    //启动检测设备是否合法
    [IPhoneTool isJaukBreak];
    [IPhoneTool antiDebugging];
    [IPhoneTool checkBundleID];
    
//    if (!KisLogin) {
//        return;
//    }
    //没有加入矿池，先提示加入矿池
    if (KcurUser.community.cid.length < 1 || [KcurUser.community.cid integerValue] == 0) {
        WEAK_SELF;
        if ([self.logic.dataModel.GlobalDetail.communityNumber integerValue] > 0) {
            OFJoinPoolAlertView *alertView = [OFJoinPoolAlertView loadFromXib];
            alertView.frame = kAppDelegate.mainTabBar.view.bounds;
            [alertView show:kAppDelegate.mainTabBar.view poolCount:[self.logic.dataModel.GlobalDetail.communityNumber integerValue] btnblock:^{
                [weakSelf worldRankClick];
            }];
        }
        return;
    }
    
    // 开始挖矿
    if (kAppDelegate.isMining) {
        self.BtnMiningStatu = NO;
        [self stopMining];
    }else{
        self.BtnMiningStatu = [self startMining];
    }
}

#pragma mark - 开始挖矿
- (BOOL)startMining{
//    if (![OFNetworkManager isNetwork]) {
//        [MBProgressHUD showError:@"请先连接网络再开始挖矿哦~"];
//        return NO;
//    }
    self.rippleLayer.position = self.miningBtn.center;
    self.rippleLayer.radius = [NUIUtil fixedWidth:135];
    [self.miningBtn setTitle:@"正在挖矿" forState:UIControlStateNormal];
    [self.miningBtn setBackgroundColor:[UIColor colorWithRGB:0x1ad19f]];

    [self.scrollView.layer insertSublayer:self.rippleLayer below:self.miningBtn.layer];
    [self.rippleLayer startAnimation];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
   
    kAppDelegate.isMining = YES;
    dispatch_resume(self.tTimer);
    dispatch_resume(self.msTimer);
    [OFMobileClick event:MobileClick_start_mining];
    return YES;
}

#pragma mark - 停止挖矿
- (BOOL)stopMining{
    kAppDelegate.isMining = NO;
    [self.miningBtn setTitle:@"开始挖矿" forState:UIControlStateNormal];
    [_miningBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
    [self.rippleLayer removeFromSuperlayer];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    //激活timer对象
    dispatch_suspend(self.tTimer);
    dispatch_suspend(self.msTimer);
    return YES;
}


//#pragma mark - 成功获取活动信息回调
//-(void)getActivitySuc{
//    //成功获取 开始创建
//    if (![self.view viewWithTag:8000]) {
//        WEAK_SELF;
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        btn.tag = 8000;
//        [btn setImage:IMAGE_NAMED(@"activity_icon") forState:UIControlStateNormal];
//        [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
//            [weakSelf sharedBtnClick];
//        }];
//        [self.view addSubview:btn];
//
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.view).offset(-15);
//            make.width.height.mas_equalTo(KWidthFixed(55));
//            make.bottom.mas_equalTo(-kTabbar_Height - 50);
//        }];
//    }
//}

#pragma mark - 我的矿池
- (void)rankClick{
    WEAK_SELF;
    //如果没加入矿池，传递并提示当前总矿池数
    if (!KUserManager.curUserInfo.community) {
        OFJoinPoolAlertView *alertView = [OFJoinPoolAlertView loadFromXib];
        alertView.frame = kAppDelegate.mainTabBar.view.bounds;
        [alertView show:kAppDelegate.mainTabBar.view.window poolCount:[self.logic.dataModel.GlobalDetail.communityNumber integerValue] btnblock:^{
            [weakSelf worldRankClick];
        }];
    }else{
        OFMyMiningPoolVC *teamList = [[OFMyMiningPoolVC alloc]init];
        [self.navigationController pushViewController:teamList animated:YES];
    }
}

#pragma mark - 全球矿池
- (void)worldRankClick{
    OFAllMiningPoolVC *teamList = [[OFAllMiningPoolVC alloc]init];
    [self.navigationController pushViewController:teamList animated:YES];
}

#pragma mark - 开始播报
-(void)startNotice{
    if (self.noticeArray.count>0 && self.isNoticeing == NO) {
        NSString *noticeStr = [self.noticeArray firstObject];
        if ([NSThread isMainThread]) {
            [self creatNoticeView:noticeStr];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self creatNoticeView:noticeStr];
            });
        }
    }
}

#pragma mark - 创建播报view
- (void)creatNoticeView:(NSString *)text{
    if (!_noticeView || !_noticeView.superview) {
        _noticeView = [[UIView alloc]init];
        _noticeView.width = kScreenWidth;
        [self.view addSubview:_noticeView];
        _noticeView.top = self.titleLabel.bottom + 5;
        
        _noticeView.backgroundColor = [UIColor colorWithRGB:0xfdfbef alpha:0.7];
        _noticeLabel = [[UILabel alloc]init];
        _noticeLabel.backgroundColor = [UIColor clearColor];
        [_noticeView addSubview:_noticeLabel];
    }
    
    NSTextAttachment *achment = [[NSTextAttachment alloc]init];
    
    NSString *str = text;
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attr addAttribute:NSFontAttributeName value:[NUIUtil fixedFont:12] range:NSMakeRange(0, str.length)];
    if ([str containsString:@"你参与协作并获得"]) {
//        NSRange rangeloc = [str rangeOfString:@"你参与协作并获得"];
//        NSRange range = NSMakeRange(rangeloc.location, str.length - rangeloc.location);
        achment.image = [UIImage imageNamed:@"mining_notice_red"];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0xee5566] range:NSMakeRange(0, str.length)];
    }else{
        achment.image = [UIImage imageNamed:@"mining_notice"];
        [attr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0xff6f00] range:NSMakeRange(0, str.length)];
    }
    
    achment.bounds = CGRectMake(0, -3, [NUIUtil fixedFont:12].lineHeight, [NUIUtil fixedFont:12].lineHeight);
    
    [attr insertAttributedString:[NSAttributedString attributedStringWithAttachment:achment] atIndex:0];
    _noticeLabel.attributedText = attr;
    
    [_noticeLabel sizeToFit];
    
    //        [self.view addSubview:_noticeLabel];

    
    _noticeLabel.left = kScreenWidth;
    _noticeLabel.top = 0;
    _noticeLabel.height = 27;
    
    NSTimeInterval time = (_noticeLabel.width + SCREEN_WIDTH) / 50.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        _noticeView.height = 27;
        self.isNoticeing = YES;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            _noticeLabel.left = -_noticeLabel.width;
        } completion:^(BOOL finished) {
            if (finished) {
                //动画正常结束，标记结束并移除数据，准备继续递归
                self.isNoticeing = NO;
                [self.noticeArray removeFirstObject];
                if (self.noticeArray.count>0) {
                    //递归继续播报没有播报过的消息
                    [self startNotice];
                }else{
                    [_noticeLabel removeFromSuperview];
                    _noticeLabel = nil;
                    [_noticeView removeFromSuperview];
                    _noticeView = nil;
                }
            }else{
                //动画非正常结束，标记结束，移除数据 并移除view，不继续递归
                self.isNoticeing = NO;
                [self.noticeArray removeFirstObject];
                [_noticeLabel removeFromSuperview];
                _noticeLabel = nil;
                [_noticeView removeFromSuperview];
                _noticeView = nil;
            }
        }];
    }];
    
}

#pragma mark - 领取收益页面
- (void)bonusClick:(ProfitType)type{
    NSLog(@"未领取收益");
    OFReceiveProfitVC *vc = [[OFReceiveProfitVC alloc]init];
    // currentAmount
//    CGFloat currentAmount = [NDataUtil floatWith:self.logic.dataDic[@"currentAmount"] valid:0.0];

    double currentAmount = [self.logic.dataModel.reward.currentRewaed doubleValue];
//    vc.money = [NSString stringWithFormat:@"%.3f",currentAmount];

//    CGFloat MiningAmount = [NDataUtil floatWith:self.logic.dataDic[@"MiningAmount"] valid:0.0];
    double MiningAmount = [self.logic.dataModel.reward.miningReward doubleValue];
    if (MiningAmount < 0.0) {
        MiningAmount = 0.000;
    }
    vc.miningReward = [NSString stringWithFormat:@"%.3f",MiningAmount];
    CGFloat candy = currentAmount - MiningAmount;
    if (candy < 0.0) {
        candy = 0.000;
    }
    vc.type = type;
    vc.candyReward = [NSString stringWithFormat:@"%.3f",candy];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 红包
- (void)sendRedPacket
{
    OFPacketSendController *controller = [[OFPacketSendController alloc] initWithReward:self.logic.dataModel.reward];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - 分享按钮点击事件
- (void)sharedBtnClick{
    if (self.logic.shareInfo) {
        [NLocalUtil setBool:YES forKey:KisFirstClickShare];
        if ([NLocalUtil boolForKey:KisFirstClickShare]) {
            [_sharedBtn setImage:[UIImage imageNamed:@"wallet_shared_btn"] forState:UIControlStateNormal];
        }else{
            [_sharedBtn setImage:[UIImage imageNamed:@"share_red_icon"] forState:UIControlStateNormal];
        }
        
        OFSharedModel *model = [[OFSharedModel alloc]init];
        model.sharedType = OFSharedTypePicture;
        
        model.urlString = self.logic.shareInfo[@"url"];
        model.thumbImage = IMAGE_NAMED(@"AppIcon");
        model.title = self.logic.shareInfo[@"title"];
        model.descript = self.logic.shareInfo[@"shareContent"];
        model.cid = KcurUser.community.cid;
        model.communityName = KcurUser.community.name;
        
        OFShareAppView *shareAppView = [OFShareAppView loadFromXib];
        [shareAppView showShareAppViewToView:kAppDelegate.mainTabBar.view shareType:0 poolName:nil shareModel:model];
        
        [OFMobileClick event:MobileClick_click_shareIcon];
    }else{
        [self getShareData];
        [MBProgressHUD showError:@"分享信息拉取失败，请重试"];
    }
    
    //弹过记录一下
//    [NLocalUtil setBool:YES forKey:KisFirstShowShareAlert];
    
//    OFSharedModel *model = [[OFSharedModel alloc]init];
//    model.sharedType = OFSharedTypeUrl;
//
//    //    model.smsText = [NSString stringWithFormat:@"哈喽~我已经在OF社群链里，通过手机挖矿赚到，挖出来的真能卖钱！快来跟我一起挖矿吧~\n（分享自@OF）"];
//    model.urlString = self.logic.shareInfo[@"url"];
//    model.thumbImage = IMAGE_NAMED(@"AppIcon");
//    model.title = self.logic.shareInfo[@"shareTitle"];
//    model.descript = self.logic.shareInfo[@"shareContent"];
//
//    OFInviteFriendView *inviteView = [OFInviteFriendView loadFromXib];
//    inviteView.frame = self.view.bounds;
//    [inviteView show:self.view.window withTitle:@"邀请好友" WithDes:@"注册成功各送66个糖果" shareModel:model];

    
}

#pragma mark - 用户首次出矿回调
-(void)firstRewardCallBack:(double)rewardValue{
    OFInviteFriendView *inviteView = [OFInviteFriendView loadFromXib];
    inviteView.frame = kAppDelegate.mainTabBar.view.bounds;
    WEAK_SELF;
    [inviteView showFirstReward:kAppDelegate.mainTabBar.view withRewardValue:rewardValue shareBlock:^{
        [weakSelf sharedBtnClick];
    }];
}

#pragma mark - 老用户当天首次出矿回调
-(void)todayFirstRewardCallBack:(double)rewardValue{
    OFInviteFriendView *inviteView = [OFInviteFriendView loadFromXib];
    inviteView.frame = kAppDelegate.mainTabBar.view.bounds;
    WEAK_SELF;
    [inviteView showTodayFirstReward:kAppDelegate.mainTabBar.view withRewardValue:rewardValue shareBlock:^{
        [weakSelf sharedBtnClick];
    }];
}


#pragma mark - 天降糖果弹窗
- (void)candyAlertCallBack:(float)candy
{
    OFCandySucAlertView *inviteView = [OFCandySucAlertView loadFromXib];
    inviteView.frame = kAppDelegate.mainTabBar.view.bounds;
    NSString *des = [NSString stringWithFormat:@"恭喜您获得%.3f个糖果",candy];
    WEAK_SELF;
    [inviteView show:kAppDelegate.mainTabBar.view withTitle:@"领取奖励" WithDes:des shareBlock:^{
        [weakSelf sharedBtnClick];
    }];
}

#pragma mark - 是否有基金分红
- (void)getPoolFuntCallBack:(BOOL)isHas{
    if (isHas) {
        self.arrowIcon2.image = IMAGE_NAMED(@"minging_poolFund_icon");
    }else{
        NSLog(@"无矿池分红");
        self.arrowIcon2.image = IMAGE_NAMED(@"mining_arrow_right");
    }
}

#pragma mark - 是否展示红包入口
- (void)getRedPacketSwitch:(bool)isShow{
    self.redPacketBtn.hidden = !isShow;
}

#pragma mark - GCD timer初始化
-(void)CreateTimer{
    WEAK_SELF;
    //创建GCD timer资源， 第一个参数为源类型， 第二个参数是资源要加入的队列
    self.tTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //设置timer信息， 第一个参数是我们的timer对象， 第二个是timer首次触发延迟时间， 第三个参数是触发时间间隔， 最后一个是是timer触发允许的延迟值， 建议值是十分之一
    dispatch_source_set_timer(self.tTimer,
                              dispatch_walltime(NULL, 0 * NSEC_PER_SEC),
                              1 * NSEC_PER_SEC,
                              0);
    
    //设置timer的触发事件
    dispatch_source_set_event_handler(self.tTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //触发事件
            [weakSelf logCount];
        });
        
    });
    
    self.msTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //设置timer信息， 第一个参数是我们的timer对象， 第二个是timer首次触发延迟时间， 第三个参数是触发时间间隔， 最后一个是是timer触发允许的延迟值， 建议值是十分之一
    dispatch_source_set_timer(self.msTimer,
                              dispatch_walltime(NULL, 0 * NSEC_PER_SEC),
                              0.01 * NSEC_PER_SEC,
                              0);
    
    //设置timer的触发事件
    dispatch_source_set_event_handler(self.msTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //触发事件
            [weakSelf msCountAction];
        });
        
    });
}


//计数 每秒执行
- (void)logCount {
    self.count ++;
    _h = self.count / 3600;
    _m = self.count / 60 % 60;
    _s = self.count % 60;
    
    //是否可以
    if (self.isCanPost && self.tenM >= 10) {
        self.isCanPost = NO;
        self.tenM = 0;
        [self sendData];
    }else{
        self.tenM ++;
    }
    
//    //30秒时 弹出糖果分享框
//    if (self.count == 30) {
//        if ([NLocalUtil boolForKey:KisFirstShowShareAlert] == NO) {
//            [self sharedBtnClick];
//        }
//    }
    //上报挖矿时间，满1小时上报一次
    [[OFUploadUserBehaviorManager sharedOFUploadUserBehaviorManager] miningUpload:self.count];
}

//毫秒计数
- (void)msCountAction {
    self.msCount ++;
    if (self.msCount>=100) {
        self.msCount = 0;
    }
    
//    if (!KisLogin) {
//        [self miningBtnClick];
//        self.timeLabel.text = @"00:00:00:000";
//        return;
//    }
    
    if (!KcurUser.community) {
        [self stopMining];
        return;
    }
    
    NSInteger randomNumber = arc4random() % 10;
    NSString *ssStr = [NSString stringWithFormat:@"%02llu%ld", self.msCount,randomNumber];
    NSString *timeStr = [NSString stringWithFormat:@"%02ld:%02ld:%02ld %@",_h,_m,_s,ssStr];
    [self setTimeText:timeStr];
}

#pragma mark ————— 网络状态变化 —————
- (void)netWorkStateChange:(NSNotification *)notification
{
    BOOL isNetWork = [notification.object boolValue];
    
    if (isNetWork) {//有网络
        if (!kAppDelegate.isMining && self.BtnMiningStatu) {
            [self miningBtnClick];
        }
    }else {//无网络
        if (kAppDelegate.isMining) {
            [self stopMining];
        }
    }
}

#pragma mark - Router
- (void)registerRouter
{
    WEAK_SELF;
    [[OFRouter appRouter] registerRootHandler:^(NSString *path) {
        if ([path hasPrefix:kMiningMyPool]) {
            OFTabBarController *tabBarController = kAppDelegate.mainTabBar;
            UINavigationController *currentNavi = [tabBarController selectedViewController];
            [currentNavi popToRootViewControllerAnimated:NO];
            [tabBarController setSelectedIndex:1];
            [weakSelf rankClick];
        }
    }];
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        _scrollView.mj_header = header;
    }
    return _scrollView;
}

- (UIImageView *)topView {
   if (!_topView) {
       _topView = [UIImageView new];
       _topView.backgroundColor = [UIColor colorWithRGB:0xf7842b];
       _topView.userInteractionEnabled = YES;
       
       UIImage *image = [UIImage makeGradientImageWithRect:CGRectMake(0, 0, kScreenHeight, 100) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2];
       _topBackView = [[UIImageView alloc] initWithFrame:CGRectZero];
       [_topBackView setImage:image];
       [_topView setImage:image];
       [_topView addSubview:_topBackView];
   }
   return _topView;
}

- (UIView *)infoView {
   if (!_infoView) {
       _infoView = [UIView new];
       _infoView.backgroundColor = KWhiteColor;
   }
   return _infoView;
}

- (UIActivityIndicatorView *)indicator
{
    if (!_indicator) {
        _indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    }
    return _indicator;
}

- (UILabel *)titleLabel {
   if (!_titleLabel) {
       _titleLabel = [UILabel new];
       _titleLabel.font = [NUIUtil fixedFont:17];
       _titleLabel.textColor = [UIColor whiteColor];
       _titleLabel.backgroundColor = [UIColor clearColor];
       _titleLabel.textAlignment = NSTextAlignmentCenter;
       _titleLabel.text = @"昨日收益(of coin)";
   }
   return _titleLabel;
}

- (UILabel *)numberLabel {
   if (!_numberLabel) {
       _numberLabel = [UILabel ws_animationLabelWithFrame:CGRectZero];
       _numberLabel.font = FixFont(36);
       _numberLabel.textColor = [UIColor whiteColor];
       _numberLabel.backgroundColor = [UIColor clearColor];
       _numberLabel.textAlignment = NSTextAlignmentCenter;
       _numberLabel.text = @"0.000";
       _numberLabel.userInteractionEnabled = YES;
       WEAK_SELF;
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
           [weakSelf lookProfitBtnClick];
       }];
       [_numberLabel addGestureRecognizer:tap];
   }
   return _numberLabel;
}

- (UIButton *)lookProfitBtn {
   if (!_lookProfitBtn) {
       _lookProfitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       _lookProfitBtn.titleLabel.font = [NUIUtil fixedFont:16];
       [_lookProfitBtn setTitle:@"见证收益" forState:UIControlStateNormal];
//       [_lookProfitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [_lookProfitBtn setTintColor:[UIColor colorWithRGB:0xfcf5a9]];
       [_lookProfitBtn addTarget:self action:@selector(lookProfitBtnClick) forControlEvents:UIControlEventTouchUpInside];
       [_lookProfitBtn setImage:[UIImage imageNamed:@"mining_btn_arrow"] forState:UIControlStateNormal];
       
       [_lookProfitBtn layoutButtonWithEdgeInsetsStyle:OFButtonEdgeInsetsStyleRight imageTitleSpace:10];
//       _lookProfitBtn.hidden = YES;
       
   }
   return _lookProfitBtn;
}

- (UILabel *)totalNumberLabel {
   if (!_totalNumberLabel) {
       _totalNumberLabel = [UILabel new];
       _totalNumberLabel.font = [NUIUtil fixedBoldFont:17];
       _totalNumberLabel.textColor = [UIColor whiteColor];
       _totalNumberLabel.backgroundColor = [UIColor clearColor];
       _totalNumberLabel.textAlignment = NSTextAlignmentCenter;
   }
   return _totalNumberLabel;
}

- (UILabel *)rankLabel {
   if (!_rankLabel) {
       _rankLabel = [UILabel new];
       _rankLabel.font = [NUIUtil fixedFont:14];
       _rankLabel.textColor = OF_COLOR_DETAILTITLE;
       _rankLabel.text = @"我的矿池";
       WEAK_SELF;
       UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
           [weakSelf rankClick];
       }];
       [_rankLabel addGestureRecognizer:tap];
       _rankLabel.userInteractionEnabled = YES;
   }
   return _rankLabel;
}

- (UIImageView *)arrowIcon1{
    if (!_arrowIcon1) {
        _arrowIcon1 = [UIImageView new];
        [_arrowIcon1 setImage:IMAGE_NAMED(@"mining_arrow_right")];
    }
    return _arrowIcon1;
}

//- (WMDragView *)actDragView
//{
//    if (!_actDragView) {
//        CGFloat topHeight = KHeightFixed(215) - 64 + Nav_Height;
//        _actDragView = [[WMDragView alloc] initWithFrame: CGRectMake(SCREEN_WIDTH - KWidthFixed(65), topHeight, KWidthFixed(62.5), KWidthFixed(65))];
//        _actDragView.backgroundColor = [UIColor clearColor];
//        [_actDragView.button setImage:IMAGE_NAMED(@"activity_icon") forState:UIControlStateNormal];
//        _actDragView.dragEnable = YES;
//        _actDragView.isKeepBounds = YES;
//        CGFloat statusBarHeight = Nav_Height - 40.f;
//        CGRect freeRect = CGRectMake(0, statusBarHeight, kScreenWidth, kScreenHeight - statusBarHeight - kTabbar_Height);
//        _actDragView.freeRect = freeRect;
//        WEAK_SELF;
//        _actDragView.clickDragViewBlock = ^(WMDragView *dragView) {
//            [weakSelf sharedBtnClick];
//        };
//    }
//    return _actDragView;
//}

//-(UIButton *)activityBtn{
//    if (!_activityBtn) {
//        _activityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_activityBtn setImage:IMAGE_NAMED(@"activity_icon") forState:UIControlStateNormal];
//        [_activityBtn addTarget:self action:@selector(sharedBtnClick) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _activityBtn;
//}

#pragma mark - 全球矿池
- (UILabel *)worldRankLabel{
    if (!_worldRankLabel) {
        _worldRankLabel = [UILabel new];
        _worldRankLabel.text = @"全球矿池";
        _worldRankLabel.font = [NUIUtil fixedFont:14];
        _worldRankLabel.textColor = OF_COLOR_DETAILTITLE;
        WEAK_SELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            //全球矿池跳转方法
            [weakSelf worldRankClick];
        }];
        [_worldRankLabel addGestureRecognizer:tap];
        _worldRankLabel.userInteractionEnabled = YES;
    }
    return _worldRankLabel;
}

- (UIImageView *)arrowIcon2{
    if (!_arrowIcon2) {
        _arrowIcon2 = [UIImageView new];
        [_arrowIcon2 setImage:IMAGE_NAMED(@"mining_arrow_right")];
    }
    return _arrowIcon2;
}

//- (UILabel *)bonusLabel {
//    if (!_bonusLabel) {
//        _bonusLabel = [UILabel new];
//        _bonusLabel.font = [NUIUtil fixedFont:14];
//        _bonusLabel.textColor = OF_COLOR_DETAILTITLE;
//        _bonusLabel.text = @"领取收益";
//        _bonusLabel.userInteractionEnabled = YES;
//        WEAK_SELF;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
//            [weakSelf bonusClick];
//        }];
//
//        [_bonusLabel addGestureRecognizer:tap];
//    }
//    return _bonusLabel;
//}

- (UILabel *)tipLabel {
   if (!_tipLabel) {
       _tipLabel = [UILabel new];
       _tipLabel.font = [NUIUtil fixedFont:17];
       _tipLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
       _tipLabel.backgroundColor = [UIColor clearColor];
       _tipLabel.textAlignment = NSTextAlignmentCenter;
       _tipLabel.text = @"本次累计时长";
   }
   return _tipLabel;
}

- (UILabel *)timeLabel {
   if (!_timeLabel) {
       _timeLabel = [UILabel new];
       _timeLabel.font = [NUIUtil fixedFont:35];
       _timeLabel.textColor = Title_Color;
       _timeLabel.backgroundColor = [UIColor clearColor];
//       _timeLabel.textAlignment = NSTextAlignmentCenter;
   }
   return _timeLabel;
}

- (UIButton *)miningBtn {
   if (!_miningBtn) {
       _miningBtn = [UIButton buttonWithType:UIButtonTypeCustom];
       _miningBtn.titleLabel.font = [NUIUtil fixedBoldFont:23];
       [_miningBtn setTitle:@"开始挖矿" forState:UIControlStateNormal];
       [_miningBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [_miningBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
       _miningBtn.layer.cornerRadius = [NUIUtil fixedWidth:135]/2;
       _miningBtn.layer.masksToBounds = YES;
       [_miningBtn addTarget:self action:@selector(miningBtnClick) forControlEvents:UIControlEventTouchUpInside];
   }
   return _miningBtn;
}

//- (UILabel *)poolNameLabel{
//    if (!_poolNameLabel) {
//        _poolNameLabel = [[UILabel alloc]init];
//        _poolNameLabel.font = [NUIUtil fixedFont:13];
//        _poolNameLabel.textColor = OF_COLOR_MINOR;
//        _poolNameLabel.text = @"矿池名字";
//        _poolNameLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _poolNameLabel;
//}

- (UILabel *)poolNodesCountLabel{
    if (!_poolNodesCountLabel) {
        _poolNodesCountLabel = [[UILabel alloc]init];
        _poolNodesCountLabel.font = [NUIUtil fixedFont:13];
        _poolNodesCountLabel.textColor = OF_COLOR_MINOR;
        _poolNodesCountLabel.text = @"0个节点正在与你写作";
        _poolNodesCountLabel.textAlignment = NSTextAlignmentCenter;
        _poolNodesCountLabel.hidden = YES;
    }
    return _poolNodesCountLabel;
}

- (UILabel *)declareLabel{
    if (!_declareLabel) {
        _declareLabel = [[UILabel alloc] init];
        _declareLabel.font = [NUIUtil fixedFont:10];
        _declareLabel.textColor = OF_COLOR_MINOR;
        _declareLabel.text = @"说明：手机挖矿内测版，算法模拟测试，收益有效。";
        _declareLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _declareLabel;
}

- (OFRipplesLayer *)rippleLayer{
    if (!_rippleLayer) {
        _rippleLayer = [[OFRipplesLayer alloc]init];

    }
    return _rippleLayer;
}

- (UIButton *)sharedBtn{
    if (!_sharedBtn) {
        _sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if ([NLocalUtil boolForKey:KisFirstClickShare]) {
            [_sharedBtn setImage:[UIImage imageNamed:@"wallet_shared_btn"] forState:UIControlStateNormal];
        }else{
            [_sharedBtn setImage:[UIImage imageNamed:@"share_red_icon"] forState:UIControlStateNormal];
        }
        
        [_sharedBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
        WEAK_SELF;
        [_sharedBtn n_clickBlock:^(id sender) {
            [weakSelf sharedBtnClick];
        }];
    }
    return _sharedBtn;
}

-(UIView *)canReceivedOFView{
    if (!_canReceivedOFView) {
        _canReceivedOFView = [UIView new];
        _canReceivedOFView.backgroundColor = [UIColor colorWithRGB:0xfdfbef alpha:0.2];
        ViewRadius(_canReceivedOFView, KWidthFixed(22.5)/2);
        WEAK_SELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf bonusClick:miningProfit];
        }];
        
        [_canReceivedOFView addGestureRecognizer:tap];

    }
    return _canReceivedOFView;
}

-(UIImageView *)OFImgView{
    if (!_OFImgView) {
        _OFImgView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"home_wk_icon")];
    }
    return _OFImgView;
}

-(UILabel *)miningRewardLabel{
    if (!_miningRewardLabel) {
        _miningRewardLabel = [UILabel new];
        _miningRewardLabel.font = FixFont(9);
//        _miningRewardLabel.textColor = [UIColor colorWithRGB:0xff6f00];
        _miningRewardLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _miningRewardLabel.textAlignment = UITextAlignmentCenter;
    }
    return _miningRewardLabel;
}

-(UIView *)canReceivedTangView{
    if (!_canReceivedTangView) {
        _canReceivedTangView = [UIView new];
        _canReceivedTangView.backgroundColor = [UIColor colorWithRGB:0xfdfbef alpha:0.2];
        ViewRadius(_canReceivedTangView, KWidthFixed(22.5)/2);
        WEAK_SELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf bonusClick:candyProfit];
        }];
        
        [_canReceivedTangView addGestureRecognizer:tap];
    }
    return _canReceivedTangView;
}
-(UIImageView *)candyImgView{
    if (!_candyImgView) {
        _candyImgView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"home_tg_icon")];
    }
    return _candyImgView;
}

-(UILabel *)candyRewardLabel{
    if (!_candyRewardLabel) {
        _candyRewardLabel = [UILabel new];
        _candyRewardLabel.font = FixFont(9);
        _candyRewardLabel.textColor = [UIColor colorWithWhite:1 alpha:0.8];
        _candyRewardLabel.textAlignment = UITextAlignmentCenter;
    }
    return _candyRewardLabel;
}

- (UIButton *)redPacketBtn
{
    if (!_redPacketBtn) {
        _redPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_redPacketBtn setImage:IMAGE_NAMED(@"redpacket_enter") forState:UIControlStateNormal];
        [_redPacketBtn addTarget:self action:@selector(sendRedPacket) forControlEvents:UIControlEventTouchUpInside];
    }
    return _redPacketBtn;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    kAppDelegate.isMining = NO;
    if (self.msTimer) {
        dispatch_resume(self.msTimer);
        dispatch_source_cancel(self.msTimer);
    }
    if (self.tTimer) {
        dispatch_resume(self.tTimer);
        dispatch_source_cancel(self.tTimer);
    }
}
@end
