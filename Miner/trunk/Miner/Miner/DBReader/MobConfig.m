//
//  MobConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "MobConfig.h"

@implementation MobDef

@end

@implementation MobConfig

static MobConfig * _mobConfig = nil;

+(MobConfig *)share
{
    if (_mobConfig == nil)
    {
        _mobConfig = [[MobConfig alloc]init];
    }
    return _mobConfig;
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
        MobDef *def = [[MobDef alloc]init];
        
        int i=0;
        def.mobID   = [[cols objectAtIndex:i++] integerValue];
        def.mobName = [cols objectAtIndex:i++];
        def.mobDesc = [cols objectAtIndex:i++];
        def.mobIcon = [cols objectAtIndex:i++];
        def.mobDataID   = [[cols objectAtIndex:i++] integerValue];
        
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
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.mobID]];
    }
}

-(MobDef*)getMobDefById:(NSInteger)identifier
{
    MobDef* def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", identifier]];
    return def;
}
@end

// ----------------------------------------------------------------------------

@implementation MobDataDef

@end

@implementation MobDataConfig

static MobDataConfig * _mobDataConfig = nil;

+(MobDataConfig *)share
{
    if (_mobDataConfig == nil)
    {
        _mobDataConfig = [[MobDataConfig alloc]init];
    }
    return _mobDataConfig;
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
        MobDataDef *def = [[MobDataDef alloc]init];
        
        int i=0;
        def.id              = [[cols objectAtIndex:i++] integerValue];
        def.hp              = [[cols objectAtIndex:i++] integerValue];
        def.hp_lv           = [[cols objectAtIndex:i++] integerValue];
        def.atk             = [[cols objectAtIndex:i++] integerValue];
        def.atk_lv          = [[cols objectAtIndex:i++] integerValue];
        def.def             = [[cols objectAtIndex:i++] integerValue];
        def.def_lv          = [[cols objectAtIndex:i++] integerValue];
        def.pdef            = [[cols objectAtIndex:i++] integerValue];
        def.pdef_lv         = [[cols objectAtIndex:i++] integerValue];
        def.mdef            = [[cols objectAtIndex:i++] integerValue];
        def.mdef_lv         = [[cols objectAtIndex:i++] integerValue];
        def.spd             = [[cols objectAtIndex:i++] integerValue];
        def.spd_lv          = [[cols objectAtIndex:i++] integerValue];
        def.cri             = [[cols objectAtIndex:i++] integerValue];
        def.cri_lv          = [[cols objectAtIndex:i++] integerValue];
        def.antiCri         = [[cols objectAtIndex:i++] integerValue];
        def.antiCri_lv      = [[cols objectAtIndex:i++] integerValue];
        def.hit             = [[cols objectAtIndex:i++] integerValue];
        def.hit_lv          = [[cols objectAtIndex:i++] integerValue];
        def.dodge           = [[cols objectAtIndex:i++] integerValue];
        def.dodge_lv        = [[cols objectAtIndex:i++] integerValue];
        def.parry           = [[cols objectAtIndex:i++] integerValue];
        def.parry_lv        = [[cols objectAtIndex:i++] integerValue];
        def.antiParry       = [[cols objectAtIndex:i++] integerValue];
        def.antiParry_lv    = [[cols objectAtIndex:i++] integerValue];
        def.skillID1        = [[cols objectAtIndex:i++] integerValue];
        def.skill1Unlocklv  = [[cols objectAtIndex:i++] integerValue];
        def.skillID2        = [[cols objectAtIndex:i++] integerValue];
        def.skill2Unlocklv  = [[cols objectAtIndex:i++] integerValue];
        def.skillID3        = [[cols objectAtIndex:i++] integerValue];
        def.skill3Unlocklv  = [[cols objectAtIndex:i++] integerValue];
        def.skillID4        = [[cols objectAtIndex:i++] integerValue];
        def.skill4Unlocklv  = [[cols objectAtIndex:i++] integerValue];
        def.normalAttackSkillID = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.id]];
    }
}

-(MobDataDef*)getMobDataDefById:(NSInteger)identifier
{
    MobDataDef* def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", identifier]];
    return def;
}
@end

// ----------------------------------------------------------------------------

@implementation MineDef

@end

@implementation MineConfig

static MineConfig * _mineConfig = nil;

+(MineConfig *)share
{
    if (_mineConfig == nil)
    {
        _mineConfig = [[MineConfig alloc]init];
    }
    return _mineConfig;
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
        MineDef *def = [[MineDef alloc]init];
        
        int i=0;
        def.mineID       = [[cols objectAtIndex:i++] integerValue];
        def.minePic      = [cols objectAtIndex:i++];
        def.mineDiscover = [[cols objectAtIndex:i++] integerValue];
        def.mineDig      = [[cols objectAtIndex:i++] integerValue];
        def.tcID         = [[cols objectAtIndex:i++] integerValue];
        def.failureTcID  = [[cols objectAtIndex:i++] integerValue];
        def.mineName     = [cols objectAtIndex:i++];
        
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
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.mineID]];
    }
}

-(MineDef*)GetMineDefWithIdentifier:(NSInteger)id
{
    MineDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", id]];
    return def;
}

-(NSString *)getMineNameWithIdentifier:(NSInteger)id
{
    MineDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", id]];
    return [NSString stringWithFormat:@"%lu", def.mineID];
}
@end