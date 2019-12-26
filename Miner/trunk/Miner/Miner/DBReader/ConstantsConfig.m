//
//  ConstantsConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "ConstantsConfig.h"

@implementation ConstantsDef

@end

@implementation ConstantsConfig

static ConstantsConfig * _constantsConfig = nil;

+(ConstantsConfig *)share
{
    if (_constantsConfig == nil)
    {
        _constantsConfig = [[ConstantsConfig alloc]init];
    }
    return _constantsConfig;
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
        ConstantsDef *def = [[ConstantsDef alloc]init];
        
        int i=0;
        def.bagMaxNum   = [[cols objectAtIndex:i++] integerValue];
        def.bagBuyNum   = [[cols objectAtIndex:i++] integerValue];
        def.subAttri1Num    = [[cols objectAtIndex:i++] integerValue];
        def.subAttri2Num    = [[cols objectAtIndex:i++] integerValue];
        def.subAttri3Num    = [[cols objectAtIndex:i++] integerValue];
        def.subAttri4Num    = [[cols objectAtIndex:i++] integerValue];
        def.subAttri5Num    = [[cols objectAtIndex:i++] integerValue];
        def.heroLV      = [[cols objectAtIndex:i++] integerValue];
        def.petLV       = [[cols objectAtIndex:i++] integerValue];
        def.logGap      = [[cols objectAtIndex:i++] integerValue];
        def.normalTurn      = [[cols objectAtIndex:i++] integerValue];
        def.bossTurn    = [[cols objectAtIndex:i++] integerValue];
        def.mineTime    = [[cols objectAtIndex:i++] integerValue];
        def.criRate     = [[cols objectAtIndex:i++] integerValue];
        def.antiCriRate = [[cols objectAtIndex:i++] integerValue];
        def.hitRate     = [[cols objectAtIndex:i++] integerValue];
        def.dodgeRate   = [[cols objectAtIndex:i++] integerValue];
        def.antiparryRate   = [[cols objectAtIndex:i++] integerValue];
        def.parryRate   = [[cols objectAtIndex:i++] integerValue];
        def.mdodgeRate  = [[cols objectAtIndex:i++] integerValue];
        def.mparryRate  = [[cols objectAtIndex:i++] integerValue];
        def.mcriRate    = [[cols objectAtIndex:i++] integerValue];
        def.cridmgRate  = [[cols objectAtIndex:i++] integerValue];
        def.parrydmgRate    = [[cols objectAtIndex:i++] integerValue];
        def.equ1price   = [[cols objectAtIndex:i++] integerValue];
        def.equ2price   = [[cols objectAtIndex:i++] integerValue];
        def.equ3price   = [[cols objectAtIndex:i++] integerValue];
        def.equ4price   = [[cols objectAtIndex:i++] integerValue];
        def.equ5price   = [[cols objectAtIndex:i++] integerValue];
        def.familyNum   = [[cols objectAtIndex:i++] integerValue];
        def.familyBuyGoldEtherRatio     = [[cols objectAtIndex:i++] integerValue];
        def.familydigMedalEtherRario    = [[cols objectAtIndex:i++] integerValue];
        def.etherDollar     = [[cols objectAtIndex:i++] integerValue];
        def.tradeTaxRatio   = [[cols objectAtIndex:i++] integerValue];
        def.tradeMinPrice   = [[cols objectAtIndex:i++] integerValue];
        def.tradeTime1  = [[cols objectAtIndex:i++] integerValue];
        def.tradeTime2  = [[cols objectAtIndex:i++] integerValue];
        def.tradeTime3  = [[cols objectAtIndex:i++] integerValue];
        def.protMaxLv   = [[cols objectAtIndex:i++] integerValue];
        def.portCurrentMaxLv    = [[cols objectAtIndex:i++] integerValue];
        def.mainAttriLvupRatio  = [[cols objectAtIndex:i++] integerValue];
        def.petMineExploreRatio = [[cols objectAtIndex:i++] integerValue];
        def.petMineDigRatio     = [[cols objectAtIndex:i++] integerValue];
        def.petSlot1Unlock      = [[cols objectAtIndex:i++] integerValue];
        def.petSlot2Unlock      = [[cols objectAtIndex:i++] integerValue];
        def.logFontSize = [[cols objectAtIndex:i++] integerValue];
        def.normalShopRefreshTime1  = [[cols objectAtIndex:i++] integerValue];
        def.normalShopRefreshTime2  = [[cols objectAtIndex:i++] integerValue];
        def.normalShopRefreshTime3  = [[cols objectAtIndex:i++] integerValue];
        def.normalShopRefreshNeedItenID     = [[cols objectAtIndex:i++] integerValue];
        def.normalShopRefreshNeedItenNum    = [[cols objectAtIndex:i++] integerValue];
        def.blackShopRefreshTime1   = [[cols objectAtIndex:i++] integerValue];
        def.blackShopRefreshTime2   = [[cols objectAtIndex:i++] integerValue];
        def.blackShopRefreshTime3   = [[cols objectAtIndex:i++] integerValue];
        def.blackShopRefreshNeedItenID      = [[cols objectAtIndex:i++] integerValue];
        def.blackShopRefreshNeedItenNum     = [[cols objectAtIndex:i++] integerValue];
        def.mainAttriLvupMoneyRatio         = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%d", 0]];
    }
}

// 获得 所有常数的def
-(ConstantsDef *)getConstantsData
{
    ConstantsDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%d", 0]];
    return def;
}

// 根据装备的星数
// 获得出售的价格
-(NSNumber *)getEquipSellPriceWithStar:(NSNumber *)star
{
    NSInteger price;
    ConstantsDef *def = [self getConstantsData];
    switch ([star integerValue])
    {
        case 1:
            price = def.equ1price;
            break;
        case 2:
            price = def.equ2price;
            break;
        case 3:
            price = def.equ3price;
            break;
        case 4:
            price = def.equ4price;
            break;
        case 5:
            price = def.equ5price;
            break;
        default:
            price = 0;
            break;
    }
    
    return [[NSNumber alloc]initWithInteger:price];
}

// 获取主属性升级的折算率
-(NSNumber *)getMainAttriLvUpRatio
{
    ConstantsDef *def = [self getConstantsData];
    return [[NSNumber alloc]initWithInteger:def.mainAttriLvupRatio];
}
@end
