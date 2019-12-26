//
//  BaseAttribute.m
//  Miner
//
//  Created by zhihua.qian on 15/1/12.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BaseAttribute.h"
#import "HeroConfig.h"
#import "PetConfig.h"
#import "UtilityDef.h"

@implementation BaseAttribute
-(id)init
{
    self = [super init];
    if (self)
    {
        self.attriPAtkValue     = DefaultValue;
        self.attriMAtkValue     = DefaultValue;
        self.attriCRiRValue     = DefaultValue;
        self.attriAntiCriRValue = DefaultValue;
        self.attriHitRValue     = DefaultValue;
        self.attriDodgeRValue   = DefaultValue;
        self.attriParryRValue   = DefaultValue;
        self.attriAntiParryRValue = DefaultValue;
    }
    return self;
}

-(void)setHeroDataWithLevel:(NSNumber*)level
{
    HeroDef* def = [[HeroConfig share] getHeroLevelDataWithLevel:level];
    self.attriHpMaxValue = [[NSNumber alloc] initWithInteger:[def hp]];
    self.attriAtkValue   = [[NSNumber alloc] initWithInteger:[def atk]];
    self.attriDefValue   = [[NSNumber alloc] initWithInteger:[def def]];
    self.attriPDefValue  = [[NSNumber alloc] initWithInteger:[def pdef]];
    self.attriMDefValue  = [[NSNumber alloc] initWithInteger:[def mdef]];
    self.attriSpdValue   = [[NSNumber alloc] initWithInteger:[def spd]];
    self.attriFoundValue = [[NSNumber alloc] initWithInteger:[def foundVal]];
    self.attriDigValue   = [[NSNumber alloc] initWithInteger:[def digVal]];
    
    self.attriCriValue       = [[NSNumber alloc] initWithInteger:[def cri]];
    self.attriAntiCriValue   = [[NSNumber alloc] initWithInteger:[def antiCri]];
    self.attriHitValue       = [[NSNumber alloc] initWithInteger:[def hit]];
    self.attriDodgeValue     = [[NSNumber alloc] initWithInteger:[def dodge]];
    self.attriParryValue     = [[NSNumber alloc] initWithInteger:[def parry]];
    self.attriAntiParryValue = [[NSNumber alloc] initWithInteger:[def antiParry]];
}
-(void)setPetDataWithId:(NSNumber*)identifier atLevel:(NSNumber*)level
{
    PetDef* def = [[PetConfig share] getPetDefWithPetId:[identifier integerValue]];
    PetDataDef* dataDef = [[PetDataConfig share] getPetDataDefWithDataId:[def petDataID]];
    
    NSInteger lv = [level integerValue];
    self.attriHpMaxValue = [[NSNumber alloc] initWithInteger:[dataDef hp]+[dataDef hp_lv]*lv];
    self.attriAtkValue   = [[NSNumber alloc] initWithInteger:[dataDef atk]+[dataDef atk_lv]*lv];
    self.attriDefValue   = [[NSNumber alloc] initWithInteger:[dataDef def]+[dataDef def_lv]*lv];
    self.attriPDefValue  = [[NSNumber alloc] initWithInteger:[dataDef pdef]+[dataDef pdef_lv]*lv];
    self.attriMDefValue  = [[NSNumber alloc] initWithInteger:[dataDef mdef]+[dataDef mdef_lv]*lv];
    self.attriSpdValue   = [[NSNumber alloc] initWithInteger:[dataDef spd]+[dataDef spd_lv]*lv];
    self.attriFoundValue = DefaultValue;
    self.attriDigValue   = DefaultValue;
    
    self.attriCriValue       = [[NSNumber alloc] initWithInteger:[dataDef cri]+[dataDef cri_lv]*lv];
    self.attriAntiCriValue   = [[NSNumber alloc] initWithInteger:[dataDef antiCri]+[dataDef antiCri_lv]*lv];
    self.attriHitValue       = [[NSNumber alloc] initWithInteger:[dataDef hit]+[dataDef hit_lv]*lv];
    self.attriDodgeValue     = [[NSNumber alloc] initWithInteger:[dataDef dodge]+[dataDef dodge_lv]*lv];
    self.attriParryValue     = [[NSNumber alloc] initWithInteger:[dataDef parry]+[dataDef parry_lv]*lv];
    self.attriAntiParryValue = [[NSNumber alloc] initWithInteger:[dataDef antiParry]+[dataDef antiParry_lv]*lv];
}

