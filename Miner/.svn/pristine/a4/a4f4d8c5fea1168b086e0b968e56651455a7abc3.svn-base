//
//  MultilanConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-20.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"

@interface MultilanDef : NSObject

@property (nonatomic, copy)   NSString* lan;       // 语言
@property (nonatomic, assign) NSInteger identifier; // 语言id编号

@end

@interface MultilanConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(MultilanConfig *)share;
-(MultilanDef*)getMultilanDefWithLang:(NSString*)lang;
@end
