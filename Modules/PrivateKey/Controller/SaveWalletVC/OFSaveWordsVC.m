//
//  OFSaveWordsVC.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//  备份助记词

#import "OFSaveWordsVC.h"
#import "OFQRcodeView.h"
#import "OFProWalletListVC.h"


@interface OFSaveWordsVC ()

@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) OFQRcodeView *bottomView;

@end

@implementation OFSaveWordsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"备份助记词";
    
    [self initUI];
    [self layout];
    [self initData];
    
    [self addNavigationItemWithTitles:@[@"完成"] isLeft:NO target:self action:@selector(completeSave) tags:nil];
    
}

- (void)initUI{
    [self.view addSubview:self.contentLabel];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.bottomView];
}

- (void)layout{
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(15);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(15);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50);
    }];
    
}

- (void)initData{
    
    self.contentLabel.text = self.model.words;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.contentLabel.text];
    
    attrStr.lineSpacing = 5;
    attrStr.font = OF_FONT_DETAILTITLE;
    
    self.contentLabel.attributedText = attrStr;
    
    self.bottomView.name = self.model.name;
    [self.bottomView setImageContent:self.model.words];
    
}

- (void)completeSave{
    // 完成保存
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您已经妥善保管钱包助记词了吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        // 确定了。
        
        [KcurUser.proWallets enumerateObjectsUsingBlock:^(OFProWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.address isEqualToString:self.model.address]) {
                obj.words = @"";
                *stop = YES;
            }
        }];
        [KUserManager updateCanseeState];
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

- (void)saveBtnClick{
    
    if (self.contentLabel.text.length < 1) {
        return;
    }
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.contentLabel.text;
    //    NSString *title = NSLocalizedString(@"copysuccess", nil);
    [MBProgressHUD showSuccess:@"已经复制到粘贴板!"];
    
}

- (YYLabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[YYLabel alloc]init];
        _contentLabel.font = OF_FONT_DETAILTITLE;
        _contentLabel.backgroundColor = [UIColor colorWithRGB:0xfafafa];
        _contentLabel.numberOfLines = 0;
        _contentLabel.preferredMaxLayoutWidth = kScreenWidth - 30;
        _contentLabel.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
        _contentLabel.textColor = OF_COLOR_TITLE;
        _contentLabel.layer.borderColor = [UIColor colorWithRGB:0xc6c6c6].CGColor;
        _contentLabel.layer.borderWidth = 0.5;
    }
    return _contentLabel;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithTitle:@"复制助记词" titleColor:[UIColor whiteColor] backgroundColor:[UIColor whiteColor] font:OF_FONT_DETAILTITLE target:self action:@selector(saveBtnClick)];
        
        [_saveBtn setBackgroundImage:OF_IMAGE_DRADIENT(234, 41) forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius = 5.0;
        _saveBtn.layer.masksToBounds = YES;
    }
    return _saveBtn;
}


- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.backgroundColor = [UIColor whiteColor];
        _tipLabel.text = @"助记词用于恢复钱包和重置资金密码，请妥善保管！";
    }
    return _tipLabel;
}

- (OFQRcodeView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[OFQRcodeView alloc]init];
        _bottomView.saveType = OFProSaveWords;
    }
    return _bottomView;
}

@end
