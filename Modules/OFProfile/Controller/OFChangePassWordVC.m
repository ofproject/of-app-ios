//
//  OFChangePassWordVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFChangePassWordVC.h"
#import "OFInputView.h"
#import "OFLoginLogic.h"

@interface OFChangePassWordVC ()

@property (nonatomic, strong) OFInputView *oldPasswordView;

@property (nonatomic, strong) OFInputView *passwordView;

@property (nonatomic, strong) OFInputView *againPasswordView;

@property (nonatomic, strong) UIButton *sureBtn;
//逻辑处理层
@property (nonatomic, strong) OFLoginLogic *logic;

@end

@implementation OFChangePassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *title = NSLocalizedString(@"changePassword", nil);
    self.title = @"修改密码";
    self.logic = [[OFLoginLogic alloc] initWithDelegate:nil];
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
        [MBProgressHUD showError:@"原密码不能为空"];
        return;
    }
    
    if (self.passwordView.content.length < 1) {
        [MBProgressHUD showError:@"新密码不能为空"];
        return;
    }
    
    if (![self.againPasswordView.content isEqualToString:self.passwordView.content]) {
        [MBProgressHUD showError:@"两次新密码不一致"];
        return;
    }
    
    if ([self.passwordView.content isEqualToString:self.oldPasswordView.content]) {
        [MBProgressHUD showError:@"新旧密码不能一致"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WEAK_SELF;
    [self.logic changePasswordWithOldPwd:self.oldPasswordView.content password:self.passwordView.content finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"修改成功"];
        } else {
            [MBProgressHUD showError:errorMessage];
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
        
        [_sureBtn setBackgroundImage:[UIImage makeGradientImageWithRect:CGRectMake(0, 0, kScreenWidth-KWidthFixed(120), Btn_Default_Height) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
        
    }
    return _sureBtn;
}



@end
