//
//  RandatdConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "RandateConfig.h"

@implementation RandateBase

@end

@implementation RandateDef

@end

@implementation RandateConfig
static RandateConfig * _randataConfig = nil;

+(RandateConfig *)share
{
    if (_randataConfig == nil)
    {
        _randataConfig = [[RandateConfig alloc]init];
    }
    return _randataConfig;
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
        RandateDef *def = [[RandateDef alloc]init];
        
        int i=0;
        def.ranID   = [[cols objectAtIndex:i++] integerValue];
        def.ranType = [[cols objectAtIndex:i++] integerValue];
        
        NSMutableDictionary *temp = [[NSMutableDictionary alloc]init];
        for (int j=0; j < RANDATE_EVENT_NUM; j++)
        {
            RandateBase *rdb = [[RandateBase alloc]init];
            rdb.ranProp      = [[cols objectAtIndex:i++] integerValue];
            rdb.ranPropRatio = [[cols objectAtIndex:i++] integerValue];
            [temp setObject:rdb forKey:[NSString stringWithFormat:@"%lu", rdb.ranProp]];
        }
        def.eventDatas =[[NSDictionary alloc] initWithDictionary:temp];
        
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.ranID]];
    }
}

@end
