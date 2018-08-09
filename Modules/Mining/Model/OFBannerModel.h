//
//  OFBannerModel.h
//  OFBank
//
//  Created by xiepengxiang on 07/04/2018.
//  Copyright © 2018 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OFBannerModel : NSObject

@property (nonatomic, assign) NSInteger bannerType;
@property (nonatomic, assign) NSInteger bid;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *expireTime;
@property (nonatomic, strong) NSString *h5Url;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *nativeUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *sponsor;
@property (nonatomic, strong) NSString *updateTime;

@end
