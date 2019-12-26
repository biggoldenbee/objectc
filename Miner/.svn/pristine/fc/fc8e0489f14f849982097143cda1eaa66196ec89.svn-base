//
//  VersionConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-6.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDBReader.h"

//
// 版本号表内，每一行数据：配置文件名和配置版本号
//
@interface VersionDef : NSObject

@property (nonatomic, copy) NSString *fileName; // 配置文件名
@property (nonatomic, copy) NSString *verNum;   // 配置文件版本号

@end


@interface VersionConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(VersionConfig *)share;

-(NSArray *)getAllConfigFileNames;      // 获取所有的配置文件名
-(NSDictionary *)getAllVersions;        // 获得文件-版本号
@end
