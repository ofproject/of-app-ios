//
//  OFLoginViewController.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/3.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFLoginViewController.h"
#import "OFLoginLogic.h"
#import "OFForgetPasswordVC.h"
#import "OFRegisterVC.h"
#import "OFCreatAddressVC.h"
#import "NLocalUtil.h"

#import "OFProTabBarController.h"

// 测试
#import "OFTestRandomVC.h"


@interface OFLoginViewController ()

@property (nonatomic, strong) UIImageView *headerView;//头部view
@property (nonatomic, strong) UIView *txtContainerView;//输入框容器view
// 用户名
@property (nonatomic, strong) UITextField *phoneNumTextField;
// 验证码
@property (nonatomic, strong) UITextField *codeTextField;
// 密码
@property (nonatomic, strong) UITextField *passwordTextField;
//输入框左边的view
@property (nonatomic, strong) UILabel *tip1Label;
@property (nonatomic, strong) UILabel *tip2Label;
@property (nonatomic, strong) UILabel *tip3Label;
//分割线
@property (nonatomic, strong) UIView *line1Layer;
@property (nonatomic, strong) UIView *line2Layer;
@property (nonatomic, strong) UIView *line3Layer;
// 条款按钮
@property (nonatomic, strong) UIButton *agreementBtn;
//计时器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger timeCount;

// 获取验证码
@property (nonatomic, strong) UIButton *getCodeBtn;
//登录按钮
@property (nonatomic, strong) UIButton *loginBtn;
// 忘记密码
@property (nonatomic, strong) UIButton *forgetPswBtn;

//逻辑处理层
@property (nonatomic, strong) OFLoginLogic *logic;

@end

@implementation OFLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logic = [OFLoginLogic new];
    self.n_isWhiteStatusBar = YES;
    self.n_isHiddenNavBar = YES;
    self.timeCount = 60;
    [self setupUI];
    [self addNoti];
    
    
    UIButton *proBtn = [[UIButton alloc]init];
    [proBtn addTarget:self action:@selector(proBtnClick) forControlEvents:UIControlEventTouchUpInside];

    [proBtn setTitle:@"Pro" forState:UIControlStateNormal];
    [proBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
    [proBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [self.view addSubview:proBtn];

    [proBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(30);
        make.size.mas_equalTo(CGSizeMake(80, 37.5));
    }];
    
}

