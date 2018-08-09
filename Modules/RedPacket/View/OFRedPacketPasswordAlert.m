//
//  OFRedPacketPasswordAlert.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRedPacketPasswordAlert.h"

#define kMargin_Top         KWidthFixed(25.f)
#define kMargin_Border      KWidthFixed(30.f)
#define KTextField_Height   KWidthFixed(30.f)

@interface OFRedPacketPasswordView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UIView *separator;
@property (nonatomic, strong) UIButton *sure;
@property (nonatomic, copy) void (^callback)(NSString *);

@end

@implementation OFRedPacketPasswordView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayout];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = OF_COLOR_WHITE;
    }
    return self;
}

- (void)setupLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(self.mas_top).offset(kMargin_Top);
    }];
    
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-KWidthFixed(10));
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Border);
        make.right.mas_equalTo(self.mas_right).offset(-kMargin_Border);
        make.height.mas_equalTo(KTextField_Height);
    }];
    
    [self.separator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.password.mas_left);
        make.right.mas_equalTo(self.password.mas_right);
        make.top.mas_equalTo(self.password.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.sure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.mas_bottom).offset(-KWidthFixed(38));
        make.centerX.mas_equalTo(self.titleLabel.mas_centerX);
        make.width.mas_equalTo(KWidthFixed(100));
        make.height.mas_equalTo(KWidthFixed(40));
    }];
}

- (void)transferFund
{
    if (self.password.text.length < 1) {
        [MBProgressHUD showToast:@"请输入资金密码" toView:[JumpUtil currentVC].view];
        return;
    }
    
    if (self.callback) {
        self.callback(self.password.text);
    }
}

#pragma mark - lazy load
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixFont(16) textColor:OF_COLOR_TITLE textAlignement:NSTextAlignmentCenter text:@"请输入资金密码"];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UITextField *)password
{
    if (!_password) {
        _password = [[UITextField alloc] initWithFrame:CGRectZero];
        _password.placeholder = @"请输入资金密码";
        _password.textColor = OF_COLOR_TITLE;
        _password.secureTextEntry = YES;
        _password.returnKeyType = UIReturnKeyGo;
        _password.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_password];
    }
    return _password;
}

- (UIView *)separator
{
    if (!_separator) {
        _separator = [[UIView alloc] initWithFrame:CGRectZero];
        _separator.backgroundColor = OF_COLOR_SEPARATOR;
        [self addSubview:_separator];
    }
    return _separator;
}

- (UIButton *)sure
{
    if (!_sure) {
        _sure = [UIButton buttonWithTitle:@"确定" titleColor:OF_COLOR_WHITE backgroundColor:nil font:FixFont(15) target:self action:@selector(transferFund)];
        _sure.layer.cornerRadius = 5.f;
        _sure.layer.masksToBounds = YES;
        _sure.backgroundColor = [UIColor colorWithRGB:0xe25d4c];
        [self addSubview:_sure];
    }
    return _sure;
}

@end

#pragma mark - OFRedPacketPasswordAlert

@interface OFRedPacketPasswordAlert ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) CALayer *backLayer;
@property (nonatomic, strong) OFRedPacketPasswordView *passwordView;

@end

@implementation OFRedPacketPasswordAlert

+ (OFRedPacketPasswordAlert *)showPasswordAlertToView:(UIView *)view callback:(void(^)(NSString *password))callback
{
    OFRedPacketPasswordAlert *alert = [[OFRedPacketPasswordAlert alloc] initWithFrame:view.bounds];
    __weak typeof (alert) weakAlert = alert;
    alert.passwordView.callback = ^(NSString *password) {
        [weakAlert hideAlert];
        if (callback) {
            callback(password);
        }
    };
    [view addSubview:alert];
    [alert.passwordView.password becomeFirstResponder];
    return alert;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.backLayer];
        [self addSubview:self.passwordView];
        _passwordView.center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.4);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAlert)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint location = [touch locationInView:self];
    if (location.x <= _passwordView.left ||
        location.x >= _passwordView.left + _passwordView.width ||
        location.y <= _passwordView.top ||
        location.y >= _passwordView.top + _passwordView.height) {
        return YES;
    }
    return NO;
}

- (void)hideAlert
{
    [self removeFromSuperview];
}

- (CALayer *)backLayer
{
    if (!_backLayer) {
        _backLayer = [CALayer layer];
        _backLayer.frame = self.bounds;
        _backLayer.backgroundColor = OF_COLOR_BLACK.CGColor;
        _backLayer.opacity = 0.4;
    }
    return _backLayer;
}

- (OFRedPacketPasswordView *)passwordView
{
    if (!_passwordView) {
        _passwordView = [[OFRedPacketPasswordView alloc] initWithFrame: CGRectMake(0, 0, KWidthFixed(290), KWidthFixed(220))];
    }
    return _passwordView;
}

@end
