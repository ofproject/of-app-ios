//
//  OFLoginLogic.m
//  OFBank
//
//  Created by Xu Yang on 2018/3/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFLoginLogic.h"
#import "OFLoginAPI.h"
#import <CloudPushSDK/CloudPushSDK.h>
#import "ToolObject.h"

@interface OFLoginLogic ()

// 密码输入错误次数
@property (nonatomic, assign) NSInteger errPwdCount;

@end

@implementation OFLoginLogic

- (instancetype)init
{
    self = [super init];
    if (self) {
        _errPwdCount = 0;
    }
    return self;
}

#pragma mark - 登录
- (void)loginWithPhone:(NSString *)phone password:(NSString *)password code:(NSString *)code finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr, BOOL showChangePwd))finished{
    
    if (![ToolObject isMobileNumber:phone]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (code.length < 1) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    if (password.length < 1) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    password = [NDataUtil md5:password];
    NSAssert(phone != nil && phone.length != 0, @"login - telphone is nil");
    NSAssert(password != nil && password.length != 0, @"login - password is nil");
    NSAssert(code != nil && code.length != 0, @"login - sms code is nil");
    
    [MBProgressHUD showMessage:@"登录中..."];
    WEAK_SELF;
    [OFLoginAPI loginWithPhone:phone password:password code:code finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        [MBProgressHUD hideHUD];
        if (success) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseObject = (NSDictionary *)obj;
                NSInteger status = [NDataUtil intWith:responseObject[@"status"] valid:0];
                NSString *message = obj[@"message"];
                if (status == 200) {
                    NSDictionary *data = [NDataUtil dictWith:responseObject[@"data"]];
                    KcurUser = [OFUserModel modelWithJSON:data];
                    KisLogin = YES;
                    [CloudPushSDK bindAccount:[KcurUser.uid stringValue] withCallback:^(CloudPushCallbackResult *res) {
                        
                    }];
                    if (KcurUser.wallets.count) {
                        KcurUser.currentWallet = KcurUser.wallets.firstObject;
                    }
                    [KUserManager saveUserInfo];
                    [OFMobileClick event:MobileClick_phone_login];
                    if (finished) {
                        finished(YES, responseObject, nil, message, NO);
                    }
                    weakSelf.errPwdCount = 0;
                    NSLog(@"登录成功");
                }else if(status == 801){ // 密码/手机号错误
                    weakSelf.errPwdCount++;
                    if (weakSelf.errPwdCount == 3) {
                        if (finished) {
                            finished(NO, responseObject, nil, message, YES);
                        }
                    }else {
                        if (finished) {
                            finished(NO, responseObject, nil, message, NO);
                        }
                    }
                }else{
                    if (finished) {
                        finished(NO, responseObject, nil, message, NO);
                    }
                    BLYLogWarn(@"登录失败");
                }
            }else{
                finished(NO,obj,error,@"数据不合法", NO);
            }
        }else{
            finished(NO,obj,error,messageStr, NO);
        }
    }];
    
}

#pragma mark - 自动登录
- (void)autoLogin{
    
}


#pragma mark - 注册
- (void)registerUserWithPhone:(NSString *)phone password:(NSString *)password email:(NSString *)email code:(NSString *)code finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr))finished{
    
    if (![ToolObject isMobileNumber:phone]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    if (code.length < 1) {
        [MBProgressHUD showError:@"验证码不能为空"];
    }
    
    if (password.length < 1) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    password = [NDataUtil md5:password];
    NSAssert(phone != nil && phone.length != 0, @"register - telphone is nil");
    NSAssert(password != nil && password.length != 0, @"register - password is nil");
    NSAssert(code != nil && code.length != 0, @"register - code is nil");
    
    [MBProgressHUD showMessage:@"注册中..."];
    [OFLoginAPI registerUserWithPhone:phone password:password email:email code:code finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        [MBProgressHUD hideHUD];
        if (success) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseObject = (NSDictionary *)obj;
                NSInteger status = [NDataUtil intWith:responseObject[@"status"] valid:0];
                NSString *message = obj[@"message"];
                if (status == 200) {
                    
                    NSDictionary *data = [NDataUtil dictWith:responseObject[@"data"]];
                    KcurUser = [OFUserModel modelWithJSON:data];
                    
                    // 注册成功
                    [CloudPushSDK bindAccount:[KcurUser.uid stringValue] withCallback:^(CloudPushCallbackResult *res) {
                        
                    }];
                    if (KcurUser.wallets.count) {
                        KcurUser.currentWallet = KcurUser.wallets.firstObject;
                    }
                    KcurUser.phone = phone;
//                    KcurUser.email = email;
                    KisLogin = YES;
                    [Bugly setUserIdentifier:KcurUser.phone];
                    [KUserManager saveUserInfo];
                    
                    if (finished) {
                        finished(YES, responseObject, nil, message);
                    }
                }else if(status == 401){
                    if (finished) {
                        finished(NO, responseObject, nil, message);
                    }
                }else if (status == 404){
                    if (finished) {
                        finished(NO, responseObject, nil, message);
                    }
                }else{
                    if (finished) {
                        finished(NO, responseObject, nil, message);
                    }
                }
            }else{
                finished(NO,obj,nil,@"数据异常");
            }
        }else{
            finished(NO,obj,error,messageStr);
        }
    }];
}

