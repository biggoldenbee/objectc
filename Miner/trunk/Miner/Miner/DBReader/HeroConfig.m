//
//  HeroConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "HeroConfig.h"

@implementation HeroDef

@end

@implementation HeroConfig
static HeroConfig * _heroConfig = nil;

+(HeroConfig *)share
{
    if (_heroConfig == nil)
    {
        _heroConfig = [[HeroConfig alloc]init];
    }
    return _heroConfig;
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
        HeroDef *def = [[HeroDef alloc]init];
        
        int i=0;
        def.heroLv  = [[cols objectAtIndex:i++] integerValue];
        def.heroExp = [[cols objectAtIndex:i++] integerValue];
        def.hp      = [[cols objectAtIndex:i++] integerValue];
        def.atk     = [[cols objectAtIndex:i++] integerValue];
        def.def     = [[cols objectAtIndex:i++] integerValue];
        def.pdef    = [[cols objectAtIndex:i++] integerValue];
        def.mdef    = [[cols objectAtIndex:i++] integerValue];
        def.spd     = [[cols objectAtIndex:i++] integerValue];
        def.cri     = [[cols objectAtIndex:i++] integerValue];
        def.antiCri = [[cols objectAtIndex:i++] integerValue];
        def.hit     = [[cols objectAtIndex:i++] integerValue];
        def.dodge   = [[cols objectAtIndex:i++] integerValue];
        def.parry   = [[cols objectAtIndex:i++] integerValue];
        def.antiParry   = [[cols objectAtIndex:i++] integerValue];
        def.foundVal    = [[cols objectAtIndex:i++] integerValue];
        def.digVal  = [[cols objectAtIndex:i++] integerValue];
        def.skillNum    = [[cols objectAtIndex:i++] integerValue];
        def.lvUpTcID    = [[cols objectAtIndex:i++] integerValue];
        
        def.logFontSize = [[cols objectAtIndex:i++] integerValue];
        
        int r,g,b;
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        def.logFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        
        def.animaFontSize = [[cols objectAtIndex:i++] integerValue];
        
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        
        def.animaFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.heroLv]];
    }
}

-(HeroDef *)getHeroLevelDataWithLevel:(NSNumber *)level
{
    HeroDef *def = [Definitions objectForKey:[level stringValue]];
    return def;
}
@end

// ----------------------------------------------------------------------------

@implementation HeroInitDef

@end

@implementation HeroInitConfig
static HeroInitConfig * _heroInitConfig = nil;

+(HeroInitConfig *)share
{
    if (_heroInitConfig == nil)
    {
        _heroInitConfig = [[HeroInitConfig alloc]init];
    }
    return _heroInitConfig;
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
        HeroInitDef *def = [[HeroInitDef alloc]init];
        
        int i=0;
        def.gemNum   = [[cols objectAtIndex:i++] integerValue];
        def.goldNum  = [[cols objectAtIndex:i++] integerValue];
        def.bagSlot  = [[cols objectAtIndex:i++] integerValue];
        def.equip1Id = [[cols objectAtIndex:i++] integerValue];
        def.equip2Id = [[cols objectAtIndex:i++] integerValue];
        def.equip3Id = [[cols objectAtIndex:i++] integerValue];
        def.equip4Id = [[cols objectAtIndex:i++] integerValue];
        def.equip5Id = [[cols objectAtIndex:i++] integerValue];
        def.equip6Id = [[cols objectAtIndex:i++] integerValue];
        def.equip7Id = [[cols objectAtIndex:i++] integerValue];
        def.equip8Id = [[cols objectAtIndex:i++] integerValue];
        def.item1Id  = [[cols objectAtIndex:i++] integerValue];
        def.item2Id  = [[cols objectAtIndex:i++] integerValue];
        def.item3Id  = [[cols objectAtIndex:i++] integerValue];
        def.item4Id  = [[cols objectAtIndex:i++] integerValue];
        def.item5Id  = [[cols objectAtIndex:i++] integerValue];
        
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%d", 0]];
    }
}

-(HeroInitDef *)getHeroInitData
{
    HeroInitDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%d", 0]];
    return def;
}
@end