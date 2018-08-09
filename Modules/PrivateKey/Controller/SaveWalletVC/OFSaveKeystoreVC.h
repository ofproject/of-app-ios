//
//  OFSaveKeystoreVC.h
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFViewController.h"
@class OFProWalletModel;
@interface OFSaveKeystoreVC : OFViewController

// 私钥文件
//@property (nonatomic, copy) NSString *keystore;
@property (nonatomic, strong) OFProWalletModel *model;
@end
