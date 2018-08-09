//
//  OFCandySucAlertView.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/26.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFCandySucAlertView.h"

@interface OFCandySucAlertView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIButton *inviteBtn;
@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertViewCentery;

@property (weak, nonatomic) IBOutlet UIImageView *lineImgView;
@property (nonatomic, copy) dispatch_block_t shareBlock;

@end

@implementation OFCandySucAlertView

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
}

-(void)show:(UIView *)toView withTitle:(NSString *)titleStr WithDes:(NSString *)desString shareBlock:(dispatch_block_t)shareBlock{
    self.shareBlock = shareBlock;
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
    self.contentLabel.font = FixFont(20);
    
    //    self.contentLabel.text = shareModel.descript;
    
    //动画入场 姿势要帅一点，不能像安卓那么Low
    _alertView.transform = CGAffineTransformMakeTranslation(0,-100);
    _lineImgView.transform = CGAffineTransformMakeTranslation(0,-100);
    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _alertView.transform = CGAffineTransformIdentity;
        _lineImgView.transform = CGAffineTransformIdentity;
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
    [UIView animateWithDuration:0.2 animations:^{
        _alertView.transform = CGAffineTransformTranslate(_alertView.transform, 0, +10);
        _lineImgView.transform = CGAffineTransformTranslate(_lineImgView.transform, 0, +10);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            _alertView.transform = CGAffineTransformMakeTranslation(0,-self.height/2-_alertView.height/2);
            _lineImgView.transform =  CGAffineTransformMakeTranslation(0,-self.height/2-_alertView.height/2);
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
    
}

- (void)dealloc{
    
}
@end
