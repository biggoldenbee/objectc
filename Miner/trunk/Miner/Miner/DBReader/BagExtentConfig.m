//
//  BagExtent.m
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BagExtentConfig.h"

@implementation BagExtentDef

@end


@implementation BagExtentConfig

static BagExtentConfig * _bagConfig = nil;

+(BagExtentConfig *)share
{
    if (_bagConfig == nil)
    {
        _bagConfig = [[BagExtentConfig alloc]init];
    }
    return _bagConfig;
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
        BagExtentDef *def = [[BagExtentDef alloc]init];
        
        int i=0;
        def.time        = [[cols objectAtIndex:i++] integerValue];
        def.moneyType   = [[cols objectAtIndex:i++] integerValue];
        def.moneyNum    = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu",def.time]];
    }
}

//
// 根据扩张的次数来获得背包的配置
//
-(BagExtentDef *)getBagExtentDefWithTimes:(NSInteger)time
{
    BagExtentDef *def = nil;
    
    def = [Definitions objectForKey:[[NSNumber alloc]initWithInteger:time]];
    
    return def;
}
@end
