//
//  OFTeamCell.h
//  OFBank
//
//  Created by hukun on 2018/2/8.
//  Copyright © 2018年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@class OFPoolModel;
@protocol OFTeamCellDelegate

- (void)joinTeam:(OFPoolModel *)model;

@end


@interface OFTeamCell : UITableViewCell

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) OFPoolModel *model;

@end



