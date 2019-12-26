//
//  quickBattleConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseDBReader.h"

#pragma mark - Class QBVipLevel
@interface QBVipLevel : NSObject

@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger moneyType;
@property (nonatomic, assign) NSInteger moneyNum;

@end
//--------------------------------------------------------

#pragma mark - Class QuickBattleDef
@interface QuickBattleDef : NSObject

@property (nonatomic, assign) NSInteger vipRank;
@property (nonatomic, strong) NSDictionary *levelDatas;

-(BOOL)addQBVipLevelIntoLevelDatas:(QBVipLevel *)def;
-(QBVipLevel *)getQBVipLevelWithTime:(NSInteger)time;

@end
//--------------------------------------------------------

#pragma mark - Class QuickBattleConfig
@interface QuickBattleConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(QuickBattleConfig *)share;

-(QuickBattleDef *)getQuickBattleDefWithLevel:(NSInteger)lv;

// 很少用到的方法   我也不知道当初写了干嘛的
-(NSInteger)getQuickBattleCostWithLevel:(NSInteger)lv countOf:(NSInteger)times kindOf:(NSInteger)type;
@end