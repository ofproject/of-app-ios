//
//  OFPacketWalletCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/9.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketWalletCell.h"
#import "OFPacketPayModel.h"
#import "OFShadowCornerView.h"
#import "OFPacketPayModel.h"

#define kCorner_Border  KWidthFixed(15)
#define kMargin_Border  KWidthFixed(10)

NSString *const OFPacketWalletCellIdentifier = @"OFPacketWalletCellIdentifier";

@interface OFPacketWalletCell ()

@property (nonatomic, strong) OFShadowCornerView *cornerView;

@end

@implementation OFPacketWalletCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = OF_COLOR_CLEAR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(KWidthFixed(20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kCorner_Border);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCorner_Border);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWidthFixed(43));
        make.height.mas_equalTo(KWidthFixed(31));
        make.left.mas_equalTo(self.cornerView.mas_left).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.cornerView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.cornerView.mas_centerY);
    }];
    
    [self.arrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cornerView.mas_right).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.cornerView.mas_centerY);
        make.width.mas_equalTo(KWidthFixed(10));
        make.height.mas_equalTo(KWidthFixed(15));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrorView.mas_left).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.cornerView.mas_centerY);
    }];
    
    self.arrorView.hidden = NO;
    self.detailLabel.textColor = [UIColor colorWithRGB:0xe25d4c];
    self.detailLabel.font = FixFont(15);
    self.iconImage.layer.cornerRadius = 5.f;
}

- (void)updateInfo:(OFPacketPayModel *)model
{
    if (model.type == OFPacketPayTypeWallet) {
        [self.iconImage sd_setImageWithURL: [NSURL URLWithString:model.wallet.imageUrl]];
    }else {
        self.iconImage.image = IMAGE_NAMED(@"redpacket_icon");
    }
    
    self.titleLabel.text = [NDataUtil stringWith:model.wallet.name valid:@"OF"];
    
    NSString *money = [NDataUtil stringWith:model.wallet.balance valid:@"0.00"];
    CGFloat moneyNum = [money doubleValue];
    self.detailLabel.text = [NSString stringWithFormat:@"%.3f OF",moneyNum];
}

#pragma mark - lazy load
- (OFShadowCornerView *)cornerView
{
    if (!_cornerView) {
        _cornerView = [[OFShadowCornerView alloc] initWithFrame:CGRectZero];
        _cornerView.shadowType = ShadowTypeNone;
        [self.contentView addSubview:_cornerView];
    }
    return _cornerView;
}

@end
