//
//  OFBaseTableViewController.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/4.
//  Copyright © 2018年 胡堃. All rights reserved.
//  tableview的基类 继承与rootVC

#import "OFViewController.h"

@interface OFBaseTableViewController : OFViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) UITableViewStyle tableViewStyle;

@property (nonatomic, strong) UITableView * tableView;

-(void)headerRereshing;

-(void)footerRereshing;


@end
