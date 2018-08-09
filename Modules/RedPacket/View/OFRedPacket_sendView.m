//
//  OFRedPacket_sendView.m
//  OFBank
//
//  Created by Xu Yang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRedPacket_sendView.h"

@interface OFRedPacket_sendView()

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;
@property (nonatomic, copy) dispatch_block_t block;
@property (nonatomic, copy) dispatch_block_t closeCallback;

@end

@implementation OFRedPacket_sendView

-(void)awakeFromNib{
    [super awakeFromNib];

    self.titleLabel.font = FixBoldFont(22);
    self.contentLabel.font = FixFont(15);
    self.tipsLabel.font = FixFont(11);
}

-(void)showRedPackedSendView:(UIView *)toView withTiltle:(NSString *)titleStr WithContentStr:(NSString *)contentStr WithBlock:(dispatch_block_t)block withCloseCallback:(dispatch_block_t)closeCallback{
    
    self.block = block;
    self.closeCallback = closeCallback;
    
    self.titleLabel.text = titleStr;
    self.contentLabel.text = contentStr;
    
    
    //    self.contentLabel.text = shareModel.descript;
    
    //动画入场 姿势要帅一点，不能像安卓那么Low
    _alertView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    _alertView.alpha = 0.8;
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:15 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _alertView.transform = CGAffineTransformIdentity;
        _alertView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
    if (toView) {
        [toView addSubview:self];
    }else{
        [[JumpUtil currentVC].view addSubview:self];
    }
}

#pragma mark - 发红包按钮 调用分享
- (IBAction)sendRedPacketAction:(id)sender {
    if (self.block) {
        self.block();
    }
}

#pragma mark - 关闭按钮事件
- (IBAction)closeAction:(id)sender {
    [self close];
    if (self.closeCallback) {
        self.closeCallback();
    }
}

#pragma mark -  关闭
-(void)close{
    [self removeFromSuperview];
}


@end
