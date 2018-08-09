//
//  OFWalletNewCell.m
//  OFBank
//
//  Created by hukun on 2018/2/27.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFWalletNewCell.h"
#import "OFWalletModel.h"
#import "OFGetMoneyVC.h"
#import "OFTransferVC.h"

#define BtnHeight 40

@interface OFWalletNewCell ()


@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *moneyLabel;


/**
 卡片视图
 */
@property (nonatomic, strong) UIView *cardView;

@property (nonatomic, strong) UIView *cardBackView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *bottomView;




/**
 分割线
 */
@property (nonatomic, strong) CALayer *line1Layer;
@property (nonatomic, strong) CALayer *line2Layer;
@property (nonatomic, strong) CALayer *line3Layer;

/**
 余额提示
 */
@property (nonatomic, strong) UILabel *tipLabel1;

@property (nonatomic, strong) UIButton *turnOutBtn;

@property (nonatomic, strong) UIButton *turnInBtn;

@property (nonatomic, strong) UIImageView *moreView;

@property (nonatomic, assign) BOOL isAnimation;

@end

@implementation OFWalletNewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor whiteColor];
        [self initUI];
//        [self layout];
        // 删格化
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.drawsAsynchronously = YES;
        
    }
    return self;
    
}

- (void)initUI{
    
    [self.contentView addSubview:self.cardBackView];
    
    [self.cardBackView addSubview:self.cardView];
    
    
//    [self.cardView addSubview:self.bottomView];
    [self.cardView addSubview:self.topView];
    
    [self.topView addSubview:self.iconView];
    [self.topView addSubview:self.titleLabel];
    [self.topView addSubview:self.addressLabel];
//    [self.topView addSubview:self.moreView];
    [self.topView addSubview:self.moneyLabel];
    
//    [self.bottomView addSubview:self.tipLabel1];
//    [self.bottomView addSubview:self.moneyLabel];
//    [self.bottomView addSubview:self.turnOutBtn];
//    [self.bottomView addSubview:self.turnInBtn];
//
//    [self.bottomView.layer addSublayer:self.line1Layer];
//    [self.bottomView.layer addSublayer:self.line2Layer];
//    [self.bottomView.layer addSublayer:self.line3Layer];
    
    
    
}

- (void)layout{
    
    
    self.cardView.width = kScreenWidth - 30;
    self.cardView.left = 0;
    self.cardView.top = 0;
    
    self.cardBackView.left = 15;
    self.cardBackView.top = 5;
    
    // 顶部视图
    self.topView.width = kScreenWidth - 30;
    self.topView.height = 55;
    
    [self.iconView sizeToFit];
    self.iconView.centerY = self.topView.centerY;
    self.iconView.left = 15;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.top = self.iconView.top;
    self.titleLabel.left = self.iconView.right + 15;
    
    [self.addressLabel sizeToFit];
    self.addressLabel.width = [NUIUtil fixedWidth:170];
    self.addressLabel.bottom = self.iconView.bottom;
    self.addressLabel.left = self.iconView.right + 15;
    
//    [self.moreView sizeToFit];
//    _moreView.centerY = self.topView.centerY;
//    _moreView.left = self.topView.width - 15 - _moreView.width;
    
    [self.moneyLabel sizeToFit];
    _moneyLabel.centerY = self.topView.centerY;
    _moneyLabel.left = self.topView.width - 15 - _moneyLabel.width;
    
    /*
    self.bottomView.height = (BtnHeight * 2 + 1);
    
    self.bottomView.top = self.showInfo ? (self.topView.bottom) : (self.topView.height - self.bottomView.height);
    
    self.bottomView.width = self.cardView.width;
    self.line1Layer.width = self.bottomView.width;
    self.line2Layer.width = self.bottomView.width;
    self.line1Layer.height = 0.5;
    self.line2Layer.height = 0.5;
    self.line1Layer.top = 0;
    self.line1Layer.left = 0;
    self.line2Layer.left = 0;
    
    self.line3Layer.width = 0.5;
    self.line3Layer.centerX = self.bottomView.centerX;
    
    self.line2Layer.top = BtnHeight + 1;
    
    [self.tipLabel1 sizeToFit];
    self.tipLabel1.left = 15;
    self.tipLabel1.height = BtnHeight;
    
    [self.moneyLabel sizeToFit];
    self.moneyLabel.height = BtnHeight;
    self.moneyLabel.left = self.cardView.width - self.moneyLabel.width - 15;
    
    self.turnOutBtn.size = CGSizeMake(self.bottomView.width / 2.0, 0);
    self.turnInBtn.size = CGSizeMake(self.bottomView.width / 2.0, 0);
    
    self.turnOutBtn.height = BtnHeight;
    self.turnInBtn.height = BtnHeight;
    
    self.turnOutBtn.left = 0;
    self.turnInBtn.left = self.turnOutBtn.width;
    
    self.turnOutBtn.top = self.line2Layer.bottom;
    self.turnInBtn.top = self.line2Layer.bottom;
    
    
    self.line3Layer.height = BtnHeight;
    
    self.line3Layer.top = self.line2Layer.bottom;
    */
    self.cardView.height = self.showInfo ? (55 + BtnHeight + BtnHeight) : 55;
    [self.cardBackView sizeToFit];
    self.cardBackView.size = self.cardView.size;
    
}




