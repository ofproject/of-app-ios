//
//  OFRegisterVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/9.
//  Copyright © 2018年 胡堃. All rights reserved.
//  注册

#import "OFRegisterVC.h"
#import "OFCreatAddressVC.h"
#import "OFWebViewController.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "PooCodeView.h"
#import "OFPoolModel.h"
#import "OFLoginLogic.h"

@interface OFRegisterVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

//@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *tip1Label;

@property (nonatomic, strong) UILabel *tip2Label;

@property (nonatomic, strong) UILabel *tip3Label;

@property (nonatomic, strong) UILabel *tip4Label;

@property (nonatomic, strong) UIView *line1View;

@property (nonatomic, strong) UIView *line2View;

@property (nonatomic, strong) UIView *line3View;

@property (nonatomic, strong) UIView *line4View;

@property (nonatomic, strong) UITextField *emailTextField;

@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UITextField *pswTextField;

@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *agreementBtn;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, strong) PooCodeView *codeView;
//逻辑处理层
@property (nonatomic, strong) OFLoginLogic *logic;
//@property (nonatomic, assign) NSInteger codeCount;

@end

static CGFloat const maxTime = 60;


@implementation OFRegisterVC

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"注册";
    self.logic = [[OFLoginLogic alloc] initWithDelegate:nil];
    
//    self.fd_prefersNavigationBarHidden = YES;
    self.n_isHiddenNavBar = YES;
    
    self.timeCount = maxTime;
    
    
    [self initUI];
    [self layout];
    
    [self addNoti];
    
    
}

- (void)initUI{
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.iconView];
    
    [self.scrollView addSubview:self.inputView];
    
//    [self.inputView addSubview:self.tip1Label];
//    [self.inputView addSubview:self.tip2Label];
//    [self.inputView addSubview:self.tip3Label];
//    [self.inputView addSubview:self.tip4Label];
    
//    [self.inputView addSubview:self.line1View];
    [self.inputView addSubview:self.line2View];
    [self.inputView addSubview:self.line3View];
    [self.inputView addSubview:self.line4View];
    
//    [self.inputView addSubview:self.emailTextField];
    [self.inputView addSubview:self.phoneTextField];
    [self.inputView addSubview:self.codeTextField];
    [self.inputView addSubview:self.pswTextField];
    
    [self.inputView addSubview:self.codeBtn];
    
    [self.scrollView addSubview:self.sureBtn];
    
    [self.scrollView addSubview:self.agreementBtn];
    [self.scrollView addSubview:self.loginBtn];
    
//    [self.scrollView addSubview:self.codeView];
}

- (void)layout{
    
    CGFloat padding = [NUIUtil fixedWidth:60];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
    }];
    
//    [self.codeView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.mas_equalTo(30);
//        make.size.mas_equalTo(CGSizeMake(150, 45));
//    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.iconView.mas_centerX);
//        make.size.mas_equalTo(CGSizeMake(kScreenWidth - padding * 2, 120));
        make.width.mas_equalTo(kScreenWidth - padding * 2);
    }];
    
//    [self.emailTextField mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(0);
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.height.mas_equalTo(TextField_Height);
//    }];
//
//    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(1);
//        make.left.right.mas_equalTo(0);
//        make.top.mas_equalTo(self.emailTextField.mas_bottom).offset(-5);
//    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(TextField_Height);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).offset(-5);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(37.5);
        make.top.mas_equalTo(self.line2View.mas_bottom).offset(23);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.codeBtn.mas_left);
        make.centerY.mas_equalTo(self.codeBtn.mas_centerY);
        make.left.mas_equalTo(0);
    }];
    
    [self.line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(self.codeBtn.mas_left);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.codeBtn.mas_bottom);
    }];
    
    
    [self.pswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(TextField_Height);
        make.top.mas_equalTo(self.line3View.mas_bottom).offset(0);
    }];
    
    [self.line4View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.pswTextField.mas_bottom).offset(-5);
        make.bottom.mas_equalTo(self.inputView.mas_bottom);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(padding);
        make.right.mas_equalTo(self.view.mas_right).offset(-padding);
        make.height.mas_equalTo(37.5);
        make.top.mas_equalTo(self.inputView.mas_bottom).offset(40);
    }];
    
    [self.agreementBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.sureBtn.mas_bottom).offset(13.5);
    }];
    
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.agreementBtn.mas_bottom).offset(20);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-55);
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
    
//    CGFloat height = self.sureBtn.bottom + keyBoardFrame.size.height;
    
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
    
    NSLog(@"隐藏 - %f",top);
    if (top > 0) return;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.top = 0;
    }];
    
}

