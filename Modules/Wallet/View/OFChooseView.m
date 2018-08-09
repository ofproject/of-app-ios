//
//  OFChooseView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFChooseView.h"

#define kRowPadding    5.f
#define kRowCount      5

#pragma mark - OFSectionButton
@interface OFChooseButton : UIControl

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation OFChooseButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selected = NO;
        [self addSubview:self.titleLabel];
        [self setupLayout];
    }
    return self;
}

- (void)setupLayout
{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithFont:FixFont(14)
                                   textColor:OF_COLOR_DETAILTITLE
                              textAlignement:NSTextAlignmentCenter
                                        text:@"title"];
    }
    return _titleLabel;
}

@end

#pragma mark - OFChooseView
@interface OFChooseView ()

@property (nonatomic, strong) NSArray<NSString *> *dataArr;
@property (nonatomic, strong) NSMutableArray <OFChooseButton *> *buttonArr;

@end

@implementation OFChooseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setDataArr:(NSArray<NSString *> *)dataArr
{
    _dataArr = dataArr;
    [self keepButtonsCount];
    [self setButtonValues];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)layoutSubviews
{
    // 一排显示五个
    CGFloat width = (self.frame.size.width - kRowPadding * (kRowCount + 1)) / kRowCount;
    for (int i = 0; i < _buttonArr.count; i++) {
        CGFloat x = 0.f;
        CGFloat y = 0.f;
        x = kRowPadding + (i % 5) * (width + kRowPadding);
        y = kRowPadding + (i / 5) * (width + kRowPadding);
        CGRect frame = CGRectMake(x, y, width, width);
        OFChooseButton *btn = [_buttonArr objectAtIndex:i];
        btn.frame = frame;
    }
}

- (CGSize)viewSize
{
    CGFloat width = (self.frame.size.width - kRowPadding * (kRowCount + 1)) / kRowCount;
    NSInteger row = 1;
    if (_buttonArr.count % kRowCount == 0) {
        row = MAX(1, _buttonArr.count / kRowCount);
    }else {
        row = MAX(1, _buttonArr.count / kRowCount + 1);
    }
    CGFloat height = row *(width + kRowPadding) + kRowPadding;
    return CGSizeMake(width, height);
}

#pragma mark - action
- (void)clickButton:(id)sender
{
    if (![_buttonArr containsObject:sender]) return;
    NSUInteger index = [_buttonArr indexOfObject:sender];
    NSString *word = [_dataArr objectAtIndex:index];
//    if (self.selectedIndex == index) return;
//    self.selectedIndex = index;
//    [self resetBttonTintColor];
//    [self setNeedsLayout];
//    [self layoutIfNeeded];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseView:didSelectedWord:index:)]) {
        [self.delegate chooseView:self didSelectedWord:word index:index];
    }
}

#pragma mark - private
- (void)setButtonValues
{
    for (int i =0; i < _dataArr.count; ++i) {
        NSString *text = [_dataArr objectAtIndex:i];
        OFChooseButton *btn = [_buttonArr objectAtIndex:i];
        btn.titleLabel.text = text;
    }
}

- (void)keepButtonsCount
{
    while (_dataArr.count > _buttonArr.count) {
        OFChooseButton *btn = [[OFChooseButton alloc] initWithFrame:CGRectZero];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArr addObject:btn];
        [self addSubview:btn];
    }
    while (_dataArr.count < _buttonArr.count) {
        OFChooseButton *btn = [_buttonArr lastObject];
        [btn removeFromSuperview];
        [self.buttonArr removeLastObject];
    }
}

- (void)resetBttonTintColor
{
    for (OFChooseButton *btn in _buttonArr) {
        btn.titleLabel.textColor = OF_COLOR_DETAILTITLE;
        btn.titleLabel.font = FixFont(14);
    }
}

- (NSMutableArray<OFChooseButton *> *)buttonArr
{
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

@end
