//
//  OFPoolSectionView.m
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFPoolSectionView.h"

#pragma mark - OFSectionButton
@interface OFSectionButton : UIControl

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation OFSectionButton

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

#pragma mark - OFPoolSectionView
@interface OFPoolSectionView ()

@property (nonatomic, strong) NSArray <NSString *> *dataArr;
@property (nonatomic, strong) NSMutableArray <OFSectionButton *> *buttonArr;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) UIView *separatorLine;
@property (nonatomic, strong) UIColor *selectedTitleColor;

@end

@implementation OFPoolSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _style = OFPoolHeaderStyleDefault;
        _selectedTitleColor = OF_COLOR_MAIN_THEME;
        [self addSubview:self.separatorLine];
        [self addSubview:self.lineView];
    }
    return self;
}

- (void)setDataArr:(NSArray<NSString *> *)dataArr
{
    BOOL isFirst = NO;
    if (self.dataArr.count == 0) {
        isFirst = YES;
    }
    
    _dataArr = dataArr;
    [self keepButtonsCount];
    [self setButtonValues];
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    if (isFirst) {
        [self fixLineCenter];
    }
}

- (void)layoutSubviews
{
    [self.separatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.bottom.mas_equalTo(self.mas_bottom).offset(3);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(0.5);
    }];
    
    if (_style == OFPoolHeaderStyleDefault) {
        [self layoutDefaultStyle];
    }else if (_style == OFPoolHeaderStyleLeft) {
        [self layoutLeftStyle];
    }
    [self layoutLineView];
    [super layoutSubviews];
}

- (void)layoutLineView
{
    OFSectionButton *btn = [self.buttonArr objectAtIndex:_selectedIndex];
    if (!btn) return;
    CGFloat width = [self lineWidth:btn.titleLabel.text];
    CGPoint center = btn.center;
    CGRect frame = CGRectMake(center.x - width * 0.5, center.y + 15, width, 1);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.lineView.frame = frame;
        btn.titleLabel.textColor = self.selectedTitleColor;
        btn.titleLabel.font = FixFont(15);
    }];
}

- (void)layoutDefaultStyle
{
    CGFloat padding = 5.f;
    CGFloat width = (kScreenWidth - padding * (_buttonArr.count + 1)) / _buttonArr.count;
    
    for (int i = 0; i < _buttonArr.count; ++i) {
        OFSectionButton *btn = [_buttonArr objectAtIndex:i];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(padding + (width + padding) * i);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(self.mas_height);
            make.centerY.mas_equalTo(self.mas_centerY).offset(-5.f);
        }];
    }
}

- (void)layoutLeftStyle
{
    CGFloat padding = 15.f;
    for (int i = 0; i < _buttonArr.count; ++i) {
        OFSectionButton *btn = [_buttonArr objectAtIndex:i];
        OFSectionButton *leftBtn = i > 0 ? [_buttonArr objectAtIndex:i - 1] : nil;
        CGFloat width = [btn.titleLabel.text widthForFont:FixFont(13)] + 3;
        if (leftBtn) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(leftBtn.mas_right).offset(8);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(self.mas_height);
                make.centerY.mas_equalTo(self.mas_centerY).offset(-5.f);
            }];
        }else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(padding);
                make.width.mas_equalTo(width);
                make.height.mas_equalTo(self.mas_height);
                make.centerY.mas_equalTo(self.mas_centerY).offset(-5.f);
            }];
        }
    }
}
#pragma mark - setting
- (void)setSeparatorLineHidden:(BOOL)isHidden
{
    self.separatorLine.hidden = isHidden;
}

- (void)setSelectedLineColor:(UIColor *)color
{
    self.lineView.backgroundColor = color;
}

- (void)setSelectedTitleColor:(UIColor *)titleColor
{
    _selectedTitleColor = titleColor;
}

- (void)setSelectedItemAtIndex:(NSInteger)index
{
    if (index < _buttonArr.count) {
        if (self.selectedIndex == index) return;
        self.selectedIndex = index;
        [self resetBttonTintColor];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(sectionView:didSelectedButtonIndex:)]) {
            [self.delegate sectionView:self didSelectedButtonIndex:index];
        }
    }
}

