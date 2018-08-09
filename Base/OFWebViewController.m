//
//  OFWebViewController.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFWebViewController.h"
#import <WebKit/WebKit.h>
#import "OFSharedModel.h"
#import "OFShareManager.h"
#import "config.h"
#import "OFPoolModel.h"

@interface OFWebJSModel : NSObject<WKScriptMessageHandler>

@property (nonatomic, weak) id<WKScriptMessageHandler> delegate;

@end



@implementation OFWebJSModel

- (instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}

@end


@interface OFWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, assign) NSUInteger loadCount;

@property (nonatomic, strong) OFWebJSModel *model;

@property (nonatomic,assign) double lastProgress;//上次进度条位置
@end

static NSString *const HtmlAction = @"invite";

@implementation OFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
//    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.mas_equalTo(0);
//        make.height.mas_equalTo(5);
//    }];
    
    
    if (self.htmlStr.length > 0) {
        
        NSString *path = [[NSBundle mainBundle] bundlePath];
        NSURL *baseURL = [NSURL fileURLWithPath:path];
        
        [self.webView loadHTMLString:self.htmlStr baseURL:baseURL];
            
    }else{
        self.urlString = [NSString activityUrl:self.urlString cid:nil];
        NSURL *url = [NSURL URLWithString:self.urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    }
    
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"loading"]) {
        
    }
    
    if ([keyPath isEqualToString:@"title"]) {
        NSLog(@"%@",self.webView.title);
        self.title = self.webView.title;
    }
    
    if ([keyPath isEqualToString:@"URL"]) {
        
    }
    
    
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        [self updateProgress:_webView.estimatedProgress];
    }
    
}

#pragma mark -  更新进度条
-(void)updateProgress:(double)progress{
    self.progressView.alpha = 1;
    if(progress > _lastProgress){
        [self.progressView setProgress:self.webView.estimatedProgress animated:YES];
    }else{
        [self.progressView setProgress:self.webView.estimatedProgress];
    }
    _lastProgress = progress;
    
    if (progress >= 1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.progressView.alpha = 0;
            [self.progressView setProgress:0];
            _lastProgress = 0;
        });
    }
}

// 页面开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    self.loadCount ++;
    NSLog(@"%s",__func__);
}

// 内容返回时
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    self.loadCount--;
    NSLog(@"%s",__func__);
}

//
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    self.loadCount--;
    NSLog(@"%@",error);
    NSString *errStr = [NSString stringWithFormat:@"code = %zd\n%@",error.code,error.domain];
    [MBProgressHUD showError:errStr];
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler{
    
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
//        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
//
//        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
//    }
    
    NSLog(@"%s",__func__);
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        if ([challenge previousFailureCount] == 0) {
            
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            
            completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
            
        } else {
            completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        }
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
//    NSString *inputValueJS = @"document.getElementsByName('input')[0].attributes['value'].value";
    
    NSString *appVersion = [NSString stringWithFormat:@"getAppVersion('%@')",[Config appVersion]];

    [webView evaluateJavaScript:appVersion completionHandler:^(id _Nullable response, NSError * _Nullable error) {

        NSLog(@"%@ - %@",response,error);

    }];
    
    NSLog(@"%s",__func__);
    
    [self.webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    self.title = webView.title; 
    
}

// 在JS端调用alert函数时
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
    
}

// 在JS端调用confirm函数时
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
}

// 在JS端调用prompt函数时
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * _Nullable))completionHandler{
    
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"%@",message.name);
    NSLog(@"%@",message.body);
    if ([message.name isEqualToString:HtmlAction]) {
        NSLog(@"点击了按钮~~~");
        [self appActivityFriend];
    }
}

// 好友邀请
- (void)appActivityFriend{
    OFSharedModel *model = [[OFSharedModel alloc]init];
    model.title = @"好友已帮你抢到一个福包！";
    model.descript = @"点击即可领取\n500000个福包 拉上好友抢抢抢";
    //    NSString *str = self.shareString;
    model.urlString = self.shareUrl;
    model.sharedType = OFSharedTypeUrl;
    model.cannotShareSMS = YES;
    model.thumbImage = [UIImage imageNamed:@"wechat_share_icon"];
    if ([NSThread isMainThread]) {
        [OFShareManager sharedToWeChatWithModel:model controller:self];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [OFShareManager sharedToWeChatWithModel:model controller:self];
        });
    }
}


- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.webView.configuration.userContentController removeScriptMessageHandlerForName:HtmlAction];
}


- (void)setLoadCount:(NSUInteger)loadCount{
    
    _loadCount = loadCount;
    
    if (loadCount == 0) {
        self.progressView.hidden = YES;
        [self.progressView setProgress:0 animated:NO];
    }else{
        self.progressView.hidden = NO;
        CGFloat oldP = self.progressView.progress;
        CGFloat newP = (1.0 - oldP) / (loadCount + 1) + oldP;
        if (newP > 0.95) {
            newP = 0.95;
        }
        [self.progressView setProgress:newP animated:YES];
    }
    
}


/*
 *通过js获取htlm中图片url
 */
-(NSArray *)getImageUrlByJS:(WKWebView *)wkWebView{
    
    //查看大图代码
    //js方法遍历图片添加点击事件返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgUrlStr='';\
    for(var i=0;i<objs.length;i++){\
    if(i==0){\
    if(objs[i].alt==''){\
    imgUrlStr=objs[i].src;\
    }\
    }else{\
    if(objs[i].alt==''){\
    imgUrlStr+='#'+objs[i].src;\
    }\
    }\
    objs[i].onclick=function(){\
    if(this.alt==''){\
    document.location=\"myweb:imageClick:\"+this.src;\
    }\
    };\
    };\
    return imgUrlStr;\
    };";
    
    //用js获取全部图片
    [wkWebView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        NSLog(@"js___Result==%@",Result);
        NSLog(@"js___Error -> %@", error);
    }];
    
    
    NSString *js2=@"getImages()";
    
    __block NSArray *array=[NSArray array];
    [wkWebView evaluateJavaScript:js2 completionHandler:^(id Result, NSError * error) {
        NSLog(@"js2__Result==%@",Result);
        NSLog(@"js2__Error -> %@", error);
        
        NSString *resurlt=[NSString stringWithFormat:@"%@",Result];
        
        if([resurlt hasPrefix:@"#"])
        {
            resurlt=[resurlt substringFromIndex:1];
        }
        NSLog(@"result===%@",resurlt);
        array=[resurlt componentsSeparatedByString:@"#"];
        NSLog(@"array====%@",array);
//        [wkWebView setMethod:array];
    }];
    
    return array;
}

#pragma mark - 懒加载
- (WKWebView *)webView{
    
    if (_webView == nil) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc]init];
//        config.preferences.minimumFontSize = 18;
        config.userContentController = [[WKUserContentController alloc] init];
        [config.userContentController addScriptMessageHandler:self.model name:HtmlAction];
        
        WKPreferences *preferences = [[WKPreferences alloc]init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preferences;
        
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.allowsBackForwardNavigationGestures =YES;//打开网页间的 滑动返回
        _webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        
    }
    return _webView;
    
}

- (UIProgressView *)progressView{
    
    if (_progressView == nil) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.tintColor = OF_COLOR_MAIN_THEME;
        _progressView.trackTintColor = [UIColor clearColor];
        _progressView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 3.0);
        [_webView addSubview:_progressView];
    }
    return _progressView;
}

- (OFWebJSModel *)model{
    if (!_model) {
        _model = [[OFWebJSModel alloc]init];
        _model.delegate = self;
    }
    return _model;
}

@end
