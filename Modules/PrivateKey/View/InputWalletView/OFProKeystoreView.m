//
//  OFProKeystoreView.m
//  OFBank
//
//  Created by michael on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//  导出私钥文件

#import "OFProKeystoreView.h"
#import "HMTextView.h"
#import "OFInputView.h"
#import "OFCipherManager.h"
#import "OFProTabBarController.h"
#import "OFProWelcomeVC.h"

@interface OFProKeystoreView ()<UITextViewDelegate>

@property (nonatomic, strong) HMTextView *textView;

@property (nonatomic, strong) OFInputView *passwordView;

@property (nonatomic, strong) UIButton *sureBtn;

@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, strong) UIButton *protocolBtn;

@property (nonatomic, strong) UIButton *helpBtn;

@end

@implementation OFProKeystoreView

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
    [self addSubview:self.agreeBtn];
    [self addSubview:self.protocolBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.helpBtn];
}

- (void)layout{
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(80);
        make.height.mas_equalTo(100);
    }];
    
    [_passwordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.right.mas_equalTo(-17);
        make.top.mas_equalTo(_textView.mas_bottom).offset(30);
        make.height.mas_equalTo(30);
    }];
    
    [_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(17);
        make.top.mas_equalTo(_passwordView.mas_bottom).offset(10);
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
    
}

- (void)changeSureBtnStatus{
    
    if (self.textView.hasText && self.passwordView.content.length > 0 && self.agreeBtn.isSelected) {

        [self.sureBtn setBackgroundImage:OF_IMAGE_DRADIENT(kScreenWidth, kScreenWidth * 0.4) forState:UIControlStateNormal];
    }else{
        
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithRGB:0xd6d6d6]];
        [_sureBtn setBackgroundImage:image2 forState:UIControlStateNormal];
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    [self changeSureBtnStatus];
}

- (void)sureBtnClick{
    NSLog(@"确定...");
    
    if (!self.agreeBtn.isSelected) {
        return;
    }
    
    if (self.textView.text.length < 1) {
//        [MBProgressHUD showError:@"请输入Keystore信息"];
        return;
    }
    
    if (self.passwordView.content.length < 1) {
//        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    
    if (!self.agreeBtn.isSelected) {
        return;
    }
    
    NSDictionary *dict = [NDataUtil getDictWithString:self.textView.text];
    
    NSString *address = [NSString stringWithFormat:@"0x%@",[NDataUtil stringWith:dict[@"address"] valid:@""]];
    
    [KcurUser.proWallets enumerateObjectsUsingBlock:^(OFProWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.address isEqualToString:address]) {
            [MBProgressHUD showError:@"已经拥有该钱包了"];
            return ;
        }
    }];
    
    [OFCipherManager getWalletScryptoKeyWithPassword:self.passwordView.content keystore:self.textView.text address:address finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
        if (success) {
            
            OFProWalletModel *model = [[OFProWalletModel alloc]init];
            
            model.address = address;
            NSInteger count = KcurUser.proWallets.count;
            model.name = [NSString stringWithFormat:@"OF %zd",count+1];
            model.keystore = self.textView.text;
            model.words = @"";
            
            [KcurUser.proWallets addObject:model];
            [KUserManager updateCanseeState];
            KcurUser.currentProWallet = model;
            [MBProgressHUD showSuccess:@"导入成功"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:OF_PRO_ADDRESS_NOTI object:[NSNumber numberWithBool:YES]];
            [JumpUtil popVC:[OFProWelcomeVC class] current:self.viewController];
            [self.viewController.navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showError:@"导入失败,请重新尝试!"];
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
}

- (HMTextView *)textView{
    if(_textView == nil){
        _textView = [[HMTextView alloc]init];
        _textView.placehoder = @"直接粘贴Keystore内容";
        _textView.layer.borderColor = [UIColor colorWithRGB:0xc6c6c6].CGColor;
        _textView.layer.borderWidth = 0.5;
    }
    return _textView;
}

- (OFInputView *)passwordView{
    if(_passwordView == nil){
        _passwordView = [[OFInputView alloc]initWithPlaceholder:@"请输入原资金密码"];
        _passwordView.secureTextEntry = YES;
    }
    return _passwordView;
}

- (UIButton *)sureBtn{
    
    if(_sureBtn == nil){
        _sureBtn = [UIButton buttonWithTitle:@"确认导入" titleColor:[UIColor whiteColor] backgroundColor:OF_COLOR_MAIN_THEME font:[NUIUtil fixedFont:15] target:self action:@selector(sureBtnClick)];
        
        
        UIImage *image2 = [UIImage imageWithColor:[UIColor colorWithRGB:0xd6d6d6]];
        [_sureBtn setBackgroundImage:image2 forState:UIControlStateNormal];
        
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
        _helpBtn = [UIButton buttonWithTitle:@"什么是Keystore?" titleColor:[UIColor colorWithRGB:0xff9e50] backgroundColor:[UIColor clearColor] font:[NUIUtil fixedFont:14]];
        [_helpBtn addTarget:self action:@selector(helpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _helpBtn;
}

@end
