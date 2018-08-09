//
//  OFProProfileLogic.h
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"
#import "OFTableViewProtocol.h"
@interface OFProProfileLogic : OFBaseLogic <OFTableViewProtocol>

/**
 更新用户名
 
 @param userName 用户名
 */
- (void) updateUserName:(NSString *)userName withBlock:(void (^)(bool suc, NSString *errorMessage))block;

/*
 * 更新头像
 */
- (void)updateUserAvatar:(NSData *)imageData withBlock:(void (^)(bool suc, NSString *avatarUrl, NSString *errorMessage))block;

@end
