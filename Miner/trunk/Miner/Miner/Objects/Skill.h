//
//  Skill.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkillConfig.h"

@interface Skill : NSObject
+(NSArray*)createDefaultAllSkill;

@property (nonatomic, strong) NSNumber* skillTId;       // 技能ID
@property (nonatomic, strong) NSNumber* skillLv;        // 技能等级
@property (nonatomic, strong) NSString* skillName;      // 技能名称
@property (nonatomic, strong) NSString* skillDesc;      // 技能描述
@property (nonatomic, strong) NSString* skillIcon;      // 技能图标
@property (nonatomic, strong) NSNumber* needHeroLV;     // 开放等级
@property (nonatomic, strong) NSDictionary* itemDatas;  // 升级物品字典
@property (nonatomic, strong) NSNumber* skillCastVal;   // 技能释放权重值
@property (nonatomic, strong) NSNumber* skillTarget;    // 技能目标：1 自己；2 单个敌方；3 己方全体；4 敌方全体
@property (nonatomic, strong) NSNumber* skillAtkType;   // 攻击类型：1 普通；2 物理；3 魔法；4 非攻击类
@property (nonatomic, strong) NSNumber* attriID1;        // 属性性质：？？？
@property (nonatomic, strong) NSNumber* skillNum1;       // 技能数值：根据技能来定
@property (nonatomic, strong) NSNumber* attriID2;        // 属性性质：？？？
@property (nonatomic, strong) NSNumber* skillNum2;       // 技能数值：根据技能来定
@property (nonatomic, strong) NSNumber* skillCD;        // 技能冷却回合
@property (nonatomic, strong) NSDictionary *buffDatas;  // 技能产生的buff
@property (nonatomic, strong) NSString* attackingAnimation;         //  攻击动画名称
@property (nonatomic, strong) NSString* attackingEffectAnimation;   //  攻击特效名称
@property (nonatomic, strong) NSString* defendingAnimation;         //  防御动画名称
@property (nonatomic, strong) NSString* defendingEffectAnimation;   //  防御特效名称
@property (nonatomic, strong) NSNumber* logFontSize;                //  字体大小
@property (nonatomic, strong) UIColor* logFontColor;                //  字体颜色
@property (nonatomic, strong) NSNumber* animaFontSize;              //  战斗字体大小
@property (nonatomic, strong) UIColor* animaFontColor;              //  战斗字体颜色
@property (nonatomic, assign) BOOL skillIsActive;       // 是否装配到身上

// 临时添加
@property (nonatomic, assign) BOOL isLocked;            // 是否锁住

//@property (nonatomic, strong) SkillDef* skillBaseDef;
-(void)setSkillDataWithSId:(NSNumber *)sid  withLevel:(NSNumber*)slv isActive:(BOOL)isAc;           // 设置使用的技能
@end
