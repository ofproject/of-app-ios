//
//  OFTeamHeadView.h
//  OFBank
//
//  Created by hukun on 2018/3/1.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProgressBtn.h"
@interface OFTeamHeadView : UIView

@property (nonatomic, strong) ProgressBtn *leaveBtn;

@property (nonatomic, copy) dispatch_block_t leaveBlock;

@property (nonatomic, copy) dispatch_block_t shareBlock;

- (void)setupInfo;

@end
