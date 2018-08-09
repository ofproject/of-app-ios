//
//  OFRipplesLayer.m
//  OFBank
//
//  Created by 胡堃 on 2018/2/2.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRipplesLayer.h"

@interface OFRipplesLayer ()

/**
 涟漪圈
 */
@property (nonatomic, strong) CALayer *roundLayer;

/**
 动画组
 */
@property (nonatomic, strong) CAAnimationGroup *ripplesAnimationGroup;

/**
 初始半径
 */
@property (nonatomic, assign) CGFloat fromValueForRadius;

/**
 涟漪圈alpha初始值
 */
@property (nonatomic, assign) CGFloat fromValueForAlpha;

@end

@implementation OFRipplesLayer


- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.roundLayer];
        [self setup];
    }
    return self;
}

- (void)setup{
    
    self.roundLayer.backgroundColor = [UIColor colorWithRGB:0x1ad19f].CGColor;
    
    self.radius = 60;
    self.animationDuration = 3.0;
    self.fromValueForRadius = 0.0f;
    self.fromValueForAlpha = 0.0f;
    
    self.repeatCount = HUGE;
    
    self.instanceCount = 3;
    self.instanceDelay = 1;
}


- (void)startAnimation{
    [self setupAnimation];
    [self.roundLayer addAnimation:self.ripplesAnimationGroup forKey:@"ripples"];
}

- (void)setupAnimation{
    
    self.ripplesAnimationGroup.duration = self.animationDuration;
    self.ripplesAnimationGroup.repeatCount = self.repeatCount;
    
    self.ripplesAnimationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.xy"];
    
    scaleAnimation.fromValue = @(self.fromValueForRadius);
    scaleAnimation.toValue = @1.1;
    scaleAnimation.duration = self.animationDuration;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    
    opacityAnimation.values = @[@(0.5),@0.2,@0];
    opacityAnimation.keyTimes = @[@0,@0.5,@1];
    opacityAnimation.duration = self.animationDuration;
    
    self.ripplesAnimationGroup.animations = @[scaleAnimation,opacityAnimation];
    
    self.ripplesAnimationGroup.removedOnCompletion = NO;
    
}


- (void)setRadius:(CGFloat)radius{
    _radius = radius;
    
    CGFloat roundW = radius + 15.0;
    self.roundLayer.bounds = CGRectMake(0, 0, roundW, roundW);
    self.roundLayer.cornerRadius = roundW/2;
    self.fromValueForRadius = radius / roundW;
}

- (CALayer *)roundLayer{
    if (!_roundLayer) {
        _roundLayer = [[CALayer alloc]init];
        _roundLayer.contentsScale = [UIScreen mainScreen].scale;
        _roundLayer.opacity = 0;
    }
    return _roundLayer;
}

- (CAAnimationGroup *)ripplesAnimationGroup{
    if (!_ripplesAnimationGroup) {
        _ripplesAnimationGroup = [CAAnimationGroup animation];
    }
    return _ripplesAnimationGroup;
}

@end
