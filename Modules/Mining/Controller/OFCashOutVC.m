//
//  OFCashOutVC.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFCashOutVC.h"
#import "OFReceiveProfitCell.h"
#import "OFCodeAlertView.h"
#import "OFTransferDetailVC.h"

@interface OFCashOutVC ()

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

static NSString *const cellID = @"OFReceiveProfitCell";
@implementation OFCashOutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self layout];
}

#pragma mark - 初始化UI
- (void) setupUI{
    if (self.type == miningProfit) {
        self.title = @"矿池提现";
    }else if(self.type == candyProfit){
        self.title = @"糖果提现";
    }else{
        self.title = @"红包提现";
    }
    [self addNavigationItemWithTitles:@[@"提现记录"] isLeft:NO target:self action:@selector(detailBtnClick) tags:nil];
    [self.tableView registerNib:[OFReceiveProfitCell nib] forCellReuseIdentifier:cellID];
    self.tableView.mj_header = nil;
    self.tableView.mj_footer = nil;
    self.tableView.rowHeight = 70.0f;
    [self.view addSubview:self.tableView];
}

#pragma mark - 布局
-(void)layout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0 );
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return KcurUser.wallets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OFReceiveProfitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OFWalletModel *model = [NDataUtil classWithArray:[OFWalletModel class] array:KcurUser.wallets index:indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *money;
    if (self.type == miningProfit) {
        money = [NDataUtil stringWith:self.miningReward valid:@"0.00"];
    }else if(self.type == candyProfit){
        money = [NDataUtil stringWith:self.candyReward valid:@"0.00"];
    }else{
        money = [NDataUtil stringWith:self.redPacketReward valid:@"0.00"];
    }
    if ([money doubleValue] == 0.00) {
        [MBProgressHUD showError:@"您已经无收益可领"];
        return;
    }
    if ([money doubleValue] < 100.0) {
        [MBProgressHUD showError:@"最小领取额度为100OF"];
        return;
    }
    
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"福币将在3个工作日内到达您的OF钱包，活动期间免手续费。如果有任何问题请联系客服微信：OFOFOFCOIN" preferredStyle:UIAlertControllerStyleAlert];
    //
    //    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        //
    
    self.indexPath = indexPath;
    [self showCodeAlertView];
    //    }];
    //
    //    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    //
    //    NSString *key = @"_titleTextColor";
    //
    //    [action setValue:OF_COLOR_MAIN_THEME forKey:key];
    //    [action1 setValue:Cancle_Color forKey:key];
    //
    //    [alert addAction:action];
    //    [alert addAction:action1];
    //    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 弹出验证码验证
- (void)showCodeAlertView{
    WEAK_SELF;
    OFCodeAlertView *v = [OFCodeAlertView loadFromXib];
    v.frame = self.view.window.bounds;
    [v show:self.view.window btnblock:^(NSString *codeStr) {
        NSLog(@"验证码: %@",codeStr);
        [weakSelf transferMoney:weakSelf.indexPath codeStr:codeStr view:v];
    }];
}


- (void)transferMoney:(NSIndexPath *)indexPath codeStr:(NSString *)codeStr view:(OFCodeAlertView *)v{
    OFWalletModel *model = [NDataUtil classWithArray:[OFWalletModel class] array:KcurUser.wallets index:indexPath.row];
    NSString *money;
    if (self.type == miningProfit) {
        money = [NDataUtil stringWith:self.miningReward valid:@"0.00"];
    }else if(self.type == candyProfit){
        money = [NDataUtil stringWith:self.candyReward valid:@"0.00"];
    }else{
        money = [NDataUtil stringWith:self.redPacketReward valid:@"0.00"];
    }
    //    NSLog(@"可领取金额 : %@",money);
    //    return;
    [MBProgressHUD showMessage:@"领取中..." toView:self.view];
    WEAK_SELF;
    if (self.type == miningProfit) {
        [OFNetWorkHandle transferMoneyToAddress:model.wid code:codeStr success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
            NSString *message = dict[@"message"];
            [v close];
            if (status == 200) {
                //领取成功后销毁验证码窗口
                [self AlertWithTitle:@"提醒" message:message andOthers:@[@"好的"] animated:YES action:^(NSInteger index) {
                    if (weakSelf.miningSucBlock) {
                        weakSelf.miningSucBlock();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                [OFMobileClick event:MobileClick_mining_receive_suc];
//                NSString *money = @"0.00";
                //            if (weakSelf.selectedBtn == weakSelf.candyBtn) {
                //                weakSelf.candyReward = @"0.00";
                //            }
                //            if (weakSelf.selectedBtn == weakSelf.miningProfitBtn) {
                //                weakSelf.miningReward = @"0.00";
                //            }
//                weakSelf.numberLabel.text = [NSString stringWithFormat:@"%.3f",[[NDataUtil stringWith:money valid:@"0.00"] doubleValue]];
            }else{
                [self AlertWithTitle:@"提醒" message:message andOthers:@[@"好的"] animated:YES action:^(NSInteger index) {
                    
                }];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
            NSString *string = [NSString stringWithFormat:@"%@ - %zd",error.localizedDescription,error.code];
            [MBProgressHUD showError:string];
        }];
    }else if(self.type == candyProfit){
        [OFNetWorkHandle transferCandyToAddress:model.wid code:codeStr success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
            NSString *message = dict[@"message"];
            [v close];
            if (status == 200) {
                //领取成功后销毁验证码窗口
                [self AlertWithTitle:@"提醒" message:message andOthers:@[@"确定"] animated:YES action:^(NSInteger index) {
                    if (weakSelf.candySucBlock) {
                        weakSelf.candySucBlock();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                [OFMobileClick event:MobileClick_tangguo_received_suc];
            }else{
                [self AlertWithTitle:@"提醒" message:message andOthers:@[@"确定"] animated:YES action:^(NSInteger index) {
                }];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
            NSString *string = [NSString stringWithFormat:@"%@ - %zd",error.localizedDescription,error.code];
            [MBProgressHUD showError:string];
        }];
    }else{
        [OFNetWorkHandle transferRedPacketToAddress:model.wid code:codeStr success:^(NSDictionary *dict) {
            NSLog(@"%@",dict);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            NSInteger status = [NDataUtil intWith:dict[@"status"] valid:0];
            NSString *message = dict[@"message"];
            [v close];
            if (status == 200) {
                //领取成功后销毁验证码窗口
                [self AlertWithTitle:@"提醒" message:message andOthers:@[@"确定"] animated:YES action:^(NSInteger index) {
                    if (weakSelf.candySucBlock) {
                        weakSelf.candySucBlock();
                    }
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }];
                [OFMobileClick event:MobileClick_tangguo_received_suc];
            }else{
                [self AlertWithTitle:@"提醒" message:message andOthers:@[@"确定"] animated:YES action:^(NSInteger index) {
                }];
            }
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            
            NSString *string = [NSString stringWithFormat:@"%@ - %zd",error.localizedDescription,error.code];
            [MBProgressHUD showError:string];
        }];
    }
}

#pragma mark - 转入记录
- (void)detailBtnClick{
    OFTransferDetailVC *vc = [[OFTransferDetailVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
