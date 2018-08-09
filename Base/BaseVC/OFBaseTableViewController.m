//
//  OFBaseTableViewController.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/4.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFBaseTableViewController.h"

@interface OFBaseTableViewController ()

@end

@implementation OFBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _tableViewStyle = UITableViewStyleGrouped;
}

- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle
{
    if (tableViewStyle != _tableViewStyle) {
        _tableViewStyle = tableViewStyle;
    }
}

/**
 *  懒加载UITableView
 *
 *  @return UITableView
 */
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - Nav_Height) style:_tableViewStyle];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [_tableView setSeparatorColor:OF_COLOR_SEPARATOR];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        //头部刷新
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
        header.automaticallyChangeAlpha = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        [header setTitle:@"刷新数据中..." forState:MJRefreshStateRefreshing];
        _tableView.mj_header = header;
        
        //底部刷新
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        
        _tableView.backgroundColor = KWhiteColor;
        //        _tableView.backgroundColor=CViewBgColor;
        _tableView.scrollsToTop = YES;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}

-(void)headerRereshing{
    
}

-(void)footerRereshing{
    
}

#pragma mark - TableView dataSource & delegate
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    NSAssert(0, @"Need override At subclass");
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSAssert(0, @"Need override At subclass");
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAssert(0, @"Need override At subclass");
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0001f;
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
