//
//  OFQRcodeScanVC.h
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//  二维码扫描

#import "OFViewController.h"

@protocol OFQRcodeSacnDelegate<NSObject>

- (void)resultAddressString:(NSString *)address;

@end

@interface OFQRcodeScanVC : OFViewController

@property (nonatomic, weak) id<OFQRcodeSacnDelegate> delegate;

@end



