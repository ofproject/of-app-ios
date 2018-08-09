//
//  OFBaseMiningPoolVC.m
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFBaseMiningPoolVC.h"

@interface OFBaseMiningPoolVC ()


@end

@implementation OFBaseMiningPoolVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = OF_COLOR_BACKGROUND;
}

#pragma mark - refresh action
- (void)refreshAction{
    
}

#pragma mark - OFPoolSectionViewDelegate
- (void)sectionView:(OFPoolSectionView *)sectionView didSelectedButtonIndex:(NSUInteger)index
{
    
}

#pragma mark - TableView dataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSAssert(0, @"Need override At subclass");
    return 0;
}

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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001f;
}

#pragma mark - lazy load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60.0;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorColor= [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (UIView *)headerView
{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.55 + 10)];
    }
    return _headerView;
}

- (OFPartMenu *)partMenu
{
    if (!_partMenu) {
        _partMenu = [[OFPartMenu alloc] initWithFrame:CGRectMake(0, kScreenWidth * 0.35, kScreenWidth, kScreenWidth * 0.2)];
        _partMenu.backgroundColor = OF_COLOR_WHITE;
    }
    return _partMenu;
}

- (OFPoolSectionView *)sectionHeader
{
    if (!_sectionHeader) {
        _sectionHeader = [[OFPoolSectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        _sectionHeader.backgroundColor = OF_COLOR_WHITE;
        _sectionHeader.delegate = self;
    }
    return _sectionHeader;
}

- (UIRefreshControl *)refresh{
    if (!_refresh) {
        _refresh = [[UIRefreshControl alloc]init];
        [_refresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    }
    return _refresh;
}

@end
