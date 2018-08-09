//
//  OFTransferDetailCell.m
//  OFBank
//
//  Created by hukun on 2018/3/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFTransferDetailCell.h"
@interface OFTransferDetailCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *stateLabel;//状态标签

@property (nonatomic, strong) UIView *lineView;


@end
@implementation OFTransferDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self layout];
        //        [self setup];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)layout{
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(50, 35));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.top.mas_equalTo(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.bottom.mas_equalTo(self.iconView.mas_bottom);
        make.left.mas_equalTo(self.titleLabel.mas_left);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(15);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.bottom.mas_equalTo(self.iconView.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}


- (void)update:(NSDictionary *)dict{
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[NDataUtil stringWith:dict[@"imageUrl"] valid:@""]]];
    
    self.titleLabel.text = [NDataUtil stringWith:dict[@"name"] valid:@"OF"];
    
    self.timeLabel.text = [NDataUtil stringWith:dict[@"registerTime"] valid:@"--"];
    
    NSString *money = [NSString stringWithFormat:@"%.3f OF",[[NDataUtil stringWith:dict[@"value"] valid:@"0"] doubleValue]];
    self.moneyLabel.text = money;
    
    NSString *statusStr = @"审核中";
    UIColor *statusColor = OF_COLOR_MINOR;
    NSInteger status = [dict[@"status"] integerValue];
    switch (status) {
        case 1:
        case 2:
            statusStr = @"审核中";
            statusColor = OF_COLOR_MINOR;
            break;
        case 3:
            statusStr = @"审核通过";
            statusColor = [UIColor colorWithRGB:0x11ac83];
            break;
        case 4:
            statusStr = @"审核拒绝";
            statusColor = [UIColor colorWithRGB:0xd73c1e];
            break;
        default:
            break;
    }
    self.stateLabel.text = statusStr;
    self.stateLabel.textColor = statusColor;
}

#pragma mark - 懒加载
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"team_of"];
    }
    return _iconView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = Title_Color;
        _titleLabel.font = [NUIUtil fixedFont:13];
    }
    return _titleLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [NUIUtil fixedFont:10];
        _timeLabel.textColor = [UIColor colorWithRGB:0x7c7c7c];
    }
    return _timeLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [NUIUtil fixedFont:13];
        _moneyLabel.textColor = [UIColor colorWithRGB:0xff9f4e];
    }
    return _moneyLabel;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        _stateLabel = [[UILabel alloc]init];
        _stateLabel.font = Font(11);
        _stateLabel.textAlignment = UITextAlignmentRight;
    }
    return _stateLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Line_Color;
    }
    return _lineView;
}



@end
