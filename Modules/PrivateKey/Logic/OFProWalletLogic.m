//
//  OFProWalletLogic.m
//  OFBank
//
//  Created by of on 2018/6/19.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProWalletLogic.h"
#import "OFTokenModel.h"

#import "OFProWalletAPI.h"
#import "OFWalletModel.h"


@interface OFProWalletLogic ()

@property (nonatomic, strong) NSMutableDictionary *dict;

@end

static NSString *const tokenListKey = @"ProTokenList";

@implementation OFProWalletLogic



- (instancetype)init{
    if (self = [super init]) {
        NSArray *array = [[OFKVStorage shareStorage] itemForKey:tokenListKey];
        
        self.tokens = [NSArray modelArrayWithClass:[OFTokenModel class] json:array];
        
    }
    return self;
}


#pragma mark - TableView
- (NSUInteger)numberOfSection
{
    return 1;
}

- (NSUInteger)itemCountOfSection:(NSUInteger)section
{
    if (KcurUser.currentProWallet) {
        return KcurUser.currentProWallet.tokens.count;
    }
    return 0;
}

- (id)itemAtIndex:(NSIndexPath *)indexPath
{
    OFTokenModel *model = [NDataUtil classWithArray:[OFTokenModel class] array:KcurUser.currentProWallet.tokens index:indexPath.row];
    return model;
}

- (void)loadIfNeed{
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


- (void)getToken{
    
    if (KcurUser.currentProWallet) {
        [KcurUser.currentProWallet.tokens removeAllObjects];
    }else{
        KcurUser.currentProWallet = KcurUser.proWallets.firstObject;
        [KcurUser.currentProWallet.tokens removeAllObjects];
    }
    
    [KUserManager updateCanseeState];
    NSLog(@"%@",KcurUser.currentProWallet.tokens);
    [OFProWalletAPI getTokenListFinished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
        if (success) {
            //                NSLog(@"%@",obj);
            NSArray *array = [NDataUtil arrayWith:obj[@"data"]];
            self.tokens = [NSArray modelArrayWithClass:[OFTokenModel class] json:array];
            if (self.tokens.count > 0) {
                NSLog(@"获取token成功");
                [[OFKVStorage shareStorage] saveItem:array forKey:tokenListKey];
                
                [self getBalance];
            }else{
                NSLog(@"获取token列表失败");
            }
        }else{
            NSLog(@"获取token列表失败");
        }
    }];
}

- (void)getBalance{
    
    NSLog(@"请求余额中....");
    if (self.tokens.count == 0) {
        NSLog(@"token数量");
        [self getToken];
        [self requestFailure:@"获取token列表失败"];
        return;
    }
    
    if (KcurUser.currentProWallet == nil) {
        [self requestFailure:@"没有钱包"];
        return;
    }
    
    OFProWalletModel *model = KcurUser.currentProWallet;
    
    NSString *address = [NDataUtil stringWith:model.address valid:@""];
    
    if (address.length < 1) {
        NSLog(@"地址为空。");
        [self requestFailure:@"地址为空"];
        return;
    }
    
    if (model.tokens.count == 0) {
        OFTokenModel *token = [[OFTokenModel alloc] init];
        token.isCoin = YES;
        
        token.name = @"OF";
        
        token.image = @"";
        // OF币
        [model.tokens addObject:token];
    }
    
    NSMutableArray *array = [NSMutableArray array];
//    NSLog(@"%@",KcurUser.currentProWallet.tokens);
    
    [KcurUser.currentProWallet.tokens enumerateObjectsUsingBlock:^(OFTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"合约地址 %@",obj.contractAddress);
    }];
    
    for (int i = 0; i < self.tokens.count; i++) {
        OFTokenModel *token = [NDataUtil classWithArray:[OFTokenModel class] array:self.tokens index:i];
        
        NSNumber *number = [NSNumber numberWithInteger:[token.toid integerValue]];
        [array addObject:number];
        
        if (![self hasToken:token]) {
//            NSLog(@"%@",token.contractAddress);
            [model.tokens addObject:token];
        }
    }
    
    NSDate *date = [NDataUtil classWith:[NSDate class] data:self.dict[address]];
    
    if (date) {
        NSTimeInterval time = [[NSDate date] timeIntervalSinceDate:date];
        
        if (time < 30.0) {
            [self requestFailure:@"多次请求"];
            [self loadIfNeed];
            NSLog(@"多次请求");
            return;
        }
        [self.dict removeObjectForKey:address];
    }
    
//
    
    [OFProWalletAPI getProBalanceWithAddress:address toids:array finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
        
        if (success) {
            
            NSDictionary *dict = [NDataUtil dictWith:obj[@"data"]];
            KcurUser.currentProWallet.balance = [NDataUtil stringWith:dict[@"of_balance"] valid:@"0.000"];
            OFTokenModel *model = KcurUser.currentProWallet.tokens.firstObject;
            model.balance = [NDataUtil stringWith:dict[@"of_balance"] valid:@"0.000"];
            // 2. tokens 余额
            NSArray *tokenBalance = [NDataUtil arrayWith:dict[@"token_balance"]];
            
            for (int i = 0; i < tokenBalance.count; i++) {
                
                NSDictionary *dict = [NDataUtil dictWithArray:tokenBalance index:i];
                
                [KcurUser.currentProWallet.tokens enumerateObjectsUsingBlock:^(OFTokenModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj.toid isEqualToString:[NDataUtil stringWith:dict[@"toid"] valid:@"0"]]) {
                        obj.balance = [NDataUtil stringWith:dict[@"balance"] valid:@"0"];
                    }
                }];
            }
            
            self.dict[address] = [NSDate date];
            [self loadIfNeed];
            [KUserManager saveUserInfo];
            return ;
        }
        
        [self requestFailure:errorMessage];
        
    }];
    
}


- (NSInteger)numberOfCells{
    return KcurUser.currentProWallet.tokens.count;
}


- (OFTokenModel *)dataWithRow:(NSInteger)row{
    return [NDataUtil classWithArray:[OFTokenModel class] array:KcurUser.currentProWallet.tokens index:row];
}

- (NSMutableDictionary *)dict{
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}

- (BOOL)hasToken:(OFTokenModel *)token{
    
    for (OFTokenModel *obj in KcurUser.currentProWallet.tokens) {
        if ([obj.contractAddress isEqualToString:token.contractAddress]) {
            return YES;
        }
    }
    return NO;
}

@end
