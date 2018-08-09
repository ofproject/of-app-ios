//
//  OFWalletNewCell.h
//  OFBank
//
//  Created by hukun on 2018/2/27.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OFWalletModel;
@interface OFWalletNewCell : UITableViewCell

@property (nonatomic, assign) BOOL showInfo;
@property (nonatomic, strong) OFWalletModel *model;

- (void)beginAnimation:(BOOL)showInfo;

- (void)setimageName:(NSInteger)row;




@end
