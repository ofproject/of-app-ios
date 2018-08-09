//
//  OFMiningAnimationIconView.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/27.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFMiningAnimationIconView.h"

@interface OFMiningAnimationIconView()

@property (nonatomic, strong) UIImageView *icon;
@end

@implementation OFMiningAnimationIconView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, KWidthFixed(34), KWidthFixed(34));
    }
    return self;
}

-(void)showMiningIconToView:(UIView *)view WithPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    [self addSubview:self.icon];
    [view addSubview:self];
    
    self.left = startPoint.x - 10;
    self.top = startPoint.y;
    self.alpha = 0;
    self.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.alpha = 1;
        self.left = startPoint.x;
    } completion:^(BOOL finished) {
            [UIView animateWithDuration:2.5 animations:^{
                self.center = endPoint;
                self.alpha = 0.7;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.alpha = 0;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }];
    }];
    
    
    
}

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_icon setImage:IMAGE_NAMED(@"mining_icon")];
    }
    return _icon;
}

-(void)dealloc{
    
}
@end
