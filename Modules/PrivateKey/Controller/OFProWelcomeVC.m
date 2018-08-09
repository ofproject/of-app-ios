//
//  OFProWelcomeVC.m
//  OFBank
//
//  Created by michael on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProWelcomeVC.h"
#import "OFCreateWalletController.h"
#import "OFImportKeyVC.h"
#import "OFProWalletListVC.h"
#import "OFCipherManager.h"

@interface OFProWelcomeVC ()

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *titleLabe;

@property (nonatomic, strong) UIButton *creatAddrBtn;
@property (nonatomic, strong) UIButton *importAddrBtn;

@end

@implementation OFProWelcomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isShowLiftBack = NO;
    self.n_isPop = NO;
    self.n_isHiddenNavBar = YES;
    self.n_isWhiteStatusBar = NO;
    
    [self initUI];
    [self layout];
    
}

- (void)initUI{
    [self.view addSubview:self.iconView];
    [self.view addSubview:self.titleLabe];
    [self.view addSubview:self.importAddrBtn];
    [self.view addSubview:self.creatAddrBtn];
}

- (void)layout{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    
    [self.titleLabe mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(20);
    }];
    [self.importAddrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(234, 41));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-150);
    }];
    [self.creatAddrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        
        make.bottom.mas_equalTo(self.importAddrBtn.mas_top).offset(-40);
    }];
}

- (void)creatAddrBtnClick{
    OFCreateWalletController *vc = [[OFCreateWalletController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)importAddrBtnClick{
    
//    OFProWalletListVC *vc = [[OFProWalletListVC alloc]init];
    
    OFImportKeyVC *vc = [[OFImportKeyVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UILabel *)titleLabe{
    if(_titleLabe == nil){
        _titleLabe = [[UILabel alloc]init];
        _titleLabe.font = [NUIUtil fixedFont:13];
        _titleLabe.textColor = [UIColor blackColor];
        _titleLabe.text = @"欢迎使用OF.Pro";
    }
    return _titleLabe;
}

- (UIImageView *)iconView{
    if (_iconView == nil){
        _iconView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
    }
    return _iconView;
}

- (UIButton *)creatAddrBtn{
    if (_creatAddrBtn == nil) {
        
        _creatAddrBtn = [UIButton buttonWithTitle:@"创建钱包" titleColor:[UIColor whiteColor] backgroundColor:OF_COLOR_MAIN_THEME font:[NUIUtil fixedFont:15] target:self action:@selector(creatAddrBtnClick)];
    
        [_creatAddrBtn setBackgroundImage:OF_IMAGE_DRADIENT(234, 41) forState:UIControlStateNormal];
        
        _creatAddrBtn.layer.cornerRadius = 5.0;
        _creatAddrBtn.layer.masksToBounds = YES;
        
    }
    return _creatAddrBtn;
}

- (UIButton *)importAddrBtn{
    if (_importAddrBtn == nil){
        UIColor *color = [UIColor colorWithRGB:0xff9e50];
        _importAddrBtn = [UIButton buttonWithTitle:@"导入钱包" titleColor:color backgroundColor:[UIColor whiteColor] font:[NUIUtil fixedFont:15] target:self action:@selector(importAddrBtnClick)];
        
        _importAddrBtn.layer.borderColor = color.CGColor;
        _importAddrBtn.layer.borderWidth = 1.0;
        
        _importAddrBtn.layer.cornerRadius = 5.0;
        _importAddrBtn.layer.masksToBounds = YES;
        
    }
    return _importAddrBtn;
}

@end
