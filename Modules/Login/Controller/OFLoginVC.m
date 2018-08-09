//
//  OFLoginVC.m
//  OFCion
//
//  Created by liyangwei on 2018/1/9.
//  Copyright © 2018年 liyangwei. All rights reserved.
//

#import "OFLoginVC.h"
#import "OFRegisterVC.h"
#import "OFForgetPasswordVC.h"
#import "OFTabBarController.h"
#import "OFWebViewController.h"
#import "OFWalletModel.h"
#import "OFPoolModel.h"
#import "OFLoginLogic.h"




@interface OFLoginVC ()


@property (nonatomic, strong) UIImageView *iconView;

// 用户名
@property (nonatomic, strong) UITextField *userNameTextField;
// 验证码
@property (nonatomic, strong) UITextField *codeTextField;
// 密码
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UIView *line1Layer;
@property (nonatomic, strong) UIView *line2Layer;
@property (nonatomic, strong) UIView *line3Layer;

@property (nonatomic, strong) UILabel *tip1Label;
@property (nonatomic, strong) UILabel *tip2Label;
@property (nonatomic, strong) UILabel *tip3Label;

@property (nonatomic, strong) UIView *inputView;

// 登录
@property (nonatomic, strong) UIButton *sureBtn;
//注册
@property (nonatomic, strong) UIButton *registerBtn;
// 手机验证码登录
@property (nonatomic, strong) UIButton *phoneCodeLoginBtn;
// 忘记密码
@property (nonatomic, strong) UIButton *forgetPswBtn;
// 条款按钮
@property (nonatomic, strong) UIButton *agreementBtn;
// 获取验证码
@property (nonatomic, strong) UIButton *getCodeBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;

// YES 为手机号验证码模式   NO 为账号密码模式
@property (nonatomic, assign) BOOL isPhoneLogin;

@property (nonatomic, assign) BOOL isAnimation;

//逻辑处理层
@property (nonatomic, strong) OFLoginLogic *logic;

@end

@implementation OFLoginVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.logic = [[OFLoginLogic alloc] initWithDelegate:nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.timeCount = 60;
    [self initUI];
    [self layout];
    [self addNoti];
    self.n_isHiddenNavBar = YES;
    
    self.phoneCodeLoginBtn.hidden = YES;
    
    
    
    
    
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.navigationController setNeedsStatusBarAppearanceUpdate];
    
    if (self.timer) {
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)initUI{
    [self.view addSubview:self.iconView];
    
    [self.view addSubview:self.inputView];
    // 账号
//    [self.inputView addSubview:self.tip1Label];
    [self.inputView addSubview:self.userNameTextField];
    [self.inputView addSubview:self.line1Layer];
    // 验证码
    [self.inputView addSubview:self.codeTextField];
    [self.inputView addSubview:self.line2Layer];
    // 密码
    [self.inputView addSubview:self.passwordTextField];
    [self.inputView addSubview:self.line3Layer];
    
    [self.inputView addSubview:self.getCodeBtn];
    
    [self.view addSubview:self.forgetPswBtn];
    [self.view addSubview:self.sureBtn];
    [self.view addSubview:self.agreementBtn];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.phoneCodeLoginBtn];
}

- (void)layout{
    
    CGFloat padding = [NUIUtil fixedWidth:60];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(60);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(30);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth - padding * 2, 150));
    }];
    
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(TextField_Height);
    }];
    
    [self.line1Layer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.userNameTextField.mas_bottom);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.line1Layer.mas_bottom);
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(TextField_Height);
    }];
    
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(37.5);
        make.centerY.mas_equalTo(self.codeTextField.mas_centerY);
    }];
    
    [self.line2Layer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.codeTextField.mas_bottom);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(TextField_Height);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.line3Layer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(0);
    }];
    
    [self.forgetPswBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.inputView.mas_bottom).offset(12);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(37.5);
        make.top.mas_equalTo(self.inputView.mas_bottom).offset(40);
    }];
    
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.sureBtn.mas_bottom).offset(13.5);
    }];
    
    [self.phoneCodeLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-27);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.bottom.mas_equalTo(self.phoneCodeLoginBtn.mas_top).offset(-17);
        make.top.mas_equalTo(self.agreementBtn.mas_bottom).offset(20);
    }];
    
}

