//
//  OFCreatAddressVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//  创建新地址

#import "OFCreatAddressVC.h"
#import "OFTabBarController.h"

#import "OFWalletModel.h"

const CGFloat tipFont = 10.0;
const NSString *warningText = @"1.OF不会保存您的资金密码;\n2.资金密码只能设置一次;\n3.资金密码不可修改，不可找回";

@interface OFCreatAddressVC ()

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *tipsLabel;

@property (nonatomic, strong) UILabel *tip1Label;
@property (nonatomic, strong) UILabel *tip2Label;

@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UITextField *aginstTextField;

@property (nonatomic, strong) UIView *line1View;

@property (nonatomic, strong) UIView *line2View;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIView *noticeView;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIButton *noticeSureBtn;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, assign) BOOL isFirst;

@end


@implementation OFCreatAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资金密码";
    [self initUI];
    [self layout];
    if (self.hiddenBack) {
        self.isShowLiftBack = NO;
        self.n_isPop = NO;
    }
    self.bgView.hidden = YES;
    
}

- (void)initUI{
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.line1View];
    [self.view addSubview:self.tipsLabel];
    [self.view addSubview:self.aginstTextField];
    [self.view addSubview:self.line2View];
    [self.view addSubview:self.tip1Label];
    [self.view addSubview:self.tip2Label];
    [self.view addSubview:self.sureBtn];
    
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.noticeView];
    [self.noticeView addSubview:self.titleLabel];
    [self.noticeView addSubview:self.contentLabel];
    [self.noticeView addSubview:self.noticeSureBtn];
}

- (void)layout{
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo([NUIUtil fixedHeight:42]);
    }];
    
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset([NUIUtil fixedHeight:50]);
    }];
    
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(175, 3));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.passwordTextField.mas_bottom).offset(10);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(0);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.line1View.mas_bottom).offset(10);
    }];
    
    [self.aginstTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.line1View.mas_bottom).offset([NUIUtil fixedHeight:47]);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(175, 3));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.aginstTextField.mas_bottom).offset(10);
    }];
    
    [self.tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(70);
        make.top.mas_equalTo(self.sureBtn.mas_bottom).offset(33);
    }];

    [self.tipsLabel sizeToFit];
    [self.tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tip1Label);
        make.width.mas_equalTo(self.tipsLabel.width);
        make.top.mas_equalTo(self.tip1Label.mas_bottom).offset(13);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(Btn_Default_Height);
        make.width.mas_equalTo(KWidthFixed(225));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.line2View.mas_bottom).offset([NUIUtil fixedHeight:55]);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.noticeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWidthFixed(272));
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-30.f);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.noticeView);
        make.top.mas_equalTo(self.noticeView.mas_top).offset(25);
        make.height.mas_equalTo(17);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.noticeView.mas_left).offset(20);
        make.right.mas_equalTo(self.noticeView.mas_right).offset(-20);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(30);
    }];
    
    [self.noticeSureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(39);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(KWidthFixed(37.5));
        make.width.mas_equalTo(KWidthFixed(80));
        make.bottom.mas_equalTo(self.noticeView.mas_bottom).offset(-30);
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (!self.isFirst) {
        self.isFirst = YES;
        [self starAnimation];
    }
}

- (void)sureBtnClick{
    
    if (KcurUser.wallets.count >= 5) {
        [MBProgressHUD showError:@"您的钱包已经达到上限不能创建啦~~~"];
        return;
    }
    
    if (![ToolObject isValidatePassword:self.passwordTextField.text]) {
        [MBProgressHUD showError:@"密码安全级别不够,请重新输入"];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.aginstTextField.text]) {
        [MBProgressHUD showError:@"两次密码不一致"];
        return;
    }
    [self getWalletAddress];
    
}
- (void)starAnimation{
    
    self.bgView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.noticeView.hidden = NO;
        [self.view layoutIfNeeded];
    }];
}




- (void)getWalletAddress{
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"创建中" toView:self.view];
    
    WEAK_SELF;
    [OFNetWorkHandle creatWalletAddressWithPassword:[NDataUtil md5:self.passwordTextField.text] success:^(NSDictionary *dict) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
//        NSString *code = [NDataUtil stringWith:dict[@"code"] valid:@""];
        NSLog(@"%@",dict);
        NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
        if (status == 200) {
            
//            NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
//            NSArray *array = [NDataUtil arrayWith:dict[@"data"]];
            NSArray *wallets = [NDataUtil arrayWith:dict[@"data"]];
            NSLog(@"%@",wallets);
            NSArray *tempArray = [NSArray modelArrayWithClass:[OFWalletModel class] json:wallets];
            NSLog(@"%@",tempArray);
            if (tempArray.count) {
                [KcurUser.wallets addObjectsFromArray:tempArray];
            }
            NSLog(@"%@",KcurUser.wallets);
            if (!KcurUser.currentWallet) {
                if (KcurUser.wallets.count) {
                    KcurUser.currentWallet = KcurUser.wallets.firstObject;
                }
            }
            [KUserManager saveUserInfo];
            
            [weakSelf returnBack];
            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLoginStateChange object:@(YES)];
            
            [MBProgressHUD showSuccess:@"创建成功"];
        }else{
            [MBProgressHUD showError:@"创建失败,请稍后再试!"];
            BLYLogError(@"创建地址失败");
        }
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view];
        [MBProgressHUD showError:@"网络异常"];
        BLYLogError(@"创建地址网络异常 - %zd",error.code);
    }];
}

