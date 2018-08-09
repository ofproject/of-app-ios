//
//  OFProWalletListVC.m
//  OFBank
//
//  Created by michael on 2018/5/30.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFProWalletListVC.h"
#import "OFWalletCell.h"
#import "OFWalletModel.h"

#import "OFProWalletDetailVC.h"

#import "OFCreateWalletController.h"

#import "OFImportKeyVC.h"

@interface OFProWalletListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIButton *creatBtn;

@property (nonatomic, strong) UIButton *importBtn;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

static NSString *const cellID = @"OFWalletCell";

@implementation OFProWalletListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"钱包列表";
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.creatBtn];
    [self.view addSubview:self.importBtn];
    
    
    CGFloat height = 41;
    
    if (IS_IPHONE_X) {
        height = 71;
    }
    
    
    [self.creatBtn mas_makeConstraints:^(MASConstraintMaker *make) {

        make.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    [self.importBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
        make.left.bottom.mas_equalTo(0);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(self.creatBtn.mas_top);
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
    
    [self reloadNewData];
    
    
    
}

- (void)reloadNewData{
    
    if (KcurUser.proWallets.count == self.dataArray.count) {
        return;
    }
    [self.dataArray removeAllObjects];
    if (KcurUser.proWallets.count > 0) {
        
        [KcurUser.proWallets enumerateObjectsUsingBlock:^(OFProWalletModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            OFWalletModel *model = [[OFWalletModel alloc]init];
            model.name = [NDataUtil stringWith:obj.name valid:@"OF"];
            model.address = [NDataUtil stringWith:obj.address valid:@"--"];
            model.imageUrl = @"http://file.lingzhuworld.cn:80/group1/M00/00/00/rBEW81rLBIWAFb0ZAAAsV7qYUnY967.png";
            model.balance = [NDataUtil stringWith:obj.balance valid:@"0.00"];
            [self.dataArray addObject:model];
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - tableView 代理数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OFWalletCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    OFWalletModel *model = [NDataUtil classWithArray:[OFWalletModel class] array:self.dataArray index:indexPath.row];
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    OFProWalletDetailVC *vc = [[OFProWalletDetailVC alloc]init];
    
    OFProWalletModel *model = [NDataUtil classWithArray:[OFProWalletModel class] array:KcurUser.proWallets index:indexPath.row];
    
    vc.title = [NDataUtil stringWith:model.name valid:@"钱包"];
    
    vc.model = model;
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)creatBtnClick{
    OFCreateWalletController *vc = [[OFCreateWalletController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)importBtnClick{
    OFImportKeyVC *vc = [[OFImportKeyVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView{
    if (_tableView == nil){
        _tableView = [[UITableView alloc]init];
        [_tableView registerNib:[OFWalletCell nib] forCellReuseIdentifier:cellID];
        
        _tableView.rowHeight = KWidthFixed(62.5);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor= [UIColor clearColor];
        
    }
    return _tableView;
}

- (UIButton *)creatBtn{
    if (!_creatBtn) {
        _creatBtn = [UIButton buttonWithTitle:@"创建钱包" titleColor:OF_COLOR_WHITE backgroundColor:OF_COLOR_MAIN_THEME font:OF_FONT_DETAILTITLE target:self action:@selector(creatBtnClick)];
        [_creatBtn setBackgroundImage:OF_IMAGE_DRADIENT(kScreenWidth/2, 41) forState:UIControlStateNormal];
    }
    return _creatBtn;
}

- (UIButton *)importBtn{
    if (!_importBtn) {
        _importBtn = [UIButton buttonWithTitle:@"导入钱包" titleColor:OF_COLOR_WHITE backgroundColor:OF_COLOR_MAIN_THEME font:OF_FONT_DETAILTITLE target:self action:@selector(importBtnClick)];
        
        UIImage *image = [UIImage imageWithColor:[UIColor colorWithRGB:0x1fcfa1] withSize:CGSizeMake(kScreenWidth/2, 41)];
        [_importBtn setBackgroundImage:image forState:UIControlStateNormal];
    }
    return _importBtn;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
