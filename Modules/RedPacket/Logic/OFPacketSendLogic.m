//
//  OFPacketSendLogic.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/8.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketSendLogic.h"
#import "OFPacketEditCell.h"
#import "OFPacketEditNameCell.h"
#import "OFRedPacketAPI.h"
#import "OFMiningAPI.h"
#import "OFMiningInfoModel.h"
#import "OFPacketPayModel.h"
#import "OFSharedModel.h"
#import "OFRedPacketModel.h"

#define kWallet_Key         @"kWallet_Key"
#define kAmount_Key         @"kAmount_Key"
#define kCount_Key          @"kCount_Key"
#define kDescription_Key    @"kDescription_Key"

@interface OFPacketSendLogic ()

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) NSString *defaultRedPacketDesc;
@property (nonatomic, strong) NSString *maxRedPacketAmount;
@property (nonatomic, strong) NSString *maxRedPacketNumber;
@property (nonatomic, strong) NSString *minRedPacketAmount;
@property (nonatomic, strong) NSString *minRedPacketNumber;

@end

@implementation OFPacketSendLogic

- (NSUInteger)numberOfSection
{
    return 1;
}

- (NSUInteger)itemCountOfSection:(NSUInteger)section
{
    return self.dataDic.allKeys.count;
}

- (id)itemAtIndex:(NSIndexPath *)indexPath
{
    NSString *key = [self itemKeyAtIndexPath:indexPath];
    return [self.dataDic objectForKey:key];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id model = [self itemAtIndex:indexPath];
    if ([model isKindOfClass:OFPacketEditNameModel.class]) {
        return KWidthFixed(100.f);
    }else {
        return 80.f;
    }
}

- (NSString *)minRedPacketAmount
{
    return _minRedPacketAmount;
}

- (BOOL)checkEditInfo
{
    OFPacketEditModel *packetAmountModel = [self.dataDic objectForKey:kAmount_Key];
    NSString *packetAmount = packetAmountModel.editText;
    if (packetAmount.floatValue < self.minRedPacketAmount.floatValue) {
        NSString *text = [NSString stringWithFormat:@"红包总金额最少%@OF",self.minRedPacketAmount];
        [MBProgressHUD showToast:text toView:[JumpUtil currentVC].view];
        return NO;
    }
    if (packetAmount.floatValue > self.maxRedPacketAmount.floatValue) {
        NSString *text = [NSString stringWithFormat:@"红包总金额最大%@OF",self.maxRedPacketAmount];
        [MBProgressHUD showToast:text toView:[JumpUtil currentVC].view];
        return NO;
    }
    
    OFPacketEditModel *packetCountModel = [self.dataDic objectForKey:kCount_Key];
    NSString *packetCount = packetCountModel.editText;
    if (packetCount.integerValue < self.minRedPacketNumber.integerValue) {
        NSString *text = [NSString stringWithFormat:@"红包数量最少%@个",self.minRedPacketNumber];
        [MBProgressHUD showToast:text toView:[JumpUtil currentVC].view];
        return NO;
    }
    if (packetCount.integerValue > self.maxRedPacketNumber.integerValue) {
        NSString *text = [NSString stringWithFormat:@"红包数量最大%@个",self.maxRedPacketNumber];
        [MBProgressHUD showToast:text toView:[JumpUtil currentVC].view];
        return NO;
    }
    
    if (packetCount.integerValue > (long)(packetAmount.doubleValue * 1000)) {
        NSString *text = [NSString stringWithFormat:@"红包数量设置过大"];
        [MBProgressHUD showToast:text toView:[JumpUtil currentVC].view];
        return NO;
    }
    
    OFPacketEditNameModel *packetDescModel = [self.dataDic objectForKey:kDescription_Key];
    NSString *packetDesc = packetDescModel.name;
    if (packetDesc.length > 20) {
        NSString *text = [NSString stringWithFormat:@"红包描述不得超过20个字符"];
        [MBProgressHUD showToast:text toView:[JumpUtil currentVC].view];
        return NO;
    }
    
    OFPacketPayModel *model = [self.dataDic objectForKey:kWallet_Key];
    if (model.wallet.balance.floatValue < packetAmount.floatValue) {
        NSString *text = [NSString stringWithFormat:@"钱包余额不足,请重新选择"];
        [MBProgressHUD showToast:text toView:[JumpUtil currentVC].view];
        return NO;
    }
    return YES;
}

- (void)resetInputInfo
{
    OFPacketEditModel *packetAmountModel = [self.dataDic objectForKey:kAmount_Key];
    packetAmountModel.editText = @"";
    
    OFPacketEditModel *packetCountModel = [self.dataDic objectForKey:kCount_Key];
    packetCountModel.editText = @"";
    
    OFPacketEditNameModel *packetDescModel = [self.dataDic objectForKey:kDescription_Key];
    packetDescModel.name = @"";
    
    [self callbackRefresh];
}

