//
//  OFWebActivityVC.m
//  OFBank
//
//  Created by hukun on 2018/2/13.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFWebActivityVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "OFShareManager.h"
#import "OFSharedModel.h"

//@protocol NativeApisProtocol <JSExport> // 遵守JSExport协议
//
////// 调用系统相机
//- (void)callCamera;
//
//// 调用系统分享
//- (void)share:(NSString *)shareInfo;
//
//@end
//
//
//@interface NativeAPIs : NSObject<JSExport>
//
//@property (nonatomic, weak) JSContext *content;
//
//@end
//
//@implementation NativeAPIs
//
//- (instancetype)init{
//    if (self = [super init]) {
//
//    }
//    return self;
//}
//
//@end

@interface OFWebActivityVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) JSContext *jsContext;

@property (strong, nonatomic) UIView *progresslayer;

//@property (nonatomic, strong) NativeAPIs *model;
@end



@implementation OFWebActivityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.view addSubview:self.progresslayer];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    
    [self.webView loadRequest:request];
    
    //添加属性监听
//    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    
}



- (void)startLoadingAnimation{
    self.progresslayer.hidden = NO;
    self.progresslayer.width = 0;
    WEAK_SELF;
    [UIView animateWithDuration:0.4 animations:^{
        weakSelf.progresslayer.width = kScreenWidth * 0.6;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.4 animations:^{
            weakSelf.progresslayer.width = kScreenWidth * 0.8;
        }];
        
    }];
}

- (void)endLoadingAnimation{
    WEAK_SELF;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.progresslayer.width = kScreenWidth;
    } completion:^(BOOL finished) {
        weakSelf.progresslayer.hidden = YES;
    }];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    [self startLoadingAnimation];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    [self endLoadingAnimation];
    BLYLogError(@"%@ - 网页请求错误 - %zd",self.urlString,error.code);
    [MBProgressHUD showError:[NSString stringWithFormat:@"%zd - %@",error.code,error.domain]];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self endLoadingAnimation];
    [self addCustomActions];
}

- (void)addCustomActions{
    
    JSContext *context = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    [context evaluateScript:@"var arr = [3, 4, 'abc'];"];
    [self addShareWithContext:context];
    
}

- (void)addShareWithContext:(JSContext *)context {
    
    NSLog(@"分享。。。");
    WEAK_SELF;
    context[@"share"] = ^() {
        [weakSelf appActivityFriend];
    };
}



// 好友邀请
- (void)appActivityFriend{
    
    OFSharedModel *model = [[OFSharedModel alloc]init];
    model.title = @"【OF福币】邀好友分1000万福币";
    model.descript = @"OF春节发糖果，千万福币等你抢！";
//    NSString *str = self.shareString;
    model.urlString = self.shareUrl;
    model.sharedType = OFSharedTypeUrl;
    model.cannotShareSMS = YES;
    model.thumbImage = [UIImage imageNamed:@"chunjie_yaoqinghaoyou"];
    if ([NSThread isMainThread]) {
        [OFShareManager sharedToWeChatWithModel:model controller:self];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [OFShareManager sharedToWeChatWithModel:model controller:self];
        });
    }
}

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *url = request.URL.absoluteString;
//
//    if ([url rangeOfString:@"toyun://"].location != NSNotFound) {
//        NSLog(@"callCamera");
//
//        return NO;
//    }
//    return YES;
//}

- (void)dealloc{
    NSLog(@"被销毁了。");
//    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    return _webView;
}

- (UIView *)progresslayer{
    if (!_progresslayer) {
        _progresslayer = [[UIView alloc] init];
        _progresslayer.frame = CGRectMake(0, 0, 0, 3);
        _progresslayer.backgroundColor = [UIColor colorWithRGB:0x7dd63b];
    }
    return _progresslayer;
}

@end
