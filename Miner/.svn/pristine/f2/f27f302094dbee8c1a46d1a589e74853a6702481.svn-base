//
//  quickBattleConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "QuickBattleConfig.h"

@implementation QBVipLevel

@end
// -------------------------------------------------------------------------------------------------

@implementation QuickBattleDef

-(id)init
{
    self = [super init];
    
    self.levelDatas = [[NSDictionary alloc]init];
    
    return self;
}

-(BOOL)addQBVipLevelIntoLevelDatas:(QBVipLevel *)qbv
{
    NSString *key = [NSString stringWithFormat:@"%lu", qbv.time];
    QBVipLevel *tempDef = [self.levelDatas objectForKey:key];
    if (tempDef != nil)
    {
        return NO;
    }
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[self levelDatas]];
    [tempDict setValue:qbv forKey:key];
    self.levelDatas = tempDict;
    return YES;
}

-(QBVipLevel *)getQBVipLevelWithTime:(NSInteger)time
{
    QBVipLevel *qbv = [self.levelDatas objectForKey:[NSString stringWithFormat:@"%lu", time]];
    return qbv;
}

@end
//----------------------------------------------------------------------------------------------

@implementation QuickBattleConfig

static QuickBattleConfig * _quickBattleConfig = nil;

+(QuickBattleConfig *)share
{
    if (_quickBattleConfig == nil)
    {
        _quickBattleConfig = [[QuickBattleConfig alloc]init];
    }
    return _quickBattleConfig;
}

-(void)dealloc
{
    Definitions = nil;
}

-(void)reset
{
    [super reset];
    Definitions = nil;
}

//
// 重载了父类的方法
//
-(void)initWithString:(NSString *)buffer
{
    NSArray *rows = [buffer componentsSeparatedByString:@"\r\n"];
    Definitions = [[NSMutableDictionary alloc]init];
    for (int k=1; k<[rows count]-1; k++)
    {
        NSArray *cols = [[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        
        int i=0;
        NSInteger vl = [[cols objectAtIndex:i++] integerValue];
        QuickBattleDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", vl]];
        if (def == nil)
        {
            def = [[QuickBattleDef alloc]init];
            def.vipRank = vl;
            [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.vipRank]];
        }
        
        QBVipLevel *qbv = [[QBVipLevel alloc]init];
        qbv.time = [[cols objectAtIndex:i++] integerValue];
        qbv.moneyType = [[cols objectAtIndex:i++] integerValue];
        qbv.moneyNum = [[cols objectAtIndex:i++] integerValue];
        [def addQBVipLevelIntoLevelDatas:qbv];
    }
}

//
// 根据vip等级  获取对应的 def
//
-(QuickBattleDef *)getQuickBattleDefWithLevel:(NSInteger)lv
{
    QuickBattleDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", lv]];
    
    return def;
}

//
// 根据vip等级 扩展的次数  货币的种类
// 获取这一次扩张的消耗
//
-(NSInteger)getQuickBattleCostWithLevel:(NSInteger)lv countOf:(NSInteger)times kindOf:(NSInteger)type
{
    QuickBattleDef *qbd = [self getQuickBattleDefWithLevel:lv];
    if (qbd != nil)
    {
        QBVipLevel *qbv = [qbd getQBVipLevelWithTime:times];
        return [qbv moneyNum];
    }
    return 0;
}
@end //----------------------------------------------------------------------------------------------
