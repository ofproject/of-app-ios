//
//  OFRecruitLogic.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRecruitLogic.h"
#import "OFCommonCell.h"
#import "OFPoolSettingCell.h"
#import "OFRecruitFinishCell.h"
#import "OFRecruitAPI.h"
#import "OFRecruitHeaderView.h"
#import "OFRecruitPoolModel.h"
#import "OFRecruitAPI.h"
#import "OFPoolModel.h"

@interface OFRecruitLogic ()

@property (nonatomic, strong) OFRecruitPoolModel *recruitInfo;
@property (nonatomic, strong) NSArray<NSArray *> *dataArr;
@property (nonatomic, strong) OFRecruitFinishCellModel *finishModel;

@end

@implementation OFRecruitLogic

- (instancetype)initWithDelegate:(id)delegate
{
    if (self = [super initWithDelegate:delegate]) {
        if (KcurUser.isPoolManager) {
            self.finishModel.pool = KcurUser.community;
            self.alreadyManager = YES;
        }
    }
    return self;
}

- (NSUInteger)numberOfSection
{
    if (self.finishModel.pool) {
        return 1;
    }
    return self.dataArr.count;
}

- (NSUInteger)itemCountOfSection:(NSUInteger)section
{
    if (self.finishModel.pool) {
        return 1;
    }
    if (section < self.dataArr.count) {
        NSArray *items = [self.dataArr objectAtIndex:section];
        return items.count;
    }
    return 0;
}

- (id)itemAtIndex:(NSIndexPath *)indexPath {
    
    if (self.finishModel.pool) {
        return self.finishModel;
    }
    if (indexPath.section < self.dataArr.count) {
        NSArray *items = [self.dataArr objectAtIndex:indexPath.section];
        if (indexPath.row < items.count) {
            return [items objectAtIndex:indexPath.row];
        }
    }
    return nil;
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finishModel.pool) {
        return [OFRecruitFinishCell finishCellHeight];
    }
    return 60.f;
}

- (CGFloat)heightForHeaderAtSection:(NSUInteger)section
{
    if (section == 0) {
        return 0.0001f;
    }else {
        return 10.f;
    }
}

- (void)loadIfNeed
{
    
}

- (OFRecruitHeaderViewModel *)headerInfo
{
    OFRecruitHeaderViewModel *model = [[OFRecruitHeaderViewModel alloc] init];
    model.applyRuleUrl = _recruitInfo.applyRuleUrl;
    model.communityCount = _recruitInfo.communityCount;
    return model;
}

- (NSString *)applyProtocolUrl
{
    return self.recruitInfo.applyProtocolUrl;
}

- (OFPoolModel *)finishPool
{
    return self.finishModel.pool;
}

- (void)getFristScreen
{
    WEAK_SELF;
    [OFRecruitAPI getLairdApplicationParamFinished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            weakSelf.recruitInfo = [OFRecruitPoolModel modelWithJSON:obj];
            [weakSelf updateFundPlaceholder];
            [weakSelf callbackSuccess];
        }
    }];
}

- (void)updatePoolLogo:(NSData *)logoData
{
    WEAK_SELF;
    [OFRecruitAPI updateCommunityLogo:logoData finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            OFCommonCellModel *model = [weakSelf modelAtSection:0 row:0];
            model.iconUrl = obj;
            [weakSelf callbackSuccess];
        }
    }];
}

- (void)updatePoolName:(NSString *)name
{
    OFPoolSettingModel *model = [self modelAtSection:0 row:1];
    model.detailTitle = name;
}

- (void)updateManagerName:(NSString *)managerName
{
    OFPoolSettingModel *model = [self modelAtSection:0 row:2];
    model.detailTitle = managerName;
}

- (void)updateManagerPhone:(NSString *)phone
{
    OFPoolSettingModel *model = [self modelAtSection:0 row:3];
    model.detailTitle = phone;
}

- (void)updateFundPlaceholder
{
    OFPoolSettingModel *model = [self modelAtSection:1 row:0];
    model.placeHolder = [NSString stringWithFormat:@"%@ OF起, 存入到矿池基金中",_recruitInfo.minStartUpOf];
}

- (void)launchPoolWithWalletAddress:(NSString *)walletAddress passphare:(NSString *)passphare
{
    OFCommonCellModel *model1 = [self modelAtSection:0 row:0];
    NSString *logoUrl = model1.iconUrl;
    
    OFPoolSettingModel *model2 = [self modelAtSection:0 row:1];
    NSString *communityName = model2.detailTitle;
    
    OFPoolSettingModel *model3 = [self modelAtSection:0 row:2];
    NSString *username = model3.detailTitle;
    
    OFPoolSettingModel *model4 = [self modelAtSection:0 row:3];
    NSString *phone = model4.detailTitle;
    
    OFPoolSettingModel *model5 = [self modelAtSection:1 row:0];
    NSString *startupOf = model5.detailTitle;
    
    WEAK_SELF;
    [OFRecruitAPI launchPool:logoUrl communityName:communityName username:username phone:phone startupOf:startupOf walletAddress:walletAddress passphare:passphare finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if (success) {
            NSDictionary *dict = [NDataUtil dictWith:obj];
            OFPoolModel *pool = [OFPoolModel modelWithJSON:dict[@"community"]];
            KcurUser.community = pool;
            [KUserManager saveUserInfo];
            weakSelf.finishModel.pool = pool;
            weakSelf.finishModel.communityCount = dict[@"communityCount"];
            [weakSelf callbackSuccess];
        }else{
            [weakSelf callbackFailure:messageStr];
        }
    }];
}

