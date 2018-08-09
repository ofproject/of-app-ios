//
//  OFTestRandomVC.m
//  OFBank
//
//  Created by michael on 2018/6/1.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFTestRandomVC.h"
#import "OFCipherManager.h"
#import "OFTestCell.h"

@interface OFTestRandomVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UILabel *tipLabel1;
@property (nonatomic, strong) UILabel *tipLabel2;
@property (nonatomic, strong) UILabel *tipLabel3;
@property (nonatomic, strong) UILabel *tipLabel4;
@property (nonatomic, strong) UILabel *tipLabel5;

@property (nonatomic, strong) UILabel *tipLabel6;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *tempArray;

// 循环次数
@property (nonatomic, assign) NSInteger num1;

// 重复次数
@property (nonatomic, assign) NSInteger num2;

// 单次助记词重复次数
@property (nonatomic, assign) NSInteger num3;

// 汉字使用个数
@property (nonatomic, assign) NSInteger num4;

@property (nonatomic, strong) NSMutableDictionary *dict;

@property (nonatomic, strong) NSMutableSet *testArray;

@end

@implementation OFTestRandomVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"随机性测试";
    [self initUI];
    [self layout];
    [self initData];
    
    [self addNavigationItemWithTitles:@[@"刷新"] isLeft:NO target:self action:@selector(initData) tags:nil];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self test];
    });
}

- (void)initUI{
    [self.view addSubview:self.tableView];
    [self.topView addSubview:self.tipLabel1];
    [self.topView addSubview:self.tipLabel2];
    [self.topView addSubview:self.tipLabel3];
    [self.topView addSubview:self.tipLabel4];
    [self.topView addSubview:self.tipLabel5];
    [self.topView addSubview:self.tipLabel6];
    self.tableView.tableHeaderView = self.topView;
    
}

- (void)layout{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.tipLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(15);
    }];
    
    [self.tipLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.tipLabel1.mas_bottom).offset(5);
    }];
    
    [self.tipLabel3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.tipLabel2.mas_bottom).offset(5);
    }];
    
    [self.tipLabel4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.tipLabel3.mas_bottom).offset(5);
    }];
    
    [self.tipLabel5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.tipLabel4.mas_bottom).offset(5);
    }];
    
    [self.tipLabel6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.top.mas_equalTo(self.tipLabel5.mas_bottom).offset(5);
    }];
    
}


- (void)initData{
    
    self.tipLabel1.text = [NSString stringWithFormat:@"循环次数:%zd",self.num1];
    self.tipLabel2.text = [NSString stringWithFormat:@"重复次数:%zd",self.num2];
    self.tipLabel3.text = [NSString stringWithFormat:@"单次生成助记词重复次数:%zd",self.num3];
    self.tipLabel4.text = [NSString stringWithFormat:@"已经使用汉字个数:%zd",self.num4];
    
    
    __block NSInteger mix = 1000000000000000000;
    __block NSInteger max = 0;
    __block NSString *mixStr;
    __block NSString *maxStr;
    __block NSMutableString *str = [NSMutableString string];
    [self.dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.integerValue > max) {
            max = obj.integerValue;
            maxStr = key;
        }
        
        if (obj.integerValue < mix) {
            mix = obj.integerValue;
            mixStr = key;
        }
        
        if (obj.integerValue < max * 0.5) {
//            [str appendString:key];
            [str appendFormat:@"%@%zd ",key,obj.integerValue];
        }
        
    }];
    
    self.tipLabel5.text = [NSString stringWithFormat:@"最小次数%zd %@- 最大次数%zd %@",mix,mixStr,max,maxStr];
    
    self.tipLabel6.text = str;
    
    [self.tableView reloadData];
    
}