- (void)textLenghtChange:(NSNotification *)notification{
    if (notification.object == self.phoneTextField) {
        
        if (self.phoneTextField.hasText) {
            self.tip2Label.text = @"+86";
            self.tip2Label.textAlignment = NSTextAlignmentCenter;
        }else{
//            NSString *title = NSLocalizedString(@"mobile", nil);
            self.tip2Label.text = @"手机号";
            self.tip2Label.textAlignment = NSTextAlignmentLeft;
        }
    }
}

#pragma mark - 注册按钮点击
- (void)sureBtnClick{
    WEAK_SELF;
    [self.logic registerUserWithPhone:self.phoneTextField.text password:self.pswTextField.text email:@"" code:self.codeTextField.text finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success){
            [weakSelf registerSuccess];
        } else {
            [MBProgressHUD showError:messageStr];
        }
    }];
}

- (void)registerSuccess{
    OFCreatAddressVC *vc = [[OFCreatAddressVC alloc]init];
    vc.hiddenBack = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)agreementBtnClick{
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = @"用户协议和隐私条款";
    
    NSString *urlString = [[NSBundle mainBundle] pathForResource:@"privacy" ofType:@"html"];
    
    NSString *htmlString = [NSString stringWithContentsOfFile:urlString encoding:NSUTF8StringEncoding error:NULL];
    
    webVC.htmlStr = htmlString;
    
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void)loginBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)codeBtnClick{
    if (![ToolObject isMobileNumber:self.phoneTextField.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        BLYLogWarn(@"手机号格式错误 %@",self.phoneTextField.text);
        return;
    }
    
//    if (self.codeCount >= 2) {
////        [MBProgressHUD showMessage:@""];
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"由于目前短信通道拥堵，您可以直接输入密码完成注册。" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//
////        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////
////        }];
//        [alert addAction:action1];
//        [self presentViewController:alert animated:YES completion:nil];
//        return;
//    }
    
    [self starTimer];
    [self getAliCode];
//    if (self.codeCount == 0) {
//        [self getAliCode];
//    }else if(self.codeCount == 1){
//        [self getYimeiCode];
//    }
    
    
}

- (void)getAliCode{
    WEAK_SELF;
    [OFNetWorkHandle getAliSMSCodeWithMobil:self.phoneTextField.text success:^(NSDictionary *dict) {
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
- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击了屏幕");
    [self.view endEditing:YES];
}



- (void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSLog(@"注册页面销毁");
}



#pragma mark - 懒加载

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
//        _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    }
    return _scrollView;
}

//- (UILabel *)titleLabel {
//   if (!_titleLabel) {
//       _titleLabel = [UILabel new];
//       _titleLabel.font = [UIFont systemFontOfSize:25];
//       _titleLabel.textColor = OF_COLOR_MAIN_THEME;
//       _titleLabel.backgroundColor = [UIColor whiteColor];
//       _titleLabel.text = @"注册";
//   }
//   return _titleLabel;
//}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"login_logo"];
    }
    return _iconView;
}

- (UILabel *)tip1Label {
   if (!_tip1Label) {
       _tip1Label = [UILabel new];
       _tip1Label.font = [UIFont systemFontOfSize:17];
       _tip1Label.textColor = [UIColor blackColor];
       _tip1Label.text = @"邮箱";
       _tip1Label.backgroundColor = [UIColor whiteColor];
       [_tip1Label sizeToFit];
       _tip1Label.width = TIPS_LABEL_WIDTH;
   }
   return _tip1Label;
}

- (UILabel *)tip2Label {
   if (!_tip2Label) {
       _tip2Label = [UILabel new];
       _tip2Label.font = [UIFont systemFontOfSize:17];
       _tip2Label.textColor = [UIColor blackColor];
//       NSString *title = NSLocalizedString(@"moblie", nil);
       _tip2Label.text = @"手机号";
       _tip2Label.backgroundColor = [UIColor whiteColor];
       [_tip2Label sizeToFit];
       _tip2Label.width = TIPS_LABEL_WIDTH;
   }
   return _tip2Label;
}

- (UILabel *)tip3Label {
   if (!_tip3Label) {
       _tip3Label = [UILabel new];
       _tip3Label.font = [UIFont systemFontOfSize:17];
       _tip3Label.textColor = [UIColor blackColor];
//       NSString *title = NSLocalizedString(@"verificacode", nil);
       _tip3Label.text = @"验证码";
       _tip3Label.backgroundColor = [UIColor whiteColor];
       [_tip3Label sizeToFit];
       _tip3Label.width = TIPS_LABEL_WIDTH;
   }
   return _tip3Label;
}

