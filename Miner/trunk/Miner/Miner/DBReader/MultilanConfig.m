//
//  MultilanConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-20.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "MultilanConfig.h"

@implementation MultilanDef

@end

@implementation MultilanConfig

static MultilanConfig * _multilanConfig = nil;

+(MultilanConfig *)share
{
    if (_multilanConfig == nil)
    {
        _multilanConfig = [[MultilanConfig alloc]init];
    }
    return _multilanConfig;
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
        NSMutableArray *cols = (NSMutableArray *)[[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        MultilanDef *def = [[MultilanDef alloc]init];
        
        int i=0;
        def.lan         = [cols objectAtIndex:i++];
        def.identifier  = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:def.lan];
    }
}

-(MultilanDef*)getMultilanDefWithLang:(NSString*)lang
{
    MultilanDef* def = [Definitions objectForKey:lang];
    return def;
}
@end
