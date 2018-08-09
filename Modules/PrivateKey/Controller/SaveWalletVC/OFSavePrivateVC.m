//
//  OFSavePrivateVC.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//  备份私钥明文

#import "OFSavePrivateVC.h"
#import "OFCipherManager.h"

#import "OFProWalletModel.h"
#import "OFProWalletListVC.h"
#import "OFProTabBarController.h"
#import "OFQRcodeView.h"

@interface OFSavePrivateVC ()

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) YYLabel *contentLabel;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) OFQRcodeView *bottomView;

@end

@implementation OFSavePrivateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"备份私钥";
    
    [self initUI];
    [self layout];
    [self initData];
}

- (void)initUI{
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.contentLabel];
    [self.scrollView addSubview:self.tipLabel];
    [self.scrollView addSubview:self.saveBtn];
    [self.scrollView addSubview:self.bottomView];
}

- (void)layout{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(15);
    }];
    
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(15);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(15);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.saveBtn.mas_bottom).offset(50);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-50);
    }];
    
}

- (void)initData{
    
    self.contentLabel.text = self.privatekey;
    
    
    self.bottomView.name = [NDataUtil stringWith:self.name valid:@"OF"];
    
    self.bottomView.tipContent = @"二维码中保存了您的私钥信息，也可以用于恢复钱包，如果需要请将二维码图片保存到安全的地方，不要直接存储在手机内。";
    
    [self.bottomView setImageContent:self.privatekey];
    
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

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.numberOfLines = 0;
        _tipLabel.font = OF_FONT_MINOR;
        _tipLabel.text = @"安全警告：私钥未经加密，导出存在风险，建议使用助记词或Keystore进行备份，如需备份私钥，请务必妥善保管！";
    }
    return _tipLabel;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithTitle:@"复制私钥" titleColor:[UIColor whiteColor] backgroundColor:[UIColor whiteColor] font:OF_FONT_DETAILTITLE target:self action:@selector(saveBtnClick)];
        
        [_saveBtn setBackgroundImage:OF_IMAGE_DRADIENT(234, 41) forState:UIControlStateNormal];
        
        _saveBtn.layer.cornerRadius = 5.0;
        _saveBtn.layer.masksToBounds = YES;
        
    }
    return _saveBtn;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

- (OFQRcodeView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[OFQRcodeView alloc]init];
        _bottomView.saveType = OFProSavePrivate;
    }
    return _bottomView;
}

@end
