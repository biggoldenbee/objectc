//
//  AttributeString.h
//  Miner
//
//  Created by zhihua.qian on 14-12-10.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BattleData.h"

typedef enum
{
    BML_Normal = 0,                 // 普通-------------对应的颜色：黑色
    BML_Name_Friend = 1,            // 自己和友方的名字---对应的颜色：紫红色
    BML_Name_Monster = 2,           // 敌方的名字--------对应的颜色：蓝色
    BML_Damage = 3,                 // 伤害值-----------对应的颜色：红色
    BML_Skill = 4,                  // 技能和状态--------对应的颜色：棕色
    
    BML_Item = 5,                   // 物品的名字--------对应的颜色：青色
    
    BML_Equi_One = 6,               // 一星装备的名字-----对应的颜色：浅灰色
    BML_Equi_Two = 7,               // 二星装备的名字-----对应的颜色：白色
    BML_Equi_Thr = 8,               // 三星装备的名字-----对应的颜色：绿色
    BML_Equi_Four = 9,              // 四星装备的名字-----对应的颜色：蓝色
    BML_Equi_Five = 10,             // 五星装备的名字-----对应的颜色：紫色
    
    BML_Level = 11,                 // 战斗中敌方等级-----对应的颜色：橙色
    BML_Cure = 12,                  // 战斗中的治疗-------对应的颜色：绿色
    BML_Dead = 13,                  // 战斗死亡--------对应的颜色：黑色
    BML_Buff = 14,
}
BATTLE_MESSAGE_LEVEL;

@interface AttributeString : NSObject
+(UIColor*)colorForMode:(BATTLE_MESSAGE_LEVEL)mode;

@property (nonatomic, strong) NSAttributedString* attrString;
@property (nonatomic, strong) NSArray* results;

#pragma mark - 战斗需要用到的
-(id)initWithActor:(BattleActor*)actor;
-(id)initWithSubAction:(BattleSubAction*)action;
-(id)initWithMine:(BattleMine*)mine;
-(id)initWithBrief:(BattleBrief *)brief;

+(NSAttributedString*)nameFromActor:(BattleActor*)actor anima:(BOOL)anima;
+(NSAttributedString*)stringWithString:(NSString*)string mode:(BATTLE_MESSAGE_LEVEL)mode;
+(NSAttributedString*)stringWithString:(NSString *)string fontSize:(float)fontSize fontBold:(BOOL)fontBold foregroundColor:(UIColor*)foregroundColor strokeColor:(UIColor*)strokeColor strokeSize:(float)strokeSize;
//-(id)initWithItemType:(int)itemID;
//-(id)initWithEquipmentType:(int)typeID level:(int)level;
//-(id)initWithFormat:(NSString*)format strings:(NSDictionary*)strings;
@end
