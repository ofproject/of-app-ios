//
//  OFSavePrivateVC.h
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFViewController.h"
@class OFProWalletModel;
@interface OFSavePrivateVC : OFViewController

// 私钥
@property (nonatomic, copy) NSString *privatekey;
@property (nonatomic, copy) NSString *name;

//@property (nonatomic, strong) OFProWalletModel *model;

@end
