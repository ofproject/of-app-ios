//
//  OFShareAppView.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFShareAppView.h"

@interface OFShareAppView()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *shareImgView;
@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UIView *shareSnapView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic, strong) OFSharedModel *shareModel;
@property (weak, nonatomic) IBOutlet UIButton *saveToPhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//标题label
@property (weak, nonatomic) IBOutlet UILabel *poolNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareToFriendBtn;
@end

@implementation OFShareAppView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    WEAK_SELF;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf close];
        
    }];
    [self.bgView addGestureRecognizer:tap];
    
    ViewRadius(self.shareView, 5.0);
    self.poolNameLabel.font = FixBoldFont(15);
}

-(void)showShareAppViewToView:(UIView *)view shareType:(NSInteger)shareType poolName:(NSString *)poolName shareModel:(OFSharedModel *)shareModel{
    self.shareModel = shareModel;
    self.frame = view.bounds;
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.frame = self.bounds;
    [self.bgView addSubview:effe];
    
    if (view) {
        [view addSubview:self];
    }else{
        [kAppWindow addSubview:self];
    }
    
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    }];
    
    if (shareType == 0) {
        self.titleLabel.font = FixFont(16);
        self.titleLabel.text = shareModel.title;
        self.poolNameLabel.text = @"";
    }else{
        self.titleLabel.font = FixFont(13);
        self.titleLabel.text = NSStringFormat(@"%@邀你加入",KcurUser.userName);
        self.poolNameLabel.text = NSStringFormat(@"—— %@ ——",poolName);
    }
    
    [self.shareView layoutIfNeeded];
    //添加二维码
    UIImage *codeImg = [NUIUtil createImageWithString:shareModel.urlString ImgSize:CGSizeMake(KWidthFixed(92), KWidthFixed(92))];
    UIImageView *codeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidthFixed(92), KWidthFixed(92))];
    codeImgView.centerX = self.shareImgView.width/2;
    codeImgView.centerY = self.shareImgView.height * 0.65;
    [codeImgView setImage:codeImg];
    
    //logo
    UIView *lView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidthFixed(17), KWidthFixed(17))];
    lView.center = CGPointMake(codeImgView.width/2, codeImgView.height/2);
    lView.backgroundColor = KWhiteColor;
    [codeImgView addSubview:lView];
    ViewRadius(lView, 2);
    
    UIImageView *logoView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KWidthFixed(15), KWidthFixed(15))];
    logoView.center = CGPointMake(lView.width/2, lView.height/2);
    [logoView setImage:IMAGE_NAMED(@"AppIcon")];
    [lView addSubview:logoView];
    ViewRadius(logoView, 2);
    
    [self.shareImgView addSubview:codeImgView];
    
    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, codeImgView.bottom+4, self.shareImgView.width, 20)];
    codeLabel.font = FixFont(10);
    if (shareType == 0) {
        if (shareModel.communityName.length > 0) {
            codeLabel.text = NSStringFormat(@"%@邀请你加入",shareModel.communityName);
        }else{
            codeLabel.text = NSStringFormat(@"%@邀你一起手机挖矿",KcurUser.userName);
        }
    }else{
        codeLabel.text = @"扫码立即加入";
    }
    codeLabel.textColor = KWhiteColor;
    codeLabel.textAlignment = UITextAlignmentCenter;
    [self.shareImgView addSubview:codeLabel];
    
    UILabel *tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.shareImgView.height - KWidthFixed(40), self.shareImgView.width, KWidthFixed(40))];
    tipsLabel.font = FixFont(14);
    tipsLabel.text = @"全世界在与你协作";
    tipsLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    tipsLabel.textAlignment = UITextAlignmentCenter;
    [self.shareImgView addSubview:tipsLabel];
    
    //奖励信息
//    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, codeImgView.top - KWidthFixed(50), self.shareImgView.width, KWidthFixed(30))];
//    moneyLabel.font = FixFont(14);
//    moneyLabel.text = NSStringFormat(@"我是%@，邀你一起手机挖矿",KcurUser.userName);
//    moneyLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
//    moneyLabel.textAlignment = UITextAlignmentCenter;
//    [self.shareImgView addSubview:moneyLabel];
//
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.bottomView.width/2, self.saveToPhoneBtn.top, 0.5, self.saveToPhoneBtn.height * 0.4)];
    line.centerX = self.bottomView.width/2;
    line.centerY = self.bottomView.height/2;
    line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.8];
    [self.bottomView addSubview:line];

    self.shareView.transform = CGAffineTransformScale(self.shareView.transform, self.width/self.shareView.width, self.width/self.shareView.width);
//    self.shareView.transform = CGAffineTransformScale(self.shareView.transform, 0.3, 0.3);
    self.shareView.alpha = 0.5;
    self.bottomView.alpha = 0;

    [UIView animateWithDuration:0.6 animations:^{
        self.shareView.transform = CGAffineTransformIdentity;
        self.shareView.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.bottomView.alpha = 1;
        }];
    }];
    
    
//    self.shareView.transform = CGAffineTransformMakeTranslation(0, - kScreenHeight);
//    self.bottomView.alpha = 0;
//
//    [UIView animateWithDuration:1.0 animations:^{
//        self.shareView.transform = CGAffineTransformIdentity;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.2 animations:^{
//            self.bottomView.alpha = 1;
//        }];
//    }];
    
}

#pragma mark - 保存到本地
- (IBAction)saveImgToLocal:(id)sender {
    //生成截图，保存到本地
    UIImage *snapImg = [self.shareSnapView snapshotImage];
    [NUIUtil loadImageFinished:snapImg completion:^(BOOL finished) {
        if (finished) {
            [MBProgressHUD showSuccess:@"已保存到相册"];
            [self close];
        }else{
            [MBProgressHUD showError:@"请先授权相册访问"];
        }
        
    }];
}

#pragma mark - 分享好友
- (IBAction)shareToFriend:(id)sender {
    
    UIImage *snapImg = [self.shareSnapView snapshotImage];
    
    OFSharedModel *model = [[OFSharedModel alloc]init];
    model.sharedType = OFSharedTypePicture;
    model.addressImage = snapImg;
    model.cannotShareSMS = YES;
    [[OFShareManager sharedInstance] sharedToWeChatWithModel:model completed:^(OFSharedWay shareWay, bool isSuccess) {
        if (isSuccess) {
            [self close];
        }else{
            [MBProgressHUD showError:@"分享取消"];
        }
    }];
}
#pragma mark -  关闭
-(void)close{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
//        self.shareView.transform = CGAffineTransformScale(self.shareView.transform, self.width/self.shareView.width, self.height/self.shareView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dealloc{
    
}

@end
