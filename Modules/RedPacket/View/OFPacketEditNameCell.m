//
//  OFPacketEditNameCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketEditNameCell.h"
#import "OFShadowCornerView.h"
#import <YYKit/YYTextView.h>

#define kCorner_Border  KWidthFixed(15)
#define kMargin_Border  KWidthFixed(10)

NSString *const OFPacketEditNameCellIdentifier = @"OFPacketEditNameCellIdentifier";

@implementation OFPacketEditNameModel

@end

@interface OFPacketEditNameCell ()<YYTextViewDelegate>
{
    OFPacketEditNameModel *_model;
}
@property (nonatomic, strong) OFShadowCornerView *cornerView;
//@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) YYTextView *textView;

@end

@implementation OFPacketEditNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = OF_COLOR_CLEAR;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(KWidthFixed(20));
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(self.contentView.mas_left).offset(kCorner_Border);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kCorner_Border);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.cornerView).offset(kMargin_Border);
        make.right.mas_equalTo(self.cornerView.mas_right).offset(-kMargin_Border);
        make.bottom.mas_equalTo(self.cornerView.mas_bottom).offset(-kMargin_Border);
//        make.height.mas_equalTo(KWidthFixed(20));
    }];
}

- (void)updateInfo:(OFPacketEditNameModel *)model
{
    _model = model;
    self.textView.placeholderText = model.placeHolder;
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView;
{
    self.textView.text = [self.textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    self.textView.text = [self.textView.text stringByReplacingOccurrencesOfString:@"\r\r" withString:@"\r"];
    _model.name = self.textView.text;
}

- (void)becomeResponder
{
    self.textView.userInteractionEnabled = YES;
    [self.textView becomeFirstResponder];
}

- (void)resignResponder
{
    [self.textView resignFirstResponder];
    self.textView.userInteractionEnabled = NO;
}

#pragma mark - lazy load
- (OFShadowCornerView *)cornerView
{
    if (!_cornerView) {
        _cornerView = [[OFShadowCornerView alloc] initWithFrame:CGRectZero];
        _cornerView.shadowType = ShadowTypeNone;
        [self.contentView addSubview:_cornerView];
    }
    return _cornerView;
}

//- (UITextField *)textField
//{
//    if (!_textField) {
//        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
//        _textField.borderStyle = UITextBorderStyleNone;
//        _textField.returnKeyType = UIReturnKeyDone;
//        _textField.placeholder = @"placeholder";
//        _textField.textAlignment = NSTextAlignmentLeft;
//        _textField.font = FixFont(15);
//        _textField.textColor = OF_COLOR_MINOR;
//        _textField.rightView = nil;
//        [_textField addTarget:self action:@selector(resignResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
//        [_textField addTarget:self action:@selector(textFieldChangeText) forControlEvents:UIControlEventEditingChanged];
//        [self.contentView addSubview:_textField];
//    }
//    return _textField;
//}

- (YYTextView *)textView
{
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.font = FixFont(15);
        _textView.textColor = OF_COLOR_TITLE;
        _textView.placeholderText = @"福币福币";
        _textView.placeholderTextColor = OF_COLOR_DETAILTITLE;
        _textView.delegate = self;
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.userInteractionEnabled = NO;
        [self.contentView addSubview:_textView];
    }
    return _textView;
}
@end
