//
//  OFPacketDetailCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketDetailCell.h"

#define kMargin_Border  KWidthFixed(15)
#define kMargin_Space   KWidthFixed(10)
#define kIcon_Width     KWidthFixed(43)

NSString *const OFPacketDetailCellIdentifier = @"OFPacketDetailCellIdentifier";

@implementation OFPacketDetailModel

- (NSString *)iconPlaceholder
{
    return @"mining_miner_icon";
}

@end

@interface OFPacketDetailCell ()
{
    OFPacketDetailModel *_model;
}
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *bestIcon;
@property (nonatomic, strong) UILabel *bestLabel;

@end

@implementation OFPacketDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:kMargin_Border trailingOffset:kMargin_Border];
    }
    return self;
}

- (void)setupUI
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.height.mas_equalTo(kIcon_Width);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kMargin_Space);
        make.top.mas_equalTo(self.iconImage.mas_top);
    }];
    
    [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kMargin_Space);
        make.bottom.mas_equalTo(self.iconImage.mas_bottom);
    }];
    
    [self.bestLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
    }];
    
    [self.bestIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bestLabel.mas_left).offset(-KWidthFixed(2));
        make.centerY.mas_equalTo(self.bestLabel.mas_centerY);
        make.width.height.mas_equalTo(KWidthFixed(13));
    }];
    
    self.iconImage.layer.cornerRadius = kIcon_Width * 0.5;
    self.detailLabel.textColor = OF_COLOR_BLACK;
    self.detailLabel.font = FixFont(14);
}

- (void)updateLayout
{
    if (_model.isMax) {
        self.bestIcon.hidden = NO;
        self.bestLabel.hidden= NO;
    }else {
        self.bestIcon.hidden = YES;
        self.bestLabel.hidden= YES;
    }
}

- (void)updateInfo:(OFPacketDetailModel *)model
{
    _model = model;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.userHeaderUrl] placeholderImage:IMAGE_NAMED(model.iconPlaceholder)];
    self.titleLabel.text = model.username;
    self.detailLabel.text = [NSString stringWithFormat:@"%0.3f OF",model.redPacketAmount.floatValue];
    self.timeLabel.text = model.createTime;
    
    [self updateLayout];
}

#pragma mark - lazy load
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithFont:FixFont(12) textColor:OF_COLOR_MINOR textAlignement:NSTextAlignmentLeft text:@"time"];
        [self.contentView addSubview:_timeLabel];
    }
    return _timeLabel;
}

- (UIImageView *)bestIcon
{
    if (!_bestIcon) {
        _bestIcon = [[UIImageView alloc] initWithImage: IMAGE_NAMED(@"redpacket_best")];
        [self.contentView addSubview:_bestIcon];
    }
    return _bestIcon;
}

- (UILabel *)bestLabel
{
    if (!_bestLabel) {
        _bestLabel = [UILabel labelWithFont:FixFont(11) textColor:[UIColor colorWithRGB:0xfece0a] textAlignement:NSTextAlignmentCenter text:@"手气最佳"];
        [self.contentView addSubview:_bestLabel];
    }
    return _bestLabel;
}

@end
