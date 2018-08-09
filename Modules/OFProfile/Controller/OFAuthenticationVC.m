//
//  OFAuthenticationVC.m
//  OFBank
//
//  Created by hukun on 2018/3/9.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFAuthenticationVC.h"
#import "OFInputView.h"
#import "OFLoginLogic.h"

@interface OFAuthenticationVC ()

@property (nonatomic, strong) OFInputView *nameView;

@property (nonatomic, strong) OFInputView *IDCardView;

@property (nonatomic, strong) UIButton *sureBtn;
//逻辑处理层
@property (nonatomic, strong) OFLoginLogic *logic;

@end

@implementation OFAuthenticationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    self.logic = [[OFLoginLogic alloc] initWithDelegate:nil];
    [self initUI];
    [self layout];
    
}

- (void)initUI{
    [self.view addSubview:self.nameView];
    [self.view addSubview:self.IDCardView];
    
    [self.view addSubview:self.sureBtn];
}

- (void)layout{
    CGFloat padding = [NUIUtil fixedWidth:60];
    
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(44);
        
    }];
    
    [self.IDCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.nameView.mas_bottom).offset(30);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.height.mas_equalTo(Btn_Default_Height);
        make.right.mas_equalTo(-padding);
        make.top.mas_equalTo(self.IDCardView.mas_bottom).offset(29);
    }];
    
}


- (void)sureBtnClick{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"认证中..." toView:self.view];
    WEAK_SELF;
    [self.logic authenticationWithName:self.nameView.content IDCard:self.IDCardView.content finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        if (success) {
            [MBProgressHUD showSuccess:@"认证成功!"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [MBProgressHUD showError:messageStr];
        }
    }];
}

- (OFInputView *)nameView{
    if (!_nameView) {
        //        NSString *title = NSLocalizedString(@"newcipher", nil);
        _nameView = [[OFInputView alloc]initWithPlaceholder:@"真实姓名"];
        _nameView.secureTextEntry = NO;
    }
    return _nameView;
}

- (OFInputView *)IDCardView{
    if (!_IDCardView) {
        //        NSString *title = NSLocalizedString(@"againcipher", nil);
        _IDCardView = [[OFInputView alloc]initWithPlaceholder:@"身份证号"];
        _IDCardView.secureTextEntry = NO;
    }
    return _IDCardView;
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
        
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.35}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_sureBtn setBackgroundImage:image forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}


@end
