//
//  OFAccountSafeCell.h
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OFAccountSafeCell : UITableViewCell

- (void)upData:(NSDictionary *)dict;

- (void)hiddenLine:(BOOL)hidden;

@end
