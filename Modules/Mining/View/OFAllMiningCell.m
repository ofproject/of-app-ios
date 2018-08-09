//
//  OFAllMiningCell.m
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFAllMiningCell.h"
#import "OFPoolModel.h"

#define kIconWidth 42.f
#define kMarigin_Left 16
#define kSubviews_Space 6
#define kSubviews_Offset 11

CGFloat const kAllMiningCellHeight = 70.f;
NSString *const kAllMiningCellIdentifier = @"kAllMiningCellIdentifier";

@interface OFAllMiningCell ()

@property (nonatomic, strong) UILabel *nodeLabel;
@property (nonatomic, strong) UILabel *activenessLabel;
@property (nonatomic, strong) UILabel *rewardLabel;
@property (nonatomic, strong) UIButton *joinButton;

@property (nonatomic, strong) OFPoolModel *model;

@end

@implementation OFAllMiningCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setModel:(OFPoolModel *)model
{
    _model = model;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:IMAGE_NAMED(@"mining_pool_icon")];
    self.iconImage.layer.cornerRadius = kIconWidth * 0.5;
    
    NSString *titleText = [NSString stringWithFormat:@"%@", model.name];
    self.titleLabel.text = titleText;
    
    NSString *nodeText = [NSString stringWithFormat:@"矿池节点 %@",model.count];
    NSMutableAttributedString *nodeString = [[NSMutableAttributedString alloc] initWithString:nodeText];
    NSRange range1 = [[nodeString string] rangeOfString:model.count];
    [nodeString addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:range1];
    [nodeString addAttribute:NSFontAttributeName value:FixFont(10) range:range1];
    self.nodeLabel.attributedText = nodeString;
    
    /*
     * 隐藏活跃度
     *
    NSString *activenessText =[NSString stringWithFormat:@"活跃度 %@",model.active];
    NSMutableAttributedString *activenessString = [[NSMutableAttributedString alloc] initWithString:activenessText];
    NSRange range2 = [[activenessString string] rangeOfString:model.active];
    [activenessString addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:range2];
    [activenessString addAttribute:NSFontAttributeName value:FixFont(10) range:range2];
    self.activenessLabel.attributedText = activenessString;
    */
     
    NSString *rewardText = [NSString stringWithFormat:@"矿池基金 %@",model.reward];
    NSMutableAttributedString *rewardString=[[NSMutableAttributedString alloc]initWithString:rewardText];
    NSRange range3=[[rewardString string]rangeOfString:model.reward];
    [rewardString addAttribute:NSForegroundColorAttributeName value:OF_COLOR_MAIN_THEME range:range3];
    [rewardString addAttribute:NSFontAttributeName value:FixFont(10) range:range3];
    self.rewardLabel.attributedText = rewardString;
    
    if ([model.cid isEqualToString:KcurUser.community.cid]) {
        [self.joinButton setTitle:@"退出" forState:UIControlStateNormal];
        [self.joinButton setTitleColor:OF_COLOR_MINOR forState:UIControlStateNormal];
        self.joinButton.layer.borderColor = OF_COLOR_MINOR.CGColor;
    }else {
        [self.joinButton setTitle:@"加入" forState:UIControlStateNormal];
        [self.joinButton setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        self.joinButton.layer.borderColor = OF_COLOR_MAIN_THEME.CGColor;
    }
}

- (void)setupUI
{
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kIconWidth);
        make.height.mas_equalTo(kIconWidth);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMarigin_Left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kSubviews_Space);
        make.top.mas_equalTo(self.iconImage.mas_top);
    }];
    
    [self.nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImage.mas_right).offset(kSubviews_Space);
        make.bottom.mas_equalTo(self.iconImage.mas_bottom);
    }];
    
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).offset(-kScreenWidth * 0.05 );
        make.bottom.mas_equalTo(self.iconImage.mas_bottom);
    }];
    
    [self.joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-15.f);
        make.width.mas_equalTo(KWidthFixed(55));
        make.height.mas_equalTo(23);
    }];
}

#pragma mark - callback
- (void)joinPool
{
    if (self.joinCallback) {
        self.joinCallback(self.model);
    }
}

#pragma mark - lazy load
- (UILabel *)nodeLabel
{
    if (!_nodeLabel) {
        _nodeLabel = [UILabel labelWithFont:FixFont(11)
                                  textColor:OF_COLOR_DETAILTITLE
                             textAlignement:NSTextAlignmentLeft
                                       text:@"node"];
        [self.contentView addSubview:_nodeLabel];
    }
    return _nodeLabel;
}

- (UILabel *)activenessLabel
{
    if (!_activenessLabel) {
        _activenessLabel = [UILabel labelWithFont:FixFont(11)
                                        textColor:OF_COLOR_DETAILTITLE
                                   textAlignement:NSTextAlignmentLeft
                                             text:@"activeness"];
        [self.contentView addSubview:_activenessLabel];
    }
    return _activenessLabel;
}

- (UILabel *)rewardLabel
{
    if (!_rewardLabel) {
        _rewardLabel = [UILabel labelWithFont:FixFont(11)
                                    textColor:OF_COLOR_DETAILTITLE
                               textAlignement:NSTextAlignmentLeft
                                         text:@"reward"];
        [self.contentView addSubview:_rewardLabel];
    }
    return _rewardLabel;
}

- (UIButton *)joinButton
{
    if (!_joinButton) {
        _joinButton = [UIButton buttonWithTitle:@"join"
                                     titleColor:OF_COLOR_MAIN_THEME
                                backgroundColor:OF_COLOR_CLEAR
                                           font:FixFont(13)];
        _joinButton.layer.borderWidth = 1.f;
        _joinButton.layer.borderColor = OF_COLOR_MAIN_THEME.CGColor;
        _joinButton.layer.cornerRadius = 5.f;
        [_joinButton addTarget:self action:@selector(joinPool) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_joinButton];
    }
    return _joinButton;
}

@end
