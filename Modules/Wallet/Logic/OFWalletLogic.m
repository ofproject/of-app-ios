//
//  OFWalletLogic.m
//  OFBank
//
//  Created by 谢鹏翔 on 2018/3/29.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFWalletLogic.h"
#import "OFWalletAPI.h"
#import "NWebService.h"
#import "NSDate+Additions.h"

@interface OFWalletLogic ()

@property (nonatomic, strong) NSArray *strArray;
@property (nonatomic, strong) NSDate *getBalanceDate;

@end

@implementation OFWalletLogic

#pragma mark - TableView
- (NSUInteger)numberOfSection
{
    return 1;
}

- (NSUInteger)itemCountOfSection:(NSUInteger)section
{
    return KcurUser.wallets.count;
}

- (id)itemAtIndex:(NSIndexPath *)indexPath
{
    OFWalletModel *model = [NDataUtil classWithArray:[OFWalletModel class] array:KcurUser.wallets index:indexPath.row];
    return model;
}

- (void)loadIfNeed
{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(requestDataSuccess)])
    {
        [self.delegate requestDataSuccess];
    }
}

- (void)requestFailure:(NSString *)errMessage
{
    if(self.delegate &&[self.delegate respondsToSelector:@selector(requestDataFailure:)])
    {
        [self.delegate requestDataFailure:errMessage];
    }
}

#pragma mark - Titles

- (NSString *)tipTitle
{
    int index = arc4random() % self.strArray.count;
    NSString *title = [NDataUtil stringWithArray:self.strArray index:index];
    return [NSString stringWithFormat:@"%@",title];
}

- (NSString *)totalMoney{
    CGFloat balance = 0.0;
    for (OFWalletModel *model in KcurUser.wallets) {
        balance += [model.balance doubleValue];
    }
    return [self transfer:[NSString stringWithFormat:@"%.3f",balance]];
}

#pragma mark - Balance
- (void)getBalance{
    WEAK_SELF;
    NSMutableArray *array = [NSMutableArray array];
    
    for (OFWalletModel *model in KcurUser.wallets) {
        
        [array addObject:[model.address copy]];
    }
    
    if (self.getBalanceDate) {
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:self.getBalanceDate];
        
        if (time < 10.0) {
            NSLog(@"多次请求 %f",time);
            [self requestFailure:@"多次请求"];
            return;
        }else{
            self.getBalanceDate = nil;
        }
    }
    
    NSLog(@"开始请求。。。");
    [OFWalletAPI getBalanceInfoWithAddress:array finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
        if (success) {
            [weakSelf loadIfNeed];
            weakSelf.getBalanceDate = [NSDate date];
        }
        [weakSelf requestFailure:errorMessage];
    }];
}

- (void)forceGetBalance {
    self.getBalanceDate = nil;
    [self getBalance];
}

- (void)getTokenBalance{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (OFWalletModel *model in KcurUser.wallets) {
        
        [array addObject:[model.address copy]];
    }
    
    [OFNetWorkHandle getTokenBalanceInfoWithAddress:array success:^(NSDictionary *dict) {
        NSLog(@"%@",dict);
//        [self endRefreshCallback];
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
//        [self endRefreshCallback];
    }];
}

#pragma mark - ActivityStatus
- (void)getActivityStatus{
    [[NWebService sharedInstance] getInternetDateSuccess:^(NSDate *date) {
        NSString *date1 = @"2018-03-12 00:00:00";
        NSString *date2 = @"2018-03-19 00:00:00";
        BOOL success = [date validateWithStartTime:date1 withExpireTime:date2];
        //        KcurUser.showActivity = success;
        if (success) {
            NSLog(@"在范围内");
            if ([NSThread isMainThread]) {
                //                [[OFActivityViewModel sharedInstance] showActivityView];
            }else{
                NSLog(@"不是主线程");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //                    [[OFActivityViewModel sharedInstance] showActivityView];
                });
            }
        }else{
            NSLog(@"不在范围内");
        }
    }];
}

#pragma mark - private method
- (NSString *)transfer:(NSString *)string{
    
    if ([string doubleValue] < 1000) {
        return [NSString stringWithFormat:@"%.3f",[string doubleValue]];
    }
    
    NSString *money = [NSString stringWithFormat:@"%.3f",[string doubleValue]];
    
    NSArray *array =  [money componentsSeparatedByString:@"."];
    
    NSMutableString *mutableStr = [NSMutableString string];
    [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (obj.length > 3) {
            // 对obj进行加,号
            
            NSInteger count = obj.length / 3;
            NSInteger count2 = obj.length % 3;
            if (count2 != 0) {
                count ++;
            }
            for (int i = 0; i < count; i++) {
                if (i == count - 1) {
                    // 最后一个不加
                    NSString *tempStr = [obj substringWithRange:NSMakeRange(0, obj.length - 3 * i)];
                    [mutableStr insertString:tempStr atIndex:0];
                }else{
                    NSString *tempStr = [NSString stringWithFormat:@",%@",[obj substringWithRange:NSMakeRange(obj.length - 3 * (i + 1), 3)]];
                    
                    [mutableStr insertString:tempStr atIndex:0];
                }
            }
        }
    }];
    
    NSString *str = [NDataUtil stringWithArray:array index:1];
    if (str.length > 1) {
        [mutableStr appendFormat:@".%@",str];
    }
    return [mutableStr copy];
}

- (NSArray *)strArray{
    if (!_strArray) {
        NSString *pathStr = [[NSBundle mainBundle] pathForResource:@"localData" ofType:@"plist"];
        _strArray = [NSArray arrayWithContentsOfFile:pathStr];
    }
    return _strArray;
}

@end
