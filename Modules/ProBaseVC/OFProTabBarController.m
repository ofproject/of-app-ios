//
//  OFProTabBarController.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProTabBarController.h"
#import "OFNavigationController.h"

#import "OFProProfileVC.h"
#import "OFProWalletVC.h"

@interface OFProTabBarController ()

@end

@implementation OFProTabBarController

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
    [self addChildVCWith:[[OFProWalletVC alloc]init] imageName:@"tabbar_wallet_normal" selImageName:@"tabbar_wallet_selected" title:@"钱包"];
//    [self addChildVCWith:[[OFMiningViewController alloc]init] imageName:@"tabbar_mining_normal" selImageName:@"tabbar_mining_selected" title:@"挖矿"];
    [self addChildVCWith:[[OFProProfileVC alloc]init] imageName:@"tabbar_profile_normal" selImageName:@"tabbar_profile_selected" title:@"我"];

    
    [IPhoneTool isJaukBreak];
    [IPhoneTool antiDebugging];
    
    
    
    
}

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
