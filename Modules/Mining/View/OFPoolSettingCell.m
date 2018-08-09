//
//  OFPoolSettingCell.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPoolSettingCell.h"

#define kMargin_Border KWidthFixed(15)
#define kIconWidth KWidthFixed(36.f)

NSString *const OFPoolSettingCellReuseIdentifier = @"OFPoolSettingCellReuseIdentifier";

@implementation OFPoolSettingModel

@end

@interface OFPoolSettingCell ()<UITextFieldDelegate>
{
    OFPoolSettingModel *_model;
}
@property (nonatomic, strong) UITextField *nameTextField;

@end

@implementation OFPoolSettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:kMargin_Border trailingOffset:kMargin_Border];
    }
    return self;
}

- (void)setupUI
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Border);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(kMargin_Border);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
    }];
    
    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth * 0.5);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
    }];
    
    [self.arrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Border);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
}

- (void)updateLayout
{
    if (_model.type == OFPoolSettingCellTypeAnnounce) {
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).offset(kMargin_Border);
            make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Border);
        }];
    }else if(_model.type == OFPoolSettingCellTypeName){
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Border);
            make.centerY.mas_equalTo(self.contentView.mas_centerY);
        }];
    }
}

- (void)update:(OFPoolSettingModel *)model
{
    _model = model;
    self.titleLabel.text = model.title;
    [self.titleLabel sizeToFit];
    self.nameTextField.placeholder = model.placeHolder;
    self.nameTextField.keyboardType = model.keyboardType;
    if (model.type == OFPoolSettingCellTypeName) {
        self.nameTextField.hidden = NO;
        self.detailLabel.hidden = YES;
        self.nameTextField.text = model.detailTitle;
        self.arrorView.hidden = YES;
    }else if(_model.type == OFPoolSettingCellTypeAnnounce){
        self.nameTextField.hidden = YES;
        self.detailLabel.hidden = NO;
        self.arrorView.hidden = NO;
        
        if (model.detailTitle.length < 1) {
            self.detailLabel.text = model.placeHolder;
        }else {
            self.detailLabel.text = model.detailTitle;
        }
    }
    [self updateLayout];
}

+ (CGFloat)rowHeight:(OFPoolSettingModel *)model
{
    if (model.type == OFPoolSettingCellTypeAnnounce) {
        return 80.f;
    }
    return 60.f;
}

#pragma mark - Action
- (void)didEditNickName
{
    if (((!_model.checkText) || (_model.checkText && _model.checkText(self.nameTextField.text))) &&
        [self nickNameSpaceCheck] &&
        self.nameTextField.text.length>0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(settingCell:model:didEditNickname:)]) {
            [self.delegate settingCell:self model:_model didEditNickname:self.nameTextField.text];
        }
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self resignResponder];
    [self didEditNickName];
}

- (BOOL)nickNameSpaceCheck
{
    NSString *currentName = self.nameTextField.text;
    currentName = [currentName stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (currentName.length > 0) {
        return YES;
    }
    return NO;
}

- (void)textFieldChangeText
{
    _model.detailTitle = self.nameTextField.text;
}

- (void)becomeResponder
{
    [self.nameTextField becomeFirstResponder];
}

- (void)resignResponder
{
    [self.nameTextField resignFirstResponder];
}

- (UITextField *)nameTextField
{
    if (!_nameTextField) {
        _nameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
        _nameTextField.borderStyle = UITextBorderStyleNone;
        _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _nameTextField.returnKeyType = UIReturnKeyDone;
        _nameTextField.placeholder = @"请输入矿池名称";
        _nameTextField.textAlignment = NSTextAlignmentRight;
        _nameTextField.font = FixFont(14);
        _nameTextField.textColor = OF_COLOR_MINOR;
        _nameTextField.delegate = self;
        _nameTextField.rightView = nil;
        [_nameTextField addTarget:self action:@selector(resignResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
        [_nameTextField addTarget:self action:@selector(textFieldChangeText) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_nameTextField];
    }
    return _nameTextField;
}

@end
