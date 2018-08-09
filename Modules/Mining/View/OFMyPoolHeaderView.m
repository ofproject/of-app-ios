//
//  OFMyPoolHeaderView.m
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFMyPoolHeaderView.h"
#import "OFPoolModel.h"

#define kLeaderAvatar_Width KWidthFixed(17.f)
#define kNavBack_Width      KWidthFixed(20.f)
#define kPoolAvatar_Width   KWidthFixed(83.f)
#define kMargin_Left        KWidthFixed(12.f)
#define kMargin_Top         (Nav_Height + KWidthFixed(5.f))
#define kSubview_Spacing_1  KWidthFixed(11.f)
#define kSubview_Spacing_2  KWidthFixed(5.f)
#define kQrcode_Width       KWidthFixed(25.f)

@interface OFMyPoolHeaderView ()
{
    OFPoolModel *_pool;
}
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIImageView *leaderAvatar;
@property (nonatomic, strong) UIImageView *poolAvatar;
@property (nonatomic, strong) UILabel *leaderLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, strong) UILabel *lastBlockTime;
@property (nonatomic, strong) UIView *blockBackView;
@property (nonatomic, strong) UIButton *noobBtn;
@property (nonatomic, strong) UIView *announceBackView;
@property (nonatomic, strong) UILabel *poolAnnouncement;
@property (nonatomic, strong) UIButton *qrcodeButton;

@end

@implementation OFMyPoolHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        [self addSubview:self.backImageView];
        [self addSubview:self.poolAvatar];
        [self addSubview:self.nameLabel];
        [self addSubview:self.leaderLabel];
        [self addSubview:self.createTime];
        [self addSubview:self.lastBlockTime];
        [self addSubview:self.noobBtn];
        [self addSubview:self.announceBackView];
        [self addSubview:self.poolAnnouncement];
        [self addSubview:self.qrcodeButton];
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout
{
    [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    [_poolAvatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Left);
        make.top.mas_equalTo(self.mas_top).offset(kMargin_Top);
        make.width.mas_equalTo(kPoolAvatar_Width);
        make.height.mas_equalTo(kPoolAvatar_Width);
    }];
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.poolAvatar.mas_right).offset(kSubview_Spacing_1);
        make.top.mas_equalTo(self.poolAvatar.mas_top).offset(kSubview_Spacing_2);
    }];
    
    [_leaderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(kSubview_Spacing_2);
    }];
    
    [_createTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.top.mas_equalTo(self.leaderLabel.mas_bottom).offset(kSubview_Spacing_2);
    }];
    
    [_lastBlockTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(self.poolAvatar.mas_bottom);
    }];
    
    [_noobBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWidthFixed(47));
        make.height.mas_equalTo(KWidthFixed(15));
        make.centerY.mas_equalTo(self.nameLabel.mas_centerY);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(5);
    }];
    
    [_announceBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.poolAvatar.mas_bottom).offset(KWidthFixed(13));
        make.height.mas_equalTo(KWidthFixed(25));
    }];

    [_poolAnnouncement mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.announceBackView.mas_top);
        make.bottom.mas_equalTo(self.announceBackView.mas_bottom);
        make.left.mas_equalTo(self.announceBackView.mas_left).offset(KWidthFixed(12));
        make.right.mas_equalTo(self.announceBackView.mas_right).offset(-KWidthFixed(10));
    }];
    
    [_qrcodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-kSubview_Spacing_1 * 2);
        make.centerY.mas_equalTo(self.poolAvatar.mas_centerY);
        make.width.mas_equalTo(kQrcode_Width);
        make.height.mas_equalTo(kQrcode_Width);
    }];
}

- (void)setPoolModel:(OFPoolModel *)model
{
    _pool = model;
    _nameLabel.text = model.name;
    WEAK_SELF;
    [_poolAvatar sd_setImageWithURL:[NSURL URLWithString:model.logoUrl] placeholderImage:IMAGE_NAMED(@"mining_pool_icon") completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        if (!image) {
            image = IMAGE_NAMED(@"mining_pool_icon");
        }
        weakSelf.backImageView.image = [image imageByBlurRadius:30.0 tintColor:[UIColor colorWithWhite:0 alpha:0.4] tintMode:0 saturation:1 maskImage:nil];
    }];
    _leaderLabel.text = [NSString stringWithFormat:@"领主 %@", model.managerName];
    _createTime.text = [NSString stringWithFormat:@"创建时间 %@",model.createTime];
    _lastBlockTime.text = [NSString stringWithFormat:@"上次出块时间 %@", model.lastBlock];
    if (model.announcement.length > 0) {
        _poolAnnouncement.hidden = NO;
        _announceBackView.hidden = NO;
        _poolAnnouncement.text = [NSString stringWithFormat:@"公告: %@", model.announcement];
    }else {
        _poolAnnouncement.hidden = YES;
        _announceBackView.hidden = YES;
    }
    
    if ([_pool isNoobPool]) {
        self.noobBtn.hidden = NO;
    }else {
        self.noobBtn.hidden = YES;
    }
}

