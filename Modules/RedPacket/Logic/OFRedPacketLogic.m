//
//  OFRedPacketLogic.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFRedPacketLogic.h"
#import "OFRedPacketModel.h"
#import "OFRedPacketAPI.h"
#import "OFMiningAPI.h"
#import "OFMiningInfoModel.h"

@interface OFRedPacketLogicModel : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray <OFRedPacketModel *> *packets;
@property (nonatomic, strong) NSString *totalRedPacketAmount;
@property (nonatomic, strong) NSString *totalRedPacketNumber;

@end

@implementation OFRedPacketLogicModel

@end

@interface OFRedPacketLogic ()

@property (nonatomic, strong) NSArray <OFRedPacketLogicModel *> *dataArr;
@property (nonatomic, strong) RewardModel *rewardModel;

@end

@implementation OFRedPacketLogic

- (instancetype)initWithDelegate:(id)delegate
{
    if (self = [super initWithDelegate:delegate]) {
        _rankType = 0;
    }
    return self;
}

- (void)setRankType:(NSInteger)rankType
{
    _rankType = rankType;
    OFRedPacketLogicModel *model = [self.dataArr objectAtIndex:rankType];
    if (model.packets.count == 0) {
        [self getRedPacketListWithRankType:rankType indexPage:1 isRefresh:YES];
    }
    [self callbackRefresh];
}

#pragma mark - OFTableViewProtocol
- (NSUInteger)numberOfSection
{
    return 1;
}

- (NSUInteger)itemCountOfSection:(NSUInteger)section
{
    OFRedPacketLogicModel *model = [self.dataArr objectAtIndex:self.rankType];
    return model.packets.count;
}

- (id)itemAtIndex:(NSIndexPath *)indexPath
{
    OFRedPacketLogicModel *model = [self.dataArr objectAtIndex:self.rankType];
    if (indexPath.row < model.packets.count) {
        return [model.packets objectAtIndex:indexPath.row];
    }
    return nil;
}

- (NSString *)sectionTitle
{
    OFRedPacketLogicModel *model = [self.dataArr objectAtIndex:self.rankType];
    return [NSString stringWithFormat:@"%@%@个红包, 共%0.3fOF",self.rankType ? @"发送" : @"收到",model.totalRedPacketNumber ? model.totalRedPacketNumber : @"0",model.totalRedPacketAmount ? model.totalRedPacketAmount.doubleValue : 0.000];
}

- (BOOL)isEmptyData
{
    if ([self itemCountOfSection:0]) {
        return NO;
    }
    return YES;
}

- (void)getFirstScreen
{
    [self getRedPacketReward];
    [self getRedPacketListWithRankType:self.rankType indexPage:1 isRefresh:YES];
}

- (void)refreshPacketList
{
    OFRedPacketLogicModel *model = [self.dataArr objectAtIndex:self.rankType];
    model.page = 1;
    [self getRedPacketListWithRankType:_rankType indexPage:model.page isRefresh:YES];
}

- (void)loadMorePacketList
{
    OFRedPacketLogicModel *model = [self.dataArr objectAtIndex:self.rankType];
    [self getRedPacketListWithRankType:_rankType indexPage:model.page isRefresh:NO];
}

- (void)getRedPacketListWithRankType:(NSInteger)rankType indexPage:(NSInteger)indexPage isRefresh:(BOOL)isRefresh
{
    WEAK_SELF;
    [OFRedPacketAPI getRedPacketListWithRankType:(rankType + 1) indexPage:indexPage finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        NSLog(@"%@", obj);
        if (success) {
            NSDictionary *dict = [NDataUtil dictWith: obj];
            NSArray *packets = dict[@"items"];
            OFRedPacketLogicModel *model = [weakSelf.dataArr objectAtIndex:weakSelf.rankType];
            model.totalRedPacketAmount = [NDataUtil stringWith:dict[@"totalRedPacketAmount"] valid:@"0.00"];
            model.totalRedPacketNumber = [NDataUtil stringWith:dict[@"totalRedPacketNumber"] valid:@"0"];
            if (packets.count < 1) {
                [self callbackWithNomoreData];
            }else {
                [weakSelf fillRedPacketDataArr:packets rankType:rankType isRefresh:isRefresh];
                [weakSelf callbackRefresh];
            }
        }else {
            [weakSelf callbackError:messageStr];
        }
    }];
}

- (void)getRedPacketReward
{
    [self callbackRedPacketReward:self.reward];
    WEAK_SELF;
    [OFMiningAPI getMiningInfo:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if(success){
            NSDictionary *dict = (NSDictionary *)obj;
            NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
            if (status == 200) {
                NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
                OFMiningInfoModel *model = [OFMiningInfoModel modelWithDictionary:data];
                weakSelf.rewardModel = model.reward;
                weakSelf.reward = model.reward.redPacketReward.stringValue;
                [weakSelf callbackRedPacketReward:weakSelf.reward];
            }
        }
    }];
}

#pragma mark - callback
- (void)callbackRefresh
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDataSuccess)]) {
        [self.delegate requestDataSuccess];
    }
}

- (void)callbackWithNomoreData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requesetNomoreDataSuccess)]) {
        [self.delegate requesetNomoreDataSuccess];
    }
}

- (void)callbackError:(NSString *)errMessage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDataFailure:)]) {
        [self.delegate requestDataFailure:errMessage];
    }
}

- (void)callbackRedPacketReward:(NSString *)reward
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestRedPacketRewardSuccess:)]) {
        [self.delegate requestRedPacketRewardSuccess:reward];
    }
}

#pragma mark - Default Items
- (NSArray *)defaultSectionItems
{
    return @[@"我收到的",
             @"我发出的"];
}

#pragma mark - private
- (void)fillRedPacketDataArr:(NSArray *)packets rankType:(NSInteger)rankType isRefresh:(BOOL)isRefresh
{
    if (isRefresh) {
        [self emptyCommunityData:rankType];
    }
    NSArray<OFRedPacketModel *> *packetArr = [NSArray modelArrayWithClass:[OFRedPacketModel class] json:packets];
    [packetArr enumerateObjectsUsingBlock:^(OFRedPacketModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.type = rankType;
    }];
    
    OFRedPacketLogicModel *model = [self.dataArr objectAtIndex:rankType];
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:model.packets];
    [mutArray addObjectsFromArray:packetArr];
    model.packets = mutArray.copy;
    model.page++;
}

- (void)emptyCommunityData:(NSInteger)rankType
{
    OFRedPacketLogicModel *model = [self.dataArr objectAtIndex:rankType];
    model.packets = nil;
}

- (NSString *)reward
{
    if (_reward.length < 1) {
        _reward = @"0.000";
    }
    return [NSString stringWithFormat:@"%.3f",_reward.floatValue];
}

#pragma mark - lazy load
- (NSArray<OFRedPacketLogicModel *> *)dataArr
{
    if (!_dataArr) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:4];
        for (int i = 0; i < 2; i++) {
            OFRedPacketLogicModel *model = [[OFRedPacketLogicModel alloc] init];
            model.page = 1;
            model.packets = nil;
            [array addObject:model];
        }
        _dataArr = array.copy;
    }
    return _dataArr;
}

@end
