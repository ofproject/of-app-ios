//
//  OFPacketDetailLogic.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketDetailLogic.h"
#import "OFPacketDetailCell.h"
#import "OFRedPacketModel.h"
#import "OFRedPacketAPI.h"
#import "OFPacketDetailHeaderView.h"
#import "OFSharedModel.h"

@interface OFPacketDetailLogic ()

@property (nonatomic, strong) PacketDetailHeaderModel *headerModel;
@property (nonatomic, strong) OFSharedModel *shareInfo;
@property (nonatomic, strong) NSString *sectionTitle;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation OFPacketDetailLogic

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

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KWidthFixed(71.f);
}

- (BOOL)canSendAgain
{
    if (self.packet.type == OFRedPacketTypeSend &&
        self.shareInfo &&
        ![self.shareInfo.urlString isKindOfClass:NSNull.class] &&
        self.shareInfo.urlString.length > 0 &&
        !self.headerModel.hasExpired &&
        !self.headerModel.hasFinished) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)isShowReceivedReward
{
    if (self.packet.type == OFRedPacketTypeReceive) {
        return YES;
    }else {
        return NO;
    }
}

- (BOOL)isExpired
{
    if (self.packet.type == OFRedPacketTypeSend &&
        self.headerModel.hasExpired &&
        !self.headerModel.hasFinished) {
        return YES;
    }
    return NO;
}

- (PacketDetailHeaderModel *)headerInfo
{
    return self.headerModel;
}

- (NSString *)sectionTitle
{
    return _sectionTitle;
}

-(OFSharedModel *)shareInfo
{
    return _shareInfo;
}

- (void)getFirstScreen
{
    self.page = 1;
    [self getRedPacketDetail];
}

- (void)loadMorePacketDetail
{
    [self getRedPacketDetail];
}

- (void)getRedPacketDetail
{
    WEAK_SELF;
    [OFRedPacketAPI getRedPacketDetailWithToken:_packet.token indexPage:_page finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        NSLog(@"%@",obj);
        if (success) {
            NSDictionary *dict = [NDataUtil dictWith: obj];
            weakSelf.headerModel = [PacketDetailHeaderModel modelWithDictionary:dict];
            weakSelf.headerModel.redPacketAmount = weakSelf.packet.redPacketAmount;
            [weakSelf fillShareInfo: dict[@"shareInfo"]];
            weakSelf.sectionTitle = dict[@"desc"];
            NSArray *packets = dict[@"items"];
            if (packets.count < 1) {
                [self callbackWithNomoreData];
            }else {
                [weakSelf fillRedPacketDetialDataArr:packets];
                [weakSelf callbackRefresh];
            }
        }else {
            [weakSelf callbackError:messageStr];
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

#pragma mark - private
- (void)fillShareInfo:(NSDictionary *)dict
{
    if (!dict || [dict isKindOfClass:NSNull.class]) return;
    
    OFSharedModel *model = [[OFSharedModel alloc] init];
    model.title = dict[@"shareTitle"];
    model.descript = dict[@"shareContent"];
    model.urlString = dict[@"shareLink"];
    model.sharedType = OFSharedTypeUrl;
    model.thumbImage = IMAGE_NAMED(@"redpacket_share");
    self.shareInfo = model;
}

- (void)fillRedPacketDetialDataArr:(NSArray *)packets
{
    NSArray<OFPacketDetailModel *> *packetArr = [NSArray modelArrayWithClass:[OFPacketDetailModel class] json:packets];
    
    NSMutableArray *mutArray = [NSMutableArray arrayWithArray:self.dataArr];
    [mutArray addObjectsFromArray:packetArr];
    self.dataArr = mutArray.copy;
    _page++;
}

@end
