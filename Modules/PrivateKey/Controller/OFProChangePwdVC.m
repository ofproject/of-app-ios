//
//  OFProChangePwdVC.m
//  OFBank
//
//  Created by michael on 2018/6/2.
//  Copyright © 2018年 胡堃. All rights reserved.
//  修改资金密码

#import "OFProChangePwdVC.h"
#import "OFInputView.h"
#import "OFCipherManager.h"

@interface OFProChangePwdVC ()

@property (nonatomic, strong) OFInputView *oldPasswordView;

@property (nonatomic, strong) OFInputView *passwordView;

@property (nonatomic, strong) OFInputView *againPasswordView;

@property (nonatomic, strong) UIButton *sureBtn;


@end

@implementation OFProChangePwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"修改资金密码";
    [self initUI];
    [self layout];
}

- (void)initUI{
    [self.view addSubview:self.oldPasswordView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.againPasswordView];
    [self.view addSubview:self.sureBtn];
}

- (void)layout{
    CGFloat padding = [NUIUtil fixedWidth:60];
    
    [self.oldPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(KHeightFixed(76.5));
        
    }];
    
    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.oldPasswordView.mas_bottom).offset(30);
    }];
    
    [self.againPasswordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.passwordView.mas_bottom).offset(30);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(Btn_Default_Height);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.againPasswordView.mas_bottom).offset(55);
    }];
}

- (void)sureBtnClick{
    
    if (self.oldPasswordView.content.length < 1) {
        [MBProgressHUD showError:@"请输入原密码"];
        return;
    }
    
    if (self.passwordView.content.length < 1) {
        [MBProgressHUD showError:@"请输入新密码"];
        return;
    }
    
    if (![self.passwordView.content isEqualToString:self.againPasswordView.content]) {
        [MBProgressHUD showError:@"两次新密码不一致"];
        return;
    }
    [MBProgressHUD showToast:@"修改中" toView:self.view];
    [OFCipherManager changePassword:self.oldPasswordView.content keystore:self.model.keystore address:self.model.address newPassword:self.passwordView.content finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:self.view];
        if (success) {
            
            [MBProgressHUD showSuccess:@"修改成功"];
            
        }else{
            [MBProgressHUD showError:[NDataUtil stringWith:errorMessage valid:@"原始密码错误！"]];
        }
    }];
    
}

- (OFInputView *)oldPasswordView{
    if (!_oldPasswordView) {
        //        NSString *title = NSLocalizedString(@"originalcipher", nil);
        _oldPasswordView = [[OFInputView alloc]initWithPlaceholder:@"原密码"];
        _oldPasswordView.secureTextEntry = YES;
    }
    return _oldPasswordView;
}

- (OFInputView *)passwordView{
    if (!_passwordView) {
        //        NSString *title = NSLocalizedString(@"newcipher", nil);
        _passwordView = [[OFInputView alloc]initWithPlaceholder:@"输入新密码"];
        _passwordView.secureTextEntry = YES;
    }
    return _passwordView;
}

- (OFInputView *)againPasswordView{
    if (!_againPasswordView) {
        //        NSString *title = NSLocalizedString(@"againcipher", nil);
        _againPasswordView = [[OFInputView alloc]initWithPlaceholder:@"再次输入新密码"];
        _againPasswordView.secureTextEntry = YES;
    }
    return _againPasswordView;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        //        NSString *title = NSLocalizedString(@"sure", nil);
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [NUIUtil fixedFont:17];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 5.0;
        _sureBtn.layer.masksToBounds = YES;
        
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setBackgroundImage:OF_IMAGE_DRADIENT(kScreenWidth-KWidthFixed(120), Btn_Default_Height) forState:UIControlStateNormal];
        
    }
    return _sureBtn;
}

@end
