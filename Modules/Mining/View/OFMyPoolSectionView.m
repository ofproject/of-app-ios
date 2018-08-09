//
//  OFMyPoolSectionView.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFMyPoolSectionView.h"

#define kMargin_Left KWidthFixed(16.f)
#define kSubview_Spacing_1      KWidthFixed(11.5f)
#define kSubview_Spacing_2      KWidthFixed(12.5f)
#define kDecorateView_Width     KWidthFixed(5.f)
#define kDecorateView_Height    KWidthFixed(16.f)

@interface OFMyPoolSectionView ()

@property (nonatomic, strong) UIView *decorateView;
@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UILabel *nodeLabel;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation OFMyPoolSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = OF_COLOR_WHITE;
        [self addSubview:self.decorateView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.nodeLabel];
        [self addSubview:self.lineView];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.decorateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Left);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.width.mas_equalTo(kDecorateView_Width);
        make.height.mas_equalTo(kDecorateView_Height);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.decorateView.mas_right).offset(kSubview_Spacing_1);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.nodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tipLabel.mas_right).offset(kSubview_Spacing_2);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(kMargin_Left);
        make.right.mas_equalTo(self.mas_right).offset(-kMargin_Left);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
}

- (void)updateNodeNumber:(NSString *)nodeNumber
{
    if (nodeNumber.length > 0) {
        _nodeLabel.text = nodeNumber;
    }
}

#pragma mark - lazy load
- (UIView *)decorateView
{
    if (!_decorateView) {
        _decorateView = [[UIView alloc] initWithFrame:CGRectZero];
        _decorateView.backgroundColor = OF_COLOR_MAIN_THEME;
    }
    return _decorateView;
}

- (UILabel *)tipLabel
{
    if (!_tipLabel) {
        _tipLabel = [UILabel labelWithFont:FixFont(14)
                                 textColor:OF_COLOR_TITLE
                            textAlignement:NSTextAlignmentLeft
                                      text:@"矿池节点"];
    }
    return _tipLabel;
}

- (UILabel *)nodeLabel
{
    if (!_nodeLabel) {
        _nodeLabel = [UILabel labelWithFont:FixFont(12) textColor:OF_COLOR_MAIN_THEME textAlignement:NSTextAlignmentLeft text:@"0"];
    }
    return _nodeLabel;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = OF_COLOR_SEPARATOR;
    }
    return _lineView;
}

@end
