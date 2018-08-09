//
//  OFProWalletDetailVC.m
//  OFBank
//
//  Created by michael on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//  钱包详情

#import "OFProWalletDetailVC.h"

#import "OFAccountSafeCell.h"

#import "OFCipherManager.h"

#import "OFProChangePwdVC.h"

#import "OFSaveWordsVC.h"
#import "OFSaveKeystoreVC.h"
#import "OFSavePrivateVC.h"

@interface OFProWalletDetailVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *addrLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, copy) NSString *privateKey;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

static NSString *const cellID = @"OFAccountSafeCell";

@implementation OFProWalletDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self layout];
    [self initData];
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    
    [self.topView addSubview:self.iconView];
    [self.topView addSubview:self.nameLabel];
    [self.topView addSubview:self.addrLabel];
    [self.topView addSubview:self.lineView];
    self.tableView.tableHeaderView = self.topView;
    
    [self.view addSubview:self.deleteBtn];
}

- (void)initData{
    self.nameLabel.text = [NDataUtil stringWith:self.model.name valid:@"OF"];
    self.addrLabel.text = [NDataUtil stringWith:self.model.address valid:@"--"];
    
    self.title = self.nameLabel.text;
    
}

- (void)layout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 90));
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.centerY.mas_equalTo(self.topView.mas_centerY).offset(-5);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(15);
        make.top.mas_equalTo(self.iconView.mas_top).offset(5);
    }];
    
    [self.addrLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(self.iconView.mas_bottom);
        make.left.mas_equalTo(self.iconView.mas_right).offset(15);
        make.right.mas_equalTo(-30);
        make.bottom.mas_equalTo(self.iconView.mas_bottom).offset(-5);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(10);
    }];
    
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([NUIUtil fixedWidth:234], [NUIUtil fixedHeight:41]));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-150);
    }];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OFAccountSafeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSDictionary *dict = [NDataUtil dictWithArray:self.dataArray index:indexPath.row];
    
    [cell upData:dict];
    
//    [cell hiddenLine:(indexPath.row == 0)];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        // 修改资金密码
        OFProChangePwdVC *vc = [[OFProChangePwdVC alloc]init];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    WEAK_SELF;
    dispatch_block_t block;
    if (indexPath.row == 1) {
        block = ^{[weakSelf savePrivate];};
    }
    
    if (indexPath.row == 2) {
        block = ^{[weakSelf saveKeystore];};
    }
    
    if (indexPath.row == 3) {
        block = ^{[weakSelf saveWork];};
    }
    
    [self alertAction:block];
    
    // 输入资金密码才能跳转
}

- (void)alertAction:(dispatch_block_t)block {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入密码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.secureTextEntry = YES;
        textField.placeholder = @"请输入密码";
    }];
    WEAK_SELF;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields.firstObject;
        NSLog(@"password,%@",textField.text);
        
        [MBProgressHUD showMessage:@"验证中..." toView:weakSelf.view];
