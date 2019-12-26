//
//  GameObject.h
//  Miner
//  GameObject
//  处理游戏相关的一些数据结构等
//  Created by jim kaden on 14/10/23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//
//  PS：管理主角、宠物、怪物的实例。

#import <Foundation/Foundation.h>
#import "Hero.h"
#import "Bag.h"
#import "Pet.h"
#import "Monstor.h"
#import "LadderCompetitor.h"
#import "Reward.h"
#import "Friend.h"

@class Equipment;
@class Item;

@interface GameObject : NSObject

+(GameObject*)sharedInstance;

@property (nonatomic, strong) Hero      *player;        // 主角对象
@property (nonatomic, strong) Bag       *bag;           // 主角背包对象

@property (nonatomic, strong) NSMutableArray* ldrInfos; // 天梯信息
@property (nonatomic, strong) NSMutableArray* rewardInfos; // 天梯信息

@property (nonatomic, strong) Friend    *preHome;       // 上家信息
@property (nonatomic, strong) NSMutableArray   *nextHomes;     // 下家信息

// about hero
-(void)setPlayerWithDictionary:(NSDictionary *)data;    // 初始化主角
-(void)setInviteCodeWithObject:(NSString*)code;         // 设置邀请码
-(NSArray*)getHeroSkillsArray;                          // 获取主角技能
-(NSArray*)getHeroEquipsArray;                          // 获取主角装备

// about bag
-(void)setBagWithDictionary:(NSDictionary *)data;       // 初始化背包信息
-(NSArray*)getEquipsInBag;

-(void)setLdrWithArray:(NSArray*)data;                  // 天梯
-(void)setRewardWithArray:(NSArray*)data;               // 奖励

// about relation
-(void)setPreHomeWithDictionary:(NSDictionary *)data;   // 初始化上家信息
-(void)setNextHomeWithArray:(NSArray *)data;            // 初始化下家信息
-(void)removeNextHomeByIndex:(NSUInteger)index;         // 移除下家信息

// about item
-(Item*)getItemWithIId:(NSNumber*)identifier;           // 根据IID获取道具
-(Item*)getItemWithTId:(NSNumber*)identifier;           // 根据TID获取道具

// about pet
-(NSArray*)getAllPetsFromHero;
-(Pet *)getPetWithIdentifier:(NSNumber *)identifier;    // 根据ID获取宠物
-(Pet *)getPetWithType:(NSNumber *)type;                // 根据type获取宠物

// about equip
-(Equipment*)getEquipWithEId:(NSNumber*)identifier;     // 根据ID获取装备
-(NSArray*)getEquipsFromBagWithSlot:(NSNumber*)slot;    // 根据slot获取装备
-(Equipment*)getEquipmentWithSlot:(NSNumber*)slot withPetId:(NSNumber*)petId;

-(void)moveEquipFromPetToBag:(Equipment *)equip;        // 把装备从宠物身上移到背包
-(void)moveEquipFromBagToPet;       // 把装备从背包移到宠物身上

-(void)moveEquipFromHeroToBag:(Equipment *)equip;       // 把装备从主角身上移到背包
-(void)moveEquipFromBagToHero;      // 把装备从背包移到主角身上

-(void)removeEquipsFromBagWithArray:(NSArray *)listdata;   // 从背包里移除多个对象

-(void)changeEquipData:(NSDictionary *)equipData;

// change equip and unload equip
-(void)setWillChangedEquipWithId:(NSNumber*)equipId withPetId:(NSNumber*)petId;    // 设置将要用来更换的装备ID
-(Equipment *)getWillChangedEquipment;                  // 获取将要更换的装备
-(void)changeOneEquip;              // 通过界面更换装备
-(void)unloadOneEquip;          // 通过界面卸载装备
@end
