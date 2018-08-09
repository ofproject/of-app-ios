//
//  OFPersonalInfoLogic.m
//  OFBank
//
//  Created by xiepengxiang on 12/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFPersonalInfoLogic.h"
#import "OFPersonalInfoCell.h"
#import "OFProfileAPI.h"

@interface OFPersonalInfoLogic ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation OFPersonalInfoLogic

- (NSUInteger)numberOfSection
{
    return 1;
}

- (NSUInteger)itemCountOfSection:(NSUInteger)section
{
    return self.dataArr.count;
}

- (id)itemAtIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataArr.count) {
        return [self.dataArr objectAtIndex:indexPath.row];
    }
    return nil;
}

- (void)loadIfNeed
{
    
}

- (void)updateUserInfo
{
    for (OFPersonalInfoItem *item in self.dataArr) {
        if (item.type == PersonalInfoCellAvatar) {
            item.avatarUrl = KcurUser.profileUrl;
        }else if (item.type == PersonalInfoCellName) {
            item.detailTitle = KcurUser.userName;
        }
    }
}

- (NSArray *)dataArr
{
    if (!_dataArr) {
        NSMutableArray *array = [NSMutableArray array];
        {
            OFPersonalInfoItem *item1 = [[OFPersonalInfoItem alloc] init];
            item1.title = @"头像";
            item1.avatarUrl = KcurUser.profileUrl;
            item1.type = PersonalInfoCellAvatar;
            [array addObject:item1];
            
            OFPersonalInfoItem *item2 = [[OFPersonalInfoItem alloc] init];
            item2.title = @"昵称";
            item2.detailTitle = KcurUser.userName;
            item2.type = PersonalInfoCellName;
            [array addObject:item2];
        }
        _dataArr = array.copy;
    }
    return _dataArr;
}

#pragma mark - 更新用户名
- (void) updateUserName:(NSString *)userName withBlock:(void (^)(bool suc, NSString *errorMessage))block{
    WEAK_SELF;
    [OFProfileAPI updateUserName:userName finishBlock:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            KcurUser.userName = userName;
            [KUserManager saveUserInfo];
            [weakSelf updateUserInfo];
            block(success,messageStr);
        }else{
            block(success,messageStr);
        }
    }];
}

#pragma mark - 更新头像
- (void)updateUserAvatar:(NSData *)imageData withBlock:(void (^)(bool suc, NSString *avatarUrl, NSString *errorMessage))block{
    WEAK_SELF;
    [OFProfileAPI updateUserAvatar:imageData finishBlock:^(BOOL success, NSString *avatarUrl, NSError *error, NSString *message) {
        if (success) {
            KcurUser.profileUrl = avatarUrl;
            [KUserManager saveUserInfo];
            [weakSelf updateUserInfo];
        }
        block(success, avatarUrl, message);
    }];
}

@end