#pragma mark - action
- (void)clickButton:(id)sender
{
    if (![_buttonArr containsObject:sender]) return;
    NSUInteger index = [_buttonArr indexOfObject:sender];
    [self setSelectedItemAtIndex:index];
}


- (void)fixLineCenter
{
    self.selectedIndex = 0;
    [self resetBttonTintColor];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - private
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) return;
    _selectedIndex = selectedIndex;
}

- (void)setButtonValues
{
    for (int i =0; i < _dataArr.count; ++i) {
        NSString *text = [_dataArr objectAtIndex:i];
        OFSectionButton *btn = [_buttonArr objectAtIndex:i];
        btn.titleLabel.text = text;
    }
}

- (void)keepButtonsCount
{
    while (_dataArr.count > _buttonArr.count) {
        OFSectionButton *btn = [[OFSectionButton alloc] initWithFrame:CGRectZero];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArr addObject:btn];
        [self addSubview:btn];
    }
    while (_dataArr.count < _buttonArr.count) {
        OFSectionButton *btn = [_buttonArr lastObject];
        [btn removeFromSuperview];
        [self.buttonArr removeLastObject];
    }
}

- (void)resetBttonTintColor
{
    for (OFSectionButton *btn in _buttonArr) {
        btn.titleLabel.textColor = OF_COLOR_DETAILTITLE;
        btn.titleLabel.font = FixFont(14);
    }
}

- (CGFloat)lineWidth:(NSString *)text
{
    CGFloat width = 0;
    width = [text widthForFont:FixFont(16)];
    width = MAX(width * 0.8, 25);
    return width;
}

- (NSMutableArray<OFSectionButton *> *)buttonArr
{
    if (!_buttonArr) {
        _buttonArr = [NSMutableArray array];
    }
    return _buttonArr;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = OF_COLOR_MAIN_THEME;
    }
    return _lineView;
}

- (UIView *)separatorLine
{
    if (!_separatorLine) {
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = OF_COLOR_SEPARATOR;
    }
    return _separatorLine;
}

@end

@interface OFPoolSectionSearchView ()

@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) OFPoolSectionView *segmentView;

@end

@implementation OFPoolSectionSearchView

- (instancetype)initWithFrame:(CGRect)frame delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        self.backgroundColor = OF_COLOR_WHITE;
        [self addSubview:self.searchBtn];
    }
    return self;
}

- (void)setDataArr:(NSArray<NSString *> *)dataArr
{
    [self.segmentView setDataArr:dataArr];
}

- (void)layoutSubviews
{
    [self.searchBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(15.f);
        make.centerX.mas_equalTo(self);
        make.width.mas_equalTo(kScreenWidth * 0.8);
        make.height.mas_equalTo(30);
    }];
    
    [self.segmentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self);
        make.height.mas_equalTo(35);
    }];
    [super layoutSubviews];
}

- (void)searchAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionSearchViewDidSearch:)]) {
        [self.delegate sectionSearchViewDidSearch:self];
    }
}

#pragma mark - lazy load
- (UIButton *)searchBtn{
    if (!_searchBtn) {
        _searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _searchBtn.frame = CGRectMake(0, 0, kScreenWidth * 0.8, 30);
        [_searchBtn setTitle:@"  搜索矿池名称" forState:UIControlStateNormal];
        [_searchBtn setTitleColor:[UIColor colorWithRGB:0xbdbebe] forState:UIControlStateNormal];
        _searchBtn.titleLabel.font = [NUIUtil fixedFont:13];
        _searchBtn.backgroundColor = [UIColor colorWithRGB:0xeeeeee];
        [_searchBtn setImage:[UIImage imageNamed:@"mining_search"] forState:UIControlStateNormal];
        _searchBtn.layer.cornerRadius = 30.0 * 0.5;
        _searchBtn.layer.masksToBounds = YES;
        [_searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchBtn;
}

- (OFPoolSectionView *)segmentView
{
    if (!_segmentView) {
        _segmentView = [[OFPoolSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        _segmentView.backgroundColor = OF_COLOR_WHITE;
        _segmentView.delegate = _delegate;
        [self addSubview:_segmentView];
    }
    return _segmentView;
}

@end
