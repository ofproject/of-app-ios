//
//  OFPacketPayCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketPayCell.h"

#define kMargin_Border  KWidthFixed(15)

NSString *const OFPacketPayCellIdentifier = @"OFPacketPayCellIdentifier";

@interface OFPacketPayCell ()
{
    BOOL _canSelected;
}
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *shadeView;

@end

@implementation OFPacketPayCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
        [self showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:kMargin_Border trailingOffset:kMargin_Border];
    }
    return self;
}

- (void)setupUI
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWidthFixed(50));
        make.height.mas_equalTo(KWidthFixed(35));
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(KWidthFixed(8));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.shadeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.contentView);
    }];
    
    self.detailLabel.textColor = OF_COLOR_MAIN_THEME;
    self.detailLabel.font = FixFont(13);
    self.iconImage.layer.cornerRadius = 5.f;
}

- (void)updateLayout
{
    if (_canSelected) {
        self.shadeView.hidden = YES;
        self.tipLabel.hidden = YES;
        self.titleLabel.textColor = OF_COLOR_TITLE;
        self.titleLabel.font = FixFont(15);
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }else {
        self.shadeView.hidden = NO;
        self.tipLabel.hidden = NO;
        self.titleLabel.textColor = OF_COLOR_MINOR;
        self.titleLabel.font = FixFont(13);
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-KWidthFixed(8));
        }];
    }
}

- (void)updateInfo:(OFWalletModel *)model canSelected:(BOOL)canSelected
{
    _canSelected = canSelected;
    
    if (model.imageUrl) {
        [self.iconImage sd_setImageWithURL: [NSURL URLWithString:model.imageUrl]];
    }else {
        self.iconImage.image = IMAGE_NAMED(@"redpacket_icon");
    }
    
    self.titleLabel.text = [NDataUtil stringWith:model.name valid:@"OF"];
    
    NSString *money = [NDataUtil stringWith:model.balance valid:@"0.00"];
    CGFloat moneyNum = [money doubleValue];
    self.detailLabel.text = [NSString stringWithFormat:@"%.3f OF",moneyNum];
    
    [self updateLayout];
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithFont:FixFont(11) textColor:OF_COLOR_MINOR textAlignement:NSTextAlignmentLeft text:@"余额不足"];
        [self.contentView addSubview:_tipLabel];
    }
    return _tipLabel;
}

- (UIView *)shadeView
{
    if (!_shadeView) {
        _shadeView = [[UIView alloc] init];
        _shadeView.backgroundColor = [UIColor colorWithRGB:0xffffff alpha:0.6];
        [self.contentView addSubview:_shadeView];
    }
    return _shadeView;
}

@end