- (void)noticeSureBtnClick{
    [self.view endEditing:YES];
    [self.noticeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kScreenHeight);
    }];
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.bgView.hidden = YES;
//        [self getWalletAddress];
    }];

}

//- (void)cancleCreatAddress{
//
//    [self.noticeView mas_updateConstraints:^(MASConstraintMaker *make) {
//
//    }];
//
//    [UIView animateWithDuration:0.3 animations:^{
//        [self.view layoutIfNeeded];
//    } completion:^(BOOL finished) {
//
//    }];
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = [UIFont systemFontOfSize:13];
        _addressLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    return _addressLabel;
}

- (UITextField *)passwordTextField{
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.borderStyle = UITextBorderStyleNone;
        _passwordTextField.font = [UIFont systemFontOfSize:16];
        _passwordTextField.placeholder = @"请设置资金密码";
        _passwordTextField.textAlignment = NSTextAlignmentCenter;
        _passwordTextField.secureTextEntry = YES;
    }
    return _passwordTextField;
}

- (UIView *)line1View{
    if (!_line1View) {
        _line1View = [[UIView alloc]init];
        _line1View.backgroundColor = OF_COLOR_MAIN_THEME;
    }
    return _line1View;
}

- (UILabel *)tipsLabel{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc]init];
        _tipsLabel.textColor = OF_COLOR_DETAILTITLE;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
        _tipsLabel.font = [NUIUtil fixedFont:tipFont];
        _tipsLabel.text = @"资金密码必须包含大写字母，小写字母和数字，在8位与16位之间";
    }
    return _tipsLabel;
}


- (UILabel *)tip1Label{
    if (!_tip1Label) {
        _tip1Label = [[UILabel alloc]init];
        _tip1Label.textColor = [UIColor colorWithRGB:0xe84343];
        _tip1Label.textAlignment = NSTextAlignmentCenter;
        _tip1Label.font = [NUIUtil fixedFont:14];
        _tip1Label.numberOfLines = 0;
        _tip1Label.text = @"安全警示";
    }
    return _tip1Label;
}

- (UILabel *)tip2Label{
    if (!_tip2Label) {
        _tip2Label = [[UILabel alloc]init];
        _tip2Label.textColor = [UIColor colorWithRGB:0xff3131];
        _tip2Label.textAlignment = NSTextAlignmentLeft;
        _tip2Label.font = [NUIUtil fixedFont:13];
        _tip2Label.numberOfLines = 0;
        NSAttributedString *attrText = [warningText getAttributedStringWithLineSpace:10.f kern:0.f];
        _tip2Label.attributedText = attrText;
    }
    return _tip2Label;
}



- (UITextField *)aginstTextField{
    if (!_aginstTextField) {
        _aginstTextField = [[UITextField alloc]init];
        _aginstTextField.borderStyle = UITextBorderStyleNone;
        _aginstTextField.font = [UIFont systemFontOfSize:16];
        _aginstTextField.placeholder = @"最后一次设置资金密码";
        _aginstTextField.textAlignment = NSTextAlignmentCenter;
        _aginstTextField.secureTextEntry = YES;
    }
    return _aginstTextField;
}

- (UIView *)line2View{
    if (!_line2View) {
        _line2View = [[UIView alloc]init];
        _line2View.backgroundColor = OF_COLOR_MAIN_THEME;
    }
    return _line2View;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [NUIUtil fixedFont:16];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        _sureBtn.layer.cornerRadius = 5.0;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setBackgroundImage:[UIImage makeGradientImageWithRect:CGRectMake(0, 0, KWidthFixed(225), Btn_Default_Height) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
    }
    return _sureBtn;
}

- (UIView *)noticeView{
    if (!_noticeView) {
        _noticeView = [[UIView alloc]init];
        _noticeView.backgroundColor = [UIColor whiteColor];
        ViewRadius(_noticeView, 5);
        _noticeView.hidden = YES;
    }
    return _noticeView;
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:CGRectZero];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancleCreatAddress)];
//        [_bgView addGestureRecognizer:tap];
//        _bgView.userInteractionEnabled = YES;
    }
    return _bgView;
}

- (UIButton *)noticeSureBtn{
    if (!_noticeSureBtn) {
        _noticeSureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _noticeSureBtn.titleLabel.font = Font(16);
        [_noticeSureBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        [_noticeSureBtn setTitle:@"知道了" forState:UIControlStateNormal];
        [_noticeSureBtn addTarget:self action:@selector(noticeSureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_noticeSureBtn setBackgroundImage:[UIImage makeGradientImageWithRect:CGRectMake(0, 0, 69.5, 25) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
        ViewRadius(_noticeSureBtn, 5);
    }
    return _noticeSureBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = OF_COLOR_TITLE;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [NUIUtil fixedFont:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.text = @"安全警示";
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.textColor = OF_COLOR_DETAILTITLE;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [NUIUtil fixedFont:14];
        _contentLabel.numberOfLines = 0;
        NSAttributedString *attrText = [warningText getAttributedStringWithLineSpace:10.f kern:0.f];
        _contentLabel.attributedText = attrText;
    }
    return _contentLabel;
}



@end
