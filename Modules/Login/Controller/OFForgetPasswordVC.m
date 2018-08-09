//
//  OFForgetPasswordVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/10.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFForgetPasswordVC.h"
#import "OFLoginLogic.h"

//#import "CKWeakTimer.h"
@interface OFForgetPasswordVC ()

@property (nonatomic, strong) UILabel *tip1Label;

@property (nonatomic, strong) UILabel *tip2Label;

@property (nonatomic, strong) UILabel *tip3Label;

@property (nonatomic, strong) UIView *line1View;

@property (nonatomic, strong) UIView *line2View;

@property (nonatomic, strong) UIView *line3View;

@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UITextField *pswTextField;

@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;
//逻辑处理层
@property (nonatomic, strong) OFLoginLogic *logic;

@end

@implementation OFForgetPasswordVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *title = NSLocalizedString(@"forgetpassword", nil);
    
    self.title = [NSString stringWithFormat:@"忘记密码"];
    self.logic = [[OFLoginLogic alloc] initWithDelegate:nil];
    
    self.timeCount = 60;
    [self initUI];
    [self layout];
    [self addNoti];
}



- (void)initUI{
    [self.view addSubview:self.inputView];
    
//    [self.inputView addSubview:self.tip1Label];
//    [self.inputView addSubview:self.tip2Label];
//    [self.inputView addSubview:self.tip3Label];
    
    [self.inputView addSubview:self.line1View];
    [self.inputView addSubview:self.line2View];
    [self.inputView addSubview:self.line3View];
    
    [self.inputView addSubview:self.phoneTextField];
    [self.inputView addSubview:self.codeTextField];
    [self.inputView addSubview:self.pswTextField];
    
    [self.inputView addSubview:self.codeBtn];
    
    [self.view addSubview:self.sureBtn];
    
}

- (void)layout{
    
    CGFloat padding = [NUIUtil fixedWidth:60];
    [self.inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(40);
    }];
    
//    [self.tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.mas_equalTo(0);
//        make.width.mas_equalTo(width);
//    }];
    
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(TextField_Height);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.centerY.mas_equalTo(self.tip1Label.mas_centerY);
        make.top.mas_equalTo(0);
    }];
    
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.phoneTextField.mas_bottom).offset(-5);
    }];
    
//    [self.tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(self.line1View.mas_bottom).offset(23);
//    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(KWidthFixed(82));
        make.height.mas_equalTo(KWidthFixed(34));
        make.centerY.mas_equalTo(self.codeTextField.mas_centerY);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.codeBtn.mas_left);
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(self.line1View.mas_bottom).offset(13);
        make.height.mas_equalTo(TextField_Height);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.right.mas_equalTo(self.codeBtn.mas_left);
        make.top.mas_equalTo(self.codeTextField.mas_bottom).offset(-5);
    }];
    
//    [self.tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.width.mas_equalTo(width);
//        make.top.mas_equalTo(self.line2View.mas_bottom).offset(23);
//    }];
    
    [self.pswTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(TextField_Height);
        make.top.mas_equalTo(self.line2View.mas_bottom).offset(13);
        make.bottom.mas_equalTo(self.inputView.mas_bottom);
    }];
    
    [self.line3View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(self.pswTextField.mas_bottom).offset(-5);
    }];
    
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.inputView.mas_bottom).offset(35);
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(44.5);
    }];
    
}

- (void)addNoti{
    
    //给键盘注册通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(inputKeyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(inputKeyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
    
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
    
    if (top > 0) return;
    
    [UIView animateWithDuration:animationTime animations:^{
        self.view.top = 0;
    }];
    
}

- (void)textLenghtChange:(NSNotification *)notification{
    if (notification.object == self.phoneTextField) {
        NSString *text1 = [NSString stringWithFormat:@"+86"];
        NSString *text2 = [NSString stringWithFormat:@"手机号"];
        if (self.phoneTextField.hasText) {
            self.tip1Label.text = text1;
            self.tip1Label.textAlignment = NSTextAlignmentCenter;
        }else{
//            NSString *title = NSLocalizedString(@"moblie", nil);
            self.tip1Label.text = text2;
            self.tip1Label.textAlignment = NSTextAlignmentLeft;
        }
    }
}

- (void)sureBtnClick{
    WEAK_SELF;
    [self.logic forgetpasswordWithPhone:self.phoneTextField.text code:self.codeTextField.text password:self.pswTextField.text finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            [MBProgressHUD showSuccess:@"修改成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:messageStr];
        }
    }];
}



