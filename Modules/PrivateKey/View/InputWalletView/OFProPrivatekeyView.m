//
//  OFProPrivatekeyView.m
//  OFBank
//
//  Created by michael on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProPrivatekeyView.h"
#import "HMTextView.h"
#import "OFInputView.h"
#import "OFCipherManager.h"
#import "OFProWelcomeVC.h"
#import "OFProTabBarController.h"

@interface OFProPrivatekeyView ()<UITextViewDelegate>

@property (nonatomic, strong) HMTextView *textView;

@property (nonatomic, strong) OFInputView *passwordView;

@property (nonatomic, strong) OFInputView *repeatPwdView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UIButton *protocolBtn;

@property (nonatomic, strong) UIButton *helpBtn;

@end

@implementation OFProPrivatekeyView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        [self initUI];
        [self layout];
        [self addListener];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.textView];
    [self addSubview:self.passwordView];
    [self addSubview:self.repeatPwdView];
    [self addSubview:self.agreeBtn];
    [self addSubview:self.protocolBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.helpBtn];
}

- (void)layout{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(80);
        make.height.mas_equalTo(100);
    }];
    
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(15);
        make.top.mas_equalTo(_textView.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    [_repeatPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(15);
        make.top.mas_equalTo(_passwordView.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(_repeatPwdView.mas_bottom).offset(10);
    }];
    
    [_protocolBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_agreeBtn.mas_right);
        make.centerY.mas_equalTo(_agreeBtn.mas_centerY);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_protocolBtn.mas_bottom).offset(42);
        make.width.mas_equalTo(234);
        make.height.mas_equalTo(37.5);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [_helpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_sureBtn.mas_bottom).offset(46);
    }];
}

- (void)addListener{
    self.textView.delegate = self;
    WEAK_SELF;
    [self.passwordView addObserverBlockForKeyPath:@"content" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        [weakSelf changeSureBtnStatus];
    }];
    
    [self.repeatPwdView addObserverBlockForKeyPath:@"content" block:^(id  _Nonnull obj, id  _Nullable oldVal, id  _Nullable newVal) {
        [weakSelf changeSureBtnStatus];
    }];
    
}

- (void)textViewDidChange:(UITextView *)textView{
    [self changeSureBtnStatus];
}

- (void)changeSureBtnStatus{
    
    if (self.textView.hasText && self.passwordView.content.length > 0 && self.repeatPwdView.content.length > 0 && self.agreeBtn.isSelected) {
        
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_sureBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        
        [self.sureBtn setBackgroundImage:image forState:UIControlStateNormal];
    }else{
        
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRGB:0xd6d6d6]];
        [_sureBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    
    
}


- (void)sureBtnClick{
    NSLog(@"确定...");
    
    if (!self.agreeBtn.isSelected) {
        return;
    }
    
    if (self.textView.text.length < 1) {
//        [MBProgressHUD showError:@"请输入私钥明文"];
        return;
    }
    
    if (self.repeatPwdView.content.length < 1) {
        return;
    }
    
    if (self.passwordView.content.length < 1) {
        return;
    }
    
    if (self.passwordView.content.length < 8) {
        [MBProgressHUD showError:@"资金密码应不少于8位"];
        return;
    }
    
    if (![self.passwordView.content isEqualToString:self.repeatPwdView.content]) {
        [MBProgressHUD showError:@"两次输入的资金密码不一致"];
        return;
    }
    
    [OFCipherManager getKeystoreByPrikey:self.textView.text appcode:@"7" sccode:@"156" password:self.passwordView.content finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
        
        if (success) {
            
            OFProWalletModel *model = [[OFProWalletModel alloc]init];
            
            model.keystore = obj;
            NSInteger count = KcurUser.proWallets.count;
            model.name = [NSString stringWithFormat:@"OF %zd",count+1];
            NSDictionary *dict = [NDataUtil getDictWithString:model.keystore];
            
//            NSString *address = [NDataUtil stringWith:dict[@"address"] valid:@"--"];
            model.address = [NSString stringWithFormat:@"0x%@",[NDataUtil stringWith:dict[@"address"] valid:@""]];;
            
            __block BOOL isHave = NO;
            [KcurUser.proWallets enumerateObjectsUsingBlock:^(OFProWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj.address isEqualToString:model.address]) {
                    [MBProgressHUD showError:@"已经拥有该钱包了"];
                    isHave = YES;
                    *stop = YES;
                }
            }];
            if (isHave) {
                return ;
            }
            [KcurUser.proWallets addObject:model];
            [KUserManager updateCanseeState];
            KcurUser.currentProWallet = model;
            [[NSNotificationCenter defaultCenter] postNotificationName:OF_PRO_ADDRESS_NOTI object:[NSNumber numberWithBool:YES]];
            [JumpUtil popVC:[OFProWelcomeVC class] current:self.viewController];
            [self.viewController.navigationController popViewControllerAnimated:YES];
            
        }else{
            [MBProgressHUD showError:@"导入失败,请重试"];
        }
        
    }];
    
}

- (void)setContent:(NSString *)content{
    if ([_content isEqualToString:content]) {
        return;
    }
    
    _content = [content copy];
    self.textView.text = content;
}

- (void)agreeBtnClick{
    self.agreeBtn.selected = !self.agreeBtn.selected;
    [self changeSureBtnStatus];
}

- (void)protocolBtnClick{
    // 跳转协议
}

- (void)helpBtnClick{
    
}

- (void)dealloc{
    [self.passwordView removeObserverBlocksForKeyPath:@"content"];
    [self.repeatPwdView removeObserverBlocksForKeyPath:@"content"];
}

- (HMTextView *)textView{
    if(_textView == nil){
        _textView = [[HMTextView alloc]init];
        _textView.placehoder = @"请输入私钥明文";
        _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textView.layer.borderWidth = 0.5;
    }
    return _textView;
}

- (OFInputView *)passwordView{
    if(_passwordView == nil){
        _passwordView = [[OFInputView alloc]initWithPlaceholder:@"请输入新资金密码"];
        _passwordView.secureTextEntry = YES;
    }
    return _passwordView;
}

- (OFInputView *)repeatPwdView{
    if(_repeatPwdView == nil){
        _repeatPwdView = [[OFInputView alloc]initWithPlaceholder:@"再次输入新资金密码"];
        _repeatPwdView.secureTextEntry = YES;
    }
    return _repeatPwdView;
}

- (UIButton *)sureBtn{
    
    if(_sureBtn == nil){
        _sureBtn = [UIButton buttonWithTitle:@"确认导入" titleColor:[UIColor whiteColor] backgroundColor:OF_COLOR_MAIN_THEME font:[NUIUtil fixedFont:15] target:self action:@selector(sureBtnClick)];
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRGB:0xd6d6d6]];
        [_sureBtn setBackgroundImage:image forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 5.0;
        _sureBtn.layer.masksToBounds = YES;
    }
    return _sureBtn;
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

- (UIButton *)helpBtn{
    if (!_helpBtn) {
        _helpBtn = [UIButton buttonWithTitle:@"什么是私钥?" titleColor:[UIColor colorWithRGB:0xff9e50] backgroundColor:[UIColor clearColor] font:[NUIUtil fixedFont:14]];
        [_helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}

@end
