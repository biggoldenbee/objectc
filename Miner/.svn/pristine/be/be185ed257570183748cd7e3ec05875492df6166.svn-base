//
//  BaseAttribute.h
//  Miner
//
//  Created by zhihua.qian on 15/1/12.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    // main attri
    ATTRI_TYPE_ATK = 1,
    ATTRI_TYPE_DEF = 2,
    ATTRI_TYPE_PDEF = 3,
    ATTRI_TYPE_MDEF = 4,
    ATTRI_TYPE_SPD = 5,
    ATTRI_TYPE_HP = 6,
    ATTRI_TYPE_FOUND = 7,
    ATTRI_TYPE_DIG = 8,
    
    // sub attri
    ATTRI_TYPE_CRI = 51,
    ATTRI_TYPE_ANTCRI = 52,
    ATTRI_TYPE_DODGE = 53,
    ATTRI_TYPE_HIT = 54,
    ATTRI_TYPE_PARRY = 55,
    ATTRI_TYPE_ANTPARRY = 56,
    ATTRI_TYPE_TAL = 57,
    ATTRI_TYPE_STR = 58,
    ATTRI_TYPE_INT = 59,
    ATTRI_TYPE_COR = 60,
    ATTRI_TYPE_AGI = 61,
    ATTRI_TYPE_STA = 62,
    
}
TYPE_ATTRIBUTE;

//
// 这个类是用来给战斗的时候用的
//
@interface BaseAttribute : NSObject

// 主属性
@property (nonatomic, strong) NSNumber* attriAtkValue;       // 攻击力
@property (nonatomic, strong) NSNumber* attriDefValue;       // 护甲
@property (nonatomic, strong) NSNumber* attriPDefValue;      // 物防
@property (nonatomic, strong) NSNumber* attriMDefValue;      // 魔防
@property (nonatomic, strong) NSNumber* attriSpdValue;       // 速度
@property (nonatomic, strong) NSNumber* attriHpMaxValue;     // 最大血量
@property (nonatomic, strong) NSNumber* attriFoundValue;     // 探测值
@property (nonatomic, strong) NSNumber* attriDigValue;       // 挖掘值

// 副属性
@property (nonatomic, strong) NSNumber* attriCriValue;       // 暴击值
@property (nonatomic, strong) NSNumber* attriAntiCriValue;   // 韧性值
@property (nonatomic, strong) NSNumber* attriHitValue;       // 命中值
@property (nonatomic, strong) NSNumber* attriDodgeValue;     // 闪避值
@property (nonatomic, strong) NSNumber* attriParryValue;     // 招架值
@property (nonatomic, strong) NSNumber* attriAntiParryValue; // 精准值

@property (nonatomic, strong) NSNumber* attriTalValue;  // 天资
@property (nonatomic, strong) NSNumber* attriStrValue;  // 力量
@property (nonatomic, strong) NSNumber* attriIntValue;  // 智力
@property (nonatomic, strong) NSNumber* attriCorValue;  // 体质
@property (nonatomic, strong) NSNumber* attriAgiValue;  // 敏捷
@property (nonatomic, strong) NSNumber* attriStaValue;  // 耐力

// 其他
@property (nonatomic, strong) NSNumber* attriPAtkValue;     // 物理攻击力
@property (nonatomic, strong) NSNumber* attriMAtkValue;     // 魔法攻击力
@property (nonatomic, strong) NSNumber* attriCRiRValue;        // 暴击率
@property (nonatomic, strong) NSNumber* attriAntiCriRValue;    // 韧性率
@property (nonatomic, strong) NSNumber* attriHitRValue;        // 命中率
@property (nonatomic, strong) NSNumber* attriDodgeRValue;      // 闪避率
@property (nonatomic, strong) NSNumber* attriParryRValue;      // 招架率
@property (nonatomic, strong) NSNumber* attriAntiParryRValue;  // 精准率


-(void)setHeroDataWithLevel:(NSNumber*)level;
-(void)setPetDataWithId:(NSNumber*)identifier atLevel:(NSNumber*)level;
-(void)scaleBaseAttriWithValueCode:(int)type addValue:(int)value;
@end

