//
//  OFPoolFundCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/26.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPoolFundCell.h"

#define kMargin_Left KWidthFixed(15)
#define kMargin_Top KHeightFixed(31.f)

//@interface OFPoolFundCell : NSObject
//
//@end
//
//@implementation
//
//@end

@interface OFPoolFundCell ()

@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *leftTip;
@property (nonatomic, strong) UILabel *rightTip;

@end

@implementation OFPoolFundCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    
    [self.leftTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(kMargin_Left);
        make.top.mas_equalTo(self.contentView).offset(kMargin_Top);
    }];
    
    [self.rightTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-kMargin_Left);
        make.top.mas_equalTo(self.contentView).offset(kMargin_Top);
    }];
}

#pragma mark - lazy load
- (UILabel *)leftTip
{
    if (!_leftTip) {
        _leftTip = [UILabel labelWithFont:FixFont(14)
                                textColor:[UIColor colorWithRGB:0x666666] textAlignement:NSTextAlignmentLeft
                                     text:@"manager"];
        [self.contentView addSubview:_leftTip];
    }
    return _leftTip;
}

- (UILabel *)rightTip
{
    if (!_rightTip) {
        _rightTip = [UILabel labelWithFont:FixFont(14)
                                 textColor:[UIColor colorWithRGB:0x666666]
                            textAlignement:NSTextAlignmentRight
                                      text:@"miner"];
        [self.contentView addSubview:_rightTip];
    }
    return _rightTip;
}

@end
