//
//  OFBaseAPI.h
//  OFBank
//
//  Created by Xu Yang on 2018/4/5.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^finishedBlock)(BOOL success, id obj, NSError *error, NSString *messageStr);

@interface OFBaseAPI : NSObject

@end
