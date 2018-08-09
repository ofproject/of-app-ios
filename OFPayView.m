//
//  OFPayView.m
//  OFBank
//
//  Created by michael on 2018/3/27.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPayView.h"

@interface OFPayView ()

/**
 容器视图
 */
#pragma mark - 支付视图
@property (nonatomic, strong) UIView *passwordView;

@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, strong) UIButton *payBtn;

@property (nonatomic, strong) UIButton *cancleBtn;

@property (nonatomic, assign) BOOL hiddenCode;


@end

static CGFloat const maxTime = 60;

@implementation OFPayView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        self.timeCount = maxTime;
        [self initUI];
        [self layout];
    }
    return self;
}

- (void)initUI{
    
    [self addSubview:self.passwordView];
    [self.passwordView addSubview:self.passwordTextField];
    [self.passwordView addSubview:self.codeTextField];
    [self.passwordView addSubview:self.codeBtn];
    [self.passwordView addSubview:self.payBtn];
    [self.passwordView addSubview:self.cancleBtn];
}

- (void)layout{
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(150 + 55);
        make.top.mas_equalTo(kScreenHeight);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(30);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(35);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(20);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.codeBtn.mas_right);
        make.centerY.mas_equalTo(self.codeBtn.mas_centerY);
        make.left.mas_equalTo(15);
    }];
    
    [self.payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(40);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(40);
        make.height.mas_equalTo(35);
        make.width.mas_equalTo(100);
    }];
    
}

- (void)setHiddenCode:(BOOL)hiddenCode{
    _hiddenCode = hiddenCode;
    
    if (hiddenCode) {
        
        self.codeBtn.hidden = YES;
        self.codeTextField.hidden = YES;
        [self.payBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(40);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(100);
        }];
        
        [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(40);
            make.height.mas_equalTo(35);
            make.width.mas_equalTo(100);
        }];
        
        [self.passwordView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(150);
        }];
        
    }
    
}


#pragma mark - 点击事件
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
        
        NSString *title = [NSString stringWithFormat:@"%zdS",self.timeCount];
        [self.codeBtn setTitle:title forState:UIControlStateNormal];
        [self.codeBtn setBackgroundColor:[UIColor colorWithRGB:0xc6c6c6]];
        self.codeBtn.userInteractionEnabled = NO;
    }
}

- (void)getAliCode{
    [self.codeTextField becomeFirstResponder];
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
    self.codeBtn.userInteractionEnabled = YES;
    //    NSString *title = NSLocalizedString(@"reget", nil);
    [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    self.timeCount = maxTime;
    [self.codeBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
    self.timer = nil;
}

- (void)verifyCodeTimerAction {
    self.timeCount--;
    if (self.timeCount == 0) {
        [self getVerifyCodeFailure];
    }else{
        NSString *title = [NSString stringWithFormat:@"%zdS",self.timeCount];
        
        [self.codeBtn setTitle:title forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = NO;
    }
}

- (void)paybtnClick{
    
    if (!self.passwordTextField.hasText) {
        [MBProgressHUD showError:@"资金密码不能为空"];
        return;
    }
    
    
    if (self.hiddenCode) {
        if (self.payBlock) {
            self.payBlock(self.passwordTextField.text, nil);
        }
    }else{
        if (!self.codeTextField.hasText) {
            [MBProgressHUD showError:@"验证码不能为空"];
            return;
        }
        
        if (self.payBlock) {
            self.payBlock(self.passwordTextField.text, self.codeTextField.text);
        }
    }
    
    
    
    
    
}

- (void)cancleBtnClick{
    [self endEditing:YES];
    [self.passwordView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenHeight);
    }];
    if (self.timer) {
        [self.timer invalidate];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.timer = nil;
        self.hidden = YES;
        self.passwordTextField.text = @"";
        [self removeFromSuperview];
    }];
}

+ (void)showPayViewWithoutCode:(PayBlock)payBlock{
    UIViewController *vc = [JumpUtil currentVC];
    OFPayView *payView = [[OFPayView alloc]initWithFrame:vc.view.frame];
    payView.payBlock = payBlock;
    payView.hiddenCode = YES;
    [vc.view addSubview:payView];
    [payView layoutIfNeeded];
    [payView showPayView];
    
}

+ (void)showPayViewWithPayBlock:(PayBlock)payBlock{
    UIViewController *vc = [JumpUtil currentVC];
    OFPayView *payView = [[OFPayView alloc]initWithFrame:vc.view.frame];
    payView.payBlock = payBlock;
    [vc.view addSubview:payView];
    [payView layoutIfNeeded];
    [payView showPayView];
}


- (void)showPayView{
    // 先弹窗
    [self.passwordView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo((kScreenHeight - self.passwordView.height)/2 - KHeightFixed(40));
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.passwordTextField becomeFirstResponder];
    }];
}

+ (void)hiddenPayView{
    
    UIViewController *vc = [JumpUtil currentVC];
    
    [vc.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[OFPayView class]]) {
            OFPayView *payView = obj;
            [payView cancleBtnClick];
        }
    }];
}


//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [self endEditing:YES];
//    [self cancleBtnClick];
//}

- (void)dealloc{
    NSLog(@"支付视图被销毁");
}

#pragma mark - 懒加载
- (UIView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[UIView alloc]init];
        _passwordView.backgroundColor = [UIColor whiteColor];
        _passwordView.layer.borderColor = [UIColor grayColor].CGColor;
        _passwordView.layer.borderWidth = 1.0;
    }
    return _passwordView;
}

- (UITextField *)passwordTextField{
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc]init];
        //        NSString *title = NSLocalizedString(@"moneypassword", nil);
        _passwordTextField.placeholder = @"请输入资金密码";
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.textAlignment = NSTextAlignmentCenter;
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        //       NSString *title = NSLocalizedString(@"get", nil);
        [_codeBtn setTitle:@"获取" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
        _codeBtn.titleLabel.font = Font(13);
        _codeBtn.layer.cornerRadius = 5;
        _codeBtn.layer.masksToBounds = YES;
        
        [_codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        _codeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _codeBtn.titleLabel.minimumScaleFactor = 0.2;
    }
    return _codeBtn;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [UITextField new];
        _codeTextField.borderStyle = UITextBorderStyleNone;
        _codeTextField.placeholder = @"请输入验证码";
        //       _codeTextField.returnKeyType = UIReturnKeyDone;
        _codeTextField.secureTextEntry = NO;
        //       _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.textAlignment = NSTextAlignmentCenter;
        //        _codeTextField.leftView = self.tip3Label;
    }
    return _codeTextField;
}

- (UIButton *)payBtn{
    if (_payBtn == nil) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        NSString *title = NSLocalizedString(@"sure", nil);
        [_payBtn setTitle:@"确定" forState:UIControlStateNormal];
        _payBtn.titleLabel.font = [NUIUtil fixedFont:17];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _payBtn.layer.cornerRadius = 5.0;
        [_payBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
        _payBtn.layer.masksToBounds = YES;
        
        [_payBtn addTarget:self action:@selector(paybtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payBtn;
}

- (UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        NSString *title = NSLocalizedString(@"cancle", nil);
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _cancleBtn.layer.cornerRadius = 5.0;
        [_cancleBtn setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
        _cancleBtn.layer.masksToBounds = YES;
        
        [_cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleBtn;
}


@end