- (BOOL)needPayPassphare
{
    OFPacketPayModel *model = [self.dataDic objectForKey:kWallet_Key];
    if (model.type == OFPacketPayTypeRedPacket) {
        return NO;
    }
    return YES;
}

- (void)getConfigInfo
{
    WEAK_SELF;
    [OFRedPacketAPI getRedPacketParamFinished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        NSLog(@"%@",obj);
        if (success) {
            NSDictionary *dict = [NDataUtil dictWith: obj];
            weakSelf.defaultRedPacketDesc = [NDataUtil stringWith:dict[@"defaultRedPacketDesc"] valid:@""];
            weakSelf.maxRedPacketAmount = [NDataUtil stringWith:dict[@"maxRedPacketAmount"] valid:@"0"];
            weakSelf.maxRedPacketNumber = [NDataUtil stringWith:dict[@"maxRedPacketNumber"] valid:@"0"];
            weakSelf.minRedPacketAmount = [NDataUtil stringWith:dict[@"minRedPacketAmount"] valid:@"0"];
            weakSelf.minRedPacketNumber = [NDataUtil stringWith:dict[@"minRedPacketNumber"] valid:@"0"];
            [weakSelf getRedPacketReward];
            [weakSelf callbackRefresh];
        }
    }];
}

- (void)getRedPacketReward
{
    WEAK_SELF;
    [OFMiningAPI getMiningInfo:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        if(success){
            NSDictionary *dict = (NSDictionary *)obj;
            NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
            if (status == 200) {
                NSDictionary *data = [NDataUtil dictWith:dict[@"data"]];
                OFMiningInfoModel *model = [OFMiningInfoModel modelWithDictionary:data];
                weakSelf.rewardModel = model.reward;
                [weakSelf sortBalance:model.reward];
                [weakSelf callbackRedPacketReward];
            }
        }
    }];
}

- (void)sendRedPacket:(NSString *)passphare
{
    WEAK_SELF;
    OFPacketEditModel *packetAmountModel = [self.dataDic objectForKey:kAmount_Key];
    NSString *packetAmount = packetAmountModel.editText;
    
    OFPacketEditModel *packetCountModel = [self.dataDic objectForKey:kCount_Key];
    NSString *packetCount = packetCountModel.editText;
    
    OFPacketEditNameModel *packetDescModel = [self.dataDic objectForKey:kDescription_Key];
    NSString *packetDesc = packetDescModel.name;
    if (packetDesc.length < 1) {
        packetDesc = packetDescModel.placeHolder;
    }
    
    OFPacketPayModel *payModel = [self.dataDic objectForKey:kWallet_Key];
    NSString *walletAddress = payModel.wallet.address;
    
    NSString *payType = @"";
    if (walletAddress.length < 1) {
        payType = @"1";
    }else {
        payType = @"2";
    }
    [MBProgressHUD showMessage:@"红包准备中"];
    [OFRedPacketAPI createRedPacketAmount:packetAmount count:packetCount desc:packetDesc walletAddress:walletAddress payType:payType passphare:[NDataUtil md5:passphare] finished:^(BOOL success, id obj, NSError *error, NSString *messageStr) {
        [MBProgressHUD hideHUD];
        NSLog(@"%@",obj);
        if (success) {
            // 减去钱包余额
            payModel.wallet.balance = [NSString stringWithFormat:@"%.3lf", payModel.wallet.balance.doubleValue - packetAmount.doubleValue];
            if (passphare.length > 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationRefreshWallet
                                                                    object:nil];
            }
            
            NSDictionary *dict = (NSDictionary *)obj;
            OFSharedModel *model = [OFSharedModel new];
            model.title = dict[@"shareTitle"];
            model.descript = dict[@"shareContent"];
            model.urlString = dict[@"shareLink"];
            model.sharedType = OFSharedTypeUrl;
            model.thumbImage = IMAGE_NAMED(@"redpacket_share");
            
            OFRedPacketModel *packet = [[OFRedPacketModel alloc] init];
            packet.type = OFRedPacketTypeSend;
            packet.token = dict[@"token"];
            
            [weakSelf callbackPacketCreateSuccess:model title:dict[@"title"] detailText:dict[@"content"] packet:packet];
        }else {
            if (error.code == 1318) {//上个红包没有打包上链，不能继续发，此时报错用alert弹窗
                if (self.delegate && [self.delegate respondsToSelector:@selector(redPacketCreateFailureWithLastIsNoOK:)]) {
                    [self.delegate redPacketCreateFailureWithLastIsNoOK:messageStr];
                }
            }else{
                [weakSelf callbackPacketCreateFailure:messageStr];
            }
        }
    }];
}

