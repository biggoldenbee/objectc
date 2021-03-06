//
//  Hero.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-3.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroConfig.h"

@class Pet;
@class Equipment;
@class BaseAttribute;

@interface Hero : NSObject
@property (nonatomic, strong) NSString* inviteCode;     // 邀请码

@property (nonatomic, strong) NSNumber* heroIdentifier; // ID(获取)
@property (nonatomic, strong) NSString* heroName;       // 名字(获取)
@property (nonatomic, strong) NSNumber* heroLevel;      // 等级
@property (nonatomic, strong) NSNumber* heroZone;       // 区号
@property (nonatomic, strong) NSNumber* heroIcon;       // 头像
@property (nonatomic, strong) NSNumber* heroCurrentExp; // 当前经验
@property (nonatomic, strong) NSNumber* heroMaxExp;     // 当前等级最大经验(计算)
@property (nonatomic, strong) NSNumber* heroMap;        // 当前挂机地图等级
@property (nonatomic, strong) NSNumber* heroTopMap;     // 最高地图等级
@property (nonatomic, strong) NSNumber* heroCoin;       // 付费币
@property (nonatomic, strong) NSNumber* heroMoney;      // 免费币
@property (nonatomic, strong) NSNumber* heroEther;      // 以太币
@property (nonatomic, strong) NSNumber* heroCntrb;      // 贡献度
@property (nonatomic, strong) NSNumber* heroCLevel;     // 贡献度等级
@property (nonatomic, strong) NSNumber* heroSkillPoint; // 技能点数
@property (nonatomic, strong) NSNumber* heroPrestige;   // 声望（暂时不用）
@property (nonatomic, strong) NSNumber* heroBv;         // 裸身战力
@property (nonatomic, strong) NSNumber* heroRkldr;      // 天梯排名
@property (nonatomic, strong) NSNumber* heroLdr;        // 天梯剩余次数  >0 免费的次数 ； <0 收费次数
@property (nonatomic, strong) NSNumber* heroQck;        // 快速战斗的剩余次数
@property (nonatomic, strong) NSNumber* heroBoss;       // 打boss与扫荡的剩余次数
@property (nonatomic, strong) NSNumber* heroVipLevel;   //

@property (nonatomic, strong) NSArray* heroSkillsArray; // 技能数组，现在使用的技能
@property (nonatomic, strong) NSArray* heroBuffsArray;  // Buff数组，单项为Buff类对象
@property (nonatomic, strong) NSArray* heroEquitsArray; // 装备数组，单项为equip类对象
@property (nonatomic, strong) NSArray* heroPetArray;    // 宠物对象数组
@property (nonatomic, strong) HeroDef *heroLevelData;   // 主角在这个等级时候的基础属性数值
@property (nonatomic, strong) BaseAttribute* heroAttributes;    // 主角属性

#pragma mark - 人物属性的设置和重置
-(void)setHeroDataWithDictionary:(NSDictionary *)data;   // 根据字典设置数据
-(void)setInviteCodeWithObject:(NSString*)code;          // 设置邀请码

-(void)changeEquipWithDictionary:(NSDictionary *)data isHero:(BOOL)sure;    // 根据字典更换装备

#pragma mark - 与 宠物 有关的方法
-(Pet *)getPetWithIdentifier:(NSNumber *)petId; // 根据ID获取宠物
-(Pet *)getPetWithType:(NSNumber *)type;        // 根据类型获取宠物

#pragma mark - 与 装备 有关的方法
-(Equipment *)getEquipmentWithIdentifier:(NSNumber *)equipId;   // 根据id获取装备
-(Equipment *)getEquipmentWithSlot:(NSNumber*)slot withPetId:(NSNumber*)petId;

-(void)addEquipToPet:(Equipment *)equip withPetId:(NSNumber*)identifier;      // 添加装备到战斗宠物身上
-(void)removeEquipFromPet:(Equipment *)equip withPetId:(NSNumber*)identifier; // 从战斗宠物上移除装备

-(void)addEquipToHero:(Equipment *)equip;       // 添加装备到主角身上
-(void)removeEquipFromHero:(Equipment *)equip;  // 从主角身上移除装备

#pragma mark - 获取需要计算的属性
-(float)getExpPercent;      // 获取经验百分比
-(float)getCntrbPercent;    // 获取贡献度百分比

#pragma mark - 与 技能 有关的方法
-(void)addSkillWithId:(NSNumber*)skillId  withLv:(NSNumber*)lv;
-(void)removeSkillWithId:(NSNumber*)skillId;

#pragma mark - 与 钱币 有关的方法
-(void)addHeroMoney:(NSInteger)count;
-(void)reduceHeroMoney:(NSInteger)count;

-(BOOL)hasBetterEquipmentForHero;
-(BOOL)hasBetterEquipmentForPet;
@end
