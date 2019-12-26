//
//  Config.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "Config.h"

@implementation Config

-(void)setConfigDataWithDictionary:(NSDictionary *)data
{
    self.autoSellOneStarEquip = [[data objectForKey:@"AS1"] boolValue];
    self.autoSellTwoStarEquip = [[data objectForKey:@"AS2"] boolValue];
    self.autoSellThrStarEquip = [[data objectForKey:@"AS3"] boolValue];
    self.autoSellFourStarEquip = [[data objectForKey:@"AS4"] boolValue];
    self.autoSellFiveStarEquip = [[data objectForKey:@"AS5"] boolValue];
}

@end
