//
//  OFBaseMiningPoolVC.h
//  OFBank
//
//  Created by xiepengxiang on 03/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import "OFViewController.h"
#import "OFPartMenu.h"
#import "OFPoolSectionView.h"

@interface OFBaseMiningPoolVC : OFViewController <UITableViewDataSource, UITableViewDelegate, OFPoolSectionViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refresh;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) OFPartMenu *partMenu;
@property (nonatomic, strong) OFPoolSectionView *sectionHeader;

@end