- (BOOL)isMyPool
{
    if (_pool && [_pool.cid isEqualToString: KcurUser.community.cid]) {
        return YES;
    }
    return NO;
}

#pragma mark - action
- (void)noobClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(poolHeaderNoobSelected:)]) {
        [self.delegate poolHeaderNoobSelected:self];
    }
}

- (void)qrcodeShare
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(poolHeaderQrcodeShareSelected:)]) {
        [self.delegate poolHeaderQrcodeShareSelected:self];
    }
}

- (void)announceClick
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(poolHeaderAnnounceSelected:)]) {
        [self.delegate poolHeaderAnnounceSelected:self];
    }
}

#pragma mark - lazy load
- (UIImageView *)backImageView
{
    if (!_backImageView) {
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0,0, kScreenWidth, kScreenWidth * 0.3}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        _backImageView = [[UIImageView alloc] initWithImage:image];
        _backImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _backImageView;
}

- (UIImageView *)leaderAvatar
{
    if (!_leaderAvatar) {
        _leaderAvatar = [[UIImageView alloc] initWithFrame: (CGRect){0, 0, kLeaderAvatar_Width, kLeaderAvatar_Width}];
        _leaderAvatar.image = [UIImage imageNamed:@"mining_miner_icon"];
        _leaderAvatar.layer.masksToBounds = YES;
        _leaderAvatar.layer.cornerRadius = kLeaderAvatar_Width * 0.5;
    }
    return _leaderAvatar;
}

- (UIImageView *)poolAvatar
{
    if (!_poolAvatar) {
        _poolAvatar = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, kPoolAvatar_Width, kPoolAvatar_Width)];
        _poolAvatar.image = [UIImage imageNamed:@"mining_miner_icon"];
        _poolAvatar.layer.masksToBounds = YES;
        _poolAvatar.layer.cornerRadius = 5.f;
        _poolAvatar.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _poolAvatar;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:FixBoldFont(15)
                                  textColor:OF_COLOR_WHITE
                             textAlignement:NSTextAlignmentLeft
                                       text:@"name"];
    }
    return _nameLabel;
}

- (UILabel *)leaderLabel
{
    if (!_leaderLabel) {
        _leaderLabel = [UILabel labelWithFont:FixFont(11)
                                    textColor:[UIColor colorWithRGB:0xf1f1f1]
                               textAlignement:NSTextAlignmentLeft
                                         text:@"leader"];
    }
    return _leaderLabel;
}

- (UILabel *)createTime
{
    if (!_createTime) {
        _createTime = [UILabel labelWithFont:FixFont(11) textColor:[UIColor colorWithRGB:0xefefef] textAlignement:NSTextAlignmentLeft text:@"createTime"];
    }
    return _createTime;
}

- (UILabel *)lastBlockTime
{
    if (!_lastBlockTime) {
        _lastBlockTime = [UILabel labelWithFont:FixFont(11)
                                      textColor:[UIColor colorWithRGB:0xefefef]
                                 textAlignement:NSTextAlignmentLeft
                                           text:@"blockTime"];
    }
    return _lastBlockTime;
}

- (UIView *)blockBackView
{
    if (!_blockBackView) {
        _blockBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 18)];
        _blockBackView.layer.masksToBounds = YES;
        _blockBackView.layer.cornerRadius = 10.f;
        _blockBackView.backgroundColor = [UIColor colorWithRGB:0xfdfbef alpha:0.7];
        _blockBackView.hidden = YES;
    }
    return _blockBackView;
}

- (UIButton *)noobBtn
{
    if (!_noobBtn) {
        _noobBtn = [UIButton buttonWithTitle:@""
                                  titleColor:OF_COLOR_MAIN_THEME
                             backgroundColor:OF_COLOR_CLEAR
                                        font:FixFont(13)
                                      target:self action:@selector(noobClick)];
        [_noobBtn setBackgroundImage:IMAGE_NAMED(@"mining_icon_noob") forState:UIControlStateNormal];
        _noobBtn.hidden = YES;
    }
    return _noobBtn;
}

- (UIView *)announceBackView
{
    if (!_announceBackView) {
        _announceBackView = [[UIView alloc] initWithFrame:CGRectZero];
        _announceBackView.backgroundColor = [UIColor colorWithRGB:0x000000 alpha:0.1];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(announceClick)];
        [_announceBackView addGestureRecognizer:tap];
    }
    return _announceBackView;
}

- (UILabel *)poolAnnouncement
{
    if (!_poolAnnouncement) {
        _poolAnnouncement = [UILabel labelWithFont:FixFont(11)
                                          textColor:[UIColor colorWithRGB:0xd6d6d6] textAlignement:NSTextAlignmentLeft text:@"announcement"];
    }
    return _poolAnnouncement;
}

- (UIButton *)qrcodeButton
{
    if (!_qrcodeButton) {
        _qrcodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_qrcodeButton setImage:IMAGE_NAMED(@"mining_mypool_qrcode") forState:UIControlStateNormal];
        [_qrcodeButton addTarget:self action:@selector(qrcodeShare) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrcodeButton;
}

@end
