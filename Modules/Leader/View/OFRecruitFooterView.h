//
//  OFRecruitFooterView.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFPoolModel;
@class OFRecruitFooterView;
@protocol OFRecruitFooterViewDelegate <NSObject>

- (void)footerViewDidClickProtocol:(OFRecruitFooterView *)footerView;
- (void)footerViewDidLanuchPool:(OFRecruitFooterView *)footerView;
- (void)footerViewDidSharePool:(OFRecruitFooterView *)footerView;

@end

@interface OFRecruitFooterView : UIView

@property (nonatomic, weak) id<OFRecruitFooterViewDelegate> delegate;

- (void)updateInfo:(OFPoolModel *)pool;

- (BOOL)seeAboutProtocolAgreeStatus;

@end
