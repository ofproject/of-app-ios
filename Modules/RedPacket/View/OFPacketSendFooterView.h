//
//  OFPacketSendFooterView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFPacketSendFooterView;
@protocol OFPacketSendFooterViewDelegate <NSObject>

- (void)packetSendFooterDidSelectedSend:(OFPacketSendFooterView *)footer;

@end

@interface OFPacketSendFooterView : UIView

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, weak) id<OFPacketSendFooterViewDelegate> delegate;

@end
