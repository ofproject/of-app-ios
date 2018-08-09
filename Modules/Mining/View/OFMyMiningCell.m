//
//  OFMyMiningCell.m
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFMyMiningCell.h"
#import "OFMinerModel.h"

#define kIconWidth 42.f
#define kMarigin_Left 16
#define kSubviews_Space 6

CGFloat const kMyMiningCellHeight = 70.f;
NSString *const kMyMiningCellIdentifier = @"kMyMiningCellIdentifier";

@implementation OFMyMiningCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setModel:(OFMinerModel *)model
{
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.profileUrl] placeholderImage:[UIImage imageNamed:@"mining_miner_icon"]];
    self.iconImage.layer.cornerRadius = kIconWidth * 0.5;
    self.titleLabel.text = model.name;
    
    NSString *text = [NSString stringWithFormat:@"累计挖矿%@分钟，矿池收益%@", model.miningTime, model.miningReward];
    NSMutableAttributedString *attrText=[[NSMutableAttributedString alloc]initWithString:text];
    NSRange range1=[[attrText string]rangeOfString:model.miningTime];
    [attrText addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:range1];
    NSRange range2=[[attrText string]rangeOfString:model.miningReward];
    [attrText addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:range2];
    self.detailLabel.attributedText = attrText;
}

- (void)setupUI
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kIconWidth);
        make.height.mas_equalTo(kIconWidth);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMarigin_Left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kSubviews_Space);
        make.top.mas_equalTo(self.iconImage.mas_top);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kSubviews_Space);
        make.bottom.mas_equalTo(self.iconImage.mas_bottom);
    }];
}

@end
