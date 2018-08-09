//
//  OFRipplesLayer.h
//  OFBank
//
//  Created by 胡堃 on 2018/2/2.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface OFRipplesLayer : CAReplicatorLayer

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign) NSTimeInterval animationDuration;


- (void)startAnimation;

@end