- (void)proBtnClick{
    
//    OFTestRandomVC *vc = [[OFTestRandomVC alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//    return;
    
    OFProTabBarController *tab = [[OFProTabBarController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = tab;

}



#pragma mark - 初始化UI
- (void) setupUI{
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.txtContainerView];
    [self.txtContainerView addSubview:self.phoneNumTextField];
    [self.txtContainerView addSubview:self.line1Layer];
    
    [self.txtContainerView addSubview:self.codeTextField];
    [self.txtContainerView addSubview:self.getCodeBtn];
    [self.txtContainerView addSubview:self.line2Layer];
    
    [self.txtContainerView addSubview:self.passwordTextField];
    [self.txtContainerView addSubview:self.line3Layer];
    
    [self.txtContainerView addSubview:self.agreementBtn];
    [self.txtContainerView addSubview:self.loginBtn];
    
    [self.txtContainerView addSubview:self.forgetPswBtn];
}

#pragma mark - 添加键盘内容改变通知
- (void)addNoti{
    //    //给键盘注册通知
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

#pragma mark - 登录按钮点击事件
- (void)loginBtnClick{
    WEAK_SELF;
    [self.logic loginWithPhone:self.phoneNumTextField.text password:self.passwordTextField.text code:self.codeTextField.text finished:^(BOOL success, id obj, NSError *error, NSString *messageStr, BOOL showChangePwd) {
        if(!success) {
            if (showChangePwd) {
                WEAK_SELF;
                [self AlertWithTitle:nil message:@"密码错误，前往修改密码？" andOthers:@[@"取消", @"去修改"] animated:YES action:^(NSInteger index) {
                    if (index == 1) {
                        [weakSelf forgetPswBtnClick];
                    }
                }];
            }else {
                [MBProgressHUD showError:messageStr];
            }
        }else{
            if (KcurUser.wallets.count == 0) {
                OFCreatAddressVC *vc = [[OFCreatAddressVC alloc]init];
                vc.hiddenBack = YES;
                [weakSelf.navigationController pushViewController:vc animated:YES];
            }else{
                //登录成功 切换到 tabbar
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLoginStateChange object:@(YES)];
            }
            [MBProgressHUD showToast:messageStr toView:[JumpUtil currentVC].view];
        }
    }];
}

#pragma mark - 获取验证码点击事件
- (void) getCodeBtnClick {
    if (![ToolObject isMobileNumber:self.phoneNumTextField.text]) {
        //        NSString *title = NSLocalizedString(@"mobileerror", nil);
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [self starTimer];
    
    [OFNetWorkHandle getAliSMSCodeWithMobil:self.phoneNumTextField.text success:^(NSDictionary *dict) {

        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        NSString *message = dict[@"message"];
        if (status == 200) {
            [self.codeTextField becomeFirstResponder];
            [MBProgressHUD showSuccess:@"获取成功"];
        }else{
            [self getVerifyCodeFailure];
            //            NSString *title = NSLocalizedString(@"geterror", nil);
            [MBProgressHUD showError:message];
            BLYLogWarn(@"获取验证码失败");
        }


    } failure:^(NSError *error) {
        [self getVerifyCodeFailure];
        [MBProgressHUD showError:@"获取失败,请稍后再试"];
        BLYLogError(@"获取验证码网络错误 - %zd",error.code);
    }];
}

#pragma mark - 开始计时器
- (void)starTimer{
    if (self.timeCount == 60) {
        [self.timer invalidate];
        WEAK_SELF;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            [weakSelf verifyCodeTimerAction];
        } repeats:YES];
        NSString *title = [NSString stringWithFormat:@"%zds",self.timeCount];
        [self.getCodeBtn setTitle:title forState:UIControlStateNormal];
        [self.getCodeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x9e9e9e]] forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 获取验证码失败 改为重新获取
- (void)getVerifyCodeFailure{
    [self.timer invalidate];
    self.getCodeBtn.userInteractionEnabled = YES;
    //    NSString *title = NSLocalizedString(@"reget", nil);
    [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    [self.getCodeBtn setBackgroundImage:[UIImage makeGradientImageWithRect:_getCodeBtn.bounds startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
    self.timeCount = 60;
    self.timer = nil;
}

#pragma mark - 倒计时
- (void)verifyCodeTimerAction {
    
    self.timeCount--;
    if (self.timeCount == 0) {
        
        [self getVerifyCodeFailure];
    }else{
        NSString *title = [NSString stringWithFormat:@"%zds",self.timeCount];
        
        [self.getCodeBtn setTitle:title forState:UIControlStateNormal];
        self.getCodeBtn.userInteractionEnabled = NO;
    }
}

#pragma mark - 打开用户协议
- (void) agreementBtnClick {
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = @"用户协议和隐私条款";
    webVC.urlString = NSStringFormat(@"%@%@",URL_H5_main,URL_H5_privacy);
    [self.navigationController pushViewController:webVC animated:YES];
    
}

#pragma mark - 忘记密码
- (void) forgetPswBtnClick {
    OFForgetPasswordVC *vc = [[OFForgetPasswordVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 键盘内容改变 更换标题
- (void)textLenghtChange:(NSNotification *)notification{
    if (notification.object == self.phoneNumTextField) {
        if (self.phoneNumTextField.hasText) {
            self.tip1Label.text = @"+86";
            self.tip1Label.textAlignment = NSTextAlignmentCenter;
        }else{
            //            NSString *title = NSLocalizedString(@"moblie", nil);
            self.tip1Label.text = @"手机号";
            self.tip1Label.textAlignment = NSTextAlignmentLeft;
        }
    }
}

#pragma mark 监听键盘的显示与隐藏
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //    NSLog(@"%@",NSStringFromCGRect(keyBoardFrame));
    //    NSLog(@"%@",NSStringFromCGRect(self.sureBtn.frame));
    
    CGRect f = [self.txtContainerView convertRect:self.loginBtn.frame toView:self.view.window];
    
    CGFloat top = self.view.height - (f.origin.y + f.size.height) - keyBoardFrame.size.height;
    if (top > 0) return;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.top = top;
    }];
}

-(void)inputKeyboardWillHide:(NSNotification *)notification{
    
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGRect f = [self.txtContainerView convertRect:self.loginBtn.frame toView:self.view.window];
    
    CGFloat top = self.view.height - (f.origin.y + f.size.height) - keyBoardFrame.size.height ;
    if (top > 0) return;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.top = 0;
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - 懒加载
-(UIImageView *)headerView{
    if (_headerView == nil) {
        _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, [NUIUtil fixedHeight:642/2])];
        _headerView.contentMode = UIViewContentModeScaleAspectFill;
        _headerView.image = [UIImage makeGradientImageWithRect:_headerView.bounds startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2];
        _headerView.userInteractionEnabled = YES;
        
        UIImageView *logoImgView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"login_logo")];
        logoImgView.frame = CGRectMake(0, KHeightFixed(48.5), [NUIUtil fixedWidth:164], [NUIUtil fixedWidth:125]);
        logoImgView.centerX = _headerView.width/2.0;
        [_headerView addSubview:logoImgView];
    }
    return _headerView;
}

-(UIView *)txtContainerView{
    if (_txtContainerView == nil) {
        _txtContainerView = [[UIView alloc] initWithFrame:CGRectMake(KWidthFixed(25), KHeightFixed(200) , KWidthFixed(325), KWidthFixed(330))];
        UIImageView *bgImgView = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"login_container_bg")];
        bgImgView.frame = CGRectMake(0, 0, _txtContainerView.width, _txtContainerView.height);
        [_txtContainerView addSubview:bgImgView];
    }
    return _txtContainerView;
}

