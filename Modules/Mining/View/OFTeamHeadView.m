//
//  OFTeamHeadView.m
//  OFBank
//
//  Created by hukun on 2018/3/1.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFTeamHeadView.h"
#import "OFPoolModel.h"



@interface OFTeamHeadView ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *teamLabel;

@property (nonatomic, strong) UILabel *creatTimeLabel;

@property (nonatomic, strong) UILabel *personLabel;

@property (nonatomic, strong) UILabel *numLabel;

@property (nonatomic, strong) UILabel *codeLabel;



@property (nonatomic, strong) UIButton *shareBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *bottomLineView;

/**
 矿池基金
 */
@property (nonatomic, strong) UILabel *rewardLabel;

@property (nonatomic, assign) BOOL layouted;

@end

@implementation OFTeamHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

        [self initUI];
//        [self setupInfo];
        self.lineView.mas_key = @"横线";
        self.mas_key = @"顶部视图";
        
        self.shareBtn.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self layout];
}

- (void)initUI{
    [self addSubview:self.iconView];
    [self addSubview:self.codeLabel];
    [self addSubview:self.titleLabel];
    [self addSubview:self.creatTimeLabel];
    [self addSubview:self.teamLabel];
    [self addSubview:self.personLabel];
    [self addSubview:self.shareBtn];
    [self addSubview:self.lineView];
    [self addSubview:self.numLabel];
    [self addSubview:self.leaveBtn];
    [self addSubview:self.rewardLabel];
    
    [self addSubview:self.bottomLineView];
}

- (void)layout{
    if (self.layouted) {
        return;
    }
    NSLog(@"布局");
    
    self.layouted = YES;
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.iconView.mas_top);
        make.left.mas_equalTo(self.iconView.mas_right).offset(8.5);
    }];
    
    [self.creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(2);
        make.centerY.mas_equalTo(self.titleLabel.mas_centerY);
    }];
    
    [self.teamLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(8.5);
        make.bottom.mas_equalTo(self.iconView.mas_bottom);
    }];
    
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teamLabel.mas_right).offset(5);
        make.bottom.mas_equalTo(self.teamLabel.mas_bottom);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.iconView.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(15);
        make.right.mas_equalTo(self.mas_right).offset(-15);
        make.height.mas_equalTo(0.5);
        make.top.mas_equalTo(self.iconView.mas_bottom).offset(15);
    }];
    
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.teamLabel.mas_left);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.rewardLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.personLabel.mas_left);
        make.centerY.mas_equalTo(self.numLabel.mas_centerY);
        
    }];
    
    [self.leaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.numLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake([NUIUtil fixedWidth:40], [NUIUtil fixedHeight:20]));
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.iconView.mas_centerX);
        make.centerY.mas_equalTo(self.numLabel.mas_centerY);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.top.mas_equalTo(self.numLabel.mas_bottom);
    }];
    
}

- (void)setupInfo{
    
    OFPoolModel *model = KcurUser.community;
    
    
    self.titleLabel.text = model.name;
    self.creatTimeLabel.text = @"创建时间 02-26-2018";
    NSString *time = [NDataUtil stringWith:model.createTime valid:@"--"];
    self.creatTimeLabel.text = [NSString stringWithFormat:@"创建时间 %@",time];
    
    
//    self.creatTimeLabel.text =
//    self.titleLabel.text = [NDataUtil stringWith:model.Name valid:@""];
    NSString *num = [NDataUtil stringWith:model.count valid:@"0"];
    
    
    self.numLabel.attributedText = [ToolObject toString:@"矿池节点 " prefixColor:[UIColor colorWithRGB:0x7c7c7c] suffix:num suffixColor:OF_COLOR_MAIN_THEME];
    self.teamLabel.attributedText = [ToolObject toString:@"矿池总收益排名 " prefixColor:[UIColor colorWithRGB:0x7c7c7c] suffix:@"--" suffixColor:OF_COLOR_MAIN_THEME];
    
    self.personLabel.attributedText = [ToolObject toString:@"个人贡献排名 " prefixColor:[UIColor colorWithRGB:0x7c7c7c] suffix:@"--" suffixColor:OF_COLOR_MAIN_THEME];
    self.codeLabel.text = [NSString stringWithFormat:@"ID:%05zd",[model.cid integerValue]];
    
    CGFloat rewardValue = [NDataUtil floatWith:model.reward valid:0.0];
    NSString *reward = [NSString stringWithFormat:@"%.3f",rewardValue];
    self.rewardLabel.attributedText = [ToolObject toString:@"矿池基金 " prefixColor:[UIColor colorWithRGB:0x7c7c7c] suffix:reward suffixColor:OF_COLOR_MAIN_THEME];
    
}

