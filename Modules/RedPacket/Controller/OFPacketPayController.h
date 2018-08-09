//
//  OFPacketPayController.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFViewController.h"
#import "OFBaseTableViewController.h"

@protocol PacketPayControllerDelegate <NSObject>

- (void)packetPayControllerChooseWallet:(OFWalletModel *)wallet;

@end

@interface OFPacketPayController : OFBaseTableViewController

- (instancetype)initWithMinRedPacketAmount:(NSString *)amount;

@property (nonatomic, weak) id<PacketPayControllerDelegate> delegate;

@end
