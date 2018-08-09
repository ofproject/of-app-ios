//
//  OFBackupWalletController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBackupWalletController.h"
#import "OFBackupWordsController.h"

#import "OFSaveWordsVC.h"
#import "OFSaveKeystoreVC.h"
#import "OFSavePrivateVC.h"

#import "OFCipherManager.h"
#import "OFProWalletModel.h"

#import "OFProWelcomeVC.h"
#import "OFProWalletModel.h"

#define kMargin_Left    KWidthFixed(20.f)
#define kMargin_Top     KWidthFixed(20.f)
#define kButtonHeight   KHeightFixed(40.f)
#define kIcon_Width     KHeightFixed(60.f)

@interface OFBackupWalletController ()

@property (nonatomic, strong) UIImageView *walletIcon;
@property (nonatomic, strong) UILabel *stepLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIButton *backup;
@property (nonatomic, strong) UIButton *keystoreBtn;
@property (nonatomic, strong) UIButton *privateBtn;
@property (nonatomic, copy) NSString *privateKey;

@end

@implementation OFBackupWalletController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"备份钱包";
    [self initUI];
//    [self initData];
}

- (void)initUI{
    [self.view addSubview:self.walletIcon];
    [self.view addSubview:self.stepLabel];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.backup];
    [self.view addSubview:self.keystoreBtn];
    [self.view addSubview:self.privateBtn];
    
    [self.walletIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(kMargin_Top * 3);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(kIcon_Width);
        make.height.mas_equalTo(kIcon_Width);
    }];
    
    [self.stepLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.walletIcon.mas_bottom).offset(kMargin_Top * 3);
        make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Left);
        make.height.mas_equalTo(KHeightFixed(20));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.stepLabel.mas_bottom).offset(kMargin_Top * 2);
        make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Left);
        make.height.mas_equalTo(KHeightFixed(60));
    }];
    
    [self.backup mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kMargin_Top * 2);
        make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Left);
        make.height.mas_equalTo(kButtonHeight);
    }];
    
    [self.keystoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Left);
        make.height.mas_equalTo(kButtonHeight);
        make.top.mas_equalTo(self.backup.mas_bottom).offset(kMargin_Top * 2);
    }];
    
    [self.privateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.keystoreBtn.mas_bottom).offset(kMargin_Top * 2);
        make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Left);
        make.height.mas_equalTo(kButtonHeight);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.model.words.length != 24) {
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRGB:0xd6d6d6]];
        [self.backup setBackgroundImage:image forState:UIControlStateNormal];
        [self.backup setTitle:@"已备份" forState:UIControlStateNormal];
        self.backup.userInteractionEnabled = NO;
    }else{
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_backup setBackgroundImage:image forState:UIControlStateNormal];
        [_backup setTitle:@"备份助记词" forState:UIControlStateNormal];
        self.backup.userInteractionEnabled = YES;
    }
    
}

- (void)initData{
    
}

#pragma mark - Action
- (void)myBtnClick:(UIButton *)btn{
    
    dispatch_block_t block;
    WEAK_SELF;
    if (btn == self.backup) {
        block = ^{[weakSelf backupWallet];};
    }
    if (btn == self.keystoreBtn) {
        block = ^{[weakSelf keystoreBtnClick];};
    }
    if (btn == self.privateBtn) {
        block = ^{[weakSelf privateBtnClick];};
    }
    
    [self alertAction:block];
    
}

- (void)backupWallet{
    OFSaveWordsVC *vc = [[OFSaveWordsVC alloc] init];
//    vc.words = [NDataUtil stringWith:self.model.words valid:@""];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
//    [JumpUtil popVC:[OFProWelcomeVC class] current:self];
}

- (void)keystoreBtnClick{
    OFSaveKeystoreVC *vc = [[OFSaveKeystoreVC alloc]init];
//    vc.keystore = [NDataUtil stringWith:self.model.keystore valid:@""];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
//    [JumpUtil popVC:[OFProWelcomeVC class] current:self];
}

- (void)privateBtnClick{
    OFSavePrivateVC *vc = [[OFSavePrivateVC alloc]init];
    vc.privatekey = self.privateKey;
    vc.name = self.model.name;
    [self.navigationController pushViewController:vc animated:YES];
    
}


