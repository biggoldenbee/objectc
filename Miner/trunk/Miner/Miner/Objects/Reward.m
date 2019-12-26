//
//  Reward.m
//  Miner
//
//  Created by zhihua.qian on 14-12-19.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "Reward.h"

@implementation Reward

-(void)setDataWithDictionary:(NSDictionary*)data
{
    self.rewardId   = [data objectForKey:@"RID"];
    self.rewardType   = [data objectForKey:@"Type"];
    self.rewardMid   = [data objectForKey:@"MID"];
    self.rewardData   = [data objectForKey:@"Data"];
    self.rewardTC   = [data objectForKey:@"TC"];
    self.rewardMoney   = [data objectForKey:@"Money"];
    self.rewardCoin   = [data objectForKey:@"Money"];
    self.rewardExp   = [data objectForKey:@"Exp"];
    
    
}

@end
