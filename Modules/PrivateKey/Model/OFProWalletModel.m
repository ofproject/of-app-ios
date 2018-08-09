//
//  OFProWalletModel.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProWalletModel.h"
#import "OFTokenModel.h"
@implementation OFProWalletModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"tokens" : @"OFTokenModel"};
}


- (NSMutableArray<OFTokenModel *> *)tokens{
    if (!_tokens) {
        _tokens = [NSMutableArray array];
    }
    return _tokens;
}

@end
