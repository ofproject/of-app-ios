//
//  OFPrifitCell.m
//  OFBank
//
//  Created by 胡堃 on 2018/2/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//  见证收益

#import "OFPrifitCell.h"

@interface OFPrifitCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *poolNameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UIView *lineView;


@end

@implementation OFPrifitCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self layout];
        [self setup];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.poolNameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)layout{
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(32, 32));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.top.mas_equalTo(15);
    }];
    
    [self.poolNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(5);
        make.height.mas_equalTo(12);
        make.centerY.mas_equalTo(self.titleLabel);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.titleLabel.mas_left);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
}

- (void)setup{
    self.titleLabel.text = @"收益";
    self.timeLabel.text = @"2018-02-10 16:11";
    
    self.moneyLabel.text = @"888.888OF";
    
    self.poolNameLabel.text = @" 白羊矿池 ";
}

- (void)update:(NSDictionary *)dict{
    
    // 福包 : profit_bouns
    // 挖矿 : profit_mining
    // 游戏 : profit_game
    
    CGFloat money = [NDataUtil floatWith:dict[@"value"] valid:0.0];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.3f OF",money];
    
    self.timeLabel.text = [NDataUtil stringWith:dict[@"receiveTime"] valid:@""];
    
    if ([[NDataUtil stringWith:dict[@"name"] valid:@""] isEqualToString:@""]) {
        self.poolNameLabel.text = @"";
    }else{
        self.poolNameLabel.text = NSStringFormat(@" %@ ",[NDataUtil stringWith:dict[@"name"] valid:@""]);
    }
    
    NSInteger type = [NDataUtil intWith:dict[@"type"] valid:1];
    NSString *imageName;
    NSString *title;
    switch (type) {
        case 1:
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            title = @"糖果收益";
            imageName = @"profit_bouns";
            break;
        case 7:
            title = @"矿池收益";
            imageName = @"profit_mining";
            break;
        case 8:
            title = @"领主基金";
            imageName = @"profit_mining";
            break;
        case 9:
            title = @"糖果收益";
            imageName = @"profit_bouns";
            self.poolNameLabel.text = @" 新人奖励 ";
            break;
        case 10:
            title = @"糖果收益";
            imageName = @"profit_bouns";
            self.poolNameLabel.text = @" 邀请奖励 ";
            break;
        case 11:
            title = @"矿池收益";
            imageName = @"profit_mining";
            break;
        default:
            title = @"--";
            imageName = @"profit_mining";
            break;
    }
    
    self.titleLabel.text = title;
    self.iconView.image = [UIImage imageNamed:imageName];
}

#pragma mark - 懒加载

-(UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"profit_mining"];
    }
    return _iconView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [NUIUtil fixedFont:13];
        _titleLabel.textColor = [UIColor colorWithRGB:0x333333];
    }
    return _titleLabel;
}

- (UILabel *)poolNameLabel{
    if (!_poolNameLabel) {
        _poolNameLabel = [[UILabel alloc]init];
        _poolNameLabel.font = [NUIUtil fixedFont:9];
        _poolNameLabel.textColor = OF_COLOR_MAIN_THEME;
        _poolNameLabel.backgroundColor = [UIColor colorWithRGB:0xffecdc];
        ViewRadius(_poolNameLabel, 2);
    }
    return _poolNameLabel;
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

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Line_Color;
    }
    return _lineView;
}

@end
