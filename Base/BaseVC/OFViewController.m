//
//  OFViewController.m
//  OFCion
//
//  Created by liyangwei on 2018/1/9.
//  Copyright © 2018年 liyangwei. All rights reserved.
//

#import "OFViewController.h"

@interface OFViewController ()

@end

@implementation OFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = OF_COLOR_WHITE;
    self.n_isWhiteStatusBar = NO;
    self.n_isPop = YES;
//    [self setNavigationReturnBtn];
    self.isShowLiftBack = YES;
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.isOpenIQKeyBoardManager = NO;
    [IPhoneTool antiDebugging];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isOpenIQKeyBoardManager) {
        [[IQKeyboardManager sharedManager]setEnable:YES];
        [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    }else{
        [[IQKeyboardManager sharedManager]setEnable:NO];
        [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if (_isOpenIQKeyBoardManager) {
        [[IQKeyboardManager sharedManager]setEnable:NO];
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;
    }
}

/**
 *  是否显示返回按钮
 */
- (void) setIsShowLiftBack:(BOOL)isShowLiftBack
{
    _isShowLiftBack = isShowLiftBack;
    NSInteger VCCount = self.navigationController.viewControllers.count;
    //下面判断的意义是 当VC所在的导航控制器中的VC个数大于1 或者 是present出来的VC时，才展示返回按钮，其他情况不展示
    if (isShowLiftBack && ( VCCount > 1 || self.navigationController.presentingViewController != nil)) {
        
        [self addNavigationItemWithImageNames:@[@"nav_back_normal"] isLeft:YES target:self action:@selector(returnBack) tags:nil];
    } else {
        self.navigationItem.hidesBackButton = YES;
        UIBarButtonItem * NULLBar=[[UIBarButtonItem alloc]initWithCustomView:[UIView new]];
        self.navigationItem.leftBarButtonItem = NULLBar;
    }
}

- (void)setNavigationReturnBtn{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setImage:[UIImage imageNamed:@"nav_back_normal"] forState:UIControlStateNormal];

    button.frame = CGRectMake(0, 0, 44, 44);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

    [button addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

}

#pragma mark - 返回点击事件
- (void)returnBack{
    if (self.navigationController.viewControllers.count>1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

//- (void)hidBack {
//    
//    self.navigationItem.leftBarButtonItem.customView.hidden = YES;
//    
//}
//
//- (void)showBack {
//    
//    self.navigationItem.leftBarButtonItem.customView.hidden = NO;
//    
//}


#pragma mark ————— 导航栏 添加图片按钮 —————
/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    NSMutableArray * items = [[NSMutableArray alloc] init];
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    NSInteger i = 0;
    for (NSString * imageName in imageNames) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        
        if (isLeft) {
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        }else{
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        }
        
        btn.tag = [tags[i++] integerValue];
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
}
#pragma mark ————— 导航栏 添加文字按钮 —————
- (NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags
{
    
    NSMutableArray * items = [[NSMutableArray alloc] init];
    
    //调整按钮位置
    //    UIBarButtonItem* spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //    //将宽度设为负值
    //    spaceItem.width= -5;
    //    [items addObject:spaceItem];
    
    NSMutableArray * buttonArray = [NSMutableArray array];
    NSInteger i = 0;
    for (NSString * title in titles) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 0, 30, 30);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = Font(15);
        [btn setTitleColor:OF_COLOR_TITLE forState:UIControlStateNormal];
        btn.tag = [tags[i++] integerValue];
        [btn sizeToFit];
        
        if (isLeft) {
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        }else{
            [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        }
        
        UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn];
        [items addObject:item];
        [buttonArray addObject:btn];
    }
    if (isLeft) {
        self.navigationItem.leftBarButtonItems = items;
    } else {
        self.navigationItem.rightBarButtonItems = items;
    }
    return buttonArray;
}


// 设置状态色是否为白色
- (void) setN_isWhiteStatusBar:(BOOL)n_isWhiteStatusBar
{
    if(_n_isWhiteStatusBar==n_isWhiteStatusBar){
        return;
    }
    _n_isWhiteStatusBar = n_isWhiteStatusBar;
    if (self.navigationController) {
        [self.navigationController setNeedsStatusBarAppearanceUpdate];
    }else{
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    if (self.n_isWhiteStatusBar) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}


- (void)dealloc{
    NSLog(@"");
    [IPhoneTool antiDebugging];
}


@end
