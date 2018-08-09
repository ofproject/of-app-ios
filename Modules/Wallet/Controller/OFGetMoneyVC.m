//
//  OFGetMoneyVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFGetMoneyVC.h"

#import <CoreImage/CoreImage.h>
#import "OFShareManager.h"
#import "OFTransferVC.h"

@interface OFGetMoneyVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *QRcodeImageView;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIButton *addressCopyBtn;

@property (nonatomic, strong) UIButton *transferBtn;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) UIImage *currentImage;

@end



@implementation OFGetMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *title = NSLocalizedString(@"Turn in", nil);
    self.title = @"接收";
    
    [self initUI];
    [self layout];
    
    
    if (KcurUser.currentWallet.address.length < 1) {
        return;
    }
    
    self.title = KcurUser.currentWallet.name;
    
    [self setup];
    
    
    if (KcurUser.wallets.count) {
        OFWalletModel *model = KcurUser.wallets.firstObject;
        NSString *tempStr= [NSString stringWithFormat:@"%@",model.address];
        
        self.addressLabel.text = tempStr;
    }
    
    if (KcurUser.currentWallet) {
        for (OFWalletModel *model in KcurUser.wallets) {
            if ([model isEqual:KcurUser.currentWallet]) {
                NSInteger index = [KcurUser.wallets indexOfObject:model];
                [self.scrollView setContentOffset:CGPointMake(kScreenWidth * index, 0)];
                break;
            }
        }
    }
    
    
    
//    self.QRcodeImageView.image = [self createImageWithString:self.addressLabel.text];

    [self addNavigationItemWithImageNames:@[@"wallet_shared_btn"] isLeft:NO target:self action:@selector(sharedToWeChat) tags:nil];
}

- (void)sharedToWeChat{
    
    OFSharedModel *model = [[OFSharedModel alloc]init];
    NSString *address = [NDataUtil stringWith:KcurUser.currentWallet.address valid:@""];
    model.address = [NSString stringWithFormat:@"我的OF钱包地址是：%@\n（分享自@OF）",address];
    model.sharedType = OFSharedTypePicture;
    model.addressImage = self.currentImage;
    model.smsText = [NSString stringWithFormat:@"我的OF钱包地址是：%@\n（分享自@OF）",address];
    
    [OFShareManager sharedToWeChatWithModel:model controller:self];
}


- (void)initUI{
    
    [self.view addSubview:self.scrollView];
    
//    [self.view addSubview:self.QRcodeImageView];
    [self.view addSubview:self.addressLabel];
    [self.view addSubview:self.addressCopyBtn];
    
    [self.view addSubview:self.transferBtn];
}

- (void)layout{
    
//    CGFloat width = [NUIUtil fixedWidth:200];
    
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth);
    self.addressLabel.frame = CGRectMake(0, 0, kScreenWidth - 30, 100);
    self.addressLabel.left = 15;
    self.addressLabel.top = kScreenWidth;
    
    CGFloat padding = [NUIUtil fixedWidth:62.5];
    CGFloat width = (kScreenWidth - padding * 2) / 2 - 20;
    
    
    self.transferBtn.frame = CGRectMake(0, 0, width, Btn_Default_Height);

    self.transferBtn.left = padding;

    self.transferBtn.top = CGRectGetMaxY(self.addressLabel.frame) + 25;
    
    self.addressCopyBtn.frame = CGRectMake(0, 0, width, Btn_Default_Height);
    self.addressCopyBtn.left = kScreenWidth - self.addressCopyBtn.width - padding;
//    self.addressCopyBtn.left = padding;
    self.addressCopyBtn.top = CGRectGetMaxY(self.addressLabel.frame) + 25;
    
    
//    [self.QRcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(35);
//        make.size.mas_equalTo(CGSizeMake(width, width));
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];
//
//    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(15);
//        make.right.mas_equalTo(-15);
//        make.top.mas_equalTo(self.QRcodeImageView.mas_bottom).offset(34);
//    }];
//
//    [self.addressCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(62.5);
//        make.right.mas_equalTo(-62.5);
//        make.height.mas_equalTo(Btn_Default_Height);
//        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset([NUIUtil fixedHeight:35]);
//    }];
    
    
}