- (void)alertAction:(dispatch_block_t)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"请输入密码";
    }];
    WEAK_SELF;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSLog(@"password,%@",textField.text);
    

        [MBProgressHUD showMessage:@"验证中..." toView:weakSelf.view];
        NSLog(@"%@,%@",weakSelf.model.keystore,weakSelf.model.address);
        [OFCipherManager getWalletScryptoKeyWithPassword:textField.text keystore:[NDataUtil stringWith:weakSelf.model.keystore valid:@""] address:[NDataUtil stringWith:weakSelf.model.address valid:@""] finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
            [MBProgressHUD hideHUDForView:self.view];
            if (success) {
                weakSelf.privateKey = [NDataUtil stringWith:obj valid:@"--"];
                if (block) {
                    block();
                }
            }else{
                [MBProgressHUD showToast:@"密码输入错误" toView:weakSelf.view];
            }
        }];
        
    }];
    
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    NSString *key = @"_titleTextColor";
    [sureAction setValue:OF_COLOR_MAIN_THEME forKey:key];
    [cancleAction setValue:Cancle_Color forKey:key];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

// 备份助记词
- (void)executeBackup {
    OFBackupWordsController *controller = [[OFBackupWordsController alloc] init];
    controller.works = self.model.words;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - lazy load
- (UIImageView *)walletIcon
{
    if (!_walletIcon) {
        _walletIcon = [[UIImageView alloc] initWithImage: IMAGE_NAMED(@"profit_bouns")];
    }
    return _walletIcon;
}

- (UILabel *)stepLabel
{
    if (!_stepLabel) {
        _stepLabel = [UILabel labelWithFont:FixFont(18)
                                  textColor:OF_COLOR_TITLE
                             textAlignement:NSTextAlignmentCenter
                                       text:@"最后一步: 立刻备份您的钱包"];
    }
    return _stepLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithFont:FixFont(14)
                                 textColor:OF_COLOR_MINOR
                            textAlignement:NSTextAlignmentLeft
                                      text:@"tip"];
        _tipLabel.numberOfLines = 0;
        NSString *text = @"可以通过备份助记词、keystore、私钥的方式保存您的钱包，不要将备份信息存储到手机或者网络上，请务必保证备份信息的安全！";
        NSAttributedString *attrText = [text getAttributedStringWithLineSpace:5.f kern:0];
        _tipLabel.attributedText = attrText;
    }
    return _tipLabel;
}

- (UIButton *)backup
{
    if (!_backup) {
        _backup = [UIButton buttonWithTitle:@"备份助记词"
                                 titleColor:OF_COLOR_WHITE
                            backgroundColor:OF_COLOR_CLEAR
                                       font:FixFont(15)];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_backup setBackgroundImage:image forState:UIControlStateNormal];
        _backup.layer.cornerRadius = 5.f;
        _backup.layer.masksToBounds = YES;
        [_backup addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backup;
}

- (UIButton *)keystoreBtn{
    if (!_keystoreBtn) {
        _keystoreBtn = [UIButton buttonWithTitle:@"备份Keystore"
                                 titleColor:OF_COLOR_WHITE
                            backgroundColor:OF_COLOR_CLEAR
                                       font:FixFont(15)];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_keystoreBtn setBackgroundImage:image forState:UIControlStateNormal];
        _keystoreBtn.layer.cornerRadius = 5.f;
        _keystoreBtn.layer.masksToBounds = YES;
        [_keystoreBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _keystoreBtn;
}

- (UIButton *)privateBtn{
    if (!_privateBtn) {
        _privateBtn = [UIButton buttonWithTitle:@"备份私钥"
                                      titleColor:OF_COLOR_WHITE
                                 backgroundColor:OF_COLOR_CLEAR
                                            font:FixFont(15)];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_privateBtn setBackgroundImage:image forState:UIControlStateNormal];
        _privateBtn.layer.cornerRadius = 5.f;
        _privateBtn.layer.masksToBounds = YES;
        [_privateBtn addTarget:self action:@selector(myBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _privateBtn;
}

@end