- (UILabel *)tip4Label {
   if (!_tip4Label) {
       _tip4Label = [UILabel new];
       _tip4Label.font = [UIFont systemFontOfSize:17];
       _tip4Label.textColor = [UIColor blackColor];
       _tip4Label.backgroundColor = [UIColor whiteColor];
//       NSString *title = NSLocalizedString(@"password", nil);
       _tip4Label.text = @"密码";
       [_tip4Label sizeToFit];
       _tip4Label.width = TIPS_LABEL_WIDTH;
   }
   return _tip4Label;
}

- (UIView *)line1View {
   if (!_line1View) {
       _line1View = [UIView new];
       _line1View.backgroundColor = Line_Color;
   }
   return _line1View;
}

- (UIView *)line2View {
   if (!_line2View) {
       _line2View = [UIView new];
       _line2View.backgroundColor = Line_Color;
   }
   return _line2View;
}

- (UIView *)line3View {
   if (!_line3View) {
       _line3View = [UIView new];
       _line3View.backgroundColor = Line_Color;
   }
   return _line3View;
}

- (UIView *)line4View {
   if (!_line4View) {
       _line4View = [UIView new];
       _line4View.backgroundColor = Line_Color;
   }
   return _line4View;
}

- (UITextField *)emailTextField {
   if (!_emailTextField) {
       _emailTextField = [UITextField new];
       _emailTextField.borderStyle = UITextBorderStyleNone;
       _emailTextField.returnKeyType = UIReturnKeyDone;
       _emailTextField.secureTextEntry = NO;
       _emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
       _emailTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
       
       [_emailTextField setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
       [_emailTextField setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
       
       _emailTextField.leftView = self.tip1Label;
       _emailTextField.leftViewMode = UITextFieldViewModeAlways;
       
   }
   return _emailTextField;
}

- (UITextField *)phoneTextField {
   if (!_phoneTextField) {
       _phoneTextField = [UITextField new];
       _phoneTextField.borderStyle = UITextBorderStyleNone;
//       _phoneTextField.returnKeyType = UIReturnKeyDone;
       _phoneTextField.secureTextEntry = NO;
//       _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
       _phoneTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
       
       _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
       _phoneTextField.leftView = self.tip2Label;
       _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
   }
   return _phoneTextField;
}

- (UITextField *)codeTextField {
   if (!_codeTextField) {
       _codeTextField = [UITextField new];
       _codeTextField.borderStyle = UITextBorderStyleNone;
//       _codeTextField.returnKeyType = UIReturnKeyDone;
       _codeTextField.secureTextEntry = NO;
//       _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
       _codeTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
       _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
       _codeTextField.leftView = self.tip3Label;
       _codeTextField.leftViewMode = UITextFieldViewModeAlways;
   }
   return _codeTextField;
}

- (UITextField *)pswTextField {
   if (!_pswTextField) {
       _pswTextField = [UITextField new];
       _pswTextField.borderStyle = UITextBorderStyleNone;
       _pswTextField.returnKeyType = UIReturnKeyDone;
       _pswTextField.secureTextEntry = YES;
       _pswTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
       _pswTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
       
       _pswTextField.leftView = self.tip4Label;
       _pswTextField.leftViewMode = UITextFieldViewModeAlways;
   }
   return _pswTextField;
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

- (UIView *)inputView {
   if (!_inputView) {
       _inputView = [UIView new];
       _inputView.backgroundColor = [UIColor whiteColor];
   }
   return _inputView;
}

- (UIButton *)sureBtn {
   if (!_sureBtn) {
       _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//       NSString *title = NSLocalizedString(@"register", nil);
       [_sureBtn setTitle:@"注册" forState:UIControlStateNormal];
       _sureBtn.layer.cornerRadius = 10;
       _sureBtn.layer.masksToBounds = YES;
       [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       [_sureBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
       
       [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
   }
   return _sureBtn;
}

- (UIButton *)agreementBtn {
   if (!_agreementBtn) {
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

- (UIButton *)loginBtn {
   if (!_loginBtn) {
       _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//       NSString *title = NSLocalizedString(@"login", nil);
       [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
       [_loginBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
       
       [_loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
   }
   return _loginBtn;
}

- (PooCodeView *)codeView{
    if (!_codeView) {
        _codeView = [[PooCodeView alloc]init];
    }
    return _codeView;
}


@end
