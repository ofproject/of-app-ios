//
//  OFChangePhoneVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFChangePhoneVC.h"
#import "OFInputView.h"

@interface OFChangePhoneVC ()

@property (nonatomic, strong) OFInputView *phoneView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UITextField *codeTextField;

@property (nonatomic, strong) UIButton *codeBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;

@end

@implementation OFChangePhoneVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.timeCount = 60;
    self.title = @"修改手机号";
    [self initUI];
    [self layout];
}

- (void)initUI{
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.codeTextField];
    [self.view addSubview:self.lineView];
    [self.view addSubview:self.codeBtn];
    [self.view addSubview:self.sureBtn];
}

- (void)layout{
    
    CGFloat padding = [NUIUtil fixedWidth:60];
    
    [self.phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(44);
    }];
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-padding);
//        make.top.mas_equalTo(self.phoneView.mas_bottom).offset(39);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(37.5);
        make.centerY.mas_equalTo(self.codeTextField.mas_centerY);
    }];
    
    [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(self.codeBtn.mas_left).offset(-15);
        make.top.mas_equalTo(self.phoneView.mas_bottom).offset(39);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(self.codeBtn.mas_left);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.codeBtn.mas_bottom);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.lineView.mas_bottom).offset(35);
        make.height.mas_equalTo(Btn_Default_Height);
    }];
}

- (void)sureBtnClick{
    
    
}

- (void)codeBtnClick{
    if (![ToolObject isMobileNumber:self.phoneView.content]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    [self starTimer];
    WEAK_SELF;
    [OFNetWorkHandle getAliSMSCodeWithMobil:self.phoneView.content success:^(NSDictionary *dict) {
        NSString *message = dict[@"message"];
        if ([[NDataUtil stringWith:dict[@"code"] valid:@""] isEqualToString:@"SUCCESS"]) {
            
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
        [self.timer invalidate];
        
        WEAK_SELF;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 block:^(NSTimer * _Nonnull timer) {
            [weakSelf verifyCodeTimerAction];
        } repeats:YES];
        
        if (self.timer) {
            [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        }
        
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
    [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    self.timeCount = 60;
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

- (void)dealloc{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (UITextField *)codeTextField{
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc]init];
        _codeTextField.borderStyle = UITextBorderStyleNone;
        _codeTextField.returnKeyType = UIReturnKeyDone;
        _codeTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        
        _codeTextField.placeholder = @"验证码";
    }
    return _codeTextField;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Line_Color;
    }
    return _lineView;
}

- (OFInputView *)phoneView{
    if (_phoneView == nil) {
        _phoneView = [[OFInputView alloc]initWithPlaceholder:@"输入新手机号"];
        _phoneView.keyboardType = UIKeyboardTypePhonePad;
    }
    return _phoneView;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [NUIUtil fixedFont:17];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _sureBtn.layer.cornerRadius = 5.0;
        [_sureBtn setBackgroundColor:OF_COLOR_MAIN_THEME];
        _sureBtn.layer.masksToBounds = YES;
        
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}



- (UIButton *)codeBtn {
    if (!_codeBtn) {
        _codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
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

@end
