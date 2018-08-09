//
//  OFProWalletCell.h
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OFTokenModel;
@interface OFProWalletCell : UITableViewCell

//- (void)update:(NSDictionary *)dict;

@property (nonatomic, strong) OFTokenModel *model;

@end
