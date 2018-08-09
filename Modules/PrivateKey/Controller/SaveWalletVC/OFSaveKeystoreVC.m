//
//  OFSaveKeystoreVC.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//  备份Keystore文件

#import "OFSaveKeystoreVC.h"
#import "OFQRcodeView.h"
#import "OFProWalletListVC.h"


@interface OFSaveKeystoreVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *contentLabel;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) OFQRcodeView *bottomView;
@end

@implementation OFSaveKeystoreVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"备份Keystore";
    [self initUI];
    [self layout];
    [self initData];
}

//- (void)returnBack{
//    [self.navigationController popToRootViewControllerAnimated:YES];
//}

- (void)initUI{
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.contentLabel];
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
        make.height.mas_equalTo(100);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(40);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.saveBtn.mas_bottom).offset(50);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-50);
    }];
    
}


- (void)initData{

    self.contentLabel.text = self.model.keystore;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:self.contentLabel.text];
    
    attrStr.lineSpacing = 5;
    attrStr.font = OF_FONT_DETAILTITLE;
    
    self.contentLabel.attributedText = attrStr;
    
    self.bottomView.name = self.model.name;
    self.bottomView.tipContent = @"二维码中保存了您的Keystore信息，也可以用于恢复钱包，如果需要请将二维码图片保存到安全的地方，不要直接存储在手机内。";
    [self.bottomView setImageContent:self.model.keystore];
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

- (UITextView *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UITextView alloc]init];
        _contentLabel.font = OF_FONT_DETAILTITLE;
        _contentLabel.backgroundColor = [UIColor colorWithRGB:0xfafafa];
        _contentLabel.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
        _contentLabel.textColor = OF_COLOR_TITLE;
        _contentLabel.layer.borderColor = [UIColor colorWithRGB:0xc6c6c6].CGColor;
        _contentLabel.layer.borderWidth = 0.5;
        _contentLabel.editable = NO;
    }
    return _contentLabel;
}

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithTitle:@"复制Keystore" titleColor:[UIColor whiteColor] backgroundColor:[UIColor whiteColor] font:OF_FONT_DETAILTITLE target:self action:@selector(saveBtnClick)];
        
        [_saveBtn setBackgroundImage:OF_IMAGE_DRADIENT(234, 41) forState:UIControlStateNormal];
        _saveBtn.layer.cornerRadius = 5.0;
        _saveBtn.layer.masksToBounds = YES;
    }
    return _saveBtn;
}

- (OFQRcodeView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[OFQRcodeView alloc]init];
        _bottomView.saveType = OFProSaveKeystore;
    }
    return _bottomView;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor clearColor];
    }
    return _scrollView;
}

@end
