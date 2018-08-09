//
//  OFProWalletModel.h
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>
@class OFTokenModel;

@interface OFProWalletModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *words;

@property (nonatomic, copy) NSString *keystore;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *balance;

/**
 钱币种类
 */
@property (nonatomic, assign) NSInteger moneyType;

/**
 钱包币种
 */
@property (nonatomic, strong) NSMutableArray<OFTokenModel *> *tokens;

@end
