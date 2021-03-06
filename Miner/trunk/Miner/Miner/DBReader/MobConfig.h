//
//  MobConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"
#import <UIKit/UIKit.h>

@interface MobDef : NSObject

@property (nonatomic, assign) NSInteger mobID;      // 怪物id
@property (nonatomic, copy)   NSString* mobName;    // 怪物名称
@property (nonatomic, copy)   NSString* mobDesc;    // 怪物描述
@property (nonatomic, copy)   NSString* mobIcon;    // 怪物icon
@property (nonatomic, assign) NSInteger mobDataID;  // 怪物数据id
@property (nonatomic, assign) NSInteger logFontSize;
@property (nonatomic, strong) UIColor*  logFontColor;
@property (nonatomic, assign) NSInteger animaFontSize;
@property (nonatomic, strong) UIColor*  animaFontColor;

@end

@interface MobConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(MobConfig *)share;

-(MobDef*)getMobDefById:(NSInteger)identifier;
@end

// ----------------------------------------------------------------------------

@interface MobDataDef : NSObject

@property (nonatomic, assign) NSInteger id;             // 怪物数据ID
@property (nonatomic, assign) NSInteger hp;             // 血量
@property (nonatomic, assign) NSInteger hp_lv;          // 血量每级增加量
@property (nonatomic, assign) NSInteger atk;            // 初始攻击
@property (nonatomic, assign) NSInteger atk_lv;         // 攻击每级增加量
@property (nonatomic, assign) NSInteger def;            // 护甲
@property (nonatomic, assign) NSInteger def_lv;         // 护甲每级增加量
@property (nonatomic, assign) NSInteger pdef;           // 物理防御
@property (nonatomic, assign) NSInteger pdef_lv;        // 物理防御每级增加量
@property (nonatomic, assign) NSInteger mdef;           // 魔法防御
@property (nonatomic, assign) NSInteger mdef_lv;        // 魔法防御每级增加量
@property (nonatomic, assign) NSInteger spd;            // 速度
@property (nonatomic, assign) NSInteger spd_lv;         // 速度每级增加量
@property (nonatomic, assign) NSInteger cri;            // 暴击率
@property (nonatomic, assign) NSInteger cri_lv;         // 暴击率每级增加量
@property (nonatomic, assign) NSInteger antiCri;        // 韧性
@property (nonatomic, assign) NSInteger antiCri_lv;     // 韧性每级增加量
@property (nonatomic, assign) NSInteger hit;            // 命中率
@property (nonatomic, assign) NSInteger hit_lv;         // 命中率每级增加量
@property (nonatomic, assign) NSInteger dodge;          // 闪避率
@property (nonatomic, assign) NSInteger dodge_lv;       // 闪避率每级增加量
@property (nonatomic, assign) NSInteger parry;          // 招架率
@property (nonatomic, assign) NSInteger parry_lv;       // 招架率每级增加量
@property (nonatomic, assign) NSInteger antiParry;      // 精准率
@property (nonatomic, assign) NSInteger antiParry_lv;   // 精准率每级增加量
@property (nonatomic, assign) NSInteger skillID1;       // 技能id1
@property (nonatomic, assign) NSInteger skill1Unlocklv; // 技能1解锁等级
@property (nonatomic, assign) NSInteger skillID2;       // 技能id2
@property (nonatomic, assign) NSInteger skill2Unlocklv; // 技能2解锁等级
@property (nonatomic, assign) NSInteger skillID3;       // 技能id3
@property (nonatomic, assign) NSInteger skill3Unlocklv; // 技能3解锁等级
@property (nonatomic, assign) NSInteger skillID4;       // 技能id4
@property (nonatomic, assign) NSInteger skill4Unlocklv; // 技能4解锁等级
@property (nonatomic, assign) NSInteger normalAttackSkillID; // 用于显示普通攻击的项目，对应Skill表里的某一项，只是取其配置，没有实际技能对应

@end

@interface MobDataConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(MobDataConfig *)share;

-(MobDataDef*)getMobDataDefById:(NSInteger)identifier;
@end

// ----------------------------------------------------------------------------

@interface MineDef : NSObject

@property (nonatomic, assign) NSInteger mineID;         // 矿石怪id
@property (nonatomic, copy)   NSString* minePic;        // 场景用图片
@property (nonatomic, assign) NSInteger mineDiscover;   // 发现指标
@property (nonatomic, assign) NSInteger mineDig;        // 开采指标
@property (nonatomic, assign) NSInteger tcID;           // 掉落ID
@property (nonatomic, assign) NSInteger failureTcID;    // 失败掉落id
@property (nonatomic, copy)   NSString* mineName;       // UI显示文字
@property (nonatomic, assign) NSInteger logFontSize;
@property (nonatomic, strong) UIColor*  logFontColor;
@property (nonatomic, assign) NSInteger animaFontSize;
@property (nonatomic, strong) UIColor*  animaFontColor;

@end

@interface MineConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(MineConfig *)share;
-(MineDef*)GetMineDefWithIdentifier:(NSInteger)id;
-(NSString *)getMineNameWithIdentifier:(NSInteger)id;
@end