- (void)updateWalletInfo:(OFWalletModel *)wallet
{
    OFPacketPayModel *payModel = [self.dataDic objectForKey:kWallet_Key];
    if (wallet.address.length > 1) {
        payModel.type = OFPacketPayTypeWallet;
    }else {
        payModel.type = OFPacketPayTypeRedPacket;
    }
    payModel.wallet = wallet;
    [self callbackRefresh];
}

#pragma mark - override
- (void)setRewardModel:(RewardModel *)rewardModel
{
    _rewardModel = rewardModel;
    [self sortBalance:rewardModel];
}

#pragma mark - callback
- (void)callbackRefresh
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDataSuccess)]) {
        [self.delegate requestDataSuccess];
    }
}

- (void)callbackError:(NSString *)errMessage
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestDataFailure:)]) {
        [self.delegate requestDataFailure:errMessage];
    }
}

- (void)callbackPacketCreateSuccess:(OFSharedModel *)shareModel title:(NSString *)title detailText:(NSString *)detail packet:(OFRedPacketModel *)packet;
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(redPacketCreateSuccess:title:detailText:packet:)]) {
        [self.delegate redPacketCreateSuccess:shareModel title:title detailText:detail packet:packet];
    }
}

- (void)callbackPacketCreateFailure:(NSString *)message
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(redPacketCreateFailure:)]) {
        [self.delegate redPacketCreateFailure:message];
    }
}

- (void)callbackRedPacketReward
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(requestRedPacketRewardSuccess)]) {
        [self.delegate requestRedPacketRewardSuccess];
    }
}

#pragma mark - private
- (NSString *)itemKeyAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self dataKeys];
    if (indexPath.row < array.count) {
        return [array objectAtIndex:indexPath.row];
    }
    return @"";
}

- (void)setDefaultRedPacketDesc:(NSString *)defaultRedPacketDesc
{
    _defaultRedPacketDesc = defaultRedPacketDesc;
    OFPacketEditNameModel *model = [self.dataDic objectForKey:kDescription_Key];
    model.placeHolder = defaultRedPacketDesc;
}

- (void)sortBalance:(RewardModel *)model
{
    NSString *reward = [NSString stringWithFormat:@"%0.3f",model.redPacketReward.floatValue];
    OFWalletModel *packetWallet = [[OFWalletModel alloc] init];
    packetWallet.name = @"红包余额";
    packetWallet.balance = reward;
    packetWallet.address = @"";
    [self defaultWalletSort:packetWallet];
}

- (void)defaultWalletSort:(OFWalletModel *)packet
{
    if (packet.balance.doubleValue < self.minRedPacketAmount.doubleValue) {
        for (OFWalletModel *wallet in KcurUser.wallets) {
            if (wallet.balance.doubleValue >= self.minRedPacketAmount.doubleValue) {
                packet = wallet;
            }
        }
    }
    
    OFPacketPayModel *payModel = [self.dataDic objectForKey:kWallet_Key];
    if (packet.address.length < 1) {
        payModel.type = OFPacketPayTypeRedPacket;
    }else {
        payModel.type = OFPacketPayTypeWallet;
    }
    payModel.wallet = packet;
}

- (NSDictionary *)dataDic
{
    if (!_dataDic) {
        NSMutableDictionary *mtlDict = [NSMutableDictionary dictionaryWithCapacity:[self dataKeys].count];
        for (NSString *key in [self dataKeys]) {
            if ([key isEqualToString:kWallet_Key]) {
                OFPacketPayModel *model = [[OFPacketPayModel alloc] init];
                model.type = OFPacketPayTypeWallet;
                model.wallet = KcurUser.wallets.firstObject;
                [mtlDict setObject:model forKey:kWallet_Key];
            }else if([key isEqualToString:kAmount_Key]) {
                OFPacketEditModel *model = [[OFPacketEditModel alloc] init];
                model.title = @"总金额";
                model.detailTitle = @"OF";
                model.placeHolder = @"0.000";
                model.keyboardType = UIKeyboardTypeDecimalPad;
                [mtlDict setObject:model forKey:kAmount_Key];
            }else if([key isEqualToString:kCount_Key]){
                OFPacketEditModel *model = [[OFPacketEditModel alloc] init];
                model.title = @"红包个数";
                model.detailTitle = @"个";
                model.placeHolder = @"0";
                model.keyboardType = UIKeyboardTypeNumberPad;
                [mtlDict setObject:model forKey:kCount_Key];
            }else if([key isEqualToString:kDescription_Key]){
                OFPacketEditNameModel *model = [[OFPacketEditNameModel alloc] init];
                model.placeHolder = @"福币福币";
                [mtlDict setObject:model forKey:kDescription_Key];
            }
        }
        _dataDic = mtlDict.copy;
    }
    return _dataDic;
}

- (NSArray<NSString *>*)dataKeys
{
    return @[kWallet_Key,
             kAmount_Key,
             kCount_Key,
             kDescription_Key];
}

@end
