//
//  MapConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseDBReader.h"

@interface MapDef : NSObject

@property (nonatomic, assign) NSInteger mapID;      // 地图id
@property (nonatomic, copy)   NSString* mapName;    // 地图名字  来自 resource表
@property (nonatomic, copy)   NSString* mapDes;     // 地图描述  来自 resource表
@property (nonatomic, copy)   NSString* mapIcon;    // 地图名称  来自 resource表
@property (nonatomic, assign) NSInteger normalTime; // 普通战斗时间上线
@property (nonatomic, assign) NSInteger ppl_exp;    // 人物经验
@property (nonatomic, assign) NSInteger pet_exp;    // 宠物经验
@property (nonatomic, assign) NSInteger boss_pplexp;// boss人物经验
@property (nonatomic, assign) NSInteger boss_petexp;// boss宠物经验
@property (nonatomic, assign) NSInteger basicWin;   // 基础胜率
@property (nonatomic, assign) NSInteger bottomWin;  // 最低胜率
@property (nonatomic, assign) NSInteger minLv;      // 最小怪物等级
@property (nonatomic, assign) NSInteger maxLv;      // 最大怪物等级
@property (nonatomic, assign) NSInteger mobNum;     // 怪物数目
@property (nonatomic, assign) NSInteger battleTcID; // 杀怪掉落集合ID
@property (nonatomic, assign) NSInteger bossID;     // 地图bossid
@property (nonatomic, assign) NSInteger bossTcID;   // boss掉落集合
@property (nonatomic, assign) NSInteger ranid1;     // 事件id
@property (nonatomic, assign) NSInteger ranid1Ratio;// 事件id概率
@property (nonatomic, assign) NSInteger ranid2;     // 事件id
@property (nonatomic, assign) NSInteger ranid2Ratio;// 事件id概率
@property (nonatomic, assign) NSInteger ranid3;     // 事件id
@property (nonatomic, assign) NSInteger ranid3Ratio;// 事件id概率
@property (nonatomic, assign) NSInteger ranid4;     // 事件id
@property (nonatomic, assign) NSInteger ranid4Ratio;// 事件id概率
@property (nonatomic, assign) NSInteger ranid5;     // 事件id
@property (nonatomic, assign) NSInteger ranid5Ratio;// 事件id概率
@property (nonatomic, assign) NSInteger petID;      // 解锁宠物ID

@end

@interface MapConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(MapConfig *)share;

-(NSArray*)getAllMapdef;
-(MapDef*)getMapDefWithID:(NSNumber*)identifier;
@end
