//
//  OFQRcodeView.h
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,OFProSaveType){
    OFProSaveWords      = 1,    // 保存助记词
    OFProSaveKeystore   = 2,    // 保存私钥文件
    OFProSavePrivate    = 3,    // 保存私钥
};

@interface OFQRcodeView : UIView

// 助记词,keystore,私钥

//@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) OFProSaveType saveType;

@property (nonatomic, copy) NSString *tipContent;

@property (nonatomic, copy) NSString *name;

- (void)setImageContent:(NSString *)content;


@end