//        NSLog(@"%@,%@",model.keystore,model.address);
        [OFCipherManager getWalletScryptoKeyWithPassword:textField.text keystore:[NDataUtil stringWith:self.model.keystore valid:@""] address:[NDataUtil stringWith:self.model.address valid:@""] finished:^(BOOL success, id obj, NSError *error, NSString *errorMessage) {
            [MBProgressHUD hideHUDForView:self.view];
            if (success) {
                weakSelf.privateKey = [NDataUtil stringWith:obj valid:@"--"];
                if (block) {
                    block();
                }
            }else{
                [MBProgressHUD showToast:@"密码输入错误" toView:weakSelf.view];
            }
        }];
        
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    NSString *key = @"_titleTextColor";
    [sureAction setValue:OF_COLOR_MAIN_THEME forKey:key];
    [cancleAction setValue:Cancle_Color forKey:key];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)savePrivate{
    OFSavePrivateVC *vc = [[OFSavePrivateVC alloc]init];
    vc.privatekey = self.privateKey;
    vc.name = self.model.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveKeystore{
    OFSaveKeystoreVC *vc = [[OFSaveKeystoreVC alloc]init];
//    vc.keystore = self.model.keystore;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)saveWork{
    OFSaveWordsVC *vc = [[OFSaveWordsVC alloc]init];
//    vc.words = self.model.words;
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteBtnClick{
    NSString *message = [NSString stringWithFormat:@"确认要删除%@吗？",[NDataUtil stringWith:self.model.name valid:@"钱包"]];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    WEAK_SELF;
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        dispatch_block_t block = ^{[weakSelf deleteWallet];};
        
        [weakSelf alertAction:block];
        
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 取消
    }];
    NSString *key = @"_titleTextColor";
    [sureAction setValue:Cancle_Color forKey:key];
    [cancleAction setValue:OF_COLOR_MAIN_THEME forKey:key];
    
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)deleteWallet{
    
    NSDictionary *dict = [self.model modelToJSONObject];
    NSString *address = [NDataUtil stringWith:dict[@"address"] valid:@""];
    if (address.length < 1) {
        return;
    }
    
    [KcurUser.proWallets enumerateObjectsUsingBlock:^(OFProWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.address isEqualToString:address]) {
            [KcurUser.proWallets removeObject:obj];
            *stop = YES;
        }
    }];
    
    [KUserManager updateCanseeState];
    
    if ([self.model.address isEqualToString:KcurUser.currentProWallet.address]) {
        // 当前钱包为要删除的钱包
        if (KcurUser.proWallets.count > 0) {
            KcurUser.currentProWallet = KcurUser.proWallets.firstObject;
        }else{
            KcurUser.currentProWallet = nil;
        }
        
    }
    
    [MBProgressHUD showSuccess:@"删除成功！"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:OF_PRO_ADDRESS_NOTI object:[NSNumber numberWithBool:NO]];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UIView *)topView{
    if(!_topView){
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

- (UIImageView *)iconView{
    if(!_iconView){
        _iconView = [[UIImageView alloc]init];
        _iconView.image = [UIImage imageNamed:@"wallet_item_background1"];
        _iconView.layer.cornerRadius = 45.0/2;
        _iconView.layer.masksToBounds = YES;
    }
    return _iconView;
}

- (UILabel *)nameLabel{
    if(_nameLabel == nil){
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [NUIUtil fixedFont:14];
    }
    return _nameLabel;
}

- (UILabel *)addrLabel{
    if(_addrLabel == nil){
        _addrLabel = [[UILabel alloc]init];
        _addrLabel.textColor = OF_COLOR_DETAILTITLE;
        _addrLabel.font = [NUIUtil fixedFont:10];
        _addrLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
//        _addrLabel.numberOfLines = 0;
    }
    return _addrLabel;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[OFAccountSafeCell class] forCellReuseIdentifier:cellID];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 50;
        _tableView.sectionHeaderHeight = 25;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorColor= [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}


- (NSArray *)dataArray{
    if (_dataArray == nil){
        NSDictionary *dict1 = @{@"title":@"修改资金密码",@"remark":@""};
        NSDictionary *dict2 = @{@"title":@"导出私钥",@"remark":@""};
        NSDictionary *dict3 = @{@"title":@"导出keystore",@"remark":@""};
        
        if (self.model.words.length == 24) {
            NSDictionary *dict4 = @{@"title":@"导出助记词",@"remark":@""};
            _dataArray = @[dict1,dict2,dict3,dict4];
        }else{
            _dataArray = @[dict1,dict2,dict3];
        }
    }
    return _dataArray;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = OF_COLOR_BACKGROUND;
    }
    return _lineView;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithTitle:@"删除钱包" titleColor:[UIColor whiteColor] backgroundColor:[UIColor colorWithRGB:0xd6d6d6] font:[NUIUtil fixedFont:15]];
        
        [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _deleteBtn.layer.cornerRadius = 5.0;
        _deleteBtn.layer.masksToBounds = YES;
    }
    return _deleteBtn;
}

@end
