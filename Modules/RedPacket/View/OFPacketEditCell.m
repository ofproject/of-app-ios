//
//  OFPacketEditCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketEditCell.h"
#import "OFShadowCornerView.h"

#define kCorner_Border  KWidthFixed(15)
#define kMargin_Border  KWidthFixed(10)

NSString *const OFPacketEditCellIdentifier = @"OFPacketEditCellIdentifier";

@implementation OFPacketEditModel

@end

@interface OFPacketEditCell () <UITextFieldDelegate>
{
    OFPacketEditModel *_model;
}
@property (nonatomic, strong) UITextField *countTextField;
@property (nonatomic, strong) OFShadowCornerView *cornerView;

@end

@implementation OFPacketEditCell

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
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.cornerView.mas_left).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.cornerView.mas_centerY);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cornerView.mas_right).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.cornerView.mas_centerY);
    }];
    
    [self.countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.detailLabel.mas_left).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.cornerView.mas_centerY);
        make.width.mas_equalTo(KWidthFixed(120));
        make.height.mas_equalTo(KWidthFixed(30));
    }];
    
    self.detailLabel.font = FixFont(14);
}

- (void)updateInfo:(OFPacketEditModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.detailTitle;
    self.countTextField.placeholder = model.placeHolder;
    self.countTextField.keyboardType = model.keyboardType;
    self.countTextField.text = model.editText;
}

#pragma mark - Action
- (void)didEditCount
{
    if (((!_model.checkText) || (_model.checkText && _model.checkText(self.countTextField.text))) &&
        self.countTextField.text.length>0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(packetEditCell:model:didEditCount:)]) {
            [self.delegate packetEditCell:self model:_model didEditCount:self.countTextField.text];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self resignResponder];
    [self didEditCount];
}

- (void)textFieldChangeText
{
    _model.editText = self.countTextField.text;
}

- (void)becomeResponder
{
    self.countTextField.userInteractionEnabled = YES;
    [self.countTextField becomeFirstResponder];
}

- (void)resignResponder
{
    [self.countTextField resignFirstResponder];
    self.countTextField.userInteractionEnabled = NO;
}

- (UITextField *)countTextField
{
    if (!_countTextField) {
        _countTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _countTextField.borderStyle = UITextBorderStyleNone;
        _countTextField.returnKeyType = UIReturnKeyDone;
        _countTextField.placeholder = @"placeholder";
        _countTextField.textAlignment = NSTextAlignmentRight;
        _countTextField.font = FixFont(15);
        _countTextField.textColor = OF_COLOR_MINOR;
        _countTextField.delegate = self;
        _countTextField.rightView = nil;
        _countTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [_countTextField addTarget:self action:@selector(resignResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_countTextField addTarget:self action:@selector(textFieldChangeText) forControlEvents:UIControlEventEditingChanged];
        _countTextField.userInteractionEnabled = NO;
        [self.contentView addSubview:_countTextField];
    }
    return _countTextField;
}

- (OFShadowCornerView *)cornerView
{
    if (!_cornerView) {
        _cornerView = [[OFShadowCornerView alloc] initWithFrame:CGRectZero];
        _cornerView.shadowType = ShadowTypeNone;
        [self.contentView addSubview:_cornerView];
    }
    return _cornerView;
}

@end