- (BOOL)checkDataFormat
{
    OFCommonCellModel *model1 = [self modelAtSection:0 row:0];
    NSString *logoUrl = model1.iconUrl;
    
    OFPoolSettingModel *model2 = [self modelAtSection:0 row:1];
    NSString *communityName = model2.detailTitle;
    
    OFPoolSettingModel *model3 = [self modelAtSection:0 row:2];
    NSString *username = model3.detailTitle;
    
    OFPoolSettingModel *model4 = [self modelAtSection:0 row:3];
    NSString *phone = model4.detailTitle;
    
    OFPoolSettingModel *model5 = [self modelAtSection:1 row:0];
    NSString *startupOf = model5.detailTitle;
    
    if (!logoUrl || logoUrl.length < 1) {
        [MBProgressHUD showToast:@"请先上传矿池Logo" toView:[JumpUtil currentVC].view];
        return NO;
    }
    if (![communityName hasSuffix:@"矿池"] ||
        !(communityName.length >= 4) ||
        !(communityName.length <= 10)) {
        [MBProgressHUD showToast:@"矿池名规定4-10个字, 以\"矿池\"结尾" toView:[JumpUtil currentVC].view];
        return NO;
    }
    if (username.length < 1 ||
        username.length > 10) {
        [MBProgressHUD showToast:@"请输入您的姓名" toView:[JumpUtil currentVC].view];
        return NO;
    }
    if (phone.length != 11) {
        [MBProgressHUD showToast:@"请输入正确格式的手机号" toView:[JumpUtil currentVC].view];
        return NO;
    }
    if (startupOf.floatValue < self.recruitInfo.minStartUpOf.floatValue) {
        NSString *text = [NSString stringWithFormat:@"启动基金最少%@ OF",self.recruitInfo.minStartUpOf];
        [MBProgressHUD showToast:text toView:[JumpUtil currentVC].view];
        return NO;
    }

    return YES;
}

- (BOOL)checkApplyProtocolStatus:(BOOL)status
{
    if (!status) {
        [MBProgressHUD showToast:@"请先阅读《OF领主申请协议》并同意" toView:[JumpUtil currentVC].view];
    }
    return status;
}

#pragma mark - callback
- (void)callbackSuccess
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDataSuccess)]) {
        [self.delegate requestDataSuccess];
    }
}

- (void)callbackFailure:(NSString *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDataFailure:)]) {
        [self.delegate requestDataFailure:message];
    }
}

#pragma mark - Private
- (id)modelAtSection:(NSInteger)section row:(NSInteger)row
{
    if (section < self.dataArr.count) {
        NSArray *array = [self.dataArr objectAtIndex:section];
        if (row < array.count) {
            return [array objectAtIndex:row];
        }
    }
    return nil;
}

#pragma mark - lazy load
- (NSArray *)dataArr
{
    if (!_dataArr) {
        NSMutableArray *array = [NSMutableArray array];
        {
            NSMutableArray *sectionArray = [NSMutableArray array];
            OFCommonCellModel *model1 = [[OFCommonCellModel alloc] init];
            model1.title = @"矿池logo";
            model1.iconUrl = @"";
            model1.iconPlaceholder = @"mining_pool_icon";
            model1.type = OFCommonCellTypeIcon;
            [sectionArray addObject:model1];
            
            OFPoolSettingModel *model2 = [[OFPoolSettingModel alloc] init];
            model2.title = @"矿池名称";
            model2.placeHolder = @"4-10个字, 以\"矿池\"结尾";
            model2.type = OFPoolSettingCellTypeName;
            [sectionArray addObject:model2];
            
            OFPoolSettingModel *model3 = [[OFPoolSettingModel alloc] init];
            model3.title = @"领主姓名";
            model3.placeHolder = @"请输入您的姓名";
            model3.type = OFPoolSettingCellTypeName;
            [sectionArray addObject:model3];
            
            OFPoolSettingModel *model4 = [[OFPoolSettingModel alloc] init];
            model4.title = @"联系方式";
            model4.placeHolder = @"请输入真实手机号";
            model4.keyboardType = UIKeyboardTypeNumberPad;
            model4.type = OFPoolSettingCellTypeName;
            [sectionArray addObject:model4];
            
            [array addObject:sectionArray];
        }
        {
            NSMutableArray *sectionArray = [NSMutableArray array];
            OFPoolSettingModel *model1 = [[OFPoolSettingModel alloc] init];
            model1.title = @"启动基金";
            model1.placeHolder = @"100 OF起, 存入到矿池基金中";
            model1.type = OFPoolSettingCellTypeName;
            model1.keyboardType = UIKeyboardTypeNumberPad;
            [sectionArray addObject:model1];
            
            [array addObject:sectionArray];
        }
        
        _dataArr = array.copy;
    }
    return _dataArr;
}

- (OFRecruitFinishCellModel *)finishModel
{
    if (!_finishModel) {
        _finishModel = [[OFRecruitFinishCellModel alloc] init];
    }
    return _finishModel;
}

@end