-(void)scaleBaseAttriWithValueCode:(int)type addValue:(int)value
{
    switch (type)
    {
        // main attribute
        case ATTRI_TYPE_HP: // 血
        {
            int hp = [self.attriHpMaxValue intValue];
            self.attriHpMaxValue = [NSNumber numberWithInt:(hp + value)];
        }
            break;
        case ATTRI_TYPE_ATK: // 攻
        {
            int atk = [self.attriAtkValue intValue];
            self.attriAtkValue = [NSNumber numberWithInt:(atk + value)];
        }
            break;
        case ATTRI_TYPE_DEF: // 护甲
        {
            int def = [self.attriDefValue intValue];
            self.attriDefValue = [NSNumber numberWithInt:(def + value)];
        }
            break;
        case ATTRI_TYPE_PDEF: // 物防
        {
            int pdef = [self.attriPDefValue intValue];
            self.attriPDefValue = [NSNumber numberWithInt:(pdef + value)];
        }
            break;
        case ATTRI_TYPE_MDEF: // 魔防
        {
            int mdef = [self.attriMDefValue intValue];
            self.attriMDefValue = [NSNumber numberWithInt:(mdef + value)];
        }
            break;
        case ATTRI_TYPE_SPD: // 速度
        {
            int spd = [self.attriSpdValue intValue];
            self.attriSpdValue = [NSNumber numberWithInt:(spd + value)];
        }
            break;
        case ATTRI_TYPE_FOUND: // 发现
        {
            int foundValue = [self.attriFoundValue intValue];
            self.attriFoundValue = [NSNumber numberWithInt:(foundValue + value)];
        }
            break;
        case ATTRI_TYPE_DIG: // 开采
        {
            int digValue = [self.attriDigValue intValue];
            self.attriDigValue = [NSNumber numberWithInt:(digValue + value)];
        }
            break;
        // sub attribute
        case ATTRI_TYPE_CRI: // 暴击值
        {
            int criValue = [self.attriCriValue intValue];
            self.attriCriValue = [NSNumber numberWithInt:(criValue + value)];
        }
            break;
        case ATTRI_TYPE_ANTCRI: // 韧性值
        {
            int antiCriValue = [self.attriAntiCriValue intValue];
            self.attriAntiCriValue = [NSNumber numberWithInt:(antiCriValue + value)];
        }
            break;
        case ATTRI_TYPE_DODGE: // 闪避值
        {
            int dodgeValue = [self.attriDodgeValue intValue];
            self.attriDodgeValue = [NSNumber numberWithInt:(dodgeValue + value)];
        }
            break;
        case ATTRI_TYPE_HIT: // 命中值
        {
            int hitValue = [self.attriHitValue intValue];
            self.attriHitValue = [NSNumber numberWithInt:(hitValue + value)];
        }
            break;
        case ATTRI_TYPE_PARRY: // 招架值
        {
            int parryValue = [self.attriParryValue intValue];
            self.attriParryValue = [NSNumber numberWithInt:(parryValue + value)];
        }
            break;
        case ATTRI_TYPE_ANTPARRY: // 精准值
        {
            int antiParryValue = [self.attriAntiParryValue intValue];
            self.attriAntiParryValue = [NSNumber numberWithInt:(antiParryValue + value)];
        }
            break;
        case ATTRI_TYPE_TAL: // 天资
        {
            int talValue = [self.attriTalValue intValue];
            self.attriTalValue = [NSNumber numberWithInt:(talValue + value)];
            [self scaleBaseAttriWithValueCode:ATTRI_TYPE_ATK addValue:value*0.1];
        }
            break;
        case ATTRI_TYPE_STR: // 力量
        {
            int strValue = [self.attriStrValue intValue];
            self.attriStrValue = [NSNumber numberWithInt:(strValue + value)];
            [self scaleBaseAttriWithValueCode:ATTRI_TYPE_DEF addValue:value*0.1];
        }
            break;
        case ATTRI_TYPE_INT: // 智力
        {
            int intValue = [self.attriIntValue intValue];
            self.attriIntValue = [NSNumber numberWithInt:(intValue + value)];
            [self scaleBaseAttriWithValueCode:ATTRI_TYPE_MDEF addValue:value*0.1];
        }
            break;
        case ATTRI_TYPE_COR: // 体质
        {
            int corValue = [self.attriCorValue intValue];
            self.attriCorValue = [NSNumber numberWithInt:(corValue + value)];
            [self scaleBaseAttriWithValueCode:ATTRI_TYPE_PDEF addValue:value*0.1];
        }
            break;
        case ATTRI_TYPE_AGI: // 敏捷
        {
            int agiValue = [self.attriAgiValue intValue];
            self.attriAgiValue = [NSNumber numberWithInt:(agiValue + value)];
            [self scaleBaseAttriWithValueCode:ATTRI_TYPE_SPD addValue:value*0.1];
        }
            break;
        case ATTRI_TYPE_STA: // 耐力
        {
            int staValue = [self.attriStaValue intValue];
            self.attriStaValue = [NSNumber numberWithInt:(staValue + value)];
            [self scaleBaseAttriWithValueCode:ATTRI_TYPE_HP addValue:value];
        }
            break;
        default:
            break;
    }
}
@end
