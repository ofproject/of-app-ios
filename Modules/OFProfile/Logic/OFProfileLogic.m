//
//  OFProfileLogic.m
//  OFBank
//
//  Created by xiepengxiang on 04/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFProfileLogic.h"
#import "OFProfileCell.h"
#import "OFProfileAPI.h"

@interface OFProfileLogic ()

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation OFProfileLogic

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
            OFProfileItem *item1 = [[OFProfileItem alloc] init];
            item1.title = @"推荐给好友";
            item1.icon = @"profile_ recommend";
            item1.rightIcon = @"profile_qrcode";
            item1.type = ProfileCellTypeTop;
            item1.targetType = ProfileTargetTypeController;
            item1.targetCalss = @"OFRecommendController";
            
            OFProfileItem *item2 = [[OFProfileItem alloc] init];
            item2.title = @"账号与安全";
            item2.icon = @"profile_account_icon";
            item2.type = ProfileCellTypeBottom;
            item2.targetType = ProfileTargetTypeController;
            item2.targetCalss = @"OFAccountSafeVC";
            [array addObject:@[item1, item2]];
        }
        {
            OFProfileItem *item1 = [[OFProfileItem alloc] init];
            item1.title = @"挖矿攻略";
            item1.urlString = NSStringFormat(@"%@%@",URL_H5_main,URL_H5_MineralStrategy);
            item1.icon = @"profile_mining";
            item1.type = ProfileCellTypeTop;
            item1.targetType = ProfileTargetTypeWeb;
            
            OFProfileItem *item2 = [[OFProfileItem alloc] init];
            item2.title = @"交易攻略";
            item2.urlString = NSStringFormat(@"%@%@",URL_H5_main,URL_H5_SaleStrategy);
            item2.icon = @"profile_buy_icon";
            item2.type = ProfileCellTypeBottom;
            item2.targetType = ProfileTargetTypeWeb;
            
            [array addObject:@[item1, item2]];
        }
        {
            OFProfileItem *item1 = [[OFProfileItem alloc] init];
            item1.title = @"关于我们";
            item1.icon = @"profile_aboutus";
            item1.type = ProfileCellTypeSingle;
            item1.targetType = ProfileTargetTypeController;
            item1.targetCalss = @"OFAboutUS";
            [array addObject:@[item1]];
        }
        {
            OFProfileItem *item2 = [[OFProfileItem alloc] init];
            item2.title = @"申请领主";
            item2.icon = @"profile_apply_leader";
            item2.type = ProfileCellTypeSingle;
            item2.targetType = ProfileTargetTypeSchema;
            item2.urlString = URL_Native_ApplyLaird;
            
            [array addObject:@[item2]];
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
