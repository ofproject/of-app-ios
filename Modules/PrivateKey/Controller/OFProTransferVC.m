//
//  OFProTransferVC.m
//  OFBank
//
//  Created by of on 2018/6/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProTransferVC.h"

#import "NSlider.h"
#import "OFWebViewController.h"
#import "OFQRcodeScanVC.h"

#import "HMLineLayout.h"
#import "OFWalletCollectionCell.h"

#import "OFPayView.h"


#import "OFProWalletAPI.h"
#import "OFCipherManager.h"

static const CGFloat fontSize = 15.0;

static const CGFloat tipsSize = 14.0;

static NSString *const cellID = @"OFWalletCollectionCell";

@interface OFProTransferVC ()<OFQRcodeSacnDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UITextFieldDelegate>
    
    
@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) UILabel *navTitleLabel;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSlider *slider;

@property (nonatomic, strong) UITextField *addressTextField;

@property (nonatomic, strong) UITextField *moneyTextField;

@property (nonatomic, strong) UILabel *tip1Label;

@property (nonatomic, strong) UIView *line1View;

@property (nonatomic, strong) UIView *line2View;

@property (nonatomic, strong) UIButton *scanBtn;

@property (nonatomic, strong) UIButton *gasBtn;

@property (nonatomic, strong) UILabel *tip2Label;

@property (nonatomic, strong) UILabel *tip3Label;

@property (nonatomic, strong) UILabel *tip4Label;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UIButton *sureBtn;


@property (nonatomic, assign) CGFloat inset;

@property (nonatomic, assign) NSInteger gasPrice;

@end

@implementation OFProTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"";
    
    //    self.fd_prefersNavigationBarHidden = YES;
    self.n_isHiddenNavBar = YES;
    
    //    self.inset = [NUIUtil fixedWidth:60];
    self.inset = 10;
    //    NSLog(@"%f --- %f --- %f",self.inset,kScreenWidth,[NUIUtil fixedWidth:5]);
    
    [self initUI];
    [self layout];
    
    
    [self.view bringSubviewToFront:self.navView];
    
    if (self.model.isCoin) {
        self.numLabel.text = @"0.105";
    }else{
        CGFloat gas = 36.6;
        
        CGFloat poundage =  1.0 * gas / 200;
        self.numLabel.text = [NSString stringWithFormat:@"%.3f",poundage];
    }
//    self.numLabel.text = @"0.105";
    self.gasPrice = 1;
    
    self.n_isHiddenNavBar = YES;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0,*)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.collectionView layoutIfNeeded];
    [self test];
    
}

- (void)test{
    
    for (int i = 0; i < KcurUser.proWallets.count; i++) {
        OFProWalletModel *model = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:i];
        if ([model isEqual:KcurUser.currentProWallet]) {
            CGFloat x = kScreenWidth - 10;
            
            NSLog(@"%f --- %d",x * i,i);
            self.collectionView.contentOffset = CGPointMake(x * i, 0);
            break;
        }
    }
}

- (void)initUI{
    
    [self.view addSubview:self.navView];
    [self.navView addSubview:self.navTitleLabel];
    [self.navView addSubview:self.backBtn];
    
    [self.view addSubview:self.scrollView];
    
    
    [self.scrollView addSubview:self.collectionView];
    
    [self.scrollView addSubview:self.addressTextField];
    [self.scrollView addSubview:self.scanBtn];
    [self.scrollView addSubview:self.line1View];
    
    [self.scrollView addSubview:self.moneyTextField];
    [self.scrollView addSubview:self.line2View];
    
    [self.scrollView addSubview:self.tip1Label];
    [self.scrollView addSubview:self.numLabel];
    
    [self.scrollView addSubview:self.gasBtn];
    
    [self.scrollView addSubview:self.slider];
    [self.scrollView addSubview:self.tip2Label];
    
    [self.scrollView addSubview:self.tip3Label];
    [self.scrollView addSubview:self.tip4Label];
    
    [self.scrollView addSubview:self.sureBtn];
    
}


