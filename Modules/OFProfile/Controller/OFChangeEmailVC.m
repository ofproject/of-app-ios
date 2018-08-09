//
//  OFChangeEmailVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFChangeEmailVC.h"
#import "OFInputView.h"

@interface OFChangeEmailVC ()

@property (nonatomic, strong) OFInputView *emailView;

@property (nonatomic, strong) OFInputView *passwordView;

@property (nonatomic, strong) UIButton *sureBtn;

@end

@implementation OFChangeEmailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改邮箱";
    
    [self.view addSubview:self.emailView];
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.sureBtn];
    
    CGFloat padding = [NUIUtil fixedWidth:60];
    
    [self.emailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo([NUIUtil fixedHeight:75]);
        
        make.height.mas_equalTo(35);
        
    }];

    [self.passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.emailView.mas_bottom).offset(30);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.right.mas_equalTo(-padding);
        make.height.mas_equalTo(Btn_Default_Height);
        make.top.mas_equalTo(self.passwordView.mas_bottom).offset(42);
    }];
    
}

- (void)sureBtnClick{
    
    if (![ToolObject isEmailAddress:self.emailView.content]) {
        [MBProgressHUD showError:@"邮箱格式不正确"];
        return;
    }
    
    if (self.passwordView.content.length < 1) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    WEAK_SELF;
    [OFNetWorkHandle changeEmailWithNewemail:self.emailView.content password:[NDataUtil md5:self.passwordView.content] success:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        
//        NSString *code = [NDataUtil stringWith:dict[@"code"] valid:@""];
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        if (status == 200) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD showSuccess:@"修改成功!"];
            
        }else if(status == 405){
            [MBProgressHUD showError:@"密码错误"];
        }else{
            [MBProgressHUD showError:@"网络错误,请重试"];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [MBProgressHUD showError:@"网络错误,请重试"];
    }];
    
}

- (OFInputView *)emailView{
    if (!_emailView) {
        _emailView = [[OFInputView alloc]initWithPlaceholder:@"输入新邮箱"];
    }
    return _emailView;
}

- (OFInputView *)passwordView{
    if (!_passwordView) {
        _passwordView = [[OFInputView alloc]initWithPlaceholder:@"输入新密码"];
        _passwordView.secureTextEntry = YES;
    }
    return _passwordView;
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



@end