- (UITextField *)phoneNumTextField{
    if (_phoneNumTextField == nil) {
        _phoneNumTextField = [[UITextField alloc]init];
        _phoneNumTextField.textColor = OF_COLOR_DETAILTITLE;
        _phoneNumTextField.borderStyle = UITextBorderStyleNone;
        _phoneNumTextField.font = [NUIUtil fixedFont:16];
        _phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
        _phoneNumTextField.leftView = self.tip1Label;
        _phoneNumTextField.leftViewMode = UITextFieldViewModeAlways;
        _phoneNumTextField.frame = CGRectMake(KWidthFixed(24), KWidthFixed(35), self.txtContainerView.width - KWidthFixed(24)*2, 35);
    }
    return _phoneNumTextField;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [UITextField new];
        _codeTextField.textColor = OF_COLOR_DETAILTITLE;
        _codeTextField.borderStyle = UITextBorderStyleNone;
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.leftView = self.tip2Label;
        _codeTextField.leftViewMode = UITextFieldViewModeAlways;
        _codeTextField.frame = CGRectMake(KWidthFixed(24), self.line1Layer.bottom + KWidthFixed(15), self.txtContainerView.width - KWidthFixed(24)*2 - KWidthFixed(82) -5, 35);
    }
    return _codeTextField;
}