- (void)layout{
    
    CGFloat top = 64.0;
    if (IS_IPHONE_X) {
        top = 88.0;
    }
    
    [self.navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(top);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        //        make.centerY.mas_equalTo(self.navTitleLabel.mas_centerY);
        make.bottom.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.navView.mas_centerX);
        make.centerY.mas_equalTo(self.backBtn.mas_centerY);
    }];
    
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        //        make.right.mas_equalTo(self.view.mas_right);
        make.width.mas_equalTo(self.view.mas_width);
        //        make.top.mas_equalTo(self.navView.mas_bottom);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(top + 15);
        make.height.mas_equalTo([NUIUtil fixedHeight:120]);
    }];
    
    [self.scanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        //        make.top.mas_equalTo(37);
        make.centerY.mas_equalTo(self.addressTextField.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [self.addressTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(35);
        make.height.mas_equalTo(35);
        make.right.mas_equalTo(self.scanBtn.mas_left).offset(-15);
    }];
    
    [self.line1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.addressTextField.mas_bottom).offset(10);
    }];
    
    
    [self.moneyTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.top.mas_equalTo(self.line1View.mas_bottom).offset(22);
        
        make.height.mas_equalTo(35);
    }];
    
    [self.line2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(15);
        make.right.mas_equalTo(self.view.mas_right).offset(-15);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.moneyTextField.mas_bottom).offset(10);
    }];
    
    [self.tip1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.line2View.mas_bottom).offset(37);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tip1Label.mas_right);
        make.centerY.mas_equalTo(self.tip1Label.mas_centerY);
    }];
    
    [self.gasBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.numLabel.mas_right).offset(10);
        make.height.width.mas_equalTo(15);
        make.centerY.mas_equalTo(self.tip1Label.mas_centerY);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(35);
        make.right.mas_equalTo(self.view.mas_right).offset(-35);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.tip1Label.mas_bottom).offset(37);
    }];
    
    [self.tip2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(28);
        make.top.mas_equalTo(self.slider.mas_bottom).offset(37);
    }];
    
    [self.tip3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.right.mas_equalTo(self.view.mas_right).offset(-28);
        make.top.mas_equalTo(self.slider.mas_bottom).offset(37);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.tip4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view.mas_right).offset(-28);
        make.top.mas_equalTo(self.slider.mas_bottom).offset(37);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.tip3Label.mas_bottom).offset(52.5);
        make.size.mas_equalTo(CGSizeMake([NUIUtil fixedWidth:270], Btn_Default_Height));
        make.bottom.mas_equalTo(self.scrollView.mas_bottom).offset(-30);
    }];
}



- (void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)gasBtnClick{
    
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = @"GAS说明";
    webVC.urlString = NSStringFormat(@"%@%@",URL_H5_main,URL_H5_content);
    [self.navigationController pushViewController:webVC animated:YES];
    
    
}

- (void)scanBtnClick{
    OFQRcodeScanVC *vc = [[OFQRcodeScanVC alloc]init];
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)resultAddressString:(NSString *)address{
    self.addressTextField.text = address;
}

- (void)sureBtnClick{
    
    //    NSLog(@"%f",self.collectionView.contentOffset.x);
    
    CGFloat width = self.collectionView.contentSize.width / KcurUser.proWallets.count;
    
    NSInteger row = (NSInteger)((self.collectionView.contentOffset.x + self.inset)/ width);
    
    
    
    KcurUser.currentProWallet = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:row];
    
    if (self.addressTextField.text.length != 52) {
        [MBProgressHUD showError:@"收款人钱包地址不合规则"];
        return;
    }
    
    if (![self.addressTextField.text hasPrefix:@"0x"]) {
        [MBProgressHUD showError:@"收款人钱包地址不合规则"];
        return;
    }
    
    if (self.moneyTextField.text.length < 1) {
        [MBProgressHUD showError:@"转账金额不能为空!"];
        return;
    }
    
    if (![ToolObject isValidateMoney:self.moneyTextField.text]) {
        [MBProgressHUD showError:@"金额最多至小数点后三位"];
        return;
    }
    
    if ([KcurUser.currentProWallet.balance floatValue] < [self.numLabel.text floatValue]) {
        [MBProgressHUD showError:@"您需要足够的OF来作为手续费"];
        return;
    }
    
    
    [OFPayView showPayViewWithoutCode:^(NSString *password, NSString *code) {
        [self pay:password code:code];
    }];
    
}

- (void)pay:(NSString *)password code:(NSString *)code{
    [self.view endEditing:YES];
    
    [MBProgressHUD showMessage:@"转账中..." toView:self.view];
    
    //    CGFloat num = [self.numLabel.text floatValue];
    //    NSInteger num = [self.numLabel.text integerValue];
    NSLog(@"%zd",self.gasPrice);
    
    [self sendTransfer:password];
}

