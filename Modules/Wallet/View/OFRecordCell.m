//
//  OFRecordCell.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRecordCell.h"


@interface OFRecordCell ()

@property (nonatomic, strong) UILabel *recordTyprLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation OFRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
        [self layout];
        [self setup];
    }
    return self;
}

- (void)initUI{
    
    [self.contentView addSubview:self.recordTyprLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.lineView];
    
}

- (void)layout{
    
    [self.recordTyprLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(10);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(10);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.recordTyprLabel.mas_bottom).offset(10);
        make.width.mas_lessThanOrEqualTo([NUIUtil fixedWidth:200]);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.addressLabel.mas_top);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    
}

- (void)setup{
    
    self.recordTyprLabel.text = @"收款";
    self.moneyLabel.text = @"+ 850.0";
    self.addressLabel.text = @"0x13g21jg3hj1g23hj1g3jh1gjh3g1jh3g2j1h3f1h";
    self.timeLabel.text = @"2018.1.11 14:23";
}


#pragma mark - 懒加载
- (UILabel *)recordTyprLabel{
    if (_recordTyprLabel == nil) {
        _recordTyprLabel = [[UILabel alloc]init];
        _recordTyprLabel.font = [UIFont systemFontOfSize:17];
        _recordTyprLabel.textColor = [UIColor blackColor];
    }
    return _recordTyprLabel;
}

- (UILabel *)moneyLabel{
    if (_moneyLabel == nil) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [UIFont systemFontOfSize:17];
        _moneyLabel.textColor = [UIColor blackColor];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}

- (UILabel *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _addressLabel.font = [UIFont systemFontOfSize:15];
    }
    return _addressLabel;
}

- (UILabel *)timeLabel{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.textColor = [UIColor colorWithRed:142/255.0 green:142/255.0 blue:142/255.0 alpha:1.0];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:15];
    }
    return _timeLabel;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Line_Color;
    }
    return _lineView;
}

@end
