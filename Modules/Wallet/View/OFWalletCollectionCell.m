//
//  OFWalletCollectionCell.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/20.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFWalletCollectionCell.h"

@interface OFWalletCollectionCell ()

@property (nonatomic, strong) UIImageView *backImageView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation OFWalletCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
        [self layout];
        [self setup];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.backImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.moneyLabel];
}

- (void)layout{
    
    [self.backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(10);
        make.width.mas_equalTo([NUIUtil fixedWidth:150]);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo([NUIUtil fixedHeight:26]);
    }];
    
}

- (void)setup{
    self.titleLabel.text = @"OF 1";
    self.addressLabel.text = KcurUser.currentWallet.address;
    self.moneyLabel.text = @"8888.88";
//    self.backImageView.image = [UIImage imageNamed:@""];
}

- (void)setModel:(OFWalletModel *)model{
    _model = model;
    
    self.titleLabel.text = [NDataUtil stringWith:model.name valid:@"OF"];
    
    self.addressLabel.text = [NDataUtil stringWith:model.address valid:@"--"];
    CGFloat money = [[NDataUtil stringWith:model.balance valid:@"0.00"] doubleValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.3f",money];
    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:model.bg_url]];
}

// wallet_item_background1
- (void)setImageName:(NSInteger)imageName{
    NSString *iconName = [NSString stringWithFormat:@"wallet_item_background%zd",imageName];
    self.backImageView.image = [UIImage imageNamed:iconName];
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        _backImageView = [[UIImageView alloc]init];
        _backImageView.image = [UIImage imageNamed:@""];
        
        _backImageView.layer.cornerRadius = 5.0;
        _backImageView.layer.masksToBounds = YES;
    }
    return _backImageView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [NUIUtil fixedFont:15];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
    }
    return _titleLabel;
}

- (UILabel *)addressLabel{
    if (!_addressLabel) {
        _addressLabel = [[UILabel alloc]init];
        _addressLabel.textColor = [UIColor whiteColor];
        _addressLabel.textColor = [UIColor colorWithRed:233.0/255 green:231.0/255 blue:231.0/255 alpha:1.0];
        _addressLabel.font = [NUIUtil fixedFont:11];
        _addressLabel.textAlignment = NSTextAlignmentCenter;
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _addressLabel.backgroundColor = [UIColor clearColor];
    }
    return _addressLabel;
}

- (UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc]init];
        _moneyLabel.textColor = Orange_New_Color;
        _moneyLabel.layer.cornerRadius = [NUIUtil fixedHeight:26] / 2;
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        _moneyLabel.layer.masksToBounds = YES;
        _moneyLabel.font = [NUIUtil fixedFont:13];
        _moneyLabel.backgroundColor = [UIColor whiteColor];
    }
    return _moneyLabel;
}


@end
