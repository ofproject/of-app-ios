//
//  OFProfileCell.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProfileCell.h"
#import "OFShadowCornerView.h"

#define kMargin_Border KWidthFixed(15)
#define kIconWidth KWidthFixed(20)

CGFloat const kOFProfileCellHeight = 45.f;
NSString *const kOFProfileCellIdentifier =@"kOFProfileCellIdentifier";

@implementation OFProfileItem

- (CornerType)cornerType
{
    CornerType type = CornerTypeNone;
    if (_type == ProfileCellTypeSingle) {
        type = CornerTypeLeftTop | CornerTypeRightTop | CornerTypeRightBottom | CornerTypeLeftBottom;
    }else if (_type == ProfileCellTypeTop) {
        type = CornerTypeLeftTop | CornerTypeRightTop;
    }else if (_type == ProfileCellTypeMiddle) {
        type = CornerTypeNone;
    }else if (_type == ProfileCellTypeBottom) {
        type = CornerTypeRightBottom | CornerTypeLeftBottom;
    }
    return type;
}

- (ShadowType)shadowType
{
    ShadowType type = ShadowTypeNone;
    if (_type == ProfileCellTypeSingle) {
        type = ShadowTypeLeft | ShadowTypeTop | ShadowTypeRight | ShadowTypeBottom;
    }else if (_type == ProfileCellTypeTop) {
        type = ShadowTypeLeft | ShadowTypeTop | ShadowTypeRight;
    }else if (_type == ProfileCellTypeMiddle) {
        type = ShadowTypeLeft | ShadowTypeRight;
    }else if (_type == ProfileCellTypeBottom) {
        type = ShadowTypeLeft | ShadowTypeRight | ShadowTypeBottom;
    }
    return type;
}

@end

@interface OFProfileCell ()

@property (nonatomic, strong) UIImageView *rightIcon;

@end

@implementation OFProfileCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = OF_COLOR_WHITE;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)update:(OFProfileItem *)item{
    self.titleLabel.text = item.title;
    self.iconImage.image = [UIImage imageNamed:item.icon];

    if (item.detailText.length > 0) {
        self.detailLabel.text = item.detailText;
        self.detailLabel.font = FixFont(13);
        self.detailLabel.hidden = NO;
        self.arrorView.hidden = YES;
    }else {
        self.detailLabel.hidden = YES;
        self.arrorView.hidden = NO;
    }
    
    if (item.rightIcon.length > 0) {
        self.rightIcon.hidden = NO;
        self.rightIcon.image = IMAGE_NAMED(item.rightIcon);
    }else {
        self.rightIcon.hidden = YES;
    }
    
    if (item.type == ProfileCellTypeTop || item.type == ProfileCellTypeMiddle) {
        [self showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:30 trailingOffset:30];
    }else {
        [self showSeperatorLineForTop:SeperatorHidden bottom:SeperatorHidden leadingOffset:0 trailingOffset:0];
    }

    [self layoutIfNeeded];
}

- (void)setupUI
{
    [self.contentView addSubview:self.arrorView];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kIconWidth);
        make.height.mas_equalTo(kIconWidth);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.arrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.arrorView.mas_left).offset(-KWidthFixed(10));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.width.mas_equalTo(kIconWidth);
        make.height.mas_equalTo(kIconWidth);
    }];
    
    self.iconImage.layer.cornerRadius = 0;
    self.iconImage.layer.masksToBounds = NO;
    self.titleLabel.textColor = OF_COLOR_TITLE;
}

- (UIImageView *)rightIcon
{
    if (!_rightIcon) {
        _rightIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightIcon.hidden = YES;
        [self.contentView addSubview:_rightIcon];
    }
    return _rightIcon;
}

@end
