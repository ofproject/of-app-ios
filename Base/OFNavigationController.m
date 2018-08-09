//
//  OFNavigationController.m
//  OFCion
//
//  Created by liyangwei on 2018/1/9.
//  Copyright © 2018年 liyangwei. All rights reserved.
//

#import "OFNavigationController.h"
#import "OFViewController.h"
@interface OFNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIPanGestureRecognizer *popRecognizer;

@end

@implementation OFNavigationController

//APP生命周期中 只会执行一次
+ (void)initialize
{
    //导航栏主题 title文字属性
    UINavigationBar *navBar = [UINavigationBar appearance];
    //    //导航栏背景图
    //    //    [navBar setBackgroundImage:[UIImage imageNamed:@"tabBarBj"] forBarMetrics:UIBarMetricsDefault];
    [navBar setBarTintColor:[UIColor whiteColor]];
    [navBar setTintColor:[UIColor blackColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName :[UIColor blackColor], NSFontAttributeName : [UIFont systemFontOfSize:17]}];
    ////导航栏透明度
    [navBar setTranslucent:NO];
    //
//    UIImage *bgImage = [UIImage imageNamed:@"navBarBg"];
//
//    bgImage = [bgImage resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch];
//    [navBar setBackgroundImage:bgImage forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];

//    [navBar setShadowImage:[UIImage new]];//去掉阴影线
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
//    UIColor *color = [UIColor colorWithRGB:0xff8f1e];
//
////    [self.navigationBar setBackgroundColor:color];
//
//    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:color size:CGSizeMake(kScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
//    //隐藏黑线
//    //    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
//    [self.navigationBar setTitleTextAttributes: @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
//
//
//    self.navigationBar.tintColor = [UIColor whiteColor];
    
    self.delegate = self;
    
//
//    self.interactivePopGestureRecognizer.delegate = nil;
    
    
    id target = self.interactivePopGestureRecognizer.delegate;
    
    SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
    
    _popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:target action:internalAction];
    _popRecognizer.maximumNumberOfTouches = 1;
    _popRecognizer.delegate = self;
    //下面是全屏返回
    //        _popRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleNavigationTransition:)];
//    _popRecognizer.edges = UIRectEdgeAll;
//    [_popRecognizer setEnabled:YES];
    [self.view addGestureRecognizer:_popRecognizer];
    self.interactivePopGestureRecognizer.enabled = NO;
    [IPhoneTool isJaukBreak];
    [IPhoneTool antiDebugging];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isKindOfClass:[UIControl class]]) {
        return NO;
    }
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //判断滑动方向，往左划不理他，默认向右
    bool isRight = YES;
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *recognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [recognizer velocityInView:recognizer.view];
        if(translation.x>0){
            //向右滑动
            isRight = YES;
        }else{
            //向左滑动
            isRight = NO;
        }
    }
    
    //只有非跟控制器才有侧滑返回的功能，其他跟控制器没有
    if (self.childViewControllers.count==1 || isRight == NO) {
        return NO;
    }else{
        //想让那个控制器不能侧滑，就做判断即可
        return YES;
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) { // 如果push进来的不是第一个控制器
        viewController.hidesBottomBarWhenPushed = YES;
        // 添加返回按钮
    }
    // 这句super的push要放在后面, 让viewController可以覆盖上面设置的leftBarButtonItem
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
//    NSLog(@"%@ - %@",self.topViewController,self.visibleViewController);
    
    return self.topViewController;
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [IPhoneTool antiDebugging];
    if ([viewController isKindOfClass:[OFViewController class]]) {
        OFViewController *vc = (OFViewController *)viewController;
        [navigationController setNavigationBarHidden:vc.n_isHiddenNavBar animated:animated];
        
        
    }
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if ([viewController isKindOfClass:[OFViewController class]]) {
        
        OFViewController *vc = (OFViewController *)viewController;
//        navigationController.interactivePopGestureRecognizer.delegate = vc.n_isPop ? self : nil;
        
        [self.popRecognizer setEnabled:vc.n_isPop];
//        navigationController.interactivePopGestureRecognizer.enabled = vc.n_isPop;
    }
    
}



@end
