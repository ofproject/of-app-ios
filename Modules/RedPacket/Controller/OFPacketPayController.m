//
//  OFPacketPayController.m
//  OFBank
//
//  Created by xiepengxiang on 2018/6/7.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPacketPayController.h"
#import "OFPacketPayCell.h"
#import "OFPacketPayLogic.h"

@interface OFPacketPayController ()<OFPacketPayLogicDelegate>

@property (nonatomic, strong) OFPacketPayLogic *logic;

@end

@implementation OFPacketPayController

- (instancetype)initWithMinRedPacketAmount:(NSString *)amount
{
    self = [super init];
    if (self) {
        self.logic.minRedPacketAmount = amount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    [self initData];
}

- (void)initUI
{
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.backgroundColor = OF_COLOR_BACKGROUND;
    [self.tableView registerClass:[OFPacketPayCell class] forCellReuseIdentifier:OFPacketPayCellIdentifier];
    [self.view addSubview:self.tableView];
}

- (void)initData
{
    self.title = @"选择钱包";
    
    [self.logic getRedPacketReward];
}

#pragma mark - OFPacketPayLogicDelegate
- (void)requestRedPacketRewardSuccess
{
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.logic numberOfSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.logic itemCountOfSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFPacketPayCell *cell = [tableView dequeueReusableCellWithIdentifier:OFPacketPayCellIdentifier];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    OFPacketPayCell *walletCell = (OFPacketPayCell *)cell;
    OFWalletModel *wallet = [self.logic itemAtIndex:indexPath];
    [walletCell updateInfo:wallet canSelected:[self.logic canSelectedAtIndexPath:indexPath]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.logic heightForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.logic canSelectedAtIndexPath:indexPath]) return;
    OFWalletModel *wallet = [self.logic itemAtIndex:indexPath];
    [self callbackChooseWallet:wallet];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - callback
- (void)callbackChooseWallet:(OFWalletModel *)wallet
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(packetPayControllerChooseWallet:)]) {
        [self.delegate packetPayControllerChooseWallet:wallet];
    }
}

#pragma mark - lazy load
- (OFPacketPayLogic *)logic
{
    if (!_logic) {
        _logic = [[OFPacketPayLogic alloc] initWithDelegate:self];
    }
    return _logic;
}

@end