- (UITextField *)passwordTextField{
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.textColor = OF_COLOR_DETAILTITLE;
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearsOnBeginEditing = YES;
        _passwordTextField.leftView = self.tip3Label;
        _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        _passwordTextField.returnKeyType = UIReturnKeyGo;
        _passwordTextField.frame = CGRectMake(KWidthFixed(24), self.line2Layer.bottom + KWidthFixed(10), self.txtContainerView.width - KWidthFixed(24)*2, 35);
        _passwordTextField.placeholder = @"请输入登录密码";
        [_passwordTextField setValue:[UIFont systemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    }
    return _passwordTextField;
}
- (UILabel *)tip1Label {
    if (_tip1Label == nil) {
        //        NSString *title = NSLocalizedString(@"moblie", nil);
        _tip1Label = [[UILabel alloc]init];
        _tip1Label.text = @"手机号";
        _tip1Label.textColor = OF_COLOR_DETAILTITLE;
        _tip1Label.font = [NUIUtil fixedFont:16];
        [_tip1Label sizeToFit];
        _tip1Label.width = TIPS_LABEL_WIDTH;
        _tip1Label.textAlignment = NSTextAlignmentLeft;
    }
    return _tip1Label;
}

- (UILabel *)tip2Label{
    if (_tip2Label == nil) {
        //        NSString *title = NSLocalizedString(@"password", nil);
        _tip2Label = [[UILabel alloc]init];
        _tip2Label.text = @"验证码";
        _tip2Label.textColor = OF_COLOR_DETAILTITLE;
        _tip2Label.font = [NUIUtil fixedFont:16];
        
        [_tip2Label sizeToFit];
        _tip2Label.width = TIPS_LABEL_WIDTH;
        
    }
    return _tip2Label;
}

- (UILabel *)tip3Label{
    if (_tip3Label == nil) {
        //        NSString *title = NSLocalizedString(@"password", nil);
        _tip3Label = [[UILabel alloc]init];
        _tip3Label.text = @"密    码";
        _tip3Label.textColor = OF_COLOR_DETAILTITLE;
        _tip3Label.font = [NUIUtil fixedFont:16];
        
        [_tip3Label sizeToFit];
        _tip3Label.width = TIPS_LABEL_WIDTH;
        
    }
    return _tip3Label;
}

- (UIView *)line1Layer{
    if (_line1Layer == nil) {
        _line1Layer = [[UIView alloc]init];
        _line1Layer.backgroundColor = Line_Color;
        _line1Layer.frame = CGRectMake(self.phoneNumTextField.left, self.phoneNumTextField.bottom, self.phoneNumTextField.width, 1);
    }
    return _line1Layer;
}

- (UIView *)line2Layer{
    if (_line2Layer == nil) {
        _line2Layer = [[UIView alloc]init];
        _line2Layer.backgroundColor = Line_Color;
        _line2Layer.frame = CGRectMake(self.codeTextField.left, self.codeTextField.bottom, self.codeTextField.width, 1);
    }
    return _line2Layer;
}


- (UIView *)line3Layer{
    if (_line3Layer == nil) {
        _line3Layer = [[UIView alloc]init];
        _line3Layer.backgroundColor = Line_Color;
        _line3Layer.frame = CGRectMake(self.passwordTextField.left, self.passwordTextField.bottom, self.passwordTextField.width, 1);
    }
    return _line3Layer;
}

- (UIButton *)getCodeBtn{
    if (_getCodeBtn == nil) {
        _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        NSString *title = NSLocalizedString(@"get", nil);
        [_getCodeBtn setTitle:@"获取" forState:UIControlStateNormal];
        [_getCodeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_getCodeBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
        _getCodeBtn.titleLabel.font = Font(16);
        _getCodeBtn.layer.cornerRadius = 5.0;
        _getCodeBtn.layer.masksToBounds = YES;
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _getCodeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _getCodeBtn.titleLabel.minimumScaleFactor = 0.2;
        _getCodeBtn.frame = CGRectMake(self.codeTextField.right+5, self.line2Layer.top - KWidthFixed(34), KWidthFixed(82), KWidthFixed(34));
        [_getCodeBtn setBackgroundImage:[UIImage makeGradientImageWithRect:_getCodeBtn.bounds startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
    }
    return _getCodeBtn;
}

- (UIButton *)agreementBtn{
    if (_agreementBtn == nil) {
        _agreementBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        NSString *title = @"登录表示同意《OF用户协议》";
        
        [_agreementBtn setTitle:title forState:UIControlStateNormal];
        _agreementBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [_agreementBtn setTitleColor:Cancle_Color forState:UIControlStateNormal];
        
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_agreementBtn.titleLabel.text];
        
        [attr addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:[title rangeOfString:@"《OF用户协议》"]];
        
        [_agreementBtn setAttributedTitle:attr forState:UIControlStateNormal];
        
        [_agreementBtn addTarget:self action:@selector(agreementBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_agreementBtn setBackgroundColor:[UIColor whiteColor]];
        _agreementBtn.frame = CGRectMake(self.line3Layer.left, self.line3Layer.bottom+5, self.line3Layer.width, 20);
        [_agreementBtn sizeToFit];
    }
    return _agreementBtn;
}

- (UIButton *)loginBtn{
    if (_loginBtn == nil) {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn setTitle:@"登录 / 注册" forState:UIControlStateNormal];
        _loginBtn.titleLabel.font = [NUIUtil fixedFont:15];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.frame = CGRectMake(self.line3Layer.left, self.agreementBtn.bottom + KWidthFixed(10), self.line3Layer.width, KWidthFixed(45));
        [_loginBtn setBackgroundImage:IMAGE_NAMED(@"loginBtn_icon") forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginBtn;
}

- (UIButton *)forgetPswBtn{
    if (_forgetPswBtn == nil) {
        _forgetPswBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        NSString *title = NSLocalizedString(@"forgetpassword", nil);
        [_forgetPswBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
        [_forgetPswBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        _forgetPswBtn.titleLabel.font = [NUIUtil fixedFont:12];
        [_forgetPswBtn setBackgroundColor:[UIColor whiteColor]];
        [_forgetPswBtn addTarget:self action:@selector(forgetPswBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _forgetPswBtn.frame = CGRectMake(0, self.loginBtn.bottom + 1, 0, 0);
        [_forgetPswBtn sizeToFit];
        _forgetPswBtn.right = self.loginBtn.right;

    }
    return _forgetPswBtn;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