#pragma mark - 忘记密码
- (void)forgetpasswordWithPhone:(NSString *)phone code:(NSString *)code password:(NSString *)password finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr))finished{
    if (![ToolObject isMobileNumber:phone]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    if (code.length < 1) {
        [MBProgressHUD showError:@"验证码不能为空"];
        return;
    }
    
    if (password.length < 1) {
        [MBProgressHUD showError:@"密码不能为空"];
        return;
    }
    
    password = [NDataUtil md5:password];
    NSAssert(phone != nil && phone.length != 0, @"forgetPwd - telphone is nil");
    NSAssert(password != nil && password.length != 0, @"forgetPwd - password is nil");
    NSAssert(code != nil && code.length != 0, @"forgetPwd - code is nil");
    
    [MBProgressHUD showMessage:@""];
    
    [OFLoginAPI forgetpasswordWithPhone:phone code:code password:password finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        [MBProgressHUD hideHUD];
        if (success) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseObject = (NSDictionary *)obj;
                NSInteger status = [NDataUtil intWith:responseObject[@"status"] valid:0];
                NSString *message = responseObject[@"message"];
                if (status == 200) {
                    if (finished) {
                        finished(YES, responseObject, nil, message);
                    }
                }else if(status == 401){
                    if (finished) {
                        finished(NO, responseObject, nil, message);
                    }
                }else{
                    if (finished) {
                        finished(NO, responseObject, nil, message);
                    }
                }
            }else{
                finished(NO,obj,nil,@"数据异常");
            }
        }else{
            finished(NO,obj,error,messageStr);
        }
    }];
    
}


#pragma mark - 修改密码
- (void)changePasswordWithOldPwd:(NSString *)oldPwd password:(NSString *)password finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr))finished{
    oldPwd = [NDataUtil md5:oldPwd];
    password = [NDataUtil md5:password];
    NSAssert(oldPwd != nil && oldPwd.length != 0, @"changePwd - oldPwd is nil");
    NSAssert(password != nil && password.length != 0, @"changePwd - password is nil");
    
    [OFLoginAPI changePasswordWithOldPwd:oldPwd password:password finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseObject = (NSDictionary *)obj;
                NSInteger status = [NDataUtil intWith:responseObject[@"status"] valid:0];
                NSString *message = responseObject[@"message"];
                if (status == 200) {
                    if (finished) {
                        finished(YES, responseObject, nil, message);
                    }
                }else{
                    if (finished) {
                        finished(NO, responseObject, nil, message);
                    }
                }
                
            }else{
                finished(NO,obj,nil,@"数据异常");
            }
        }else{
            finished(NO,obj,error,messageStr);
        }
    }];
}

#pragma mark - 实名认证
- (void)authenticationWithName:(NSString *)name IDCard:(NSString *)IDCard finished:(void(^)(BOOL success, id obj, NSError *error, NSString *messageStr))finished{
    
    if (![ToolObject isValidateIDCard:IDCard]) {
        [MBProgressHUD showError:@"身份证号码格式错误"];
        return;
    }
    
    if (name.length < 1) {
        [MBProgressHUD showError:@"请输入姓名"];
        return;
    }
    
    [OFLoginAPI authenticationWithName:name IDCard:IDCard finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSDictionary *responseObject = (NSDictionary *)obj;
                NSInteger status = [NDataUtil intWith:responseObject[@"status"] valid:0];
                NSString *message = responseObject[@"message"];
                if (status == 200) {
                    [KUserManager saveUserInfo];
                    if (finished) {
                        finished(YES, responseObject, nil, @"认证成功");
                    }
                }else if (status == 413){
                    if (finished) {
                        finished(NO, responseObject, nil, @"该身份证已经达到认证上限了");
                    }
                }else{
                    if (finished) {
                        finished(NO, responseObject, nil, message);
                    }
                }
                
            }else{
                finished(NO,obj,nil,@"数据异常");
            }
        }else{
            finished(NO,obj,error,messageStr);
        }
    }];
    
}

@end
