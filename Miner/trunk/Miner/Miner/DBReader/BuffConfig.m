//
//  BuffConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-13.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BuffConfig.h"

@implementation BuffBase

@end

@implementation BuffDef
-(BOOL)addBuffBaseIntoBuffDatas:(BuffBase*)base
{
    NSString *key = [NSString stringWithFormat:@"%lu", base.buffLV];
    BuffBase *tempDef = [self.buffDatas objectForKey:key];
    if (tempDef != nil)
    {
        return NO;
    }
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[self buffDatas]];
    [tempDict setValue:base forKey:key];
    self.buffDatas = tempDict;
    return YES;
}
@end

@implementation BuffConfig
static BuffConfig * _buffConfig = nil;

+(BuffConfig *)share
{
    if (_buffConfig == nil)
    {
        _buffConfig = [[BuffConfig alloc]init];
    }
    return _buffConfig;
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
        NSInteger buffid = [[cols objectAtIndex:i++] integerValue];
        BuffDef* def    = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", buffid]];
        if (def ==nil)
        {
            def = [[BuffDef alloc] init];
            def.buffId = buffid;
            [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.buffId]];
        }
        
        BuffBase* base  = [[BuffBase alloc] init];
        base.buffName   = [cols objectAtIndex:i++];
        base.buffDesc   = [cols objectAtIndex:i++];
        base.buffIcon   = [cols objectAtIndex:i++];
        base.buffLV     = [[cols objectAtIndex:i++] integerValue];
        base.buffType   = [[cols objectAtIndex:i++] integerValue];
        base.attriId1    = [[cols objectAtIndex:i++] integerValue];
        base.attriNum1   = [[cols objectAtIndex:i++] integerValue];
        base.attriId2    = [[cols objectAtIndex:i++] integerValue];
        base.attriNum2   = [[cols objectAtIndex:i++] integerValue];
        base.buffMultiLimit = [[cols objectAtIndex:i++] integerValue];
        base.bTimeType  = [[cols objectAtIndex:i++] integerValue];
        base.instantEffect  = [[cols objectAtIndex:i++] integerValue];
        base.effectHappen   = [[cols objectAtIndex:i++] integerValue];
        base.buffLast   = [[cols objectAtIndex:i++] integerValue];
        base.buffTurn   = [[cols objectAtIndex:i++] integerValue];
        base.buffNewGet = [[cols objectAtIndex:i++] integerValue];
        base.buffNewChance  = [[cols objectAtIndex:i++] integerValue];
        base.buffNewId  = [[cols objectAtIndex:i++] integerValue];
        base.buffNewLv  = [[cols objectAtIndex:i++] integerValue];
        base.logFontSize    = [[cols objectAtIndex:i++] integerValue];
        
        int r,g,b;
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        base.logFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        
        base.animaFontSize = [[cols objectAtIndex:i++] integerValue];
        
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        
        base.animaFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        
        [def addBuffBaseIntoBuffDatas:base];
    }
}

//
// 重载了父类的方法
//
-(void)loadDBFromLocal
{
    Definitions = [[NSMutableDictionary alloc]init];
    for (int i=0; i<[self numOfRow]; i++)
    {
        BuffDef *def = [self rowAtIndex:i];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu",def.buffId]];
        def =nil;
    }
}

-(BuffBase*) getBuffBaseWithTId:(NSNumber*)bid withLevel:(NSNumber*)blv
{
    BuffDef *def = [Definitions objectForKey:[bid stringValue]];
    BuffBase* base = [[def buffDatas] objectForKey:[blv stringValue]];
    return base;
}
@end
