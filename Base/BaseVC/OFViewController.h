//
//  OFViewController.h
//  OFCion
//
//  Created by liyangwei on 2018/1/9.
//  Copyright © 2018年 liyangwei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IQKeyboardManager.h>


@interface OFViewController : UIViewController

@property (nonatomic,assign) BOOL n_isWhiteStatusBar;

@property (nonatomic,assign) BOOL n_isHiddenNavBar;

@property (nonatomic,assign) BOOL n_isPop;

/**
 *  是否显示返回按钮,默认情况是YES
 */
@property (nonatomic, assign) BOOL isShowLiftBack;


/**
 是否打开键盘自动管理
 */
@property(nonatomic,assign) BOOL isOpenIQKeyBoardManager;

/**
 *  默认返回按钮的点击事件，默认是返回，子类可重写
 */
- (void)returnBack;

/**
 导航栏添加文本按钮
 
 @param titles 文本数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
-(NSMutableArray<UIButton *> *)addNavigationItemWithTitles:(NSArray *)titles isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

/**
 导航栏添加图标按钮
 
 @param imageNames 图标数组
 @param isLeft 是否是左边 非左即右
 @param target 目标
 @param action 点击方法
 @param tags tags数组 回调区分用
 */
- (void)addNavigationItemWithImageNames:(NSArray *)imageNames isLeft:(BOOL)isLeft target:(id)target action:(SEL)action tags:(NSArray *)tags;

@end
