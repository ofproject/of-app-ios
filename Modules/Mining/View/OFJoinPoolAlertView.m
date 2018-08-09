//
//  OFJoinPoolAlertView.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/5.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFJoinPoolAlertView.h"

@interface OFJoinPoolAlertView()
@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (nonatomic, copy) dispatch_block_t btnBlock;
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

//按钮
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation OFJoinPoolAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    ViewRadius(self.alertView, 5);
    WEAK_SELF;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf close];
        
    }];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        //空实现 目的为拦截手势，避免点击alertView就执行close
    }];
    [self.alertView addGestureRecognizer:tap2];
    
    [_btn setBackgroundImage:[UIImage makeGradientImageWithRect:CGRectMake(0, 0, 100, 26) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
    ViewRadius(_btn, 5);
    [_btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (weakSelf.btnBlock) {
            weakSelf.btnBlock();
        }
        [weakSelf close];
    }];
    
}

#pragma mark - 初始化UI
- (void) setupUI{
    //添加 label 和 按钮
}

#pragma mark -  show
-(void)show:(UIView *)toView poolCount:(NSInteger)poolCount btnblock:(dispatch_block_t)block{
    self.btnBlock = block;
    
    NSString *str = [NSString stringWithFormat:@"全球共有%ld个超级矿池",poolCount];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:str];
    
    [attr addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:[str rangeOfString:NSStringFormat(@"%ld个",poolCount)]];
    
    [self.titleLabel setAttributedText:attr];
    
    [self showAnimationToView:toView];
}

- (void)show:(UIView *)toView title:(NSString *)title content:(NSString *)content btnblock:(dispatch_block_t)block
{
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attrTitle addAttribute:NSFontAttributeName value:FixFont(16) range:NSMakeRange(0, title.length)];
    self.titleLabel.attributedText = attrTitle;
    
    NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:KHeightFixed(4)];
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attrContent addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, content.length)];
    [attrContent addAttribute:NSFontAttributeName value:FixFont(13) range:NSMakeRange(0, content.length)];
    self.contentLabel.attributedText = attrContent;
    
    [self.btn setTitle:@"知道了" forState:UIControlStateNormal];
    
    [self showAnimationToView:toView];
}

- (void)showAnimationToView:(UIView *)toView
{
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

#pragma mark -  关闭
-(void)close{
    [self removeFromSuperview];
}

- (void)dealloc{
    
}


@end
