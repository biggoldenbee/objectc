//
//  HeroConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"
#import <UIKit/UIKit.h>

@interface HeroDef : NSObject

@property (nonatomic, assign) NSInteger heroLv;     // 英雄等级
@property (nonatomic, assign) NSInteger heroExp;    // 英雄经验
@property (nonatomic, assign) NSInteger hp;         // 血量
@property (nonatomic, assign) NSInteger atk;        // 攻击力
@property (nonatomic, assign) NSInteger def;        // 护甲值
@property (nonatomic, assign) NSInteger pdef;       // 物理防御
@property (nonatomic, assign) NSInteger mdef;       // 魔法防御
@property (nonatomic, assign) NSInteger spd;        // 速度
@property (nonatomic, assign) NSInteger cri;        // 暴击值
@property (nonatomic, assign) NSInteger antiCri;    // 韧性值
@property (nonatomic, assign) NSInteger hit;        // 命中值
@property (nonatomic, assign) NSInteger dodge;      // 闪避值
@property (nonatomic, assign) NSInteger parry;      // 招架值
@property (nonatomic, assign) NSInteger antiParry;  // 精准值
@property (nonatomic, assign) NSInteger foundVal;   // 发现值
@property (nonatomic, assign) NSInteger digVal;     // 开采值
@property (nonatomic, assign) NSInteger skillNum;   // 技能位
@property (nonatomic, assign) NSInteger lvUpTcID;   // 成长奖励
@property (nonatomic, assign) NSInteger logFontSize;
@property (nonatomic, strong) UIColor* logFontColor;
@property (nonatomic, assign) NSInteger animaFontSize;
@property (nonatomic, strong) UIColor* animaFontColor;
@end

@interface HeroConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(HeroConfig *)share;
-(HeroDef *)getHeroLevelDataWithLevel:(NSNumber *)level;
@end

// ----------------------------------------------------------------------------

@interface HeroInitDef : NSObject

@property (nonatomic, assign) NSInteger gemNum;     // 宝石币
@property (nonatomic, assign) NSInteger goldNum;    // 金币
@property (nonatomic, assign) NSInteger bagSlot;    // 背包初始值
@property (nonatomic, assign) NSInteger equip1Id;   // 装备1id
@property (nonatomic, assign) NSInteger equip2Id;   // 装备2id
@property (nonatomic, assign) NSInteger equip3Id;   // 装备3id
@property (nonatomic, assign) NSInteger equip4Id;   // 装备4id
@property (nonatomic, assign) NSInteger equip5Id;   // 装备5id
@property (nonatomic, assign) NSInteger equip6Id;   // 装备6id
@property (nonatomic, assign) NSInteger equip7Id;   // 装备7id
@property (nonatomic, assign) NSInteger equip8Id;   // 装备8id
@property (nonatomic, assign) NSInteger item1Id;    // 物品1id
@property (nonatomic, assign) NSInteger item2Id;    // 物品2id
@property (nonatomic, assign) NSInteger item3Id;    // 物品3id
@property (nonatomic, assign) NSInteger item4Id;    // 物品4id
@property (nonatomic, assign) NSInteger item5Id;    // 物品5id

@end

@interface HeroInitConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(HeroInitConfig *)share;

-(HeroInitDef *)getHeroInitData;
@end