- (void)leaveBtnClick{
    // 退出
    if (self.leaveBlock) {
        self.leaveBlock();
    }
}
- (void)sharedBtnClick{
    // 分享
    if (self.shareBlock) {
        self.shareBlock();
    }
}
#pragma mark - 懒加载
- (UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_shareBtn setImage:[UIImage imageNamed:@"wallet_shared_btn"] forState:UIControlStateNormal];
        
        [_shareBtn setTintColor:OF_COLOR_MAIN_THEME];
        
        [_shareBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
        WEAK_SELF;
        [_shareBtn n_clickBlock:^(id sender) {
            [weakSelf sharedBtnClick];
        }];
    }
    return _shareBtn;
}

- (ProgressBtn *)leaveBtn{
    if (!_leaveBtn) {
//        _leaveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _leaveBtn = [[ProgressBtn alloc]initWithStyle:UIActivityIndicatorViewStyleGray];
        
        [_leaveBtn setTitle:@"离开" forState:UIControlStateNormal];
        [_leaveBtn setTitleColor:[UIColor colorWithRGB:0x6b6c6d] forState:UIControlStateNormal];
        
        _leaveBtn.titleLabel.font = [NUIUtil fixedFont:10];
        _leaveBtn.layer.cornerRadius = 5.0;
        _leaveBtn.layer.borderWidth = 1.0f;
        _leaveBtn.layer.borderColor = [UIColor colorWithRGB:0x6b6c6d].CGColor;
        
        WEAK_SELF;
        [_leaveBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
        [_leaveBtn n_clickBlock:^(id sender) {
            [weakSelf leaveBtnClick];
        }];
    }
    return _leaveBtn;
}



- (UILabel *)teamLabel{
    if (!_teamLabel) {
        _teamLabel = [[UILabel alloc]init];
        _teamLabel.font = [NUIUtil fixedFont:10];
        _teamLabel.textColor = [UIColor colorWithRGB:0x7c7c7c];
        
        [_teamLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_teamLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    }
    return _teamLabel;
}

- (UILabel *)personLabel{
    if (!_personLabel) {
        _personLabel = [[UILabel alloc]init];
        _personLabel.font = [NUIUtil fixedFont:10];
        _personLabel.textColor = [UIColor colorWithRGB:0x7c7c7c];
    }
    return _personLabel;
}

- (UILabel *)numLabel{
    if (!_numLabel) {
        _numLabel = [[UILabel alloc]init];
        _numLabel.font = [NUIUtil fixedFont:10];
        _numLabel.textColor = [UIColor colorWithRGB:0x7c7c7c];
    }
    return _numLabel;
}

- (UILabel *)creatTimeLabel{
    if (!_creatTimeLabel) {
        _creatTimeLabel = [[UILabel alloc]init];
        _creatTimeLabel.font = [NUIUtil fixedFont:9];
        _creatTimeLabel.textColor = [UIColor colorWithRGB:0x999999];
    }
    return _creatTimeLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = Title_Color;
        _titleLabel.font = [NUIUtil fixedFont:13];
        
        [_titleLabel setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        
    }
    return _titleLabel;
}

- (UILabel *)codeLabel{
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc]init];
        _codeLabel.font = [NUIUtil fixedFont:10];
        _codeLabel.textColor = OF_COLOR_MAIN_THEME;
        _codeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _codeLabel;
}

- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"team_of"];
    }
    return _iconView;
}

- (UILabel *)rewardLabel{
    if (!_rewardLabel) {
        _rewardLabel = [[UILabel alloc]init];
        _rewardLabel.textColor = Title_Color;
        _rewardLabel.font = [NUIUtil fixedFont:13];
    }
    return _rewardLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Line_Color;
    }
    return _lineView;
}

- (UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc]init];
        _bottomLineView.backgroundColor = BackGround_Color;
    }
    return _bottomLineView;
}


@end
