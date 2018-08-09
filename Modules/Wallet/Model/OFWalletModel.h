//
//  OFWalletModel.h
//  OFBank
//
//  Created by 胡堃 on 2018/1/16.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, OFCoinType){
    OFCoinTypeOF = 1,       // OF
    OFCoinTypeBitcoin = 2,  // 比特币
    OFCoinTypeEthereum = 3, // 以太坊
};

@interface OFWalletModel : NSObject

@property (nonatomic, copy) NSString *wid;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, copy) NSString *balance;

@property (nonatomic, assign) OFCoinType cointype;

@property (nonatomic, copy) NSString *name;
//钱包图片
@property (nonatomic, copy) NSString * imageUrl;
//钱包背景图
@property (nonatomic, copy) NSString * bg_url;

//@property (nonatomic, assign) BOOL showInfo;

@end
