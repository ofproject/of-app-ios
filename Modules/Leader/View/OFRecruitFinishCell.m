//
//  OFRecruitFinishCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRecruitFinishCell.h"
#import <YYKit/YYLabel.h>
#import "OFPoolModel.h"

#define kMargin_Border KWidthFixed(15)

NSString *const OFRecruitFinishCellIdentifier = @"OFRecruitFinishCellIdentifier";

@implementation OFRecruitFinishCellModel

@end

@interface OFRecruitFinishCell ()

@property (nonatomic, strong) UIView *borderView;
@property (nonatomic, strong) YYLabel *enterPoolLabel;

@end

@implementation OFRecruitFinishCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.titleLabel.textColor = OF_COLOR_TITLE;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = FixFont(19);
    
    self.detailLabel.textColor = OF_COLOR_MAIN_THEME;
    self.detailLabel.textAlignment = NSTextAlignmentCenter;
    self.detailLabel.font = FixFont(22);
    
    [self.borderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(kMargin_Border);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Border);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-kMargin_Border);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.contentView.mas_top).offset(KWidthFixed(33));
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(KWidthFixed(12));
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.detailLabel.mas_bottom).offset(KWidthFixed(20));
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.width.mas_equalTo(kScreenWidth * 0.48);
        make.height.mas_equalTo(kScreenWidth * 0.35);
    }];
    
    [self.enterPoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView.mas_centerX);
        make.top.mas_equalTo(self.iconImage.mas_bottom).offset(KWidthFixed(18));
    }];
}

- (void)updateInfo:(OFRecruitFinishCellModel *)model alreadyManager:(BOOL)alreadyManager
{
    if (alreadyManager) {
        self.titleLabel.hidden = YES;
        self.iconImage.image = IMAGE_NAMED(@"leader_recruit_already");
    }else {
        self.titleLabel.hidden = NO;
        self.titleLabel.text = @"创建成功";
        self.iconImage.image = IMAGE_NAMED(@"leader_recruit_finish");
    }
    
    self.detailLabel.text = model.pool.name;
    
    NSString *defaultText = @"进入矿池看看吧 》";
    NSString *text = defaultText;
//    text = [NSString stringWithFormat:@"您成为第%@名领主, 进入矿池看看吧 》",model.communityCount];
    NSRange range = [text rangeOfString:defaultText];
    NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
    attrText.font = FixFont(13);
    attrText.color = OF_COLOR_DETAILTITLE;
    WEAK_SELF;
    [attrText setTextHighlightRange:range color:OF_COLOR_MAIN_THEME backgroundColor:nil tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [weakSelf enterPool];
    }];
    self.enterPoolLabel.attributedText = attrText;
}

- (void)enterPool
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(recruitFinishCellEnterPool)]) {
        [self.delegate recruitFinishCellEnterPool];
    }
}

+ (CGFloat)finishCellHeight
{
    return KWidthFixed(185) + kScreenWidth * 0.35;
}

#pragma mark - lazy load
- (UIView *)borderView
{
    if (!_borderView) {
        _borderView = [[UIView alloc] init];
        _borderView.layer.borderColor = OF_COLOR_MAIN_THEME.CGColor;
        _borderView.layer.borderWidth = 2.f;
        [self.contentView addSubview:_borderView];
    }
    return _borderView;
}

- (YYLabel *)enterPoolLabel
{
    if (!_enterPoolLabel) {
        _enterPoolLabel = [[YYLabel alloc] init];
        _enterPoolLabel.numberOfLines = 0;
        [self.contentView addSubview:_enterPoolLabel];
    }
    return _enterPoolLabel;
}

@end
