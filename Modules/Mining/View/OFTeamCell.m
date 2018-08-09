//
//  OFTeamCell.m
//  OFBank
//
//  Created by hukun on 2018/2/8.
//  Copyright © 2018年 hukun. All rights reserved.
//

#import "OFTeamCell.h"
#import "OFPoolModel.h"
#import "ProgressBtn.h"
@interface OFTeamCell ()

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) ProgressBtn *joinBtn;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) BOOL join;
@end

@implementation OFTeamCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
        [self layout];
        [self setup];
    }
    return self;
}

- (void)initUI{
    [self.contentView addSubview:self.iconView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.numberLabel];
    
    [self.contentView addSubview:self.joinBtn];
    [self.contentView addSubview:self.lineView];
}

- (void)layout{
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(8.5);
        make.top.mas_equalTo(self.iconView.mas_top).offset(-2);
    }];
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(8.5);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(8);
    }];
    
    [self.joinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.centerY.mas_equalTo(self.titleLabel);
        make.size.mas_equalTo(CGSizeMake([NUIUtil fixedWidth:40], [NUIUtil fixedHeight:20]));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
    }];
    
}

- (void)setup{
    self.titleLabel.text = @"OF VIP1";
    self.numberLabel.text = @"200人";
}

- (void)joinBtnClick{
    
    if (self.joinBtn.isProgress) {
        return;
    }
    
    [self.joinBtn startProgress];
    NSLog(@"点击了这里");
    WEAK_SELF;
    if (self.join) {
        // 已经加入了
        // 需要离开
        [OFNetWorkHandle leaveCommunitySuccess:^(NSDictionary *dict) {
            NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
//            NSLog(@"%@",dict);
            [weakSelf.joinBtn endProgress];
            if (status == 200) {
                [MBProgressHUD showSuccess:@"已经离开"];
                KcurUser.community = nil;
                weakSelf.join = NO;
                [KUserManager saveUserInfo];
            }else{
                NSString *errorStr = [NSString stringWithFormat:@"离开失败！ - %zd",status];
                [MBProgressHUD showError:errorStr];
            }
        } failure:^(NSError *error) {
            [weakSelf.joinBtn endProgress];
            NSString *errorStr = [NSString stringWithFormat:@"离开失败！ - %zd",error.code];
            [MBProgressHUD showError:errorStr];
        }];
    }else{
        // 加入
        [OFNetWorkHandle joinCommunityWithCid:self.model.cid success:^(NSDictionary *dict) {
//            NSLog(@"%@",dict);
            [weakSelf.joinBtn endProgress];
            NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
            if (status == 200) {
                [MBProgressHUD showSuccess:@"加入成功"];
                
                
                OFPoolModel *model = [OFPoolModel modelWithJSON:[NDataUtil dictWith:dict[@"data"]]];
                model.cid = weakSelf.model.cid;
                KcurUser.community = model;
                weakSelf.join = YES;
                [KUserManager saveUserInfo];
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(joinTeam:)]) {
                    [weakSelf.delegate joinTeam:weakSelf.model];
                }
                
            }else{
//                [MBProgressHUD showError:@"加入失败"];
                
                if (KcurUser.community) {
                    [MBProgressHUD showError:@"只能加入一个社群，请退出当前社群后再试"];
                }else{
                    NSString *string = [NSString stringWithFormat:@"网络异常,请稍后重试 code=%zd",status];
                    [MBProgressHUD showError:string];
                }
            }
        } failure:^(NSError *error) {
            [weakSelf.joinBtn endProgress];
            NSString *string = [NSString stringWithFormat:@"网络异常,请稍后重试 %zd",error.code];
            [MBProgressHUD showError:string];
        }];
        
    }
    
    
    
    
    
}

- (void)setModel:(OFPoolModel *)model{
    _model = model;
    
    self.titleLabel.text = [NDataUtil stringWith:model.name valid:@""];
    NSString *num = [NDataUtil stringWith:model.count valid:@"0"];
    self.numberLabel.text = [NSString stringWithFormat:@"%@节点",num];
    self.join = [model.cid isEqualToString:KcurUser.community.cid];
}


- (void)setJoin:(BOOL)join{
    if (_join == join) {
        return;
    }
    
    _join = join;
    if (join) {
        [self.joinBtn setTitle:@"离开" forState:UIControlStateNormal];
        self.joinBtn.layer.borderColor = [UIColor colorWithRGB:0x6b6c6d].CGColor;
        [self.joinBtn setTitleColor:[UIColor colorWithRGB:0x6b6c6d] forState:UIControlStateNormal];
    }else{
        [self.joinBtn setTitle:@"加入" forState:UIControlStateNormal];
        _joinBtn.layer.borderColor = OF_COLOR_MAIN_THEME.CGColor;
        [_joinBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
    }
}




#pragma mark - 懒加载
- (UIImageView *)iconView{
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"team_of"];
    }
    return _iconView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.font = [NUIUtil fixedFont:13];
        _titleLabel.textColor = [UIColor colorWithRGB:0x333333];
    }
    return _titleLabel;
}

- (UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc]init];
        _numberLabel.font = [NUIUtil fixedFont:10];
        _numberLabel.textColor = [UIColor colorWithRGB:0x7c7c7c];
    }
    return _numberLabel;
}

- (ProgressBtn *)joinBtn{
    if (!_joinBtn) {
        _joinBtn = [[ProgressBtn alloc]initWithStyle:UIActivityIndicatorViewStyleGray];
        [_joinBtn setTitle:@"加入" forState:UIControlStateNormal];
        [_joinBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        _joinBtn.titleLabel.font = [NUIUtil fixedFont:10];
        _joinBtn.layer.cornerRadius = 5.0;
        _joinBtn.layer.borderWidth = 1.0f;
        _joinBtn.layer.borderColor = OF_COLOR_MAIN_THEME.CGColor;
        WEAK_SELF;
        [_joinBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
        [_joinBtn n_clickBlock:^(id sender) {
            [weakSelf joinBtnClick];
        }];
    }
    return _joinBtn;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = Line_Color;
    }
    return _lineView;
}


@end
