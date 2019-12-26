//
//  VersionConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-6.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "VersionConfig.h"

@implementation VersionDef

@end


@implementation VersionConfig

static VersionConfig * _versionConfig = nil;

+(VersionConfig *)share
{
    if (_versionConfig == nil)
    {
        _versionConfig = [[VersionConfig alloc]init];
    }
    return _versionConfig;
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
        VersionDef *def = [[VersionDef alloc]init];
        
        int i=0;
        def.fileName = [cols objectAtIndex:i++];
        def.verNum   = [cols objectAtIndex:i++];
        [Definitions setObject:def forKey:def.fileName];
    }
}

//
// 获取所有的配置文件名
//
-(NSArray *)getAllConfigFileNames
{
    return [Definitions allKeys];
}

//
// 转化成  文件名 <-> 版本号 类型的dictionary
//
-(NSDictionary *)getAllVersions
{
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    NSArray *values = [Definitions allValues];
    for (VersionDef *def in values)
    {
        [tempDict setObject:def.fileName forKey:def.verNum];
    }
    
    return tempDict;
}
@end
