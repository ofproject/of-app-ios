//
//  OFPacketPayModel.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/9.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OFPacketPayType) {
    OFPacketPayTypeRedPacket,
    OFPacketPayTypeWallet
};

@interface OFPacketPayModel : NSObject

@property (nonatomic, assign) OFPacketPayType type;

@property (nonatomic, strong) OFWalletModel *wallet;

@end
