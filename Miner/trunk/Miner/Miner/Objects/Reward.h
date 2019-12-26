//
//  Reward.h
//  Miner
//
//  Created by zhihua.qian on 14-12-19.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reward : NSObject

@property (nonatomic, strong) NSNumber* rewardId;
@property (nonatomic, strong) NSNumber* rewardType;
@property (nonatomic, strong) NSNumber* rewardMid;
@property (nonatomic, strong) NSNumber* rewardData;
@property (nonatomic, strong) NSNumber* rewardTC;
@property (nonatomic, strong) NSNumber* rewardMoney;
@property (nonatomic, strong) NSNumber* rewardCoin;
@property (nonatomic, strong) NSNumber* rewardExp;

@property (nonatomic, strong) NSArray* rewardAS;
@property (nonatomic, strong) NSArray* rewardEquips;
@property (nonatomic, strong) NSArray* rewardItems;

-(void)setDataWithDictionary:(NSDictionary*)data;

@end
