//
//  OFAboutUS.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFAboutUS.h"

@interface OFAboutUS ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;

@end

@implementation OFAboutUS

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    self.view.backgroundColor = OF_COLOR_BACKGROUND;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    // app名称
    NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLabel.text = NSStringFormat(@"%@ v%@",app_Name,app_Version);
}
- (IBAction)versionInfo:(id)sender {
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = @"版本介绍";
    webVC.urlString = NSStringFormat(@"%@%@",URL_H5_main,URL_H5_Update);;
    [self.navigationController pushViewController:webVC animated:YES];
}
- (IBAction)agreementInfo:(id)sender {
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = @"用户协议和隐私条款";
    webVC.urlString = NSStringFormat(@"%@%@",URL_H5_main,URL_H5_privacy);
    [self.navigationController pushViewController:webVC animated:YES];
}
- (IBAction)callUS:(id)sender {
       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"mailto:service@ofbank.com"]];
}
- (IBAction)applyLord:(id)sender {
    // 把地址字符串复制到粘贴板。
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"OFOFOFBANK";
    //    NSString *title = NSLocalizedString(@"copysuccess", nil);
    [MBProgressHUD showSuccess:@"客服微信已复制到粘贴板"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