- (void)addNoti{
    
    //给键盘注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(inputKeyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textLenghtChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
//    NSLog(@"%@",NSStringFromCGRect(keyBoardFrame));
//    NSLog(@"%@",NSStringFromCGRect(self.sureBtn.frame));
    
    
    CGFloat top = self.view.height - self.sureBtn.bottom - keyBoardFrame.size.height - 30;
    if (top > 0) return;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.top = top;
    }];
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat top = self.view.height - self.sureBtn.bottom - keyBoardFrame.size.height - 30;
    if (top > 0) return;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.top = 0;
    }];
}

- (void)textLenghtChange:(NSNotification *)notification{
    if (notification.object == self.userNameTextField) {
        if (self.userNameTextField.hasText) {
            self.tip1Label.text = @"+86";
            self.tip1Label.textAlignment = NSTextAlignmentCenter;
        }else{
//            NSString *title = NSLocalizedString(@"moblie", nil);
            self.tip1Label.text = @"手机号";
            self.tip1Label.textAlignment = NSTextAlignmentLeft;
        }
    }
}

#pragma mark - 登录按钮点击
- (void)sureBtnClick{
    [self.logic loginWithPhone:self.userNameTextField.text password:self.passwordTextField.text code:self.codeTextField.text finished:^(BOOL success, id obj, NSError *error, NSString *messageStr, BOOL showChangePwd) {
        if(!success) {
            [MBProgressHUD showError:messageStr];
        }
    }];
}

#pragma mark - 注册按钮事件
- (void)registerBtnClick{
    
    OFRegisterVC *vc = [[OFRegisterVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

// 切换登录模式
- (void)phoneCodeLoginBtnClick {
    if (self.isAnimation) {
        return;
    }
    
    self.isAnimation = YES;
    
    self.isPhoneLogin = !self.isPhoneLogin;
    
    if (self.isPhoneLogin) {
        // 手机验证码登录
        [self.phoneCodeLoginBtn setTitle:@"账号密码登录" forState:UIControlStateNormal];
        
        self.tip1Label.text = @"手机号";
        self.tip2Label.text = @"验证码";
        
        self.userNameTextField.placeholder = @"";
        
        [self.getCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(80);
        }];
        
        self.userNameTextField.keyboardType = UIKeyboardTypePhonePad;
        self.passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        
    }else{
        // 账号密码登录
        [self.phoneCodeLoginBtn setTitle:@"手机验证码登录" forState:UIControlStateNormal];
        
        self.tip1Label.text = @"账号";
        self.tip2Label.text = @"密码";
        self.userNameTextField.keyboardType = UIKeyboardTypeDefault;
        self.passwordTextField.keyboardType = UIKeyboardTypeDefault;
        
        self.userNameTextField.placeholder = @"手机号/邮箱";
        [self.getCodeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(0);
        }];
//        [self.line2Layer mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.getCodeBtn.mas_right);
//        }];
        
    }
    self.passwordTextField.secureTextEntry = !self.isPhoneLogin;
    self.forgetPswBtn.hidden = self.isPhoneLogin;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.isAnimation = NO;
    }];
}

