//
//  PetConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BaseDBReader.h"
#import <UIKit/UIKit.h>

@interface PetDef : NSObject

@property (nonatomic, assign)   NSInteger petID;     // 佣兵id
@property (nonatomic, copy)     NSString* petName;   // 佣兵名字  来自 resource表
@property (nonatomic, copy)     NSString* petDes;    // 佣兵描述  来自 resource表
@property (nonatomic, copy)     NSString* petIcon;   // 佣兵名称  来自 resource表
@property (nonatomic, assign)   NSInteger petDataID;    // 佣兵数据ID
@property (nonatomic, assign)   NSInteger logFontSize;  // log字体大小
@property (nonatomic, strong)   UIColor*  logFontColor; //
@property (nonatomic, assign)   NSInteger animaFontSize;    // 战斗场景字体大小
@property (nonatomic, strong)   UIColor*  animaFontColor;   //
@end

@interface PetConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(PetConfig *)share;

-(PetDef *)getPetDefWithPetId:(NSInteger)petId;
@end

// ------------------------------------------------------------------------

@interface PetDataDef : NSObject

@property (nonatomic, assign) NSInteger petDataID;      // 怪物数据ID
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
@property (nonatomic, assign) NSInteger skillId1;       // 技能id1
@property (nonatomic, assign) NSInteger skill1Unlocklv; // 技能1解锁等级
@property (nonatomic, assign) NSInteger skillId2;       // 技能id2
@property (nonatomic, assign) NSInteger skill2Unlocklv; // 技能2解锁等级
@property (nonatomic, assign) NSInteger skillId3;       // 技能id3
@property (nonatomic, assign) NSInteger skill3Unlocklv; // 技能3解锁等级
@property (nonatomic, assign) NSInteger skillId4;       // 技能id4
@property (nonatomic, assign) NSInteger skill4Unlocklv; // 技能4解锁等级
@property (nonatomic, assign) NSInteger normalAttackSkillID; // 用于显示普通攻击的项目，对应Skill表里的某一项，只是取其配置，没有实际技能对应

-(NSInteger)getSkillIdAtIndex:(int)index;
-(NSInteger)getSkillUnlockLvWithIndex:(int)index;
@end

@interface PetDataConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(PetDataConfig *)share;

-(PetDataDef *)getPetDataDefWithDataId:(NSInteger)dataId;
@end
// ---------------------------------------------------------------------

@interface PetLvDef : NSObject

@property (nonatomic, assign) NSInteger petLv;      // 等级
@property (nonatomic, assign) NSInteger petExp;     // 经验

@end

@interface PetLvConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(PetLvConfig *)share;

-(PetLvDef *)getPetLvDefWithLevel:(NSNumber*)level;
@end

