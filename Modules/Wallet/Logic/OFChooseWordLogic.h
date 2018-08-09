//
//  OFChooseWordLogic.h
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseLogic.h"

@protocol OFChooseWordLogicDelegate <BaseLogicDelegate>

- (void)updateChosenWords;

@end

@interface OFChooseWordLogic : OFBaseLogic

- (instancetype)initWithDelegate:(id)delegate words:(NSArray *)words;

- (NSArray *)getShowWords;
- (NSArray *)getChosenWords;

- (void)chooseWord:(NSString *)word;
- (void)cancleChooseWord:(NSString *)word;

@end
