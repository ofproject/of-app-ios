//
//  OFProWalletHeaderCell.m
//  OFBank
//
//  Created by michael on 2018/7/19.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProWalletHeaderCell.h"

#import "OFProWalletModel.h"

@interface OFProWalletHeaderCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation OFProWalletHeaderCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        UIColor *color = [UIColor colorWithPatternImage:OF_IMAGE_DRADIENT(frame.size.width, frame.size.height)];
        self.backgroundColor = color;
        [self initUI];
        [self layout];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview: self.addressLabel];
    [self addSubview:self.moneyLabel];
}

- (void)layout{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-17.5);
    }];
    
}

- (void)setModel:(OFProWalletModel *)model{
    _model = model;
    
    self.nameLabel.text = [NDataUtil stringWith:model.name valid:@"OF"];
    self.addressLabel.text = [NDataUtil stringWith:model.address valid:@""];
    CGFloat mf = [model.balance floatValue];
    
    NSString *ms = [NSString stringWithFormat:@"%.3f",mf];
    self.moneyLabel.text = [NDataUtil stringWith:ms valid:@"0.00"];
    
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.backgroundColor = [UIColor whiteColor];
    }
    return _iconView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [NUIUtil fixedFont:14];
        _nameLabel.textColor = [UIColor whiteColor];
    }
    return _nameLabel;
}

- (UILabel *)addressLabel{
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.font = [NUIUtil fixedFont:11];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _addressLabel.textColor = [UIColor whiteColor];
    }
    return _addressLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.font = [NUIUtil fixedFont:18];
        _moneyLabel.textColor = [UIColor whiteColor];
    }
    return _moneyLabel;
}


@end
