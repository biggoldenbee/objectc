//
//  ExtraConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-20.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "ExtraConfig.h"

@implementation ExtraDef

@end

@implementation ExtraConfig

static ExtraConfig * _extraConfig = nil;

+(ExtraConfig *)share
{
    if (_extraConfig == nil)
    {
        _extraConfig = [[ExtraConfig alloc]init];
    }
    return _extraConfig;
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
        ExtraDef *def = [[ExtraDef alloc]init];
        
        int i=0;
        def.resultValue = [[cols objectAtIndex:i++] integerValue];
        def.en          = [cols objectAtIndex:i++];
        def.cn          = [cols objectAtIndex:i++];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.resultValue]];
    }
}

//
// 根据返回值  获得错误多语言def
//
-(ExtraDef*)getExtraDefWithResultValue:(NSInteger)rv
{
    ExtraDef* def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", rv]];
    return def;
}
@end
