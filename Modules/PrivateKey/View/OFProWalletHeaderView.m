//
//  OFProWalletHeaderView.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProWalletHeaderView.h"
#import "OFProWalletDetailVC.h"

@interface OFProWalletHeaderView ()

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation OFProWalletHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = OF_COLOR_BACKGROUND;
        [self initUI];
        [self layout];
        UIColor *color = [UIColor colorWithPatternImage:OF_IMAGE_DRADIENT(frame.size.width, frame.size.height)];
        self.backgroundColor = color;
        WEAK_SELF;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
            [weakSelf jumpToDetaile];
        }];
        
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.imageView];
    [self addSubview:self.nameLabel];
    [self addSubview: self.addressLabel];
    [self addSubview:self.moneyLabel];
}

- (void)layout{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(50);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(48, 48));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(10);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
//        make.top.mas_equalTo(self.addressLabel.mas_bottom).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-17.5);
    }];
    
}

- (void)jumpToDetaile{
    OFProWalletDetailVC *vc = [[OFProWalletDetailVC alloc]init];
    
    vc.model = self.model;
    
    [self.viewController.navigationController pushViewController:vc animated:YES];
}



- (void)setModel:(OFProWalletModel *)model{
    _model = model;
    
    self.nameLabel.text = [NDataUtil stringWith:model.name valid:@"OF"];
    self.addressLabel.text = [NDataUtil stringWith:model.address valid:@""];
    CGFloat mf = [model.balance floatValue];
    
    NSString *ms = [NSString stringWithFormat:@"%.3f",mf];
    self.moneyLabel.text = [NDataUtil stringWith:ms valid:@"0.00"];
    
}

- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.backgroundColor = [UIColor whiteColor];
    }
    return _imageView;
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
