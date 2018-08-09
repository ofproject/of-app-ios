//
//  OFTextVC.m
//  OFBank
//
//  Created by 胡堃 on 2018/1/19.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFTextVC.h"
#import "NWaveView.h"

@interface OFTextVC ()



@end

@implementation OFTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
    
    
    NWaveView *waveView = [[NWaveView alloc] init];
    waveView.waveSpeed = 1.5f;
    waveView.waveHeight = [NUIUtil fixedHeight:5];
    waveView.userInteractionEnabled = NO;
    
    [view addSubview:waveView];
    
    view.backgroundColor = OF_COLOR_MAIN_THEME;
    
    [self.view addSubview:view];
    
    
    [waveView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [waveView startWaveAnimation];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
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
