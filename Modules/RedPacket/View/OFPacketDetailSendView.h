//
//  OFPacketDetailSendView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/13.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFPacketDetailSendView;
@protocol PacketDetailSendViewDelegate <NSObject>

- (void)packetDetailSendViewDidClick:(OFPacketDetailSendView *)sendView;

@end

@interface OFPacketDetailSendView : UIView

@property (nonatomic, weak) id<PacketDetailSendViewDelegate> delegate;

@end
