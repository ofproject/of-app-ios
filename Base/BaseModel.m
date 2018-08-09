//
//  BaseModel.m
//  OFBank
//
//  Created by hukun on 2018/3/14.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [self modelEncodeWithCoder:aCoder];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    return [self modelInitWithCoder:aDecoder];
}

- (instancetype)copyWithZone:(NSZone *)zone{
    return [self modelCopy];
}

- (NSUInteger)hash{
    return [self modelHash];
}

- (BOOL)isEqual:(id)object{
    return [self modelIsEqual:object];
}

@end
