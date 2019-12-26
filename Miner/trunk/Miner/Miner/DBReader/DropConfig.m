//
//  DropConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "DropConfig.h"

@implementation DropBase

@end

@implementation DropDef

@end

@implementation DropConfig

static DropConfig * _dropConfig = nil;

+(DropConfig *)share
{
    if (_dropConfig == nil)
    {
        _dropConfig = [[DropConfig alloc]init];
    }
    return _dropConfig;
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
        DropDef *def = [[DropDef alloc]init];
        
        int i=0;
        def.dropId  = [[cols objectAtIndex:i++] integerValue];
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        for (int j=0; j < DROP_ITEM_NUM; j++)
        {
            DropBase *db = [[DropBase alloc]init];
            db.itemId = [[cols objectAtIndex:i++] integerValue];
            if ([db itemId] == 0)
            {
                i++;
                continue;
            }
            db.idNum  = [[cols objectAtIndex:i++] integerValue];
            [tempDic setObject:db forKey:[NSString stringWithFormat:@"%lu",db.itemId]];
        }
        def.dropDatas = [[NSDictionary alloc]initWithDictionary:tempDic];
        
        def.dropIcon = [cols objectAtIndex:i++];
        def.dropName = [cols objectAtIndex:i++];
        
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu",def.dropId]];
    }
}

// 根据掉落ID  获取对应的掉落def（里面是item和equip的id 和 num）
-(DropDef*)getDropDefWithId:(NSInteger)identifier
{
    DropDef* def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", identifier]];
    return def;
}
@end

// ----------------------------------------------------------------------------

@implementation TcBase

@end

@implementation TcDef

@end

@implementation TcConfig

static TcConfig * _tcConfig = nil;

+(TcConfig *)share
{
    if (_tcConfig == nil)
    {
        _tcConfig = [[TcConfig alloc]init];
    }
    return _tcConfig;
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
        TcDef *def = [[TcDef alloc]init];
        
        int i=0;
        def.tcId     = [[cols objectAtIndex:i++] integerValue];
        def.run      = [[cols objectAtIndex:i++] integerValue];
        def.noDrop   = [[cols objectAtIndex:i++] integerValue];
        
        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
        while (i<[cols count])
        {
            TcBase *tb =[[TcBase alloc]init];
            tb.dropID  = [[cols objectAtIndex:i++] integerValue];
            if ([tb dropID] == 0)
            {
                continue;
            }
            tb.IdRatio = [[cols objectAtIndex:i++] integerValue];
            [tempDic setObject:tb forKey:[NSString stringWithFormat:@"%lu",tb.dropID]];
        }
        def.tcDatas = [[NSDictionary alloc]initWithDictionary:tempDic];

        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu",def.tcId]];
    }
}

//
// 根据掉落集合id  获取对用的集合def（里面是掉落ID）
//
-(TcDef*)getTcDefWithId:(NSInteger)identifier
{
    TcDef* def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", identifier]];
    return def;
}
@end