- (void)sendTransfer:(NSString *)password{
    
    NSString *address = [NDataUtil stringWith:KcurUser.currentProWallet.address valid:@""];
    
    NSInteger tempGasPrice = self.gasPrice * 5E12;
    if (tempGasPrice > 5E14) {
        tempGasPrice = 5E14;
    }else if (tempGasPrice < 5E12){
        tempGasPrice = 5E12;
    }
    
    //
    NSString *value;
    // data字段
    NSMutableString *data = [NSMutableString string];
    // 以0x开头
    [data appendString:@"0x"];
    
    NSString *to;
    if (self.model.isCoin) {
        // 是OF
        // 当时OF时，value 为 转账金额   to 是接收地址
        value = self.moneyTextField.text;
        to = self.addressTextField.text;
    }else{
        // 是token
        // to  为合约地址
        to = self.model.contractAddress;
        // value 为 0.0
        value = @"0.0";
        // data 第一个参数为转账函数：a9059cbb
        // 转账
        [data appendString:@"a9059cbb"];
        
        // from
        NSString *add = [self.addressTextField.text stringByReplacingOccurrencesOfString:@"0x" withString:@""];
        // data 第二个参数 为接收地址 不包含开头的0x 总长度64位，用0补齐
        [data appendString:[add characterStringAddDigit:64 addString:@"0"]];
        
        NSString *money = self.moneyTextField.text;
        
        CGFloat m = [money floatValue];
        
        NSInteger accuracy = [self.model.accuracy integerValue];
        
        for (int i = 0; i < accuracy; i++) {
            m = m * 10;
        }
        NSInteger n = m;
        
        NSString *mm = [NDataUtil getHexByDecimal:n];
        // data 第三个参数 为转账金额， 转账金额为输入的数字 右移 accuracy位取整 专16进制   64位，用0补齐
        [data appendString:[mm characterStringAddDigit:64 addString:@"0"]];
        
    }
    
    
    WEAK_SELF;
    // 1. 取Nonce
    [OFProWalletAPI getNonceWithAddress:address finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
       
        if (success) {
            NSString *nonceStr = [NDataUtil stringWith:obj valid:@"0"];
            
            long nonce = [nonceStr longValue];
            // 2. 签名
            [OFCipherManager signTx:address to:to value:value gasPrice:[NSString stringWithFormat:@"%ld",(long)tempGasPrice] nonce:nonce data:data keystore:KcurUser.currentProWallet.keystore password:password finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
                
                if (success) {
                    // 3. 发送请求
                    [OFProWalletAPI sendTransactionWithTx:obj finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
                        [MBProgressHUD hideHUDForView:weakSelf.view];
                        if (success) {
                            [OFPayView hiddenPayView];
                            [OFMobileClick event:MobileClick_transfer_suc];
                            [self AlertWithTitle:@"提示" message:@"OF转账成功，到达对方账户需要一定时间，请耐心等待" andOthers:@[@"我知道了"] animated:YES action:^(NSInteger index) {

                            }];
                        }else{
                            NSLog(@"转账失败");
                            [MBProgressHUD showError:errorMessage];
                        }
                        
                    }];
                    
                }else{
                    NSLog(@"签名失败");
                    [MBProgressHUD hideHUDForView:weakSelf.view];
                    [MBProgressHUD showError:errorMessage];
                }
                
            }];
            
        }else{
            NSLog(@"获取nonce失败");
            [MBProgressHUD hideHUDForView:weakSelf.view];
            [MBProgressHUD showError:@"网络异常，请稍后重试！"];
        }
        
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

#pragma mark - <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return KcurUser.proWallets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    OFWalletCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    
    OFWalletModel *model = [[OFWalletModel alloc]init];
    model.address = KcurUser.currentProWallet.address;
    model.name = self.model.name;
    model.cointype = OFCoinTypeOF;
    model.balance = self.model.balance;
    
//    OFWalletModel *model = [NDataUtil classWithArray:[OFWalletModel class] array:KcurUser.wallets index:indexPath.item];
    cell.model = model;
    [cell setImageName:(indexPath.row + 1) % 5];
    return cell;
}

#pragma mark - UISlider 代理
- (void) sliderTouchBegin:(UISlider *)sender {
    //    NSLog(@"sliderTouchBegin %f",sender.value);
    //    self.numLabel.text = [NSString stringWithFormat:@"%f",sender.value];
    [self setNum:sender.value];
}

- (void) sliderValueChanged:(UISlider *)sender
{
    //    NSLog(@"sliderValueChanged %f",sender.value);
    //    self.numLabel.text = [NSString stringWithFormat:@"%f",sender.value];
    [self setNum:sender.value];
}

