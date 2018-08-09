//
//  BaseModel.h
//  OFBank
//
//  Created by hukun on 2018/3/14.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject <NSCopying, NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder;

- (instancetype)initWithCoder:(NSCoder *)aDecoder;

- (instancetype)copyWithZone:(NSZone *)zone;

- (NSUInteger)hash;

- (BOOL)isEqual:(id)object;

@end
