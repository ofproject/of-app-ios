//
//  OFProfileHeaderView.m
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFProfileHeaderView.h"
#import "OFShadowCornerView.h"

#define kMargin_Border 15
#define kAvatarWidth KWidthFixed(105)
#define kMarkLeaderWidth KWidthFixed(20)

@interface OFProfileHeaderView () <UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *backView;
@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UIImageView *markLeaderView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation OFProfileHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayout];
        [self bindData];
    }
    return self;
}

#pragma mark - 绑定数据
- (void)bindData{
    [self.avatarView sd_setImageWithURL:[NSURL URLWithString:KcurUser.profileUrl] placeholderImage:[UIImage imageNamed:@"mining_miner_icon"]];
    if (KcurUser.isPoolManager ) {
        self.markLeaderView.hidden = NO;
    }else {
        self.markLeaderView.hidden = YES;
    }
    self.nameLabel.text = KcurUser.userName;
}

- (void)setupLayout
{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(30.f);
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-KHeightFixed(20));
    }];
    
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kAvatarWidth);
        make.height.mas_equalTo(kAvatarWidth);
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.bottom.mas_equalTo(self.nameLabel.mas_top).offset(-KHeightFixed(15));
    }];
    
    [self.markLeaderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kMarkLeaderWidth);
        make.height.mas_equalTo(kMarkLeaderWidth);
        make.centerX.mas_equalTo(self.avatarView.mas_right).offset(-kAvatarWidth * 0.146);
        make.centerY.mas_equalTo(self.avatarView.mas_bottom).offset(-kAvatarWidth * 0.146);
    }];
}

- (UIImageView *)backView
{
    if (!_backView ) {
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        _backView = [[UIImageView alloc] initWithImage:image];
        _backView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_backView];
    }
    return _backView;
}

- (UIImageView *)avatarView
{
    if (!_avatarView) {
        _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kAvatarWidth, kAvatarWidth)];
        _avatarView.image = [UIImage imageNamed:@"mining_miner_icon"];
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        _avatarView.layer.cornerRadius = kAvatarWidth * 0.5;
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.borderWidth = 3.f;
        _avatarView.layer.borderColor = OF_COLOR_WHITE.CGColor;
        _avatarView.userInteractionEnabled = YES;
        [self addSubview:_avatarView];
    }
    return _avatarView;
}

- (UIImageView *)markLeaderView
{
    if (!_markLeaderView) {
        _markLeaderView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kMarkLeaderWidth, kMarkLeaderWidth)];
        _markLeaderView.image = [UIImage imageNamed:@"profile_mark_leader"];
        _markLeaderView.contentMode = UIViewContentModeScaleAspectFill;
        _markLeaderView.layer.cornerRadius = kMarkLeaderWidth * 0.5;
        _markLeaderView.layer.masksToBounds = YES;
        _markLeaderView.layer.borderWidth = 2.f;
        _markLeaderView.layer.borderColor = OF_COLOR_WHITE.CGColor;
        _markLeaderView.userInteractionEnabled = YES;
        _markLeaderView.hidden = YES;
        [self addSubview:_markLeaderView];
    }
    return _markLeaderView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:FixFont(16) textColor:OF_COLOR_WHITE textAlignement:NSTextAlignmentCenter text:@"name"];
        [self addSubview:_nameLabel];
    }
    return _nameLabel;
}

@end
