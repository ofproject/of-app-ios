//
//  OFAssetsModel.h
//  OFBank
//
//  Created by of on 2018/6/19.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFAssetsModel : NSObject

@property (nonatomic, assign) NSInteger coinType;

@property (nonatomic, copy) NSString *name;

/**
 精准度
 */
@property (nonatomic, copy) NSString *accuracy;

/**
 合约地址
 */
@property (nonatomic, copy) NSString *contractAddress;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *sender;

@property (nonatomic, copy) NSString *slogan;

/**
 tokenID
 */
@property (nonatomic, copy) NSString *toid;

/**
 总量
 */
@property (nonatomic, copy) NSString *total;

/**
 余额
 */
@property (nonatomic, copy) NSString *balance;

@end
