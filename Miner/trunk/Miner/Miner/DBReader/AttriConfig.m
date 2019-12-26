//
//  AttriConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "AttriConfig.h"

@implementation AttriDef

@end

@implementation AttriConfig
static AttriConfig * _attriConfig = nil;

+(AttriConfig *)share
{
    if (_attriConfig == nil)
    {
        _attriConfig = [[AttriConfig alloc]init];
    }
    return _attriConfig;
}

//
// 释放
//
-(void)dealloc
{
    Definitions = nil;
}

//
// 重置
//
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
        AttriDef *def = [[AttriDef alloc]init];
        
        int i=0;
        def.attriID   = [[cols objectAtIndex:i++] integerValue];
        def.attriName = [cols objectAtIndex:i++];
        def.attriDesc = [cols objectAtIndex:i++];
        def.attriIcon = [cols objectAtIndex:i++];

        def.sub1Val   = [[cols objectAtIndex:i++] integerValue];
        def.sub1ValLV = [[cols objectAtIndex:i++] integerValue];
        def.sub2Val   = [[cols objectAtIndex:i++] integerValue];
        def.sub2ValLV = [[cols objectAtIndex:i++] integerValue];
        def.sub3Val   = [[cols objectAtIndex:i++] integerValue];
        def.sub3ValLV = [[cols objectAtIndex:i++] integerValue];
        def.sub4Val   = [[cols objectAtIndex:i++] integerValue];
        def.sub4ValLV = [[cols objectAtIndex:i++] integerValue];
        def.sub5Val   = [[cols objectAtIndex:i++] integerValue];
        def.sub5ValLV = [[cols objectAtIndex:i++] integerValue];
        def.valueRatio = [[cols objectAtIndex:i++] integerValue];
        def.isDebuff = [[cols objectAtIndex:i++] boolValue];
        def.effectAnimation = [cols objectAtIndex:i++];
        def.effectContinurous = [[cols objectAtIndex:i++] boolValue];
        if ( [def.effectAnimation isEqualToString:@"0"])
            def.effectAnimation = nil;
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.attriID]];
    }
}

-(AttriDef*)getAttriDefById:(NSNumber*)identifier
{
    AttriDef *def = [Definitions objectForKey:[identifier stringValue]];
    return def;
}

-(NSString *)getAttriNameWithId:(NSNumber *)identifier
{
    AttriDef *def = [Definitions objectForKey:[identifier stringValue]];
    return def.attriName;
}
-(NSString *)getAttriDescWithId:(NSNumber *)identifier
{
    AttriDef *def = [Definitions objectForKey:[identifier stringValue]];
    return def.attriDesc;
}
-(NSString *)getAttriIconWithId:(NSNumber *)identifier
{
    AttriDef *def = [Definitions objectForKey:[identifier stringValue]];
    return def.attriIcon;
}
-(NSNumber *)getAttriValueWithId:(NSNumber *)identifier withLv:(NSNumber *)level withStar:(NSNumber *)star
{
    AttriDef *def = [Definitions objectForKey:[identifier stringValue]];
    
    NSInteger baseValue = 0;
    NSInteger addValue = 0;
    
    switch ([star integerValue])
    {
        case 1:
        {
            baseValue = [def sub1Val];
            addValue = [def sub1ValLV] * ([level integerValue] - 1);
        }
            break;
        case 2:
        {
            baseValue = [def sub2Val];
            addValue = [def sub2ValLV] * ([level integerValue] - 1);
        }
            break;
        case 3:
        {
            baseValue = [def sub3Val];
            addValue = [def sub3ValLV] * ([level integerValue] - 1);
        }
            break;
        case 4:
        {
            baseValue = [def sub4Val];
            addValue = [def sub4ValLV] * ([level integerValue] - 1);
        }
            break;
        case 5:
        {
            baseValue = [def sub5Val];
            addValue = [def sub5ValLV] * ([level integerValue] - 1);
        }
            break;
        default:
            break;
    }
    
    NSNumber* lastValue = [NSNumber numberWithInteger:baseValue+addValue];
    return lastValue;
}
@end
