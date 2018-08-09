//
//  OFPrifitHeaderView.m
//  OFBank
//
//  Created by Xu Yang on 2018/4/11.
//  Copyright © 2018年 胡堃. All rights reserved.
//

#import "OFPrifitHeaderView.h"
#import "OFReceiveProfitVC.h"

@interface OFPrifitHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *wakuangLabel;
@property (weak, nonatomic) IBOutlet UILabel *tangguoLabel;

@end


@implementation OFPrifitHeaderView

-(void)awakeFromNib{
    [super awakeFromNib];
}

-(void)setMiningReward:(NSString *)miningReward{
    _miningReward = miningReward;
    self.wakuangLabel.text = [NSString stringWithFormat:@"%.3f",[[NDataUtil stringWith:self.miningReward valid:@"0.00"] doubleValue]];
}

-(void)setCandyReward:(NSString *)candyReward{
    _candyReward = candyReward;
    self.tangguoLabel.text = [NSString stringWithFormat:@"%.3f",[[NDataUtil stringWith:self.candyReward valid:@"0.00"] doubleValue]];

}

- (IBAction)getKuangchiProfit:(id)sender {
    NSLog(@"矿池收益");
    [OFMobileClick event:MobileClick_click_mining_receive];
    OFReceiveProfitVC *vc = [[OFReceiveProfitVC alloc]init];
    vc.title = @"领取矿池收益";
    vc.type = miningProfit;
    vc.miningReward = self.miningReward;
    vc.candyReward = self.candyReward;
    [[JumpUtil currentVC].navigationController pushViewController:vc animated:YES];
}
- (IBAction)getTangguoProfit:(id)sender {
    NSLog(@"糖果收益");
    [OFMobileClick event:MobileClick_click_tangguo_receive];
    OFReceiveProfitVC *vc = [[OFReceiveProfitVC alloc]init];
    vc.title = @"领取糖果收益";
    vc.type = candyProfit;
    vc.miningReward = self.miningReward;
    vc.candyReward = self.candyReward;
    [[JumpUtil currentVC].navigationController pushViewController:vc animated:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
