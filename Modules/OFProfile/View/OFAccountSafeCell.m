//
//  OFAccountSafeCell.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFAccountSafeCell.h"

@interface OFAccountSafeCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *remarkLabel;

@property (nonatomic, strong) UIImageView *arrowView;

@property (nonatomic, strong) UIView *lineView;
@end

@implementation OFAccountSafeCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
        [self layout];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.arrowView];
}

- (void)layout{
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrowView.mas_left).offset(-5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)upData:(NSDictionary *)dict{
    self.titleLabel.text = [NDataUtil stringWith:dict[@"title"] valid:@""];
    self.remarkLabel.text = [NDataUtil stringWith:dict[@"remark"] valid:@""];
}

- (void)hiddenLine:(BOOL)hidden{
    
//    NSLog(@"%tu",hidden);
    self.lineView.hidden = hidden;
    
    self.arrowView.hidden = hidden;
    
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _titleLabel;
}


- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc]init];
        _remarkLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1.0];
        _remarkLabel.textAlignment = NSTextAlignmentRight;
    }
    return _remarkLabel;
}


- (UIImageView *)arrowView{
    if (!_arrowView) {
        _arrowView = [[UIImageView alloc]init];
        _arrowView.image = [UIImage imageNamed:@"profile_arrow_small"];
    }
    return _arrowView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Line_Color;
    }
    return _lineView;
}

@end
