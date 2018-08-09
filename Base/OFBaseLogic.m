//
//  OFBaseLogic.m
//  OFBank
//
//  Created by Xu Yang on 2018/3/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"

@implementation OFBaseLogic

- (instancetype) initWithDelegate:(id)delegate{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

@end
