//
//  OFBaseLogic.h
//  OFBank
//
//  Created by Xu Yang on 2018/3/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//  逻辑基类

#import <Foundation/Foundation.h>

@protocol BaseLogicDelegate <NSObject>
@optional
/**
 数据加载成功
 */
-(void)requestDataSuccess;

/**
 数据加载成功(分页数据中没有更多数据回调)
 */
-(void)requesetNomoreDataSuccess;

/**
 数据加载失败
 */
-(void)requestDataFailure:(NSString *)errMessage;

@end

@interface OFBaseLogic : NSObject

@property (nonatomic, weak) id delegate;

- (instancetype) initWithDelegate:(id)delegate;

@end
