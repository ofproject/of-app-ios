//
//  OFRecommendController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/27.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRecommendController.h"
#import "OFNavView.h"

#define kAvatarWidth KWidthFixed(47.f)

@interface OFRecommendController ()

@property (nonatomic, strong) OFNavView *navView;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *dotView;
@property (nonatomic, strong) UIImageView *qrcodeView;
@property (nonatomic, strong) UILabel *slogonLabel;

@property (nonatomic, strong) UIButton *quitButton;

@end

@implementation OFRecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.view.backgroundColor = [UIColor colorWithRGB:0xe6e6e6];
    [self.view addSubview:self.navView];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(KWidthFixed(10.f));
        make.right.mas_equalTo(self.view.mas_right).offset(-KWidthFixed(10.f));
        make.centerY.mas_equalTo(self.view.mas_centerY).offset(-KWidthFixed(20));
    }];
    
    [self.avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(KWidthFixed(28.f));
        make.top.mas_equalTo(self.backView.mas_top).offset(KWidthFixed(15.f));
        make.width.mas_equalTo(kAvatarWidth);
        make.height.mas_equalTo(kAvatarWidth);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatar.mas_right).offset(KWidthFixed(10.f));
        make.centerY.mas_equalTo(self.avatar.mas_centerY);
    }];
    
    [self.dotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.top.mas_equalTo(self.avatar.mas_bottom).offset(KWidthFixed(15.f));
    }];
    
    [self.qrcodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.backView.mas_left).offset(KWidthFixed(65.f));
        make.right.mas_equalTo(self.backView.mas_right).offset(-KWidthFixed(65.f));
        make.top.mas_equalTo(self.dotView.mas_bottom).offset(KWidthFixed(20.f));
        make.height.mas_equalTo(self.qrcodeView.mas_width);
    }];
    
    [self.slogonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.qrcodeView.mas_bottom).offset(30.f);
        make.centerX.mas_equalTo(self.backView.mas_centerX);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-KWidthFixed(35.f));
    }];
    
    [self.quitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView.mas_bottom).offset(KWidthFixed(50));
        make.width.mas_equalTo(KWidthFixed(25.f));
        make.height.mas_equalTo(KWidthFixed(25.f));
        make.centerX.mas_equalTo(self.backView.mas_centerX);
    }];
}

- (void)initData
{
    self.n_isHiddenNavBar = YES;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@的二维码", KcurUser.userName];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:KcurUser.profileUrl] placeholderImage:IMAGE_NAMED(@"mining_miner_icon")];
    UIImage *qrcodeImage = [NUIUtil createImageWithString:KcurUser.appDownloadAddress ImgSize:CGSizeMake(KWidthFixed(200), KWidthFixed(200))];
    self.qrcodeView.image = qrcodeImage;
}


#pragma mark - lazy load
- (OFNavView *)navView{
    if (!_navView) {
        _navView = [[OFNavView alloc]initWithTitle:@"推荐给好友"];
        _navView.frame = CGRectMake(0, 0, kScreenWidth, Nav_Height);
        [_navView setNavBackgroundColor: OF_COLOR_CLEAR];
        [_navView setNavTitleColor:[UIColor colorWithRGB:0x1b1b1b]];
        [_navView setBackHidden:YES];
        [_navView setShadowHidden:YES];
    }
    return _navView;
}

- (UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = OF_COLOR_WHITE;
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 5.f;
        [self.view addSubview:_backView];
    }
    return _backView;
}

- (UIImageView *)avatar
{
    if (!_avatar) {
        _avatar = [[UIImageView alloc] initWithImage:IMAGE_NAMED(@"mining_miner_icon")];
        _avatar.layer.masksToBounds = YES;
        _avatar.layer.cornerRadius = kAvatarWidth * 0.5;
        [self.backView addSubview:_avatar];
    }
    return _avatar;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithFont:FixFont(14) textColor:OF_COLOR_TITLE textAlignement:NSTextAlignmentLeft text:@""];
        [self.backView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UIImageView *)dotView
{
    if (!_dotView) {
        _dotView = [[UIImageView alloc] initWithImage: IMAGE_NAMED(@"recommend_dot")];
        [self.backView addSubview:_dotView];
    }
    return _dotView;
}

- (UIImageView *)qrcodeView
{
    if (!_qrcodeView) {
        _qrcodeView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _qrcodeView.image = IMAGE_NAMED(@"mining_miner_icon");
        [self.backView addSubview:_qrcodeView];
    }
    return _qrcodeView;
}

- (UILabel *)slogonLabel
{
    if (!_slogonLabel) {
        _slogonLabel = [UILabel labelWithFont:FixFont(16) textColor:OF_COLOR_TITLE textAlignement:NSTextAlignmentCenter text:@"全球第一个手机挖矿App"];
        [self.backView addSubview:_slogonLabel];
    }
    return _slogonLabel;
}

- (UIButton *)quitButton
{
    if (!_quitButton) {
        _quitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_quitButton setImage:IMAGE_NAMED(@"recommend_quit") forState:UIControlStateNormal];
        [_quitButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_quitButton];
    }
    return _quitButton;
}


@end
