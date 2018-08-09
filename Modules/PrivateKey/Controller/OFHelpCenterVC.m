//
//  OFHelpCenterVC.m
//  OFBank
//
//  Created by michael on 2018/6/27.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFHelpCenterVC.h"
#import "OFProfileCell.h"

//#import "OFProfileItem.h"

@interface OFHelpCenterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation OFHelpCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"帮助中心";
    
    
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor colorWithRGB:0xefeff4];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
}

#pragma mark - UITableViewDelegate & DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OFProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:kOFProfileCellIdentifier];
    OFProfileItem *item = [NDataUtil classWithArray:[OFProfileItem class] array:self.dataArray index:indexPath.row];
    [cell update:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    OFProfileItem *item = [NDataUtil classWithArray:[OFProfileItem class] array:self.dataArray index:indexPath.row];
    NSString *title = item.title;
    NSString *fileName = item.fileName;
    
    OFWebViewController *webVC = [[OFWebViewController alloc]init];
    webVC.title = title;
    if (item.fileName) {
        NSString *urlString = [[NSBundle mainBundle] pathForResource:fileName ofType:@"html"];
        NSString *htmlString = [NSString stringWithContentsOfFile:urlString encoding:NSUTF8StringEncoding error:nil];
        webVC.htmlStr = htmlString;
    }else if(item.urlString){
        webVC.urlString = item.urlString;
    }
    
    [self.navigationController pushViewController:webVC animated:YES];

    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[OFProfileCell class] forCellReuseIdentifier:kOFProfileCellIdentifier];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 62;
        _tableView.sectionHeaderHeight = 15;
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
        
        
        OFProfileItem *item1 = [[OFProfileItem alloc] init];
        item1.title = @"挖矿攻略";
        item1.urlString = NSStringFormat(@"%@%@",URL_H5_main,URL_H5_MineralStrategy);
        item1.icon = @"profile_mining";
        item1.type = ProfileCellTypeTop;
        
        OFProfileItem *item2 = [[OFProfileItem alloc] init];
        item2.title = @"交易攻略";
        item2.urlString = NSStringFormat(@"%@%@",URL_H5_main,URL_H5_SaleStrategy);
        item2.icon = @"profile_buy_icon";
        item2.type = ProfileCellTypeBottom;
        
        
        _dataArray = @[item1,item2];
        
//        NSDictionary *dict1 = @{@"title":@"手机号",@"remark":[NDataUtil stringWith:KcurUser.phone valid:@""]};
//        //        NSDictionary *dict1 = @{@"title":@"手机号",@"remark":KcurUser.phone};
//        //        NSDictionary *dict2 = @{@"title":@"邮箱",@"remark":KcurUser.email};
//        NSDictionary *dict3 = @{@"title":@"修改密码",@"remark":@""};
//        NSDictionary *dict4 = @{@"title":@"实名认证",@"remark":@""};
//        _dataArray = @[dict1,dict3,dict4];
        
        
        
        
    }
    return _dataArray;
}

@end
