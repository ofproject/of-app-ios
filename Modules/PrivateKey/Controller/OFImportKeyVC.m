//
//  OFImportKeyVC.m
//  OFBank
//
//  Created by michael on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//  导入私钥

#import "OFImportKeyVC.h"

#import "OFProWordsView.h"
#import "OFProKeystoreView.h"
#import "OFProPrivatekeyView.h"

#import "OFPoolSectionView.h"

#import "OFQRcodeScanVC.h"

@interface OFImportKeyVC ()<OFPoolSectionViewDelegate,UIScrollViewDelegate,OFQRcodeSacnDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) OFProWordsView *wordView;

@property (nonatomic, strong) OFProKeystoreView *keystoreView;

@property (nonatomic, strong) OFProPrivatekeyView *privatekeyView;

@property (nonatomic, strong) OFPoolSectionView *sectionView;

@end

@implementation OFImportKeyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"导入钱包";
    
    [self initUI];
    [self layout];
    
    [self addNavigationItemWithImageNames:@[@"wallet_transfer_scan"] isLeft:NO target:self action:@selector(rightNavBtnClick) tags:nil];
    
    self.isOpenIQKeyBoardManager = YES;
}

- (void)initUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.wordView];
    [self.scrollView addSubview:self.keystoreView];
    [self.scrollView addSubview:self.privatekeyView];
    
    [self.view addSubview:self.sectionView];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * 3, 0);
    self.scrollView.scrollEnabled = NO;
}

- (void)layout{
    _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    
    self.wordView.left = 0;
    self.keystoreView.left = CGRectGetMaxX(self.wordView.frame);
    self.privatekeyView.left = CGRectGetMaxX(self.keystoreView.frame);
    [self.sectionView layoutSubviews];
}

- (void)rightNavBtnClick{
    OFQRcodeScanVC *vc = [[OFQRcodeScanVC alloc]init];
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)resultAddressString:(NSString *)address{
    NSLog(@"%@",address);
    
    
    
    if (address.length == 24) {
        // 助记词
        
//        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [self.sectionView setSelectedItemAtIndex:0];
        self.wordView.content = address;
        
        
    }else if ([address containsString:@"address"]){
//        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
        [self.sectionView setSelectedItemAtIndex:1];
        self.keystoreView.content = address;
    }else{
        self.privatekeyView.content = address;
//        [self.scrollView setContentOffset:CGPointMake(kScreenWidth * 2, 0) animated:YES];
        [self.sectionView setSelectedItemAtIndex:2];
    }
    return;
    
//    if (address.length == 2) {
//        
//        
//        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:YES];
//        
//        self.keystoreView.content = address;
//    }
//    
//    
//    
//    
//    NSInteger index = self.scrollView.contentOffset.x / kScreenWidth;
//    
//    switch (index) {
//        case 0:
//            self.wordView.content = address;
//            break;
//        case 1:
//            self.keystoreView.content = address;
//            break;
//        case 2:
//            self.privatekeyView.content = address;
//            break;
//        default:
//            break;
//    }
    
    
}

- (void)sectionView:(OFPoolSectionView *)sectionView didSelectedButtonIndex:(NSUInteger)index{
    // 选择了哪个
    CGFloat x = index * kScreenWidth;
    [_scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (UIScrollView *)scrollView{
    if(_scrollView == nil){
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.pagingEnabled = YES;
    }
    return _scrollView;
}

- (OFProWordsView *)wordView{
    if(_wordView == nil){
        _wordView = [[OFProWordsView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
    }
    return _wordView;
}

- (OFProKeystoreView *)keystoreView{
    if(_keystoreView == nil){
        _keystoreView = [[OFProKeystoreView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _keystoreView;
}

- (OFProPrivatekeyView *)privatekeyView{
    if (_privatekeyView == nil) {
        _privatekeyView = [[OFProPrivatekeyView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _privatekeyView;
}

- (OFPoolSectionView *)sectionView{
    if(_sectionView == nil){
        _sectionView = [[OFPoolSectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _sectionView.style = OFPoolHeaderStyleDefault;
        _sectionView.delegate = self;
        [_sectionView setDataArr:@[@"助记词",@"Keystore",@"私钥"]];
    }
    return _sectionView;
}


@end
