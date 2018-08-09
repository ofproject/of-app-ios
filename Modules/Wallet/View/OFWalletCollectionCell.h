//
//  OFWalletCollectionCell.h
//  OFBank
//
//  Created by 胡堃 on 2018/1/20.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface OFWalletCollectionCell : UICollectionViewCell

@property (nonatomic, strong) OFWalletModel *model;

// wallet_item_background1
- (void)setImageName:(NSInteger)imageName;

@end
