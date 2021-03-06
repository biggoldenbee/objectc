//
//  Pet.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PetConfig.h"

@class BaseAttribute;

@class Equipment;

//
// 这个Pet类不知道有什么用  先放在这  感觉有用
// 还真是有用
//
@interface Pet : NSObject

@property (nonatomic, strong) NSNumber* petId;         // ID
@property (nonatomic, strong) NSString* petName;       // 名字
@property (nonatomic, strong) NSString* petDesc;       // 描述
@property (nonatomic, strong) NSString* petIcon;       // 图片
@property (nonatomic, strong) NSNumber* petLevel;      // 等级
@property (nonatomic, strong) NSNumber* curExp;        // 当前经验
@property (nonatomic, strong) NSNumber* maxExp;        // 最高经验
@property (nonatomic, strong) BaseAttribute* basicAttri;    // 基础数值
@property (nonatomic, strong) NSNumber* petBV;          // 裸身战斗力
@property (nonatomic, strong) NSArray*  petEquitsArray;   // 装备信息
@property (nonatomic, strong) NSArray*  skillsArray;    // 技能信息
@property (nonatomic, strong) PetDef*   petDef;
@property (nonatomic, assign) BOOL      isBattle;       // 是否出战 0 未出战：1 已出战

-(void)setPetDataWithDictionary:(NSDictionary *)data;   // 初始化宠物信息

-(void)changeEquipWithDictionary:(NSDictionary *)data;  // 更改宠物身上装备信息
-(Equipment *)getEquipmentWithIdentifier:(NSNumber *)identifier;    // 根据ID查找身上的装备
-(Equipment *)getEquipmentWithSlot:(NSNumber*)slot;

-(void)addEquip:(Equipment *)equip;     // 添加装备
-(void)removeEquip:(Equipment *)equip;  // 移除装备
@end