//
//  OFChooseWordLogic.m
//  OFBank
//
//  Created by xiepengxiang on 2018/5/28.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFChooseWordLogic.h"

@interface OFChooseWordLogic ()

@property (nonatomic, strong) NSMutableArray *showWords;
@property (nonatomic, strong) NSMutableArray *chooseWords;

@end

@implementation OFChooseWordLogic

- (instancetype)initWithDelegate:(id)delegate words:(NSArray *)words
{
    self = [super initWithDelegate:delegate];
    if (self) {
        _chooseWords = [NSMutableArray arrayWithArray:words];
        _showWords = [NSMutableArray array];
    }
    return self;
}

- (NSArray *)getShowWords
{
    return self.showWords.copy;
}

- (NSArray *)getChosenWords
{
    return self.chooseWords.copy;
}

#pragma mark - callback
- (void)updateCallback
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateChosenWords)]) {
        [self.delegate updateChosenWords];
    }
}

#pragma mark - Action
- (void)chooseWord:(NSString *)word
{
    if ([_chooseWords containsObject:word]) {
        [self.showWords addObject:word];
        [_chooseWords removeObject:word];
        [_chooseWords sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if (arc4random_uniform(2) == 0) {
                return [obj2 compare:obj1];
            }else{
                return [obj1 compare:obj2];
            }
        }];
        [self updateCallback];
    }
}

- (void)cancleChooseWord:(NSString *)word
{
    if ([_showWords containsObject:word]) {
        [_chooseWords addObject:word];
        [_showWords removeObject:word];
        [_chooseWords sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            if (arc4random_uniform(2) == 0) {
                return [obj2 compare:obj1];
            }else{
                return [obj1 compare:obj2];
            }
        }];
        [self updateCallback];
    }
}

#pragma mark - private
- (NSMutableArray *)sortRandom:(NSArray *)array
{
    NSInteger count = array.count;
    NSMutableArray *dataArray = [NSMutableArray arrayWithArray:array];
    NSMutableArray *sortArray = [NSMutableArray arrayWithCapacity:count];
    for (NSInteger i = 0; i < count; i++) {
        if (dataArray.count == 1) {
            [sortArray addObject:dataArray.firstObject];
            break;
        }
        int random = arc4random() % (count - i);
        if (random < dataArray.count) {
            id obj = [dataArray objectAtIndex:random];
            [sortArray addObject:obj];
            [dataArray removeObject:obj];
        }
    }
    return sortArray;
}

@end
