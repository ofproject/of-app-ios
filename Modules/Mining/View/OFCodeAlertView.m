//
//  OFCodeAlertView.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/6.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFCodeAlertView.h"

@interface OFCodeAlertView()
@property (weak, nonatomic) IBOutlet UILabel *phoneNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *codeTxt;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIView *alertView;

@property (nonatomic, copy) void (^codeBlock)(NSString *codeStr);

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeCount;
@end

static CGFloat const maxTime = 60;

@implementation OFCodeAlertView

-(void)awakeFromNib{
    [super awakeFromNib];
    ViewRadius(self.alertView, 5);
    ViewBorderRadius(self.getCodeBtn, 3, 1, OF_COLOR_MAIN_THEME);
    WEAK_SELF;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [weakSelf close];
        
    }];
    [self addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        //空实现 目的为拦截手势，避免点击alertView就执行close
    }];
    [self.alertView addGestureRecognizer:tap2];
    
    [_okBtn setBackgroundImage:[UIImage makeGradientImageWithRect:CGRectMake(0, 0, 100, 26) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
    ViewRadius(_okBtn, 5);
    
    self.timeCount = maxTime;
    NSString *phoneStr = [KcurUser.phone stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.phoneNumLabel.text = phoneStr;
    
}

-(void)show:(UIView *)toView btnblock:(void(^)(NSString *codeStr))block{
    self.codeBlock = block;
    
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

#pragma mark - 支付逻辑
- (void)codeBtnClick{
    [self starTimer];
    [self getAliCode];
}

- (void)starTimer{
    if (self.timeCount == maxTime) {
        [self.timer invalidate];
        WEAK_SELF;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            [weakSelf verifyCodeTimerAction];
        } repeats:YES];
        NSString *title = [NSString stringWithFormat:@"%zd秒后重发",self.timeCount];
        [self.getCodeBtn setTitle:title forState:UIControlStateNormal];
        ViewBorderRadius(self.getCodeBtn, 3, 1, [UIColor colorWithRGB:0x999999]);
        [self.getCodeBtn setTitleColor:OF_COLOR_MINOR forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = NO;
    }
}

- (void)getAliCode{
    [self.codeTxt becomeFirstResponder];
    WEAK_SELF;
    [OFNetWorkHandle getAliSMSCodeWithMobil:KcurUser.phone success:^(NSDictionary *dict) {
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        NSString *message = dict[@"message"];
        if (status == 200) {
            [MBProgressHUD showSuccess:@"获取成功"];
        }else{
            [weakSelf getVerifyCodeFailure];
            [MBProgressHUD showError:message];
            BLYLogError(@"获取验证码失败");
        }
    } failure:^(NSError *error) {
        [weakSelf getVerifyCodeFailure];
        BLYLogError(@"获取验证码失败 - %zd",error.code);
    }];
    
}

/**
 获取验证码失败
 */
- (void)getVerifyCodeFailure{
    [self.timer invalidate];
    self.getCodeBtn.userInteractionEnabled = YES;
    //    NSString *title = NSLocalizedString(@"reget", nil);
    [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    self.timeCount = maxTime;
    ViewBorderRadius(self.getCodeBtn, 3, 1, OF_COLOR_MAIN_THEME);
    [self.getCodeBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
    self.timer = nil;
}

- (void)verifyCodeTimerAction {
    
    self.timeCount--;
    if (self.timeCount == 0) {
        [self getVerifyCodeFailure];
    }else{
        NSString *title = [NSString stringWithFormat:@"%zd秒后重发",self.timeCount];
        
        [self.getCodeBtn setTitle:title forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 获取验证码
- (IBAction)getCodeAction:(id)sender {
    [self codeBtnClick];
}

- (IBAction)okBtnAction:(id)sender {
    if (!self.codeTxt.hasText) {
        [MBProgressHUD showError:@"请输入验证码"];
    }else{
        if (self.codeBlock) {
            self.codeBlock(self.codeTxt.text);
        }
    }
}

#pragma mark -  关闭
-(void)close{
    [self removeFromSuperview];
}

- (void)dealloc{
    
}


@end
