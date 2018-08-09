//
//  OFCreateWalletController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFCreateWalletController.h"
#import "OFBackupWalletController.h"
#import "OFCipherManager.h"

#import "OFProWalletModel.h"

#import "OFInputView.h"
#import "OFProWelcomeVC.h"

#import "IQPreviousNextView.h"

#define kMargin_Left    KWidthFixed(20.f)
#define kMargin_Top     KWidthFixed(20.f)
#define kTextFieldHeight    KHeightFixed(60.f)
#define kButtonHeight    KHeightFixed(40.f)

@interface OFCreateWalletController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView *warningView;
@property (nonatomic, strong) UILabel *warningLabel;

@property (nonatomic, strong) IQPreviousNextView *backView;

@property (nonatomic, strong) OFInputView *walletName;
@property (nonatomic, strong) OFInputView *walletPwd;
@property (nonatomic, strong) OFInputView *walletPwdRepeat;

@property (nonatomic, strong) UIButton *create;

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UIButton *protocolBtn;


@end

@implementation OFCreateWalletController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"创建钱包";
    [self initUI];
    [self addListener];
//    [self addNoti];
    self.isOpenIQKeyBoardManager = YES;
    
}


- (void)initUI
{
    [self.view addSubview:self.backView];
    
    [self.warningView addSubview:self.warningLabel];
    [self.backView addSubview:self.warningView];
    [self.backView addSubview:self.walletName];
    [self.backView addSubview:self.walletPwd];
    [self.backView addSubview:self.walletPwdRepeat];
    [self.backView addSubview:self.agreeBtn];
    [self.backView addSubview:self.protocolBtn];
    [self.backView addSubview:self.create];
//    [self.view addSubview:self.import];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.warningView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.mas_equalTo(KHeightFixed(70));
    }];
    
    [self.warningLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warningView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.warningView.mas_right).offset(-kMargin_Left);
        make.top.mas_equalTo(self.warningView.mas_top);
        make.bottom.mas_equalTo(self.warningView.mas_bottom);
    }];
    
    [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warningView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.warningView.mas_right).offset(-kMargin_Left);
        make.top.mas_equalTo(self.warningView.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    
    [self.walletPwd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warningView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.warningView.mas_right).offset(-kMargin_Left);
        make.top.mas_equalTo(self.walletName.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    
    [self.walletPwdRepeat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warningView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.warningView.mas_right).offset(-kMargin_Left);
        make.top.mas_equalTo(self.walletPwd.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(kTextFieldHeight);
    }];
    
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(_walletPwdRepeat.mas_bottom).offset(10);
    }];
    
    [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_agreeBtn.mas_right);
        make.centerY.mas_equalTo(_agreeBtn.mas_centerY);
    }];
    
    [self.create mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warningView.mas_left).offset(kMargin_Left * 2);
        make.right.mas_equalTo(self.warningView.mas_right).offset(-kMargin_Left * 2);
        make.top.mas_equalTo(_agreeBtn.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(kButtonHeight);
    }];
}

- (void)addListener{
    
    WEAK_SELF;
    [self.walletName addObserverBlockForKeyPath:@"content" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        [weakSelf changeSureBtnStatus];
    }];
    
    [self.walletPwd addObserverBlockForKeyPath:@"content" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        [weakSelf changeSureBtnStatus];
    }];
    
    [self.walletPwdRepeat addObserverBlockForKeyPath:@"content" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        [weakSelf changeSureBtnStatus];
    }];
}

- (void)changeSureBtnStatus{
    if (self.walletName.content.length > 0
        && self.walletPwd.content.length > 0
        && self.agreeBtn.isSelected
        && self.walletPwdRepeat.content.length > 0) {
        
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_create setBackgroundImage:image forState:UIControlStateNormal];
        
    }else{
        
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRGB:0xd6d6d6]];
        [_create setBackgroundImage:image forState:UIControlStateNormal];
    }
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    NSLog(@"%s - %@",__func__,viewController);
//}
//
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"%s - %@",__func__,viewController);
}

#pragma mark - Action
- (void)createWallet{
    
    if ([self checkInputSteam]) {
//        NSError *error = nil;
        NSString *words = [OFCipherManager generateMemorizingWords];
        if (words.length == 24) {
            [MBProgressHUD showMessage:@"钱包地址生成中" toView:self.view];
            [OFCipherManager generateAddress:words appcode:@"7" sccode:@"156" password:self.walletPwd.content finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
                [MBProgressHUD hideHUDForView:self.view];
                if (error) {
                    NSString *message = [NSString stringWithFormat:@"钱包地址生成失败"];
                    [MBProgressHUD showToast:message toView:self.view];
                }else {
                    
                    OFProWalletModel *model = [[OFProWalletModel alloc]init];
                    model.name = self.walletName.content;
                    model.keystore = obj;
                    model.words = words;
                    NSDictionary *dict = [NDataUtil getDictWithString:model.keystore];
                    
                    NSString *address = [NSString stringWithFormat:@"0x%@",[NDataUtil stringWith:dict[@"address"] valid:@""]];
                    model.address = address;
                    
                    [KcurUser.proWallets addObject:model];
                    
                    [KUserManager updateCanseeState];
                    KcurUser.currentProWallet = model;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:OF_PRO_ADDRESS_NOTI object:[NSNumber numberWithBool:YES]];
                    
                    
                    OFBackupWalletController *controller = [[OFBackupWalletController alloc] init];
//                    controller.words = words;
                    controller.model = model;
//                    NSLog(@"%@,%@",model.keystore,model.address);
                    
                    [JumpUtil popVC:[OFProWelcomeVC class] current:self];
                    
                    [self.navigationController pushViewController:controller animated:YES];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [JumpUtil popVC:self];

                    });
                    
                }
            }];
        }
    }
}