- (void) forgetPswBtnClick {
    OFForgetPasswordVC *vc = [[OFForgetPasswordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) agreementBtnClick {
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = @"用户协议和隐私条款";
    
    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:urlString encoding:NSUTF8StringEncoding error:NULL];
    
    webVC.htmlStr = htmlString;
    
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void) getCodeBtnClick {
    if (![ToolObject isMobileNumber:self.userNameTextField.text]) {
//        NSString *title = NSLocalizedString(@"mobileerror", nil);
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [self starTimer];
    WEAK_SELF;
    [OFNetWorkHandle getAliSMSCodeWithMobil:self.userNameTextField.text success:^(NSDictionary *dict) {

        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        NSString *message = dict[@"message"];
        if (status == 200) {
            
//            NSString *title = NSLocalizedString(@"getsuccess", nil);
            [MBProgressHUD showSuccess:@"获取成功"];
        }else{
            [weakSelf getVerifyCodeFailure];
//            NSString *title = NSLocalizedString(@"geterror", nil);
            [MBProgressHUD showError:message];
            BLYLogWarn(@"获取验证码失败");
        }
        
        
    } failure:^(NSError *error) {
        [weakSelf getVerifyCodeFailure];
        [MBProgressHUD showError:@"获取失败,请稍后再试"];
        BLYLogError(@"获取验证码网络错误 - %zd",error.code);
    }];
}

- (void)starTimer{
    if (self.timeCount == 60) {
        [self.timer invalidate];
        WEAK_SELF;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            [weakSelf verifyCodeTimerAction];
        } repeats:YES];
        NSString *title = [NSString stringWithFormat:@"%zdS",self.timeCount];
        [self.getCodeBtn setTitle:title forState:UIControlStateNormal];
        [self.getCodeBtn setBackgroundColor:[UIColor colorWithRGB:0xc6c6c6]];
        self.getCodeBtn.userInteractionEnabled = NO;
    }
}

/**
 获取验证码失败
 */