- (void)codeBtnClick{
    if (![ToolObject isMobileNumber:self.phoneTextField.text]) {
//        NSString *title = NSLocalizedString(@"mobileerror", nil);
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [self starTimer];
    WEAK_SELF;
    [OFNetWorkHandle getAliSMSCodeWithMobil:self.phoneTextField.text success:^(NSDictionary *dict) {
        
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        NSString *message = dict[@"message"];
        if (status == 200) {
//            NSString *title = NSLocalizedString(@"getsuccess", nil);
            [MBProgressHUD showSuccess:@"获取成功"];
        }else{
            [weakSelf getVerifyCodeFailure];
            [MBProgressHUD showError:message];
        }
    } failure:^(NSError *error) {
        [weakSelf getVerifyCodeFailure];
    }];
}


- (void)starTimer{
    if (self.timeCount == 60) {
        self.codeBtn.userInteractionEnabled = NO;
        [self.timer invalidate];
        WEAK_SELF;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            [weakSelf verifyCodeTimerAction];
        } repeats:YES];
        if (self.timer) {
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        
        NSString *title = [NSString stringWithFormat:@"%zds",self.timeCount];
        
        [self.codeBtn setTitle:title forState:UIControlStateNormal];
        
        [self.codeBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRGB:0x9e9e9e]] forState:UIControlStateNormal];
        
    }
}

/**
 获取验证码失败
 */
- (void)getVerifyCodeFailure{
    [self.timer invalidate];
    self.codeBtn.userInteractionEnabled = YES;
//    NSString *title = NSLocalizedString(@"reget", nil);
    NSString *title = [NSString stringWithFormat:@"重新获取"];
    [self.codeBtn setTitle:title forState:UIControlStateNormal];
    self.timeCount = 60;
    [self.codeBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
    self.timer = nil;
}

- (void)verifyCodeTimerAction {
    
    self.timeCount--;
    if (self.timeCount == 0) {
        [self getVerifyCodeFailure];
    }else{
        NSString *title = [NSString stringWithFormat:@"%zds",self.timeCount];
        [self.codeBtn setTitle:title forState:UIControlStateNormal];
        self.codeBtn.userInteractionEnabled = NO;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)dealloc{
    
    NSLog(@"忘记密码被销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载
- (UILabel *)tip1Label {
    if (!_tip1Label) {
        _tip1Label = [UILabel new];
        _tip1Label.font = [UIFont systemFontOfSize:17];
        _tip1Label.textColor = [UIColor blackColor];
//        NSString *title = NSLocalizedString(@"moblie", nil);
        _tip1Label.text = @"手机号";
        _tip1Label.backgroundColor = [UIColor whiteColor];
        [_tip1Label sizeToFit];
        _tip1Label.width = [NUIUtil fixedWidth:65];
    }
    return _tip1Label;
}

- (UILabel *)tip2Label {
    if (!_tip2Label) {
        _tip2Label = [UILabel new];
        _tip2Label.font = [UIFont systemFontOfSize:17];
        _tip2Label.textColor = [UIColor blackColor];
//        NSString *title = NSLocalizedString(@"verificacode", nil);
        NSString *title = [NSString stringWithFormat:@"验证码"];
        _tip2Label.text = title;
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
//        NSString *title = NSLocalizedString(@"newpassword", nil);
        NSString *title = [NSString stringWithFormat:@"新密码"];
        _tip3Label.text = title;
        _tip3Label.backgroundColor = [UIColor whiteColor];
        [_tip3Label sizeToFit];
        _tip3Label.width = TIPS_LABEL_WIDTH;
    }
    return _tip3Label;
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

- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [UITextField new];
        _phoneTextField.borderStyle = UITextBorderStyleNone;
//        _phoneTextField.returnKeyType = UIReturnKeyDone;
//        _phoneTextField.secureTextEntry = NO;
        _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _phoneTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
        _phoneTextField.keyboardType = UIKeyboardTypePhonePad;
        
        _phoneTextField.leftView = self.tip1Label;
        _phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _phoneTextField;
}

- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [UITextField new];
        _codeTextField.borderStyle = UITextBorderStyleNone;
//        _codeTextField.returnKeyType = UIReturnKeyDone;
//        _codeTextField.secureTextEntry = NO;
        _codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//        _codeTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.leftView = self.tip2Label;
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
//        _pswTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
        _pswTextField.leftView = self.tip3Label;
        _pswTextField.leftViewMode = UITextFieldViewModeAlways;
    }
    return _pswTextField;
}

- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        NSString *title = NSLocalizedString(@"get", nil);
        NSString *title = [NSString stringWithFormat:@"获取"];
        [_codeBtn setTitle:title forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = Font(16);
        _codeBtn.layer.cornerRadius = 5;
        _codeBtn.layer.masksToBounds = YES;
        [_codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _codeBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _codeBtn.titleLabel.minimumScaleFactor = 0.2;
        [_codeBtn setBackgroundImage:[UIImage makeGradientImageWithRect:CGRectMake(0, 0, KWidthFixed(82), KWidthFixed(34)) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
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
//        NSString *title = NSLocalizedString(@"sure", nil);
        NSString *sure =[NSString stringWithFormat:@"确定"];
        _sureBtn.titleLabel.font = [NUIUtil fixedFont:15];
        [_sureBtn setTitle:sure forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 10;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_sureBtn setBackgroundImage:IMAGE_NAMED(@"loginBtn_icon") forState:UIControlStateNormal];
        
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
