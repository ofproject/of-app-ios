//
//  OFBonusCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBonusCell.h"
#import "OFBonusModel.h"

#define kMargin_Top     KWidthFixed(13.f)
#define kMargin_Left    KWidthFixed(17.f)

NSString *const kOFBonusCellReuseIdentifier = @"kOFBonusCellReuseIdentifier";
CGFloat const kkOFBonusCellHeight = 70.f;

@interface OFBonusCell ()
{
    OFBonusModel *_model;
}
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UILabel *bonus;

@end

@implementation OFBonusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupLayout];
        [self showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:kMargin_Left trailingOffset:kMargin_Left];
    }
    return self;
}

- (void)setupLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Left);
        make.top.mas_equalTo(self.contentView.mas_top).offset(kMargin_Top);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Left);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Left);
        make.centerY.mas_equalTo(self.bonus.mas_centerY);
    }];
    
    [self.bonus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Left);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kMargin_Top);
    }];
}

- (void)setModel:(OFBonusModel *)model
{
    _model = model;
    self.titleLabel.text = @"分红基金";
    self.detailLabel.textColor = OF_COLOR_MINOR;
    self.detailLabel.text = model.bonusTime;
    self.infoLabel.textColor = OF_COLOR_DETAILTITLE;
    self.infoLabel.text = [NSString stringWithFormat:@"比例 %.0f%%   人数 %@",model.bonusPercentage.floatValue * 100, model.personCnt];
    self.bonus.text = [NDataUtil convertAmountStr:model.ofCnt];
}

#pragma mark - lazy load
- (UILabel *)infoLabel
{
    if (!_infoLabel) {
        _infoLabel = [UILabel labelWithFont:FixFont(13) textColor:OF_COLOR_TITLE textAlignement:NSTextAlignmentLeft text:@"info"];
        [self.contentView addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UILabel *)bonus
{
    if (!_bonus) {
        _bonus = [UILabel labelWithFont:FixFont(15) textColor:OF_COLOR_MAIN_THEME textAlignement:NSTextAlignmentRight text:@"0 OF"];
        [self.contentView addSubview:_bonus];
    }
    return _bonus;
}

@end
