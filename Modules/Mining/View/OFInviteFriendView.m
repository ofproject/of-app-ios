//
//  OFInviteFriendView.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/25.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFInviteFriendView.h"

@interface OFInviteFriendView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel1;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel2;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (nonatomic, copy) dispatch_block_t shareBlock;
//@property (nonatomic, strong) OFSharedModel *shareModel;

@end

@implementation OFInviteFriendView

-(void)awakeFromNib{
    [super awakeFromNib];
    WEAK_SELF;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf close];
        
    }];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        //空实现 目的为拦截手势，避免点击alertView就执行close
    }];
    [self.alertView addGestureRecognizer:tap2];
    self.contentLabel1.font = FixFont(17);
    self.contentLabel2.font = FixFont(17);
}

-(void)showFirstReward:(UIView *)toView withRewardValue:(double)rewardValue shareBlock:(dispatch_block_t)shareBlock{
    self.shareBlock = shareBlock;
    
    NSString *labelText1 = @"人生首矿";
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:labelText1];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:KHeightFixed(8)];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [labelText1 length])];
    self.titleLabel.attributedText = attributedString1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = FixBoldFont(19);
    
    self.contentLabel1.text = @"恭喜你挖到第一个区块";
    
    NSString *labelText = NSStringFormat(@"获得%.3f枚OF奖励",rewardValue);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:KHeightFixed(8)];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    NSRange range = [labelText rangeOfString:NSStringFormat(@"%.3f",rewardValue)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0xFF5237] range:range];
    
    self.contentLabel2.attributedText = attributedString;
    
    
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

-(void)showTodayFirstReward:(UIView *)toView withRewardValue:(double)rewardValue shareBlock:(dispatch_block_t)shareBlock{
    self.shareBlock = shareBlock;
    
    NSString *labelText1 = @"今日首矿";
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:labelText1];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:KHeightFixed(8)];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [labelText1 length])];
    self.titleLabel.attributedText = attributedString1;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = FixBoldFont(19);
    
    self.contentLabel1.text = @"恭喜你挖到今天第一个区块";
    
    NSString *labelText = NSStringFormat(@"获得%.3f枚OF奖励",rewardValue);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:KHeightFixed(8)];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    
    NSRange range = [labelText rangeOfString:NSStringFormat(@"%.3f",rewardValue)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRGB:0xFF5237] range:range];
    
    self.contentLabel2.attributedText = attributedString;
    
    
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


#pragma mark - 邀请按钮
- (IBAction)inviteBtnAction:(id)sender {
    [self close];
    if (self.shareBlock) {
        self.shareBlock();
    }
}

- (IBAction)closeBtnAction:(id)sender {
    [self close];
}

#pragma mark -  关闭
-(void)close{
    [self removeFromSuperview];
}

- (void)dealloc{
    
}
@end