- (void)test{
    
    
    
//    for (int i = 0; i < 2; i++) {
////        @autoreleasepool{
//        
//            self.num1++;
//            NSArray *arr = [OFCipherManager testWord];
//            // 是否有重复的字符串
//            //            NSLog(@"%zd - %@",self.num1,arr);
//            // 是否有重复的助记词
//            if ([self.testArray containsObject:arr]) {
//                self.num2++;
//            }else{
//                [self.testArray addObject:arr];
//            }
//            
//            // 统计个数
//            [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                NSInteger n = [NDataUtil intWith:self.dict[obj] valid:0];
//                n++;
//                self.dict[obj] = [NSNumber numberWithInteger:n];
//            }];
//            
//            // 已经使用的汉字个数
//            if (self.num4 <= 2048) {
//                
//                __block NSInteger num = 0;
//                [self.dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber *_Nonnull obj, BOOL * _Nonnull stop) {
//                    
//                    NSNumber *nub = self.dict[key];
//                    if (nub.integerValue > 0) {
//                        num++;
//                    }
//                }];
//                self.num4 = num;
//            }
////        }
//    }
//    
//    return;
    do {
//        @autoreleasepool{
        
            self.num1++;
            NSArray *arr = [OFCipherManager testWord];
            // 是否有重复的字符串
//            NSLog(@"%zd - %@",self.num1,arr);
            // 是否有重复的助记词
            if ([self.testArray containsObject:arr]) {
                self.num2++;
            }else{
                [self.testArray addObject:arr];
            }
            
            // 统计个数
            [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger n = [NDataUtil intWith:self.dict[obj] valid:0];
                self.dict[obj] = @(n+1);
            }];
            
            // 已经使用的汉字个数
            if (self.num4 <= 2048) {
                
                __block NSInteger num = 0;
                [self.dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber *_Nonnull obj, BOOL * _Nonnull stop) {
                    
                    NSNumber *nub = self.dict[key];
                    if (nub.integerValue > 0) {
                        num++;
                    }
                }];
                self.num4 = num;
            }
//        }
    } while (YES);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OFTestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
//    NSDictionary *dict = [NDataUtil dictWithArray:self.dataArray index:indexPath.row];
    NSString *str = [NDataUtil stringWithArray:self.dataArray index:indexPath.row];
    
    cell.titleLabel.text = str;
    NSNumber *num = self.dict[str];
    NSInteger n = num.integerValue;
    cell.remarkLabel.text = [NSString stringWithFormat:@"%zd",n];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self initData];
//    [self.tableView reloadData];
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        _topView.backgroundColor = OF_COLOR_MAIN_THEME;
    }
    return _topView;
}

- (UILabel *)tipLabel1{
    if (!_tipLabel1) {
        _tipLabel1 = [[UILabel alloc]init];
    }
    return _tipLabel1;
}

- (UILabel *)tipLabel2{
    if (!_tipLabel2) {
        _tipLabel2 = [[UILabel alloc]init];
    }
    return _tipLabel2;
}

- (UILabel *)tipLabel3{
    if (!_tipLabel3) {
        _tipLabel3 = [[UILabel alloc]init];
    }
    return _tipLabel3;
}

- (UILabel *)tipLabel4{
    if (!_tipLabel4) {
        _tipLabel4 = [[UILabel alloc]init];
    }
    return _tipLabel4;
}

- (UILabel *)tipLabel5{
    if (!_tipLabel5) {
        _tipLabel5 = [[UILabel alloc]init];
    }
    return _tipLabel5;
}

- (UILabel *)tipLabel6{
    if (!_tipLabel6) {
        _tipLabel6 = [[UILabel alloc]init];
        _tipLabel6.numberOfLines = 0;
    }
    return _tipLabel6;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        [_tableView registerClass:[OFTestCell class] forCellReuseIdentifier:@"cell"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 60;
        _tableView.separatorColor= [UIColor clearColor];
        
    }
    return _tableView;
}


- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        NSBundle *resourceBundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"OFPrivateKey" withExtension:@"bundle"]];
        NSString *filePath = [resourceBundle pathForResource:@"dic" ofType:@"txt"];
        
        NSString *words = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        id temp = [NDataUtil getDictWithString:words];
        
        NSArray *array = (NSArray *)temp;
        _dataArray = [NSMutableArray array];
        [array enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [_dataArray addObject:obj];
        }];
    }
    return _dataArray;
}

- (NSMutableDictionary *)dict{
    
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
        NSBundle *resourceBundle = [NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"OFPrivateKey" withExtension:@"bundle"]];
        NSString *filePath = [resourceBundle pathForResource:@"dic" ofType:@"txt"];
        
        NSString *words = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
        id temp = [NDataUtil getDictWithString:words];
        NSArray *array = (NSArray *)temp;
        
        [array enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            _dict[obj] = @0;
        }];
    }
    return _dict;
}

- (NSMutableArray *)tempArray{
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
        [_tempArray addObjectsFromArray:self.dataArray];
    }
    return _tempArray;
}

-(NSMutableSet *)testArray{
    if (!_testArray) {
        _testArray = [NSMutableSet set];
    }
    return _testArray;
}

@end
