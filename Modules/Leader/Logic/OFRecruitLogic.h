//
//  OFRecruitLogic.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"
#import "OFTableViewProtocol.h"

@class OFPoolModel;
@class OFRecruitHeaderViewModel;
@interface OFRecruitLogic : OFBaseLogic <OFTableViewProtocol>

@property (nonatomic, assign) BOOL alreadyManager;

- (void)getFristScreen;

- (OFRecruitHeaderViewModel *)headerInfo;
- (NSString *)applyProtocolUrl;
- (OFPoolModel *)finishPool;

- (void)updatePoolLogo:(NSData *)logoData;
- (void)launchPoolWithWalletAddress:(NSString *)walletAddress passphare:(NSString *)passphare;
- (BOOL)checkDataFormat;
- (BOOL)checkApplyProtocolStatus:(BOOL)status;

@end
