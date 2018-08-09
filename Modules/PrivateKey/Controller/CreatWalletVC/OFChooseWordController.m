//
//  OFChooseWordController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFChooseWordController.h"
#import "OFChooseView.h"
#import "OFChooseWordLogic.h"
#import "OFProTabBarController.h"

#define kMargin_Left    KWidthFixed(20.f)
#define kMargin_Top     KWidthFixed(20.f)
#define kButtonHeight   KHeightFixed(40.f)

@interface OFChooseWordController () <OFChooseViewDelegate,OFChooseWordLogicDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) OFChooseView *showView;
@property (nonatomic, strong) OFChooseView *chooseView;
@property (nonatomic, strong) UIButton *ensure;
@property (nonatomic, strong) OFChooseWordLogic *logic;

@end

@implementation OFChooseWordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"备份助记词";
    [self initUI];
    [self initData];
}

- (void)initUI
{
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.tipLabel];
    [self.scrollView addSubview:self.showView];
    [self.scrollView addSubview:self.chooseView];
    [self.scrollView addSubview:self.ensure];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.top.mas_equalTo(self.view.mas_top);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.scrollView.mas_right).offset(-kMargin_Left);
        make.top.mas_equalTo(self.scrollView.mas_top).offset(kMargin_Top);
        make.height.mas_equalTo(KHeightFixed(20));
    }];

    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.scrollView.mas_right).offset(-kMargin_Left);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(60);
        make.width.mas_equalTo(kScreenWidth - kMargin_Left * 2);
    }];

    [self.showView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.scrollView.mas_right).offset(-kMargin_Left);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(60);
    }];

    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scrollView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.scrollView.mas_right).offset(-kMargin_Left);
        make.top.mas_equalTo(self.showView.mas_bottom).offset(kMargin_Top);
        make.height.mas_equalTo(60);
    }];

    [self.ensure mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chooseView.mas_bottom).offset(kMargin_Top);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.scrollView.mas_right).offset(-kMargin_Left);
        make.height.mas_equalTo(kButtonHeight);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
    }];
}

- (void)initData
{
    NSArray *words = [[OFKVStorage shareStorage] itemForKey:@"PrivateKey_words"];
    _logic = [[OFChooseWordLogic alloc] initWithDelegate:self words:words];
    [self.chooseView setDataArr:[_logic getChosenWords]];
    [self updateChooseView];
}

#pragma mark - Update layout
- (void)updateShowView
{
    CGSize size = [self.showView viewSize];
    [self.showView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
}

- (void)updateChooseView
{
    CGSize size = [self.chooseView viewSize];
    [self.chooseView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - OFChooseViewDelegate
- (void)chooseView:(OFChooseView *)sectionView didSelectedWord:(NSString *)word index:(NSInteger)index
{
    if (sectionView == self.showView) {
        [self.logic cancleChooseWord:word];
    }else if (sectionView == self.chooseView) {
        [self.logic chooseWord:word];
    }
}

#pragma mark - OFChooseWordLogicDelegate
- (void)updateChosenWords
{
    [self.chooseView setDataArr:[_logic getChosenWords]];
    [self updateChooseView];
    [self.showView setDataArr:[_logic getShowWords]];
    [self updateShowView];
}

#pragma mark - Action
- (void)ensureChosenWords {
    NSLog(@"%@",self.logic.getShowWords);
    
    NSMutableString *words = [NSMutableString string];
    
    [self.logic.getShowWords enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [words appendString:obj];
    }];
    
    if ([words isEqualToString:self.works]) {
        
        OFProTabBarController *tab = [[OFProTabBarController alloc]init];
        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        
    }
    
    
}

#pragma mark - lazy load
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.backgroundColor = OF_COLOR_WHITE;
        _scrollView.contentSize = CGSizeMake(0, self.view.bounds.size.height * 2);
    }
    return _scrollView;
}

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

- (OFChooseView *)chooseView
{
    if (!_chooseView) {
        _chooseView = [[OFChooseView alloc] initWithFrame:CGRectZero];
        _chooseView.delegate = self;
    }
    return _chooseView;
}

- (UIButton *)ensure
{
    if (!_ensure) {
        _ensure = [UIButton buttonWithTitle:@"确认"
                                   titleColor:OF_COLOR_WHITE
                              backgroundColor:OF_COLOR_CLEAR
                                         font:FixFont(15)];
        UIImage *image = [UIImage makeGradientImageWithRect:(CGRect){0, 0, kScreenWidth, kScreenWidth * 0.4}
                                                 startPoint:CGPointMake(0, 0.5)
                                                   endPoint:CGPointMake(1, 0.5)
                                                 startColor:OF_COLOR_GRADUAL_1
                                                   endColor:OF_COLOR_GRADUAL_2];
        [_ensure setBackgroundImage:image forState:UIControlStateNormal];
        _ensure.layer.cornerRadius = 5.f;
        _ensure.layer.masksToBounds = YES;
        [_ensure addTarget:self action:@selector(ensureChosenWords) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ensure;
}

@end
