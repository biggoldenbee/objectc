//
//  StringConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseDBReader.h"

@interface StringDef : NSObject

@property (nonatomic, copy) NSString  *key;         // key
@property (nonatomic, copy) NSString  *string;      // 名字
@end

@interface StringConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
    int currentState;   // 当前语言类型  1是中文  2 是其他
}

+(StringConfig *)share;

-(NSString *)getLocalLanguage:(NSString *)name state:(int)coder;

-(NSString *)getLocalLanguage:(NSString *)name;
@end
