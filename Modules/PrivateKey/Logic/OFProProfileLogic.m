//
//  OFProProfileLogic.m
//  OFBank
//
//  Created by michael on 2018/5/31.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProProfileLogic.h"
#import "OFProfileCell.h"
#import "OFProfileAPI.h"

@interface OFProProfileLogic ()
@property (nonatomic, strong) NSArray *dataArr;
@end

@implementation OFProProfileLogic


- (NSUInteger)numberOfSection
{
    return self.dataArr.count;
}

- (NSUInteger)itemCountOfSection:(NSUInteger)section
{
    NSArray *items = [self.dataArr objectAtIndex:section];
    return items.count;
}

- (id)itemAtIndex:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataArr.count) {
        NSArray *items = [self.dataArr objectAtIndex:indexPath.section];
        if (indexPath.row < items.count) {
            return [items objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

- (void)loadIfNeed
{
    
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        NSMutableArray *array = [NSMutableArray array];
        {
            OFProfileItem *item = [[OFProfileItem alloc] init];
            item.title = @"管理钱包";
            item.icon = @"profile_account_icon";
            item.type = ProfileCellTypeSingle;
//            [array addObject:@[item]];
            
            
            
            [array addObject:@[item]];
        }
        _dataArr = array.copy;
    }
    return _dataArr;
}

#pragma mark - 更新用户名
- (void) updateUserName:(NSString *)userName withBlock:(void (^)(bool suc, NSString *errorMessage))block{
    [OFProfileAPI updateUserName:userName finishBlock:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            block(success,messageStr);
        }else{
            block(success,messageStr);
        }
    }];
}

#pragma mark - 更新头像
- (void)updateUserAvatar:(NSData *)imageData withBlock:(void (^)(bool suc, NSString *avatarUrl, NSString *errorMessage))block{
    [OFProfileAPI updateUserAvatar:imageData finishBlock:^(BOOL success, NSString *avatarUrl, NSError *error, NSString *message) {
        if (success) {
            KcurUser.profileUrl = avatarUrl;
            [KUserManager saveUserInfo];
        }
        block(success, avatarUrl, message);
    }];
}

@end
