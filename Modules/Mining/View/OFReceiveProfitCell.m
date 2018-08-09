//
//  OFReceiveProfitCell.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/6.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFReceiveProfitCell.h"

@interface OFReceiveProfitCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *walletNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *receiveBtn;


@end

@implementation OFReceiveProfitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    ViewBorderRadius(self.receiveBtn, 3, 0.5,OF_COLOR_MAIN_THEME);
    self.receiveBtn.userInteractionEnabled = NO;
}

- (void)setModel:(OFWalletModel *)model{
    _model = model;
    
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    
    self.walletNameLabel.text = [NDataUtil stringWith:model.name valid:@"OF"];
    self.walletAddressLabel.text = [NDataUtil stringWith:model.address valid:@""];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
