//
//  OFMiningItemCell.m
//  OFBank
//
//  Created by hukun on 2018/2/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFMiningItemCell.h"
#import "OFWalletModel.h"



@interface OFMiningItemCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UIButton *turnInBtn;

@property (nonatomic, strong) UIView *lineView;
@end

@implementation OFMiningItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
        [self layout];
    }
    return self;
}


- (void)initUI {
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.addressLabel];
    [self.contentView addSubview:self.turnInBtn];
    [self.contentView addSubview:self.lineView];
    
}

- (void)layout{
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([NUIUtil fixedWidth:50], [NUIUtil fixedWidth:35]));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(13);
        make.top.mas_equalTo(15);
    }];
    
    [self.turnInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(55, 25));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(13);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-13.5);
        //        make.right.mas_equalTo(self.moneyLabel.mas_left).offset(-15);
        make.width.mas_lessThanOrEqualTo([NUIUtil fixedWidth:170]);
    }];
    
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(0);
    }];
}

- (void)setModel:(OFWalletModel *)model{
    _model = model;
    
    if ([model.name rangeOfString:@"OF "].location != NSNotFound) {
        NSInteger index = [[model.name stringByReplacingOccurrencesOfString:@"OF " withString:@""] integerValue]+1;
        NSString *imageName = [NSString stringWithFormat:@"wallet_item_logo%zd",index];
        self.iconView.image = IMAGE_NAMED(imageName);
    }else{
        NSString *imageName = [NSString stringWithFormat:@"wallet_item_logo1"];
        self.iconView.image = IMAGE_NAMED(imageName);
    }
    
    self.titleLabel.text = [NDataUtil stringWith:model.name valid:@"OF"];
    self.addressLabel.text = [NDataUtil stringWith:model.address valid:@""];
}

#pragma mark - 懒加载
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.image = [UIImage imageNamed:@"team_of"];
    }
    return _iconView;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Line_Color;
    }
    return _lineView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [NUIUtil fixedFont:15];
        _titleLabel.textColor = Black_Color;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"OF";
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.font = [NUIUtil fixedFont:12];
        _addressLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _addressLabel.preferredMaxLayoutWidth = [NUIUtil fixedWidth:200];
    }
    return _addressLabel;
}

- (UIButton *)turnInBtn{
    if (!_turnInBtn) {
        _turnInBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_turnInBtn setTitle:@" 转入钱包 " forState:UIControlStateNormal];
        _turnInBtn.titleLabel.font = [NUIUtil fixedFont:10];
        
        [_turnInBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        _turnInBtn.titleLabel.font = [NUIUtil fixedFont:10];
        _turnInBtn.layer.cornerRadius = 5.0;
        _turnInBtn.layer.borderWidth = 1.0f;
        _turnInBtn.layer.borderColor = OF_COLOR_MAIN_THEME.CGColor;
//        WEAK_SELF;
        _turnInBtn.userInteractionEnabled = NO;
//        [_turnInBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
//        [_turnInBtn n_clickBlock:^(id sender) {
////            [weakSelf joinBtnClick];
//        }];
    }
    return _turnInBtn;
}

@end
