//
//  OFQRcodeScanVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//  二维码扫描

#import "OFQRcodeScanVC.h"

#import <AVFoundation/AVFoundation.h>

#define kImageMaxSize   CGSizeMake(1000, 1000)

@interface OFQRcodeScanVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>{
    UIImagePickerController *imagePicker;
}

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property ( strong , nonatomic ) AVCaptureDevice * device;
@property ( strong , nonatomic ) AVCaptureDeviceInput * input;
@property ( strong , nonatomic ) AVCaptureMetadataOutput * output;

// 检测计数
@property (nonatomic, assign) NSInteger currentDetectedCount;

@property (nonatomic,assign)BOOL isScanSuccess;

@property (nonatomic, assign) BOOL isStart;

@property (nonatomic, strong) CALayer *drawLayer;

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) UIView *backView;

@end



@implementation OFQRcodeScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    NSString *title = [NSString stringWithFormat:@"二维码/条码"];
    NSString *title2 = [NSString stringWithFormat:@"相册"];
    UIBarButtonItem *navRightButton = [[UIBarButtonItem alloc]initWithTitle:title2 style:UIBarButtonItemStylePlain target:self action:@selector(choicePhoto)];
    self.navigationItem.rightBarButtonItem = navRightButton;
    self.navigationItem.title = title;
    self.currentDetectedCount = 0;
    
    [self initBgView];
    
//    //开始扫描
//    [self startScan];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getAVState];
    [self startAnimation];
//    [self startScan];
}

- (void)initBgView{
    
    [self.view addSubview:self.backView];
    
    UIImageView *imageView1 = [[UIImageView alloc]init];
    UIImageView *imageView2 = [[UIImageView alloc]init];
    UIImageView *imageView3 = [[UIImageView alloc]init];
    UIImageView *imageView4 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageNamed:@"scan_corner_bottom_left"];
    imageView2.image = [UIImage imageNamed:@"scan_corner_bottom_right"];
    imageView3.image = [UIImage imageNamed:@"scan_corner_top_left"];
    imageView4.image = [UIImage imageNamed:@"scan_corner_top_right"];
    
    UIImageView *lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"qrcode_line"]];

    [self.backView addSubview:imageView1];
    [self.backView addSubview:imageView2];
    [self.backView addSubview:imageView3];
    [self.backView addSubview:imageView4];
    [self.backView addSubview:lineView];
    self.lineView = lineView;
    
    [imageView1 sizeToFit];
    [imageView2 sizeToFit];
    [imageView3 sizeToFit];
    [imageView4 sizeToFit];
    
    [lineView sizeToFit];
    
    
    CGFloat a = 250.0;
    CGFloat top = (kScreenHeight - a - 64) / 2;
    CGFloat x = (kScreenWidth - a) / 2;

    self.backView.frame = CGRectMake(x, top, a, a);
    imageView1.left = 0;
    imageView1.top = a - imageView1.height;
    
    imageView2.left = a - imageView2.width;
    imageView2.top = a - imageView2.height;
    
    imageView3.left = 0;
    imageView3.top = 0;
    
    imageView4.top = 0;
    imageView4.left = a - imageView4.width;
    
    self.lineView.center = CGPointMake(self.backView.width * 0.5, 0);
}


- (void)startAnimation{
    [self stopAnimation];
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{
        [UIView setAnimationRepeatCount:MAXFLOAT];
        self.lineView.center = CGPointMake(self.backView.width * 0.5, self.backView.height);
                         
    } completion:nil];
}

- (void)stopAnimation{
    [self.lineView.layer removeAllAnimations];
    
    self.lineView.center = CGPointMake(self.backView.width * 0.5, 0);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if (_session) {
        [_session startRunning];
        
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear: animated];
    
    [self.session stopRunning];
    [self stopAnimation];
    
    
}

- (void)getAVState{
    
    WEAK_SELF;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        NSLog(@"没权限");
        NSString *sure = [NSString stringWithFormat:@"确定"];
        UIAlertAction *action = [UIAlertAction actionWithTitle:sure style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        NSString *title = [NSString stringWithFormat:@"无法使用相机"];
        NSString *message = [NSString stringWithFormat:@"请在ipone的“设置-隐私-相机”中允许访问相机"];
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:action];
        [weakSelf presentViewController:alertController animated:YES completion:nil];
        return;
    }else {
        NSLog(@"有权限");
        [self startScan];
    }
}

- (void)choicePhoto{
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)startScan{
    
    if (self.isStart) return;
    self.isStart = YES;
    
    
    if (![self.session canAddInput:self.input]) {
        NSLog(@"无法添加输入设备");
        self.session = nil;
        
        return;
    }
    if (![self.session canAddOutput:self.output]) {
        NSLog(@"无法添加输入设备");
        self.session = nil;
        
        return;
    }
    
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    //扫码类型，需要先将输出流添加到捕捉会话后再进行设置

    self.output.metadataObjectTypes = self.output.availableMetadataObjectTypes;
    //设置输出流delegate,在主线程刷新UI
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    //设置扫描范围 output.rectOfInterest
    
    self.drawLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.drawLayer atIndex:0];
    //预览层
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
    self.previewLayer.frame = self.view.bounds;
    
    [self.session startRunning];
    
}


