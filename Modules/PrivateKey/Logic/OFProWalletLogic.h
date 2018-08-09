//
//  OFProWalletLogic.h
//  OFBank
//
//  Created by of on 2018/6/19.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"
#import "OFTableViewProtocol.h"



// pro钱包逻辑
@interface OFProWalletLogic : OFBaseLogic <OFTableViewProtocol>

/**
 token列表
 */
@property (nonatomic, strong) NSArray *tokens;

- (void)getBalance;


- (void)getToken;

@end
