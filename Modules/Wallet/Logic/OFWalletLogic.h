//
//  OFWalletLogic.h
//  OFBank
//
//  Created by 谢鹏翔 on 2018/3/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"
#import "OFTableViewProtocol.h"

@interface OFWalletLogic : OFBaseLogic <OFTableViewProtocol>

- (NSString *)tipTitle;
- (NSString *)totalMoney;

- (void)getBalance;
- (void)forceGetBalance;

@end