- (void)resultContent:(NSString *)content{
    
    if (_delegate && [_delegate respondsToSelector:@selector(resultAddressString:)]) {
        [_delegate resultAddressString:content];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 扫描结果处理
 
 @param captureOutput 输出数据源
 @param metadataObjects 扫描结果数组
 @param connection 用于协调输入与输出之间的数据流
 */
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    
    [self clearDrawLayer];
    
    for (id obj in metadataObjects) {
        if (![obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            return;
        }
        
        // 转换对象坐标
        AVMetadataMachineReadableCodeObject *dataObject = (AVMetadataMachineReadableCodeObject *)[self.previewLayer transformedMetadataObjectForMetadataObject:obj];
        
        
        if (self.currentDetectedCount++ < 20) {
            [self drawCornersShape:dataObject];
        }else{
            if ([self.session isRunning]) {
                [self.session stopRunning];
            }
            
            NSString *stringValue = dataObject.stringValue;
            if (stringValue.length < 1) {
                
                return;
            }
            
            if ([stringValue containsString:@"http"]) {
                
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue] options:[NSDictionary dictionary] completionHandler:^(BOOL success) {
                        
                        if (success) {
                            NSLog(@"成功");
                        }
                    }];
                } else {
                    // Fallback on earlier versions
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
                }
            }else{
                NSLog(@"普通字符串：%@ - %zd",stringValue,stringValue.length);     // 可以将字符串放到需要用到的地方（比如label）
                [self resultContent:stringValue];
            }
        }
        
    }
    
}

/// 绘制条码形状
///
/// @param dataObject 识别到的数据对象
- (void)drawCornersShape:(AVMetadataMachineReadableCodeObject *)dataObject {
    
    if (dataObject.corners.count == 0) {
        return;
    }
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    layer.lineWidth = 4;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = [self cornersPath:dataObject.corners];
    
    [self.drawLayer addSublayer:layer];
}


/// 使用 corners 数组生成绘制路径
///
/// @param corners corners 数组
///
/// @return 绘制路径
- (CGPathRef)cornersPath:(NSArray *)corners {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointZero;
    
    // 1. 移动到第一个点
    NSInteger index = 0;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
    [path moveToPoint:point];
    
    // 2. 遍历剩余的点
    while (index < corners.count) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)corners[index++], &point);
        [path addLineToPoint:point];
    }
    
    // 3. 关闭路径
    [path closePath];
    
    return path.CGPath;
}

/// 清空绘制图层
- (void)clearDrawLayer {
    if (self.drawLayer.sublayers.count == 0) {
        return;
    }
    
    [self.drawLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
}

#pragma mark - ImagePickerDelegate
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
//    NSLog(@"%@",info);
    
    NSString *content = @"" ;
    //取出选中的图片 UIImagePickerControllerOriginalImage
    UIImage *pickImage = [self resizeImage:info[UIImagePickerControllerOriginalImage]];
    
//    NSData *imageData = UIImagePNGRepresentation(pickImage);
    
    CIImage *ciImage = [[CIImage alloc] initWithImage:pickImage];
    
    CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @YES}] options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
//    CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    //创建探测器
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyLow}];
    
    if (ciImage) {
//        NSLog(@"%@",qrDetector);
        NSArray *feature = [qrDetector featuresInImage:ciImage];
        
        //取出探测到的数据
//        for (CIQRCodeFeature *result in feature) {
//            content = result.messageString;
//        }
        
        CIQRCodeFeature *result = [NDataUtil classWithArray:[CIQRCodeFeature class] array:feature index:0];
        content = result.messageString;
//        NSLog(@"%@",content);
        __weak typeof(self) weakSelf = self;
        //选中图片后先返回扫描页面，然后跳转到新页面进行展示
        [picker dismissViewControllerAnimated:NO completion:^{
            
            if (![content isEqualToString:@""]) {
                //震动
                [weakSelf resultContent:content];
            }else{
                NSLog(@"没扫到东西");
            }
        }];
    }
}


- (UIImage *)resizeImage:(UIImage *)image {
    
    if (image.size.width < kImageMaxSize.width && image.size.height < kImageMaxSize.height) {
        return image;
    }
    
    CGFloat xScale = kImageMaxSize.width / image.size.width;
    CGFloat yScale = kImageMaxSize.height / image.size.height;
    CGFloat scale = MIN(xScale, yScale);
    CGSize size = CGSizeMake(image.size.width * scale, image.size.height * scale);
    
    UIGraphicsBeginImageContext(size);
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return result;
}


- (AVCaptureSession *)session{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc]init];
    }
    return _session;
}

- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        
        // 5.视频预览图层
        _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session]; // 传递session是为了告诉图层将来显示什么内容
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;   // 显示方式
        // 设置videoGravity,顾名思义就是视频播放时的拉伸方式,默认是AVLayerVideoGravityResizeAspect
        // AVLayerVideoGravityResizeAspect 保持视频的宽高比并使播放内容自动适应播放窗口的大小。
        // AVLayerVideoGravityResizeAspectFill 和前者类似，但它是以播放内容填充而不是适应播放窗口的大小。最后一个值会拉伸播放内容以适应播放窗口.
        // 因为考虑到全屏显示以及设备自适应,这里我们采用fill填充
        
        _previewLayer.frame = self.view.bounds;
        
        
    }
    return _previewLayer;
}

- (AVCaptureMetadataOutput *)output
{
    if (_output == nil) {
        _output = [[AVCaptureMetadataOutput alloc] init];
    }
    return _output;
}

- (AVCaptureDevice *)device
{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}

- (AVCaptureDeviceInput *)input
{
    if (_input == nil) {
        _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    }
    return _input;
}

- (CALayer *)drawLayer{
    if (!_drawLayer) {
        _drawLayer = [CALayer layer];
    }
    return _drawLayer;
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        _backView.backgroundColor = [UIColor clearColor];
    }
    return _backView;
}

@end