- (void)setNum:(CGFloat)value{
    
    CGFloat poundage =  [self getPoundage:value];
    
    if (poundage < 0.001) {
        self.numLabel.text = @"小于0.001";
    }else{
        self.numLabel.text = [NSString stringWithFormat:@"%.3f",poundage];
    }
}

- (CGFloat)getPoundage:(CGFloat)value{
    
    NSInteger num = (NSInteger)(value * 100 + 1);
    if (num > 100) {
        num = 100;
    }
    self.gasPrice = num;
    CGFloat gas = self.model.isCoin ? 21.0 : 36.6;
    return (CGFloat)(num) * gas / 200;
}

- (void) sliderTouchEnd:(UISlider *)sender
{
    //    NSLog(@"sliderTouchEnd %f",sender.value);
    [self setNum:sender.value];
}

#pragma mark - 输入金额文本框
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
    
    if (![ToolObject isNum:theTextField.text] && ![ToolObject isFloat:theTextField.text]) {
        theTextField.text = @"";
    }else{
        double inputNum = [theTextField.text doubleValue];
        
        CGFloat poundage =  [self getPoundage:self.slider.value];
        
        CGFloat width = self.collectionView.contentSize.width / KcurUser.wallets.count;
        NSInteger row = (NSInteger)((self.collectionView.contentOffset.x + self.inset)/ width);
        KcurUser.currentProWallet = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:row];
        
        if (inputNum > [self.model.balance doubleValue] - poundage) {
            if ([KcurUser.currentProWallet.balance doubleValue] - poundage < 0){
                theTextField.text = @"";
                [MBProgressHUD showError:@"钱包余额不足"];
            }else{
                theTextField.text = NSStringFormat(@"%.3f",[KcurUser.currentProWallet.balance doubleValue] - poundage);
            }
        }
    }
}

-(void)dealloc{
    
}

- (NSlider *)slider{
    if (_slider == nil) {
        _slider = [[NSlider alloc]init];
        [_slider setMinimumTrackTintColor:[UIColor colorWithRGB:0xffa040]];
        [_slider setMaximumTrackTintColor:[[UIColor colorWithRGB:0x0d0408] colorWithAlphaComponent:0.35]];
        
        [_slider addTarget:self action:@selector(sliderTouchBegin:) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(sliderTouchEnd:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        _slider.enabled=YES;
        
    }
    return _slider;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
    }
    return _scrollView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        //        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[HMLineLayout alloc]init]];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kScreenWidth - 20, [NUIUtil fixedHeight:120] - 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[OFWalletCollectionCell class] forCellWithReuseIdentifier:cellID];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
    }
    return _collectionView;
}

