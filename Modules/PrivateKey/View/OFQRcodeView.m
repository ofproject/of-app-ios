//
//  OFQRcodeView.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFQRcodeView.h"
#import <CoreImage/CoreImage.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <Photos/Photos.h>

#import "OFProWalletListVC.h"

@interface OFQRcodeView ()

@property (nonatomic, strong) UIImageView *QRcodeImageView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UIButton *saveBtn;

@end

@implementation OFQRcodeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self layout];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.QRcodeImageView];
    [self addSubview:self.tipLabel];
    [self addSubview:self.saveBtn];
    
}

- (void)layout{
    [self.QRcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.QRcodeImageView.mas_bottom).offset(30);
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 37.5));
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    
}

- (void)setTipContent:(NSString *)tipContent{
    _tipContent = [tipContent copy];
    self.tipLabel.text = tipContent;
}

- (void)setImageContent:(NSString *)content{
    
    UIImage *image = [self createImageWithString:content];
    
    self.QRcodeImageView.image = image;
    
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
    
    UIImage *image = [self getErWeiMaImageFormCIImage:outputImage withSize:kScreenWidth];
    
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

- (void)saveBtnClick{
    
    if (![self isCanUsePhotos]) {
        [self.viewController AlertWithTitle:@"无法使用照片" message:@"请在ipone的“设置-隐私-相机”中允许访问照片" andOthers:@[@"确定"] animated:YES action:nil];
        return;
    }
    
    if (self.QRcodeImageView.image == nil) {
        return;
    }
    
    // 绘制一个图片.
    UIImage *saveImage = [self creatQRView];
    UIImageWriteToSavedPhotosAlbum(saveImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}

/**
 判断是否有权限访问相册
 */
- (BOOL)isCanUsePhotos {
    
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        //无权限
        return NO;
    }
    return YES;
    
}

- (UIImage *)creatQRView{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 1.4);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, kScreenWidth * 0.2, kScreenWidth, kScreenWidth)];
    imageView.image = self.QRcodeImageView.image;
    
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kScreenWidth * 1.2, kScreenWidth, kScreenWidth * 0.2)];
    
    label.top = kScreenWidth * 1.2;
    label.font = [NUIUtil fixedFont:20];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    
    if (self.name.length < 1) {
        self.name = @"OF";
    }
    
    NSMutableString *string = [NSMutableString string];
    [string appendString:self.name];
    switch (self.saveType) {
        case OFProSaveWords:
            [string appendString:@" - 助记词"];
            break;
        case OFProSaveKeystore:
            [string appendString:@" - keystore"];
            break;
        case OFProSavePrivate:
            [string appendString:@" - 私钥"];
            break;
            
        default:
            break;
    }
    
    label.attributedText = [NUIUtil changeColor:string range:[string rangeOfString:self.name] color:[UIColor redColor] font:label.font];
    
    [view addSubview:label];
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}



- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
        [MBProgressHUD showError:msg];
    }else{
        
        msg = @"保存图片成功" ;
        [MBProgressHUD showSuccess:msg];
        // 保存成功.  删除本地存储的助记词.
        
    }
}

- (UIImageView *)QRcodeImageView{
    if (_QRcodeImageView == nil) {
        _QRcodeImageView = [[UIImageView alloc]init];
    }
    return _QRcodeImageView;
}

- (UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc]init];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIButton *)saveBtn{
    if (_saveBtn == nil) {
        _saveBtn = [UIButton buttonWithTitle:@"保存二维码" titleColor:[UIColor whiteColor] backgroundColor:OF_COLOR_MAIN_THEME font:[NUIUtil fixedFont:15] target:self action:@selector(saveBtnClick)];
        
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_saveBtn setBackgroundImage:image forState:UIControlStateNormal];
        
        _saveBtn.layer.cornerRadius = 5;
        _saveBtn.layer.masksToBounds = YES;
        
    }
    return _saveBtn;
}

@end
