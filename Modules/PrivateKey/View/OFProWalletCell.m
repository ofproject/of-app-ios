//
//  OFProWalletCell.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProWalletCell.h"
#import "OFTokenModel.h"
@interface OFProWalletCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLable;

@end

@implementation OFProWalletCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(OFTokenModel *)model{
    _model = model;
    
    
    if (model.isCoin) {
        self.iconView.image = [UIImage imageNamed:@"wallet_item_logo1"];
    }else{
        NSString *icon = [NDataUtil stringWith:model.image valid:@""];
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:icon]];
    }
    
    
    self.nameLabel.text = [NDataUtil stringWith:model.name valid:@""];
    
    CGFloat mf = [model.balance floatValue];
    
    NSString *ms = [NSString stringWithFormat:@"%.3f",mf];
    
    self.moneyLable.text = [NDataUtil stringWith:ms valid:@"0.00"];
    
}

- (void)update:(NSDictionary *)dict{
    self.iconView.image = [UIImage imageNamed:[NDataUtil stringWith:dict[@"icon"] valid:@"wallet_item_logo1"]];
    
    self.nameLabel.text = [NDataUtil stringWith:dict[@"name"] valid:@"OF"];
    
    self.moneyLable.text = [NDataUtil stringWith:dict[@"money"] valid:@"0.00"];
    
}


@end