- (void)layoutSubviews{
    [super layoutSubviews];
//    NSLog(@"%s",__func__);
    self.topView.backgroundColor = [UIColor whiteColor];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    if (self.isAnimation) {
        return;
    }
    [self layout];
}


- (void)setModel:(OFWalletModel *)model{
    _model = model;
    
    self.titleLabel.text = [NDataUtil stringWith:model.name valid:@"OF"];
    
    self.addressLabel.text = [NDataUtil stringWith:model.address valid:@"--"];
    
    NSString *money = [NDataUtil stringWith:model.balance valid:@"0.00"];
    
    CGFloat moneyNum = [money doubleValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.3f",moneyNum];
    
}

- (void)setimageName:(NSInteger)row{
    
    if (row < 1 || row > 5) {
        row = 1;
    }
    
    NSString *imageName = [NSString stringWithFormat:@"wallet_item_logo%zd",row];
    
    self.iconView.image = [UIImage imageNamed:imageName];
}


- (void)beginAnimation:(BOOL)showInfo{
    
    self.isAnimation = YES;
    self.showInfo = showInfo;
    NSLog(@"动画开始");
    [UIView animateWithDuration:0.35 animations:^{
        self.bottomView.top = self.showInfo ? (self.topView.bottom) : (self.topView.height - self.bottomView.height);
        self.cardView.height = self.showInfo ? (55 + BtnHeight + BtnHeight) : 55;
        self.cardBackView.height = self.cardView.height;
        self.moreView.transform = self.showInfo ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        NSLog(@"动画完成");
        self.isAnimation = NO;
    }];
}


#pragma mark - 按钮点击事件
- (void)turnOutBtnClick{
    // 转出
    OFTransferVC *vc = [[OFTransferVC alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}

- (void)turnInBtnClick{
    // 转入
    OFGetMoneyVC *vc = [[OFGetMoneyVC alloc]init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 懒加载
- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [UIImageView new];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        _iconView.image = [UIImage imageNamed:@"wallet_item_logo1"];
        _iconView.layer.cornerRadius = 5;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [NUIUtil fixedFont:15];
        _titleLabel.textColor = Title_Color;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.text = @"OF";
    }
    return _titleLabel;
}

- (UILabel *)addressLabel {
    if (!_addressLabel) {
        _addressLabel = [UILabel new];
        _addressLabel.font = [NUIUtil fixedFont:12];
        _addressLabel.textColor = [UIColor colorWithRGB:0x999999];
        _addressLabel.backgroundColor = [UIColor clearColor];
        _addressLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        _addressLabel.preferredMaxLayoutWidth = [NUIUtil fixedWidth:200];
    }
    return _addressLabel;
}

- (UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [UILabel new];
        _moneyLabel.font = [UIFont systemFontOfPx:17];
        _moneyLabel.textColor = Orange_New_Color;
        _moneyLabel.backgroundColor = [UIColor clearColor];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
        _moneyLabel.text = @"0.00";
    }
    return _moneyLabel;
}

- (UIView *)cardView{
    if (!_cardView) {
        _cardView = [[UIView alloc]init];
        _cardView.backgroundColor = [UIColor whiteColor];
        _cardView.layer.cornerRadius = 5;
        _cardView.layer.masksToBounds = YES;
    }
    return _cardView;
}


- (UIView *)cardBackView{
    if (!_cardBackView) {
        _cardBackView = [[UIView alloc]init];
        _cardBackView.backgroundColor = [UIColor whiteColor];
        _cardBackView.layer.shadowOpacity = 0.5;
        _cardBackView.layer.shadowRadius = 5.0;
        _cardBackView.layer.shadowOffset = CGSizeMake(0.2, 1.0);
        _cardBackView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    }
    return _cardBackView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (CALayer *)line1Layer{
    if (!_line1Layer) {
        _line1Layer = [CALayer layer];
        _line1Layer.backgroundColor = Line_Color.CGColor;
    }
    return _line1Layer;
}

- (CALayer *)line2Layer{
    if (!_line2Layer) {
        _line2Layer = [CALayer layer];
        _line2Layer.backgroundColor = Line_Color.CGColor;
    }
    return _line2Layer;
}

- (CALayer *)line3Layer{
    if (!_line3Layer) {
        _line3Layer = [CALayer layer];
        _line3Layer.backgroundColor = Line_Color.CGColor;
    }
    return _line3Layer;
}

- (UILabel *)tipLabel1{
    if (!_tipLabel1) {
        _tipLabel1 = [[UILabel alloc]init];
        _tipLabel1.text = @"余额";
        _tipLabel1.font = [NUIUtil fixedFont:14];
        _tipLabel1.textColor = Title_Color;
    }
    return _tipLabel1;
}

- (UIButton *)turnOutBtn{
    if (!_turnOutBtn) {
        _turnOutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_turnOutBtn setTitle:@"转账" forState:UIControlStateNormal];
        [_turnOutBtn setBackgroundColor:[UIColor whiteColor]];
        [_turnOutBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        
        _turnOutBtn.titleLabel.font = [NUIUtil fixedFont:15];
        
        [_turnOutBtn setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateSelected];
        
        WEAK_SELF;
        [_turnOutBtn n_clickBlock:^(id sender) {
            [weakSelf turnOutBtnClick];
        }];
        [_turnOutBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
    }
    return _turnOutBtn;
}

- (UIButton *)turnInBtn{
    if (!_turnInBtn) {
        _turnInBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_turnInBtn setTitle:@"收款" forState:UIControlStateNormal];
        [_turnInBtn setBackgroundColor:[UIColor whiteColor]];
        [_turnInBtn setTitleColor:OF_COLOR_MAIN_THEME forState:UIControlStateNormal];
        [_turnInBtn setTitleColor:[UIColor colorWithRGB:0x666666] forState:UIControlStateSelected];
        
        
        _turnInBtn.titleLabel.font = [NUIUtil fixedFont:15];
        WEAK_SELF;
        [_turnInBtn n_clickBlock:^(id sender) {
            [weakSelf turnInBtnClick];
        }];
        [_turnInBtn n_clickEdgeWithTop:5 bottom:5 left:5 right:5];
    }
    return _turnInBtn;
}

- (UIImageView *)moreView{
    if (!_moreView) {
        _moreView = [[UIImageView alloc]init];
        _moreView.image = [UIImage imageNamed:@"arrow_down_icon"];
    }
    return _moreView;
}


@end