- (void)getVerifyCodeFailure{
    [self.timer invalidate];
    self.getCodeBtn.userInteractionEnabled = YES;
//    NSString *title = NSLocalizedString(@"reget", nil);
    [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    self.timeCount = 60;
    [self.getCodeBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
    self.timer = nil;
}

- (void)verifyCodeTimerAction {
    
    self.timeCount--;
    if (self.timeCount == 0) {
        
        [self getVerifyCodeFailure];
    }else{
        NSString *title = [NSString stringWithFormat:@"%zdS",self.timeCount];
        
        [self.getCodeBtn setTitle:title forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = NO;
    }
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - 懒加载
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"login_logo"];
    }
    return _iconView;
}

- (UIView *)inputView{
    if (_inputView == nil) {
        _inputView = [[UIView alloc]init];
        _inputView.backgroundColor = [UIColor whiteColor];
    }
    return _inputView;
}

- (UILabel *)tip1Label {
    if (_tip1Label == nil) {
//        NSString *title = NSLocalizedString(@"moblie", nil);
        _tip1Label = [[UILabel alloc]init];
        _tip1Label.text = @"手机号";
        _tip1Label.font = [NUIUtil fixedFont:17];
        [_tip1Label sizeToFit];
        _tip1Label.width = TIPS_LABEL_WIDTH;
        _tip1Label.textAlignment = NSTextAlignmentLeft;
    }
    return _tip1Label;
}

- (UIView *)line1Layer{
    if (_line1Layer == nil) {
        _line1Layer = [[UIView alloc]init];
        _line1Layer.backgroundColor = Line_Color;
    }
    return _line1Layer;
}

- (UILabel *)tip2Label{
    if (_tip2Label == nil) {
//        NSString *title = NSLocalizedString(@"password", nil);
        _tip2Label = [[UILabel alloc]init];
        _tip2Label.text = @"验证码";
        _tip2Label.font = [UIFont systemFontOfSize:17];
        
        [_tip2Label sizeToFit];
        _tip2Label.width = TIPS_LABEL_WIDTH;
        
    }
    return _tip2Label;
}

- (UIView *)line2Layer{
    if (_line2Layer == nil) {
        _line2Layer = [[UIView alloc]init];
        _line2Layer.backgroundColor = Line_Color;
    }
    return _line2Layer;
}

- (UILabel *)tip3Label{
    if (_tip3Label == nil) {
        //        NSString *title = NSLocalizedString(@"password", nil);
        _tip3Label = [[UILabel alloc]init];
        _tip3Label.text = @"密码";
        _tip3Label.font = [UIFont systemFontOfSize:17];
        
        [_tip3Label sizeToFit];
        _tip3Label.width = TIPS_LABEL_WIDTH;
        
    }
    return _tip3Label;
}

- (UIView *)line3Layer{
    if (_line3Layer == nil) {
        _line3Layer = [[UIView alloc]init];
        _line3Layer.backgroundColor = Line_Color;
    }
    return _line3Layer;
}

- (UITextField *)userNameTextField{
    if (_userNameTextField == nil) {
        _userNameTextField = [[UITextField alloc]init];
//        _userNameTextField.placeholder = @"手机号";
        _userNameTextField.borderStyle = UITextBorderStyleNone;
        _userNameTextField.font = [NUIUtil fixedFont:17];
        _userNameTextField.keyboardType = UIKeyboardTypePhonePad;
        _userNameTextField.leftView = self.tip1Label;
        _userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _userNameTextField;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [UITextField new];
        _codeTextField.borderStyle = UITextBorderStyleNone;
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.leftView = self.tip2Label;
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _codeTextField;
}

- (UITextField *)passwordTextField{
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearsOnBeginEditing = YES;
        _passwordTextField.leftView = self.tip3Label;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _passwordTextField;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        NSString *title = NSLocalizedString(@"login", nil);
        [_sureBtn setTitle:@"登录" forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 10;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
        
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _sureBtn;
}

- (UIButton *)registerBtn{
    if (_registerBtn == nil) {
        _registerBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        NSString *title = NSLocalizedString(@"register", nil);
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        [_registerBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:[UIColor whiteColor]];
        [_registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}

- (UIButton *)phoneCodeLoginBtn{
    if (_phoneCodeLoginBtn == nil) {
        _phoneCodeLoginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_phoneCodeLoginBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        [_phoneCodeLoginBtn setTitle:@"手机验证码登录" forState:UIControlStateNormal];
        [_phoneCodeLoginBtn setBackgroundColor:[UIColor whiteColor]];
        
        [_phoneCodeLoginBtn addTarget:self action:@selector(phoneCodeLoginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _phoneCodeLoginBtn;
}

- (UIButton *)forgetPswBtn{
    if (_forgetPswBtn == nil) {
        _forgetPswBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        NSString *title = NSLocalizedString(@"forgetpassword", nil);
        [_forgetPswBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        [_forgetPswBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        _forgetPswBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_forgetPswBtn setBackgroundColor:[UIColor whiteColor]];
        [_forgetPswBtn addTarget:self action:@selector(forgetPswBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _forgetPswBtn;
}

- (UIButton *)agreementBtn{
    if (_agreementBtn == nil) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        
        NSString *title = @"点击确定表示同意《用户协议和隐私条款》";
        
        [_agreementBtn setTitle:title forState:UIControlStateNormal];
        _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_agreementBtn setTitleColor:[UIColor colorWithRed:55.0/255 green:55.0/255 blue:55.0/255 alpha:1.0] forState:UIControlStateNormal];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_agreementBtn.titleLabel.text];
        
        [attr addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:[title rangeOfString:@"《用户协议和隐私条款》"]];
        
        [_agreementBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_agreementBtn addTarget:self action:@selector(agreementBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_agreementBtn setBackgroundColor:[UIColor whiteColor]];
    }
    return _agreementBtn;
}

- (UIButton *)getCodeBtn{
    if (_getCodeBtn == nil) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        NSString *title = NSLocalizedString(@"get", nil);
        [_getCodeBtn setTitle:@"获取" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_getCodeBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
        _getCodeBtn.titleLabel.font = Font(13);
        _getCodeBtn.layer.cornerRadius = 5.0;
        _getCodeBtn.layer.masksToBounds = YES;
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        _getCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _getCodeBtn.titleLabel.minimumScaleFactor = 0.2;
    }
    return _getCodeBtn;
}

@end
