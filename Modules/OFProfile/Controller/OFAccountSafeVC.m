//
//  OFAccountSafeVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/12.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFAccountSafeVC.h"
#import "OFAccountSafeCell.h"

#import "OFChangeEmailVC.h"
#import "OFChangePhoneVC.h"
#import "OFChangePassWordVC.h"
#import "config.h"
#import "OFTabBarController.h"

static NSString *const cellID = @"OFAccountSafeCell";

@interface OFAccountSafeVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIButton *logoutBtn;

@property (nonatomic, assign) CGFloat btnWidth;

@property (nonatomic, strong) UILabel *versionLabel;

@end

//CGFloat width = [NUIUtil fixedWidth:60];

@implementation OFAccountSafeVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *title1 = NSLocalizedString(@"accountSafe", nil);
    self.title = [NSString stringWithFormat:@"账号与安全"];
    NSLog(@"账号与安全");
    self.btnWidth = [NUIUtil fixedWidth:60];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor colorWithRGB:0xefeff4];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
//    self.versionLabel = [[UILabel alloc]init];
//    self.versionLabel.textColor = [UIColor grayColor];
//    self.versionLabel.font = [NUIUtil fixedFont:13];
//    self.versionLabel.text = [NSString stringWithFormat:@"当前版本 : %@",[Config appVersion]];
//
//    [self.view addSubview:self.versionLabel];
    
    
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(12.5, 0, 0, 0);
    
    [self.view addSubview:self.logoutBtn];
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([NUIUtil fixedWidth:60]);
        make.right.mas_equalTo(-[NUIUtil fixedWidth:60]);
        make.height.mas_equalTo(Btn_Default_Height);
        make.bottom.mas_equalTo(-150);
    }];
    
//    [self.versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-50);
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//    }];
    
}

- (void)logoutBtnClick{
//    [KcurUser logout];
    
    NSString *message = [NSString stringWithFormat:@"确定要退出吗?"];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    NSString *sure = [NSString stringWithFormat:@"确定"];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sure style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationLoginStateChange object:@(NO)];
    }];
    
    NSString *cancle = [NSString stringWithFormat:@"取消"];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        return ;
    }];
    
    NSString *key = @"_titleTextColor";
    
    [sureAction setValue:OF_COLOR_MAIN_THEME forKey:key];
    [cancleAction setValue:Cancle_Color forKey:key];
    
    
    [alert addAction:sureAction];
    [alert addAction:cancleAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OFAccountSafeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSDictionary *dict = [NDataUtil dictWithArray:self.dataArray index:indexPath.row];
    
    [cell upData:dict];
    
    [cell hiddenLine:(indexPath.row == 0)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            // 修改手机号
//        {
//            OFChangePhoneVC *vc = [[OFChangePhoneVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
            
            break;
//        case 2:
//            // 修改邮箱
//        {
//            OFChangeEmailVC *vc = [[OFChangeEmailVC alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
            break;
        case 1:
            // 修改密码
        {
            OFChangePassWordVC *vc = [[OFChangePassWordVC alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            
            break;
            
        default:
            break;
    }
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[OFAccountSafeCell class] forCellReuseIdentifier:cellID];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 42.5;
        _tableView.sectionHeaderHeight = 25;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorColor= [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
//        NSString *title1 = NSLocalizedString(@"moblie", nil);
//        NSString *title2 = NSLocalizedString(@"changePassword", nil);
        
        NSDictionary *dict1 = @{@"title":@"手机号",@"remark":[NDataUtil stringWith:KcurUser.phone valid:@""]};
//        NSDictionary *dict1 = @{@"title":@"手机号",@"remark":KcurUser.phone};
//        NSDictionary *dict2 = @{@"title":@"邮箱",@"remark":KcurUser.email};
        NSDictionary *dict3 = @{@"title":@"修改密码",@"remark":@""};
        _dataArray = @[dict1,dict3];
    }
    return _dataArray;
}

- (UIButton *)logoutBtn{
    if (!_logoutBtn) {
        _logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        NSString *title = NSLocalizedString(@"logout", nil);
        [_logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        CGSize size = CGSizeMake(KWidthFixed(200), KWidthFixed(35));
        UIImage *normal = [UIImage imageWithColor:[UIColor colorWithRGB:0xc3c3c3] size:size];
        UIImage *selected = [UIImage imageWithColor:OF_COLOR_MAIN_THEME size:size];
        [_logoutBtn setBackgroundImage:normal forState:UIControlStateNormal];
        [_logoutBtn setBackgroundImage:selected forState:UIControlStateSelected];
        _logoutBtn.layer.cornerRadius = 5;
        _logoutBtn.layer.masksToBounds = YES;
        [_logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _logoutBtn;
}

@end