- (BOOL)checkInputSteam{
    if (self.walletName.content.length < 1) {
//        [MBProgressHUD showToast:@"钱包名字不能为空" toView:self.view];
        return NO;
    }else if (self.walletPwd.content.length < 1) {
//        [MBProgressHUD showToast:@"资金密码不能为空" toView:self.view];
        return NO;
    }else if (self.walletPwdRepeat.content.length < 1) {
//        [MBProgressHUD showToast:@"请再次输入资金密码" toView:self.view];
        return NO;
    }else if (self.walletPwd.content.length < 8) {
        [MBProgressHUD showToast:@"资金密码长度不能少于8位" toView:self.view];
        return NO;
    }else if (![self.walletPwd.content isEqualToString:self.walletPwdRepeat.content]) {
        [MBProgressHUD showToast:@"两次输入资金密码不一致,请重新输入" toView:self.view];
        return NO;
    }else if (!self.agreeBtn.isSelected){
        return NO;
    }
    return YES;
}


- (void)agreeBtnClick{
    self.agreeBtn.selected = !self.agreeBtn.selected;
    [self changeSureBtnStatus];
}

- (void)protocolBtnClick{
    // 跳转协议
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)dealloc{
    [self.walletName removeObserverBlocksForKeyPath:@"content"];
    [self.walletPwdRepeat removeObserverBlocksForKeyPath:@"content"];
    [self.walletPwd removeObserverBlocksForKeyPath:@"content"];
}
#pragma mark - lazy load
- (UIView *)warningView
{
    if (!_warningView) {
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        _warningView = [[UIImageView alloc] initWithImage:image];
    }
    return _warningView;
}

- (UILabel *)warningLabel
{
    if (!_warningLabel) {
        _warningLabel = [UILabel labelWithFont:FixFont(15) textColor:OF_COLOR_WHITE textAlignement:NSTextAlignmentLeft text:@"warning"];
        _warningLabel.numberOfLines = 0;
        NSString *text = @"用户密码保护私钥和交易授权, 强度非常重要\nOF不会存储密码,也无法帮您找回, 请务必牢记";
        NSAttributedString *attrText = [text getAttributedStringWithLineSpace:3.f kern:0];
        _warningLabel.attributedText = attrText;
    }
    return _warningLabel;
}

- (OFInputView *)walletName
{
    if (!_walletName) {
        _walletName = [[OFInputView alloc]initWithPlaceholder:@"钱包名称"];
    }
    return _walletName;
}

- (OFInputView *)walletPwd
{
    if (!_walletPwd) {
        _walletPwd = [[OFInputView alloc]initWithPlaceholder:@"密码"];
        
        _walletPwd.secureTextEntry = YES;
    }
    return _walletPwd;
}

- (OFInputView *)walletPwdRepeat
{
    if (!_walletPwdRepeat) {
        _walletPwdRepeat = [[OFInputView alloc]initWithPlaceholder:@"再次输入密码"];
        _walletPwdRepeat.secureTextEntry = YES;
    }
    return _walletPwdRepeat;
}

- (UIButton *)create
{
    if (!_create) {
        _create = [UIButton buttonWithTitle:@"创建钱包"
                                 titleColor:OF_COLOR_WHITE
                            backgroundColor:OF_COLOR_CLEAR font:FixFont(15)];
//        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
//                                                 startPoint:CGPointMake(0, 0.5)
//                                                   endPoint:CGPointMake(1, 0.5)
//                                                 startColor:OF_COLOR_GRADUAL_1
//                                                   endColor:OF_COLOR_GRADUAL_2];
//        [_create setBackgroundImage:image forState:UIControlStateNormal];
        
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRGB:0xd6d6d6]];
        [_create setBackgroundImage:image forState:UIControlStateNormal];
        
        _create.layer.cornerRadius = 5.f;
        _create.layer.masksToBounds = YES;
        [_create addTarget:self action:@selector(createWallet) forControlEvents:UIControlEventTouchUpInside];
    }
    return _create;
}

- (UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreeBtn setImage:[UIImage imageNamed:@"wallet_agree_normal"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"wallet_agree_sellected"] forState:UIControlStateSelected];
        
        [_agreeBtn setTitle:@" 同意" forState:UIControlStateNormal];
        _agreeBtn.titleLabel.font = [NUIUtil fixedFont:11];
        [_agreeBtn setTitleColor:OF_COLOR_MINOR forState:UIControlStateNormal];
        
        [_agreeBtn addTarget:self action:@selector(agreeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _agreeBtn;
}

- (UIButton *)protocolBtn{
    if (!_protocolBtn) {
        _protocolBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_protocolBtn setTitleColor:[UIColor colorWithRGB:0xff9e50] forState:UIControlStateNormal];
        _protocolBtn.titleLabel.font = [NUIUtil fixedFont:11];
        [_protocolBtn setTitle:@"《服务条款与隐私协议》" forState:UIControlStateNormal];
        
        [_protocolBtn addTarget:self action:@selector(protocolBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _protocolBtn;
}

- (IQPreviousNextView *)backView{
    if (!_backView) {
        _backView = [[IQPreviousNextView alloc]init];
    }
    return _backView;
}


@end