- (void)setup{
    CGFloat width = [NUIUtil fixedWidth:225];
    
    CGFloat top = KHeightFixed(56);
    
    for (int i = 0; i < KcurUser.wallets.count; i++) {
        OFWalletModel *model = [NDataUtil classWithArray:[OFWalletModel class] array:KcurUser.wallets index:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, top, width, width)];
        
        if (model.address.length < 1) {
            continue;
        }
        imageView.image = [self createImageWithString:model.address];
        
        imageView.left = (kScreenWidth - width)/2 + i * kScreenWidth;
        
//        UILabel *label1 = [[UILabel alloc]init];
//        label1.font = [NUIUtil fixedFont:17];
//        label1.textAlignment = NSTextAlignmentRight;
//        label1.text = [NSString stringWithFormat:@"%@",[NDataUtil stringWith:model.name valid:@"OF"]];
//        label1.textColor = Orange_New_Color;
//
//        [label1 sizeToFit];
//
//        label1.centerX = imageView.centerX;
//        label1.top = 30;
        
        
        UILabel *label = [[UILabel alloc]init];
        label.font = [NUIUtil fixedFont:17];
        label.textAlignment = NSTextAlignmentRight;
        CGFloat money = [[NDataUtil stringWith:model.balance valid:@"0.00"] doubleValue];
        label.text = [NSString stringWithFormat:@"%@: %@",@"钱包资产",[NSString stringWithFormat:@"%.3f",money]];
        label.textColor = Orange_New_Color;
        
        [label sizeToFit];
        
        label.centerX = imageView.centerX;
        label.top = CGRectGetMaxY(imageView.frame) + 15;
        
        
        [self.scrollView addSubview:imageView];
        [self.scrollView addSubview:label];
        
        [self.addressArray addObject:imageView.image];
        if (i == 0) {
            self.currentImage = imageView.image;
        }
//        [self.scrollView addSubview:label1];
    }
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * KcurUser.wallets.count, 0);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%zd",(NSInteger)(scrollView.contentOffset.x / kScreenWidth));
    
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreenWidth);
    
    OFWalletModel *model = [NDataUtil classWithArray:[OFWalletModel class] array:KcurUser.wallets index:index];
    KcurUser.currentWallet = model;
    NSString *tempStr= [NSString stringWithFormat:@"%@",model.address];
    self.addressLabel.text = tempStr;
    
    self.currentImage = [NDataUtil classWithArray:[UIImage class] array:self.addressArray index:index];
    
}


- (void)addressCopyBtnClick{
    
    if (KcurUser.currentWallet.address.length < 1) {
        
        return;
    }
    
    // 把地址字符串复制到粘贴板。
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = KcurUser.currentWallet.address;
//    NSString *title = NSLocalizedString(@"copysuccess", nil);
    [MBProgressHUD showSuccess:@"已经复制到粘贴板!"];
}

- (void)transferBtnClick{
    
    OFTransferVC *vc = [[OFTransferVC alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

// 生成二维码
- (UIImage *)createImageWithString:(NSString *)string{
    
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性（因为滤镜可能保存上一次的属性）
    [filter setDefaults];
    
    // 3.讲字符串转换为NSData
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // 4.通过KVC设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5.通过了滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6.因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    
    UIImage *image = [self getErWeiMaImageFormCIImage:outputImage withSize:[NUIUtil fixedWidth:200]];
    
    return image;
}

- (UIImage *)getErWeiMaImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (UIImageView *)QRcodeImageView{
    if (_QRcodeImageView == nil) {
        _QRcodeImageView = [[UIImageView alloc]init];
    }
    return _QRcodeImageView;
}

- (UILabel *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [UIColor colorWithRed:64/255.0 green:64/255.0 blue:64/255.0 alpha:1.0];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.numberOfLines = 0;
        _addressLabel.font = [NUIUtil fixedFont:17];
        _addressLabel.preferredMaxLayoutWidth = kScreenWidth - 30;
        
        WEAK_SELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf addressCopyBtnClick];
        }];
        _addressLabel.userInteractionEnabled = YES;
        [_addressLabel addGestureRecognizer:tap];
    }
    return _addressLabel;
}

- (UIButton *)addressCopyBtn{
    if (_addressCopyBtn == nil) {
        _addressCopyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addressCopyBtn.layer.cornerRadius = 5.0;
        _addressCopyBtn.layer.masksToBounds = YES;
        [_addressCopyBtn setTitle:@"收款" forState:UIControlStateNormal];
        [_addressCopyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addressCopyBtn.titleLabel.font = [NUIUtil fixedFont:20];
        [_addressCopyBtn addTarget:self action:@selector(addressCopyBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, 100, 40}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_addressCopyBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    return _addressCopyBtn;
}


- (UIButton *)transferBtn{
    if (!_transferBtn) {
        _transferBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _transferBtn.layer.cornerRadius = 5.0;
        _transferBtn.layer.masksToBounds = YES;
        [_transferBtn setTitle:@"转账" forState:UIControlStateNormal];
        [_transferBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _transferBtn.titleLabel.font = [NUIUtil fixedFont:20];
        [_transferBtn addTarget:self action:@selector(transferBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, 100, 40}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_transferBtn setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    return _transferBtn;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollEnabled = NO;
    }
    return _scrollView;
}

- (NSMutableArray *)addressArray{
    if (!_addressArray) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}

@end
