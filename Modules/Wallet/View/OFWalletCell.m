//
//  OFWalletCell.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/6.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFWalletCell.h"

@interface OFWalletCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletBalanceLabel;

@end

@implementation OFWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewRadius(self.iconImage, 2);
}


- (void)setModel:(OFWalletModel *)model{
    _model = model;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    
    self.walletNameLabel.text = [NDataUtil stringWith:model.name valid:@"OF"];
    
    self.walletAddressLabel.text = [NDataUtil stringWith:model.address valid:@"--"];
    
    NSString *money = [NDataUtil stringWith:model.balance valid:@"0.00"];
    
    CGFloat moneyNum = [money doubleValue];
    self.walletBalanceLabel.text = [NSString stringWithFormat:@"%.3f",moneyNum];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
