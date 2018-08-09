//
//  OFLoginLogic.h
//  OFBank
//
//  Created by Xu Yang on 2018/3/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"

@protocol LoginLogicDelegate <NSObject>
@optional
//此业务模块使用block回调，暂不需要delegate

@end

@interface OFLoginLogic : OFBaseLogic

/*
 * 登录
 */
- (void)loginWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr, BOOL showChangePwd))finished;

/*
 * 自动登录
 */
//- (void)autoLogin;


/*
 * 注册
 */
- (void)registerUserWithPhone:(NSString *)phone password:(NSString *)password email:(NSString *)email code:(NSString *)code finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr))finished;

/*
 * 忘记密码
 */
- (void)forgetpasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr))finished;

/*
 * 获取个人信息 (暂无)
 */

/*
 * 修改密码
 */
- (void)changePasswordWithOldPwd:(NSString *)oldPwd password:(NSString *)password finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr))finished;

/*
 * 实名认证
 */
- (void)authenticationWithName:(NSString *)name IDCard:(NSString *)IDCard finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr))finished;

@end
