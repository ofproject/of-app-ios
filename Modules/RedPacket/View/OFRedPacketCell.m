//
//  OFRedPacketCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRedPacketCell.h"
#import "OFRedPacketModel.h"

#define kMargin_Left    KWidthFixed(15.f)
#define kSubview_Height KWidthFixed(18.f)

NSString *const OFRedPacketCellIdentifier = @"OFRedPacketCellIdentifier";
CGFloat const OFRedPacketCellHeight = 64.f;

@interface OFRedPacketCell ()
{
    OFRedPacketModel *_model;
}
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *packetCount;

@end

@implementation OFRedPacketCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:kMargin_Left trailingOffset:kMargin_Left];
    }
    return self;
}

- (void)setupUI
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(-kSubview_Height * 0.5);
        make.height.mas_equalTo(kSubview_Height);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY).offset(kSubview_Height * 0.5);
        make.height.mas_equalTo(kSubview_Height);
    }];
    
    [self.packetCount mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Left);
        make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
        make.height.mas_equalTo(kSubview_Height);
    }];
    
    self.detailLabel.font = FixFont(14);
    self.detailLabel.textColor = OF_COLOR_TITLE;
}

- (void)updateLayout
{
    if (_model.type == OFRedPacketTypeSend) {
        self.packetCount.hidden = NO;
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Left);
            make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
            make.height.mas_equalTo(kSubview_Height);
        }];
    }else if(_model.type == OFRedPacketTypeReceive){
        self.packetCount.hidden = YES;
        [self.detailLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Left);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
            make.height.mas_equalTo(kSubview_Height);
        }];
    }
}

- (void)updateInfo:(OFRedPacketModel *)model
{
    _model = model;
    
    self.titleLabel.text = model.name;
    self.detailLabel.text = [NSString stringWithFormat:@"%0.3fOF",model.redPacketAmount.floatValue];
    self.timeLabel.text = model.createTime;
    self.packetCount.text = [NSString stringWithFormat:@"%ld/%ld个",(long)model.receivedRedPacketNumber, (long)model.redPacketNumber];
    
    [self updateLayout];
}

#pragma mark - lazy load
- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithFont:FixFont(10) textColor:[UIColor colorWithRGB:0x7c7c7c] textAlignement:NSTextAlignmentLeft text:@"time"];
        [self.contentView addSubview:self.timeLabel];
    }
    return _timeLabel;
}

- (UILabel *)packetCount
{
    if (!_packetCount) {
        _packetCount = [UILabel labelWithFont:FixFont(10) textColor:OF_COLOR_DETAILTITLE textAlignement:NSTextAlignmentRight text:@""];
        [self.contentView addSubview:self.packetCount];
    }
    return _packetCount;
}

@end
