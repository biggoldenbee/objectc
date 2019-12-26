//
//  PortConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-12-18.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "PortConfig.h"

@implementation PortDef

@end

@implementation PortConfig
static PortConfig * _portConfig = nil;

+(PortConfig *)share
{
    if (_portConfig == nil)
    {
        _portConfig = [[PortConfig alloc]init];
    }
    return _portConfig;
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
    for (int k=0; k<[rows count]-1; k++)
    {
        NSArray *cols = [[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        PortDef *def = [[PortDef alloc]init];
        
        int i=0;
        def.portId      = [[cols objectAtIndex:i++] integerValue];
        def.sName       = [cols objectAtIndex:i++];
        def.fName       = [cols objectAtIndex:i++];
        def.serverID    = [[cols objectAtIndex:i++] integerValue];
        def.portGroup   = [[cols objectAtIndex:i++] integerValue];
        def.portTimezone = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.portId]];
    }
}

-(PortDef*)getPortDefWithPortId:(NSNumber*)portId
{
    PortDef* def = [Definitions objectForKey:[portId stringValue]];
    return def;
}
@end

// **************************************************************************************
@implementation PortLvNeeds

@end
@implementation PortLvDef

@end

@implementation PortLvConfig
static PortLvConfig * _portLvConfig = nil;

+(PortLvConfig *)share
{
    if (_portLvConfig == nil)
    {
        _portLvConfig = [[PortLvConfig alloc]init];
    }
    return _portLvConfig;
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
    NSMutableArray *rows = (NSMutableArray *)[buffer componentsSeparatedByString:@"\r\n"];
    Definitions = [[NSMutableDictionary alloc]init];
    for (int k=0; k<[rows count]-1; k++)
    {
        NSMutableArray *cols = (NSMutableArray *)[[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        PortLvDef *def = [[PortLvDef alloc]init];
        
        int i=0;
        def.portLv          = [[cols objectAtIndex:i++] integerValue];
        def.landLockUpperLimit  = [[cols objectAtIndex:i++] integerValue];
        def.mayorNum        = [[cols objectAtIndex:i++] integerValue];
        def.deputyNum       = [[cols objectAtIndex:i++] integerValue];
        def.assemblyNum     = [[cols objectAtIndex:i++] integerValue];
        
        NSMutableArray* tempArr = [[NSMutableArray alloc]init];
        while (i < [cols count])
        {
            PortLvNeeds* needs = [[PortLvNeeds alloc]init];
            needs.needkey = [[cols objectAtIndex:i++] integerValue];
            needs.needValue = [cols objectAtIndex:i++];
            [tempArr addObject:needs];
        }
        def.lvNeedsArray = [[NSArray alloc]initWithArray:tempArr];
        
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.portLv]];
    }
}

-(PortLvDef*)getPortLvDefWithPortId:(NSNumber*)portId
{
    PortLvDef* def = [Definitions objectForKey:[portId stringValue]];
    return def;
}
@end

//*************************************************************************************
@implementation ContributionDef

@end

@implementation ContributionConfig
static ContributionConfig * _contributionConfig = nil;

+(ContributionConfig *)share
{
    if (_contributionConfig == nil)
    {
        _contributionConfig = [[ContributionConfig alloc]init];
    }
    return _contributionConfig;
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
    for (int k=0; k<[rows count]-1; k++)
    {
        NSArray *cols = [[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        ContributionDef *def = [[ContributionDef alloc]init];
        
        int i=0;
        def.conLv       = [[cols objectAtIndex:i++] integerValue];
        def.conName     = [cols objectAtIndex:i++];
        def.conIcon     = [cols objectAtIndex:i++];
        def.conValue    = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.conLv]];
    }
}

-(ContributionDef*)getContributionDefWithLevel:(NSNumber*)level
{
    ContributionDef* def = [Definitions objectForKey:[level stringValue]];
    return def;
}
@end
// **************************************************************************************

@implementation AppDownContriDef

@end

@implementation AppDownContriConfig
static AppDownContriConfig * _appDownContriConfig = nil;

+(AppDownContriConfig *)share
{
    if (_appDownContriConfig == nil)
    {
        _appDownContriConfig = [[AppDownContriConfig alloc]init];
    }
    return _appDownContriConfig;
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
    for (int k=0; k<[rows count]-1; k++)
    {
        NSArray *cols = [[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        AppDownContriDef *def = [[AppDownContriDef alloc]init];
        
        int i=0;
        def.appPriceGap = [[cols objectAtIndex:i++] integerValue];
        def.conValue    = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.appPriceGap]];
    }
}

-(AppDownContriDef*)getAppDownContriDefWithGap:(NSNumber*)gap
{
    AppDownContriDef* def = [Definitions objectForKey:[gap stringValue]];
    return def;
}
@end
