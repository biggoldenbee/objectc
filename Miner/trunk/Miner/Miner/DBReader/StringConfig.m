//
//  StringConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "StringConfig.h"

@implementation StringDef

@end

@implementation StringConfig
static StringConfig * _stringConfig = nil;

+(StringConfig *)share
{
    if (_stringConfig == nil)
    {
        _stringConfig = [[StringConfig alloc]init];
    }
    return _stringConfig;
}

-(id)init
{
    self = [super init];
    
    NSArray* lans = [NSLocale preferredLanguages];
    NSString* lan = [lans objectAtIndex:0];
    NSString* lowLan = [lan lowercaseString];
    if ( [lowLan hasPrefix:@"zh" ]
        || [lan hasPrefix:@"cn" ] )
        currentState = 1;
    else
        currentState = 2;
    return self;
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
        StringDef *def = [[StringDef alloc]init];
        
        int i=0;
        def.key         = [cols objectAtIndex:i++];
        
        for(int k = i ; k < cols.count; k ++ )
        {
            if ( currentState == k )
            {
                NSString* str = [cols objectAtIndex:k];
                def.string = [[str stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "] stringByReplacingOccurrencesOfString:@"/n" withString:@"\n"];
                break;
            }
        }
        
        [Definitions setObject:def forKey:def.key];
    }
}

-(NSString *)getLocalLanguage:(NSString *)name
{
    return [self getLocalLanguage:name state:currentState];
}

-(NSString *)getLocalLanguage:(NSString *)name state:(int)coder
{
    StringDef *def = [Definitions objectForKey:name];
    if (def != nil)
    {
        return def.string;
        /*
        switch (coder) {
            case 1:
                return def.string_cn;
            case 2:
                return def.string_en;
            default:
                NSLog(@"获取本地化文字出错：key is %@", name);
                return [NSString stringWithFormat:@"%@(语言未翻译)",name];
        }*/
    }
    return [NSString stringWithFormat:@"%@(未翻译)",name];
}
@end
