//
//  OFPersonalInfoCell.m
//  OFBank
//
//  Created by xiepengxiang on 12/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFPersonalInfoCell.h"

#define kMargin_Left KWidthFixed(15)
#define kAvatar_Width KWidthFixed(29)

CGFloat const kOFPersonalInfoCellHeight = 45.f;
NSString *const kOFPersonalInfoCellIdentifier =@"kOFPersonalInfoCellIdentifier";

@implementation OFPersonalInfoItem

@end

@interface OFPersonalInfoCell ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField *nameTextField;

@end

@implementation OFPersonalInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.iconImage.layer.cornerRadius = kAvatar_Width * 0.5;
        self.titleLabel.font = FixFont(16);
        self.titleLabel.textColor = OF_COLOR_DETAILTITLE;
        self.backgroundColor = OF_COLOR_WHITE;
        [self showSeperatorLineForTop:SeperatorHidden bottom:SeperatorWidthEqualToView leadingOffset:kMargin_Left trailingOffset:kMargin_Left];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(kMargin_Left);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kAvatar_Width);
        make.height.mas_equalTo(kAvatar_Width);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Left);
    }];

    [self.nameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(KWidthFixed(130));
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-kMargin_Left);
    }];
}

- (void)setItem:(OFPersonalInfoItem *)item
{
    if (item.type == PersonalInfoCellAvatar) {
        self.nameTextField.hidden = YES;
        self.iconImage.hidden = NO;
        [self.iconImage sd_setImageWithURL:[NSURL URLWithString:item.avatarUrl]
                          placeholderImage: [UIImage imageNamed:@"mining_miner_icon"]];
    }else if(item.type == PersonalInfoCellName) {
        self.iconImage.hidden = YES;
        self.nameTextField.hidden = NO;
        self.nameTextField.text = item.detailTitle;
    }
    self.titleLabel.text = item.title;
}

#pragma mark - Action
- (void)didEditNickName
{
    if (![self.nameTextField.text isEqualToString:KcurUser.userName] &&
        [self nickNameSpaceCheck] &&
        self.nameTextField.text.length>0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(infoCell:didEditNickname:)]) {
            [self.delegate infoCell:self didEditNickname:self.nameTextField.text];
        }
    }else{
        self.nameTextField.text = KcurUser.userName;
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
    NSString *currentString = self.nameTextField.text;
    if (currentString.length > 10) {
        [MBProgressHUD showError:@"昵称最长10个字符"];
        self.nameTextField.text = [currentString substringToIndex:10];
    }
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
        _nameTextField.placeholder = @"请输入昵称";
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
