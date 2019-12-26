//
//  GameConfig.h
//  Miner
//
//  Created by jim kaden on 14/10/23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//
//  PS：管理所有的config

#import <Foundation/Foundation.h>
#import "Config.h"

@interface GameConfig : NSObject

@property (nonatomic, strong) NSMutableDictionary *configObjects;
@property (nonatomic, strong) Config    *config;    // 战斗配置设置

+(GameConfig*)sharedInstance;


-(NSDictionary *)getAllVersions;
-(void)loadVersionConfigWithFileName:(NSString *)filename;
-(void)loadAllConfigs;
-(BOOL)saveConfigInCaches:(NSString *)filename context:(NSData *)data;

-(void)downloadNeedUpdateFiles:(NSDictionary *)verdict;

-(void)setBattleConfigWithDictionary:(NSDictionary *)data;  // 初始化战斗配置

-(BOOL)encodeConfigData:(NSString *)dataStr Name:(NSString *)name;
@end
