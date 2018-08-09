//
//  OFPoolFundAlertView.m
//  OFBank
//
//  Created by Xu Yang on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPoolFundAlertView.h"

@interface OFPoolFundAlertView()
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (nonatomic, copy) dispatch_block_t block;
@end

@implementation OFPoolFundAlertView



-(void)awakeFromNib{
    [super awakeFromNib];
//    WEAK_SELF;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//        [weakSelf close];
//
//    }];
//    [self addGestureRecognizer:tap];
    
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
//        //空实现 目的为拦截手势，避免点击alertView就执行close
//    }];
//    [self.alertView addGestureRecognizer:tap2];
    self.titleLabel.font = FixFont(17);
    self.contentLabel.font = FixFont(31);
    self.tipsLabel.font = FixFont(11);
}

-(void)showPoolFundAlertView:(UIView *)toView withRewardValue:(double)rewardValue WithBlock:(dispatch_block_t)block{

    self.block = block;
    
    self.contentLabel.text = NSStringFormat(@"%.3f OF",rewardValue);
    
    
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

#pragma mark - 关闭按钮
- (IBAction)closeBtnAction:(id)sender {
    if (self.block) {
        self.block();
    }
    [self close];
}

#pragma mark -  关闭
-(void)close{
    [self removeFromSuperview];
}

@end