- (UITextField *)addressTextField {
    if (!_addressTextField) {
        _addressTextField = [UITextField new];
        _addressTextField.borderStyle = UITextBorderStyleNone;
        _addressTextField.returnKeyType = UIReturnKeyDone;
        _addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _addressTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
        _addressTextField.font = [NUIUtil fixedFont:fontSize];
        //       NSString *title = NSLocalizedString(@"walletaddress", nil);
        _addressTextField.placeholder = @"收款人钱包地址";
        _addressTextField.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
        
        [_addressTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_addressTextField setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _addressTextField;
}

- (UITextField *)moneyTextField {
    if (!_moneyTextField) {
        _moneyTextField = [UITextField new];
        _moneyTextField.borderStyle = UITextBorderStyleNone;
        _moneyTextField.returnKeyType = UIReturnKeyDone;
        _moneyTextField.font = [NUIUtil fixedFont:fontSize];
        //       NSString *title = NSLocalizedString(@"money", nil);
        _moneyTextField.placeholder = @"转账金额";
        _moneyTextField.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
        _moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _moneyTextField.keyboardAppearance = UIKeyboardAppearanceDefault;
        _moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_moneyTextField setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_moneyTextField setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_moneyTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _moneyTextField;
}

- (UILabel *)tip1Label {
    if (!_tip1Label) {
        _tip1Label = [UILabel new];
        _tip1Label.font = [NUIUtil fixedFont:fontSize];
        _tip1Label.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
        _tip1Label.backgroundColor = [UIColor clearColor];
        //       NSString *title = NSLocalizedString(@"acceleratecost", nil);
        _tip1Label.text = @"矿工费用:";
        [_tip1Label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_tip1Label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _tip1Label;
}

- (UIView *)line1View {
    if (!_line1View) {
        _line1View = [UIView new];
        _line1View.backgroundColor = Line_Color;
    }
    return _line1View;
}

- (UIView *)line2View {
    if (!_line2View) {
        _line2View = [UIView new];
        _line2View.backgroundColor = Line_Color;
    }
    return _line2View;
}

- (UIButton *)scanBtn {
    if (!_scanBtn) {
        _scanBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_scanBtn setImage:[UIImage imageNamed:@"wallet_transfer_scan"] forState:UIControlStateNormal];
        [_scanBtn setBackgroundColor:[UIColor whiteColor]];
        //       [_scanBtn setBackgroundImage:[UIImage imageNamed:@"wallet_transfer_scan"] forState:UIControlStateNormal];
        
        [_scanBtn setTintColor:[UIColor colorWithRGB:0x5a5b5c]];
        
        [_scanBtn setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_scanBtn setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_scanBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
        WEAK_SELF;
        [_scanBtn n_clickBlock:^(id sender) {
            [weakSelf scanBtnClick];
        }];
    }
    return _scanBtn;
}

- (UIButton *)gasBtn {
    if (!_gasBtn) {
        _gasBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gasBtn setImage:[UIImage imageNamed:@"wallet_transfer_gas"] forState:UIControlStateNormal];
        
        [_gasBtn addTarget:self action:@selector(gasBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _gasBtn;
}

- (UILabel *)tip2Label {
    if (!_tip2Label) {
        _tip2Label = [UILabel new];
        _tip2Label.font = [NUIUtil fixedFont:tipsSize];
        _tip2Label.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
        //       NSString *title = NSLocalizedString(@"slow", nil);
        _tip2Label.text = @"慢";
        _tip2Label.backgroundColor = [UIColor clearColor];
        
        [_tip2Label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_tip2Label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _tip2Label;
}

- (UILabel *)tip3Label {
    if (!_tip3Label) {
        _tip3Label = [UILabel new];
        _tip3Label.font = [NUIUtil fixedFont:tipsSize];
        _tip3Label.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
        //       NSString *title = NSLocalizedString(@"fast", nil);
        _tip3Label.text = @"快";
        _tip3Label.textAlignment = NSTextAlignmentCenter;
        _tip3Label.backgroundColor = [UIColor clearColor];
        
        [_tip3Label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_tip3Label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _tip3Label;
}

- (UILabel *)tip4Label{
    if (!_tip4Label) {
        _tip4Label = [UILabel new];
        _tip4Label.font = [NUIUtil fixedFont:tipsSize];
        _tip4Label.textColor = [UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0];
        //        NSString *title = NSLocalizedString(@"fastest", nil);
        _tip4Label.text = @"极快";
        _tip4Label.textAlignment = NSTextAlignmentRight;
        _tip4Label.backgroundColor = [UIColor clearColor];
        
        [_tip4Label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [_tip4Label setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    }
    return _tip4Label;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [UILabel new];
        _numLabel.font = [NUIUtil fixedFont:fontSize];
        _numLabel.textColor = Orange_New_Color;
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        
        [_numLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [_numLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        
    }
    return _numLabel;
}

- (UIButton *)sureBtn{
    if (_sureBtn == nil) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        NSString *title = NSLocalizedString(@"Turn out", nil);
        [_sureBtn setTitle:@"转账" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [NUIUtil fixedFont:16];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 5.0;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn setBackgroundImage:[UIImage makeGradientImageWithRect:CGRectMake(0, 0, [NUIUtil fixedWidth:270], Btn_Default_Height) startPoint:CGPointMake(0, 0.5) endPoint:CGPointMake(1, 0.5) startColor:OF_COLOR_GRADUAL_1 endColor:OF_COLOR_GRADUAL_2] forState:UIControlStateNormal];
    }
    return _sureBtn;
}


- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc]init];
        _navView.backgroundColor = [UIColor whiteColor];
        _navView.layer.shadowColor = [UIColor blackColor].CGColor;
        _navView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
        _navView.layer.shadowRadius = 3.0;
        _navView.layer.shadowOpacity = 0.1;
    }
    return _navView;
}

- (UILabel *)navTitleLabel{
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc]init];
        //        NSString *title = NSLocalizedString(@"Turn out", nil);
        NSString *title = [NSString stringWithFormat:@"%@转账",self.model.name];
        _navTitleLabel.text = title;
        _navTitleLabel.font = [UIFont boldSystemFontOfSize:17];
    }
    return _navTitleLabel;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_backBtn setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];
        [_backBtn setTintColor:[UIColor blackColor]];
        _backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _backBtn;
}

@end
