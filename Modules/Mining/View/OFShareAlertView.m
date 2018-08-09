//
//  OFShareAlertView.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/6.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFShareAlertView.h"

@interface OFShareAlertView()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (nonatomic, copy) NSString *shareUrlStr;

@property (nonatomic, strong) OFSharedModel *shareModel;
@end

@implementation OFShareAlertView

- (void)awakeFromNib{
    [super awakeFromNib];
    ViewRadius(self.alertView, 10);
    WEAK_SELF;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf close];
        
    }];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        //空实现 目的为拦截手势，避免点击alertView就执行close
    }];
    [self.alertView addGestureRecognizer:tap2];
}

-(void)show:(UIView *)toView withTitle:(NSString *)titleStr WithDes:(NSString *)desString shareModel:(OFSharedModel *)shareModel{
    self.shareModel = shareModel;
    
    NSString *labelText1 = titleStr;
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:labelText1];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:KHeightFixed(8)];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [labelText1 length])];
    self.titleLabel.attributedText = attributedString1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = FixBoldFont(19);
    
    NSString *labelText = desString;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:KHeightFixed(8)];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.contentLabel.attributedText = attributedString;
    self.contentLabel.font = FixFont(12);
    
//    self.contentLabel.text = shareModel.descript;
    
    //动画入场 姿势要帅一点，不能像安卓那么Low
    _alertView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _alertView.alpha = 0.8;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _alertView.transform = CGAffineTransformIdentity;
        _alertView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    if (toView) {
        [toView addSubview:self];
    }else{
        [[JumpUtil currentVC].view addSubview:self];
    }
}

#pragma mark - 微信好友分享
- (IBAction)wxBtnAction:(id)sender {
    [OFMobileClick event:MobileClick_click_wechat_share];
    [self close];
    [[OFShareManager sharedInstance] sharedToWeChatWithModel:self.shareModel AndWay:OFSharedWayOfSession withShareType:OFSharedTangGuo controller:nil];
}

#pragma mark - 朋友圈分享
- (IBAction)quanziBtnAction:(id)sender {
    [OFMobileClick event:MobileClick_click_wechat_circle_share];
    [self close];
    [[OFShareManager sharedInstance] sharedToWeChatWithModel:self.shareModel AndWay:OFSharedWayOfTimeline withShareType:OFSharedTangGuo controller:nil];
}

#pragma mark -  关闭
-(void)close{
    [self removeFromSuperview];
}

- (void)dealloc{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
