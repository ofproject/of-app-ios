//
//  OFTabBarController.m
//  OFCion
//
//  Created by liyangwei on 2018/1/9.
//  Copyright © 2018年 liyangwei. All rights reserved.
//

#import "OFTabBarController.h"
#import "OFNavigationController.h"
#import "OFWalletViewController.h"
#import "OFProfileViewController.h"
#import "OFMiningViewController.h"

#import "OFProWalletVC.h"

@interface OFTabBarController ()

@end

@implementation OFTabBarController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
//    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBar_background_image"]];
    
    [self.tabBar setBackgroundImage:[UIImage new]];
    [self.tabBar setShadowImage:[UIImage new]];
    
//    self.tabBar.layer.shadowOpacity = 0.5;
//    self.tabBar.layer.shadowColor = Orange_New_Color.CGColor;
//    self.tabBar.layer.shadowRadius = 1;
//    self.tabBar.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    
    self.tabBar.layer.shadowColor = [UIColor blackColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    self.tabBar.layer.shadowRadius = 3.0;
    self.tabBar.layer.shadowOpacity = 0.5;
    
//    NSString *title2 = NSLocalizedString(@"mining", nil);
//    NSString *title3 = NSLocalizedString(@"me", nil);
    // 48*48  72*72
    // 普通版本
//    [self addChildVCWith:[[OFWalletViewController alloc]init] imageName:@"tabbar_wallet_normal" selImageName:@"tabbar_wallet_selected" title:@"OF"];
    // pro版本
    [self addChildVCWith:[[OFProWalletVC alloc]init] imageName:@"tabbar_wallet_normal" selImageName:@"tabbar_wallet_selected" title:@"OF"];
    
    [self addChildVCWith:[[OFMiningViewController alloc]init] imageName:@"tabbar_mining_normal" selImageName:@"tabbar_mining_selected" title:@"挖矿"];
    [self addChildVCWith:[[OFProfileViewController alloc]init] imageName:@"tabbar_profile_normal" selImageName:@"tabbar_profile_selected" title:@"我"];
//    [self addChildVCWith:[[OFProfileViewController alloc]init] imageName:@"project" selImageName:@"project-selected" title:@"我"];
    self.selectedIndex = 1;
    
    [IPhoneTool isJaukBreak];
    [IPhoneTool antiDebugging];
}

/**
 *  检查更新回调
 *  @param response 检查更新的返回结果
 */
//- (void)updateMethod:(NSDictionary *)response{
//    NSLog(@"%@",response);
//
//    if (response) {
//        NSString *message = [NDataUtil stringWith:response[@"releaseNote"] valid:@"有新版本啦~快去更新吧！"];
//
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSString *appURL = [NDataUtil stringWith:response[@"appUrl"] valid:@""];
//            if (@available(iOS 10.0, *)) {
//                // @{UIApplicationOpenURLOptionUniversalLinksOnly : @YES}
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL] options:@{} completionHandler:^(BOOL success) {
//                    if (success) {
//                        NSLog(@"打开成功");
//                        [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
//                    }else{
//                        NSLog(@"打开失败");
//                    }
//                }];
//            } else {
//
//                BOOL success = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appURL]];
//
//                if (success) {
//                    [[PgyUpdateManager sharedPgyManager] updateLocalBuildNumber];
//                    NSLog(@"打开成功");
//                }else{
//                    NSLog(@"打开失败");
//                }
//
//            }
//
//        }];
//
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"暂不升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//
//        }];
//        NSString *key = @"_titleTextColor";
//        UIColor *color = [UIColor colorWithRGB:0xff9f4e];
//
//        [action1 setValue:color forKey:key];
//        [action2 setValue:color forKey:key];
//
//        [alert addAction:action1];
//        [alert addAction:action2];
//        [self.selectedViewController presentViewController:alert animated:YES completion:nil];
//    }
//}

- (void)addChildVCWith:(UIViewController *)viewController imageName:(NSString *)imageName selImageName:(NSString *)selImageName title:(NSString *)title{
    
    OFNavigationController *nav = [[OFNavigationController alloc]initWithRootViewController:viewController];
    
    [nav.tabBarItem setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [nav.tabBarItem setSelectedImage:[[UIImage imageNamed:selImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    viewController.title = title;//这句代码相当于上面两句代码
    [nav.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:OF_COLOR_MAIN_THEME} forState:UIControlStateSelected];
    [nav.tabBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    nav.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, 0);
    [self addChildViewController:nav];
}


- (void)resetTabBar{
    // 重置
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UINavigationController *nav;
        if ([obj isKindOfClass:[UINavigationController class]]) {
            nav = obj;
        }else if([obj isKindOfClass:[UIViewController class]]){
            nav = obj.navigationController;
        }
        if ([nav isKindOfClass:[UINavigationController class]]) {
            
            [nav.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (idx != 0) {
                    [obj removeFromParentViewController];
                }
            }];
        }
    }];
    if (self.viewControllers.count) {
        self.selectedIndex = 0;
    }
    self.tabBar.hidden = NO;
}


@end
