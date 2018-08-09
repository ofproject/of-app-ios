//
//  OFBackupWordsController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBackupWordsController.h"
#import "OFChooseWordController.h"
#import "OFChooseView.h"

#define kMargin_Left    KWidthFixed(20.f)
#define kMargin_Top     KWidthFixed(20.f)
#define kButtonHeight   KHeightFixed(40.f)

@interface OFBackupWordsController ()<OFChooseViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) OFChooseView *showView;
@property (nonatomic, strong) UIButton *nextStep;

@end

@implementation OFBackupWordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"备份助记词";
    [self initUI];
    [self initData];
}

- (void)initUI
{
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tipLabel];
    [self.view addSubview:self.showView];
    [self.view addSubview:self.nextStep];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(kMargin_Left);
        make.right.mas_equalTo(self.view).offset(-kMargin_Left);
        make.top.mas_equalTo(self.view).offset(kMargin_Top);
        make.height.mas_equalTo(KHeightFixed(20));
    }];
    
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(kMargin_Left);
        make.right.mas_equalTo(self.view).offset(-kMargin_Left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(60);
    }];
    
    [_showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(kMargin_Left);
        make.right.mas_equalTo(self.view).offset(-kMargin_Left);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(60);
    }];
    
    [_nextStep mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.showView.mas_bottom).offset(kMargin_Top * 2);
        make.left.mas_equalTo(self.view.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.view.mas_right).offset(-kMargin_Left);
        make.height.mas_equalTo(kButtonHeight);
    }];
}

- (void)initData
{
    NSArray *words =[[OFKVStorage shareStorage] itemForKey:@"PrivateKey_words"];
    [self.showView setDataArr:words];
    [self updateShowView];
}

- (void)updateShowView
{
    CGSize size = [self.showView viewSize];
    [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - Action
- (void)nextStepAction
{
    OFChooseWordController *controller = [[OFChooseWordController alloc] init];
    controller.works = self.works;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - lazy load
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixFont(17)
                                   textColor:OF_COLOR_TITLE
                              textAlignement:NSTextAlignmentCenter
                                        text:@"抄写下您的钱包助记词"];
    }
    return _titleLabel;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithFont:FixFont(14)
                                 textColor:OF_COLOR_MINOR
                            textAlignement:NSTextAlignmentLeft
                                      text:@"tip"];
        _tipLabel.numberOfLines = 0;
        NSString *text = @"助记词用于恢复钱包或重置钱包密码, 将它准确的抄写到纸上, 并存放在只有你知道的安全地方";
        NSAttributedString *attrText = [text getAttributedStringWithLineSpace:5.f kern:0];
        _tipLabel.attributedText = attrText;
    }
    return _tipLabel;
}

- (OFChooseView *)showView
{
    if (!_showView) {
        _showView = [[OFChooseView alloc] initWithFrame:CGRectZero];
        _showView.backgroundColor = OF_COLOR_BACKGROUND;
        _showView.delegate = self;
    }
    return _showView;
}

- (UIButton *)nextStep
{
    if (!_nextStep) {
        _nextStep = [UIButton buttonWithTitle:@"下一步"
                                 titleColor:OF_COLOR_WHITE
                            backgroundColor:OF_COLOR_CLEAR
                                       font:FixFont(15)];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_nextStep setBackgroundImage:image forState:UIControlStateNormal];
        _nextStep.layer.cornerRadius = 5.f;
        _nextStep.layer.masksToBounds = YES;
        [_nextStep addTarget:self action:@selector(nextStepAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextStep;
}

@end
