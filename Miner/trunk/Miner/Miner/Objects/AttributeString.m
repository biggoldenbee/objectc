//
//  AttributeString.m
//  Miner
//
//  Created by zhihua.qian on 14-12-10.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "AttributeString.h"
#import "SkillConfig.h"
#import "BuffConfig.h"
#import "ItemConfig.h"
#import "StringConfig.h"
#import "EquipmentConfig.h"
#import "MobConfig.h"
#import "PetConfig.h"
#import "GameUtility.h"
#import "HeroConfig.h"
#import "ConstantsConfig.h"
#import "Equipment.h"
#import "Item.h"

#import "GameObject.h"
@implementation AttributeString

/*
 以下函数需要变为查表
 */

+(UIColor*)colorForMode:(BATTLE_MESSAGE_LEVEL)mode
{
    switch(mode)
    {
        case BML_Normal:
            return [UIColor blackColor];
        case BML_Name_Friend:
            return [UIColor magentaColor];
        case BML_Name_Monster:
            return [UIColor blueColor];
        case BML_Damage:
            return [UIColor redColor];
        case BML_Skill:
            return [UIColor brownColor];
        case BML_Item:
            return [UIColor cyanColor];
        case BML_Equi_One:
            return [UIColor lightGrayColor];
        case BML_Equi_Two:
            return [UIColor whiteColor];
        case BML_Equi_Thr:
            return [UIColor greenColor];
        case BML_Equi_Four:
            return [UIColor blueColor];
        case BML_Equi_Five:
            return [UIColor purpleColor];
        case BML_Level:
            return [UIColor orangeColor];
        case BML_Cure:
            return [UIColor greenColor];
        case BML_Dead:
            return [UIColor blackColor];
        case BML_Buff:
            return [UIColor orangeColor];
        default:
            return [UIColor blackColor];
    }
}

#pragma mark - 根据 BattleActor 初始化对象
-(id)initWithActor:(BattleActor*)actor
{
    self = [super init];
    if (self)
    {
        if (actor != nil)
        {
            NSAttributedString* name = [self stringFromActor:actor anima:NO];
            NSAttributedString* level = [self stringWithString:[NSString stringWithFormat:@"%lu", actor.level] mode:BML_Level];
            NSAttributedString* hp = [self stringWithString:[NSString stringWithFormat:@"%lu", actor.hp] mode:BML_Normal];
            NSString* formatString = [[StringConfig share] getLocalLanguage:@"battlog_meet"];
            NSMutableDictionary* dictValues = [[NSMutableDictionary alloc]init];
            if ( name != nil )
                [dictValues setObject:name forKey:@"{0}"];
            if ( level != nil )
                [dictValues setObject:level forKey:@"{9}"];
            if ( hp != nil )
                [dictValues setObject:hp forKey:@"{8}"];
            self.attrString = [self createAttributeStringWithFormat:formatString strings:dictValues];
        }
    }
    return self;
}

+(NSAttributedString*)nameFromActor:(BattleActor*)actor anima:(BOOL)anima
{
    AttributeString* str = [[AttributeString alloc]init];
    return [str stringFromActor:actor anima:anima];
}
#pragma mark - 根据 BattleMine 初始化对象
-(id)initWithMine:(BattleMine*)mine
{    self = [super init];
    if (self)
    {
        if ( mine != nil && mine.battle != nil )
        {
            BattleDetail* battle = mine.battle;
            NSInteger actorCnt = battle.actors.count;
            
            BattleActor* miner = (mine.A >= 1 && mine.A <= actorCnt) ? [battle.actors objectAtIndex:(mine.A-1)] : nil ; // 挖矿者
            
            NSAttributedString* str0 = [self stringFromActor:miner anima:NO];
//            NSAttributedString* str1 = [self stringFromItemType:mine.mid level:0];
            NSAttributedString* str1 = [self stringFromMineType:mine.mid];
            NSString* formatString = [self formatFromMine:mine.ret];
            NSMutableDictionary* dictValues = [[NSMutableDictionary alloc]init];
            if ( str0 != nil )
                [dictValues setObject:str0 forKey:@"{0}"];
            if ( str1 != nil )
                [dictValues setObject:str1 forKey:@"{10}"];
            
            self.attrString = [self createAttributeStringWithFormat:formatString strings:dictValues];
        }
    }
    return self;
}

// 根据MineMob的ID显示
-(NSAttributedString*)stringFromMineType:(NSInteger)mid
{
    MineDef* md = [[MineConfig share] GetMineDefWithIdentifier:mid];
    if ( md == nil )
        return nil;
    NSString* name = [[StringConfig share] getLocalLanguage:md.mineName];
    if ( name == nil )
        return nil;

    NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attrsDictionary = @{
                                      NSForegroundColorAttributeName : md.logFontColor,
                                      NSFontAttributeName : [GameUtility getNormalFont:md.logFontSize],
                                      NSParagraphStyleAttributeName : ps,
                                      };
    NSAttributedString *attrString =[[NSAttributedString alloc] initWithString:name attributes:attrsDictionary];
    return attrString;

}

//
// 根据矿名和等级，生成NSAttributedString对象
//
-(NSAttributedString*)stringFromItemType:(NSInteger)mid level:(int)level
{
    BATTLE_MESSAGE_LEVEL bml = BML_Normal;
    NSString* itemString = nil;
    NSNumber* mineId = [[NSNumber alloc] initWithInteger:mid];
    UIColor* color = nil;
    UIFont* font = nil;
    UIImage* image = nil;
    int width = 12;
    if ( mid < 60000 )
    {
        bml = BML_Item;
        ItemDef* item = [[ItemConfig share] getItemDefWithKey:mineId];
        if ( item == nil )
            return [[NSAttributedString alloc]initWithString:@"未获得物品对象"];
        itemString = [[StringConfig share] getLocalLanguage:item.itemName];
        color = item.logFontColor;
        font = [GameUtility getNormalFont:item.logFontSize];
        image = [GameUtility imageNamed:item.itemIcon];
        width = (int)item.logFontSize;
    }
    else
    {
        EquipmentDef* equip = [[EquipmentConfig share] getEquipmentDefWithKey:mineId];
        if ( equip == nil )
            return [[NSAttributedString alloc]initWithString:@"未获得装备对象"];;
        itemString = [[StringConfig share] getLocalLanguage:equip.equipName];
        
        color = equip.logFontColor;
        font = [GameUtility getNormalFont:equip.logFontSize];
        image = [GameUtility imageNamed:equip.equipIcon];
        width = (int)equip.logFontSize;
    }
    
    NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSTextAttachment* attachment = [[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds = CGRectMake(0,0, width, width);
    NSMutableAttributedString* picString = [[NSAttributedString attributedStringWithAttachment:attachment] mutableCopy];
    
    NSMutableAttributedString* baseString = [[NSMutableAttributedString alloc]initWithString:itemString
                                                                                  attributes:@{
                                                                                               NSForegroundColorAttributeName : color,
                                                                                               NSParagraphStyleAttributeName : ps,
                                                                                               NSFontAttributeName : font,
                                                                                            }];
    [picString appendAttributedString:baseString];
    return picString;
}

-(NSString*)formatFromMine:(NSInteger)mineRet
{
    return [[StringConfig share] getLocalLanguage:[NSString stringWithFormat:@"battlog_mine%d", (int)mineRet]];
}

#pragma mark - 根据 BattleSubAction 初始化对象
//
// 最终形成  A 使用了 S 对 B 造成了 V 的伤害
//
-(id)initWithSubAction:(BattleSubAction*)subAction
{
    self = [super init];
    if (self)
    {
        if ( subAction != nil && subAction.action != nil && subAction.action.battle != nil )
        {
            BattleDetail* battle = subAction.action.battle;
            NSInteger actorCnt = battle.actors.count;       // 参与本次战斗的人员总数（人，宠，怪）
            
            // 获取攻击者和防御者
            BattleActor* attacker = (subAction.action.A >= 1 && subAction.action.A <= actorCnt) ? [battle.actors objectAtIndex:(subAction.action.A-1)] : nil ;
            BattleActor* defender = (subAction.B >= 1 && subAction.B <= actorCnt) ? [battle.actors objectAtIndex:(subAction.B-1)] : nil;
            
            // 三个attributeString，描述：攻击者 防御者 和行为结果（一般指伤害值）
            NSAttributedString* str0 = [self stringFromActor:attacker anima:NO];     // 攻击者
            NSAttributedString* str1 = [self stringFromActor:defender anima:NO];     // 防御者
            NSAttributedString* str2 = [self stringFromValue2:subAction];   // 伤害值
            NSAttributedString* str4 = [self stringWithString:[NSString stringWithFormat:@"%ld", subAction.action.turn + 1] mode:BML_Normal];
            NSAttributedString* str5 = nil;
            // 攻击者使用的技能
            NSInteger skillID = subAction.action.sid;
            // 攻击者使用的技能等级
            NSInteger skillLv = subAction.action.slv;

            NSAttributedString* str3 = [self stringFromSkill:(int)skillID withLevel:(int)skillLv];

            if (str3 == nil)
            {
                skillLv = 1;
                
                if ( attacker.type == 0 || attacker.type == 4 )
                {
                    skillID = 10000;
                    
                }
                else if ( attacker.type == 1 )
                {
                    PetDef* pd = [[PetConfig share] getPetDefWithPetId:attacker.mid];
                    if ( pd )
                    {
                        PetDataDef* pdc = [[PetDataConfig share] getPetDataDefWithDataId:pd.petDataID];
                        if ( pdc )
                        {
                            skillID = (int)pdc.normalAttackSkillID;
                        }
                    }
                }
                else if ( attacker.type == 2 || attacker.type == 3 || attacker.type == 5 )
                {
                    MobDef* md = [[MobConfig share] getMobDefById:attacker.mid];
                    if ( md )
                    {
                        MobDataDef* mdc = [[MobDataConfig share] getMobDataDefById:md.mobDataID];
                        if ( mdc )
                        {
                            skillID = (int)mdc.normalAttackSkillID;
                        }
                    }
                }
                
                str3 = [self stringFromSkill:(int)skillID withLevel:(int)skillLv];
            }
            
            if ( subAction.type == 2 )
            {
                int buffid = (int)abs((int)subAction.value1);
                int bufflv = (int)abs((int)subAction.value3);
                str5 = [self stringFromBuff:buffid withLevel:bufflv];
            }
            
            // 行文类型
            NSString* formatString = [self formatFromActionType:subAction.type subType:subAction.value1 value:(int)subAction.value2];
            NSMutableDictionary* dictValues = [[NSMutableDictionary alloc]init];
            if ( str0 != nil )
                [dictValues setObject:str0 forKey:@"{0}"];  // 攻击者
            if ( str1 != nil )
                [dictValues setObject:str1 forKey:@"{1}"];  // 防御者
            if ( str2 != nil )
                [dictValues setObject:str2 forKey:@"{2}"];  // 行为描述
            if ( str3 != nil )
                [dictValues setObject:str3 forKey:@"{3}"];  // 技能名称
            if ( str4 != nil )
                [dictValues setObject:str4 forKey:@"{4}"];  // 回合数
            if ( str5 != nil )
                [dictValues setObject:str5 forKey:@"{5}"];  // BuffName
            
            self.attrString = [self createAttributeStringWithFormat:formatString strings:dictValues];
        }
    }
    return self;
}

//
// B 数组里面的第二个value的处理
// 获得一个 NSAttributedString 字符串对象
//
-(NSAttributedString*)stringFromValue2:(BattleSubAction*)subAction
{
    BATTLE_MESSAGE_LEVEL bml = BML_Normal;
    
    NSString* value2 = [NSString stringWithFormat:@"%ld", (long)fabs(subAction.value2)];
    NSInteger key = subAction.type, subType = subAction.value1;
    
    switch(key)
    {
        case 0: // 对防御者B攻击
        {
            bml = BML_Damage;
            return [self stringWithString:value2 mode:bml];
        }
            break;
        case 1: // 对攻击者A反作用
        {
            if (subType == 0)
            {
                bml = BML_Damage;
            }
            if (subType == 1)
            {
                bml = BML_Cure;
            }
            return [self stringWithString:value2 mode:bml];
        }
            break;
        case 2: // 上buff
        {
            bml = BML_Skill;
            return [self stringWithString:value2 mode:bml];
        }
        case 3: // 状态改变
        {
            switch (subType)
            {
                case 0:
                    bml = BML_Damage;
                    break;
                case 255:
                    bml = BML_Cure;
                    break;
                case 351:
                    bml = BML_Skill;
                    break;
                case 352:
                case 353:
                    bml = BML_Normal;
                    break;
                default:
                    break;
            }
            return [self stringWithString:value2 mode:bml];
        }
            break;
    }
    
    return nil;
}

//
// 根据行为类型 和 子类型  获得一个 nsstring 对象
//
-(NSString*)formatFromActionType:(NSInteger)key subType:(NSInteger)subType value:(int)value
{
    int formatKeyIndex = 0;
    switch(key)
    {
        case 0: // 对 防御者B 攻击
        {
            switch (subType)
            {
                case -1:
                    formatKeyIndex=1;
                    break;
//                    return @"[{4}] {0} 没有攻击";
                case 0:
                    formatKeyIndex=2;
                    break;
//                    return @"[{4}] {0} 使用 {3} 对 {1} 产生了 {2} 点伤害";
                case 1:
                    formatKeyIndex=3;
                    break;
//                    return @"[{4}] {0} 使用 {3} 对 {1} 产生了 {2} 点暴击伤害";
                case 2:
                    formatKeyIndex=4;
                    break;
//                    return @"[{4}]&nbsp;{0}使用{3}对{1}产生了{2}点伤害（招架）";
                case 3:
                    formatKeyIndex=5;
                    break;
//                    return @"[{4}]&nbsp;{0}使用{3}对{1}产生了{2}点伤害（闪避）";
                case 4:
                    formatKeyIndex=6;
                    break;
//                    return @"[{4}]&nbsp;{0}使用{3}对{1}疗伤，增加血量{2} ";
            }
        }
            break;
        case 1: // 对 攻击者A 反作用
        {
            switch (subType)
            {
                case 0: // 攻击
                    formatKeyIndex=7;
                    break;
//                    return @"[{4}] {1} 对 {0} 反伤 {2} 点伤害";
                case 1: // 上buff
                    formatKeyIndex=8;
                    break;
//                    return @"[{4}] {1} 对 {0} {2}";
            }
        }
            break;
        case 2: // 给自己上buff
        {
            if ( value > 0 )
                formatKeyIndex=9;
//                return [NSString stringWithFormat:@"[{4}] {1} 因为%@获得{2}点", buffName];
            else if ( value == 0 )
                formatKeyIndex=10;
//                return [NSString stringWithFormat:@"[{4}] {1} %@", buffName];
            else
                formatKeyIndex=11;
//                return [NSString stringWithFormat:@"[{4}] {1} 因为%@损伤了{2}点", buffName];
        }
            break;
        case 3: // 状态改变
        {
            switch (subType)
            {
                case 0:
                    formatKeyIndex=12; break;
//                    return @"[{4}] {0} 死亡";
                case 1:
                    formatKeyIndex=13; break;
//                    return @"[{4}]&nbsp;{1}死亡";
                case 255:
                    formatKeyIndex=14; break;
//                    return @"[{4}]&nbsp;{0}&nbsp;吸血{2}";
                case 351:
                    formatKeyIndex=15; break;
//                    return @"[{4}]&nbsp;{0}无法攻击";
                case 352:
                    formatKeyIndex=16; break;
//                    return @"[{4}]&nbsp;{0}攻击两次";
                case 353:
                    formatKeyIndex=17; break;
//                    return @"[{4}]&nbsp;{0}只能普通攻击";
                case 354:
                    formatKeyIndex=18; break;
//                    return @"[{4}]&nbsp;{0}眩晕，无法攻击";
                case 355:
                    formatKeyIndex=19; break;
//                    return @"[{4}]&nbsp;{0}被冰冻，无法攻击";
            }
        }
            break;
    }
    if ( formatKeyIndex > 0 )
        return [[StringConfig share] getLocalLanguage:[NSString stringWithFormat:@"battlog_atk%d", formatKeyIndex]];
    return nil;
}

#pragma mark - 根据 BattleBrief 初始化对象
-(id)initWithBrief:(BattleBrief *)brief
{
    self = [super init];
    if (self)
    {
        if (brief != nil)
        {
            BattleActor* me = nil;
            for(BattleActor* ba in brief.battle.actors )
            {
                if ( ba.type == 0)
                {
                    me = ba;
                    break;
                }
            }
            // 获取攻击者和防御者
            NSAttributedString* str0 = [self stringFromActor:me anima:NO];
            NSString* winItemResultFormat = [[StringConfig share] getLocalLanguage:@"battlog_result_item"];
            NSString* winEquipResultFormat = [[StringConfig share] getLocalLanguage:@"battlog_result_equip"];
            
            if( brief.type == NormalBattle || brief.type == BossBattle || brief.type == BigBossBattle )
            {
                if ( brief.win > 0 )
                {
                    // result
                    NSMutableArray* result = [[NSMutableArray alloc] init];

                    NSString* formatBattleResult = [[StringConfig share] getLocalLanguage:@"battlog_result1"];
                    NSMutableDictionary* dictValuesForResult = [[NSMutableDictionary alloc]init];

                    if( str0!= nil )
                        [dictValuesForResult setObject:str0 forKey:@"{0}"];
                    NSAttributedString* battleResult = [self createAttributeStringWithFormat:formatBattleResult strings:dictValuesForResult];
                    [result addObject:battleResult];

                    // result for money
                    if ( brief.money > 0 )
                    {
                        NSAttributedString* money = [self stringWithString:[NSString stringWithFormat:@"%lu", brief.money] mode:BML_Damage];
                        NSAttributedString* moneyEmbededString = [self stringFromItemType:1 level:0];

                        
                        if ( money != nil )
                            [dictValuesForResult setObject:money forKey:@"{12}"];
                        if (moneyEmbededString != nil )
                            [dictValuesForResult setObject:moneyEmbededString forKey:@"{11}"];
                        
                        NSAttributedString* moneyString = [self createAttributeStringWithFormat:winItemResultFormat strings:dictValuesForResult];
                        [result addObject:moneyString];
                    }
                    
                    // result for exp
                    if ( brief.exp > 0 )
                    {
                        NSAttributedString* exp = [self stringWithString:[NSString stringWithFormat:@"%lu", brief.exp] mode:BML_Damage];
                        NSAttributedString* expEmbededString = [self stringFromItemType:3 level:0];

                        if ( exp != nil )
                            [dictValuesForResult setObject:exp forKey:@"{12}"];
                        if (expEmbededString != nil )
                            [dictValuesForResult setObject:expEmbededString forKey:@"{11}"];
                        
                        NSAttributedString* expString = [self createAttributeStringWithFormat:winItemResultFormat strings:dictValuesForResult];
                        [result addObject:expString];
                    }
                    // result for skill point
                    if ( brief.skillPoint > 0 )
                    {
                        NSAttributedString* sp = [self stringWithString:[NSString stringWithFormat:@"%lu", brief.skillPoint] mode:BML_Damage];
                        NSAttributedString* spEmbededString = [self stringFromItemType:8 level:0];
                        
                        if ( sp != nil )
                            [dictValuesForResult setObject:sp forKey:@"{12}"];
                        if (spEmbededString != nil )
                            [dictValuesForResult setObject:spEmbededString forKey:@"{11}"];
                        
                        NSAttributedString* spString = [self createAttributeStringWithFormat:winItemResultFormat strings:dictValuesForResult];
                        [result addObject:spString];
                    }
                    
                    [dictValuesForResult removeObjectForKey:@"{12}"];
                    for(Equipment* equip in brief.equips)
                    {
                        NSAttributedString* equipString = [self stringFromItemType:[equip.equipTId intValue] level:(int)equip.mainAttri.attriLevel];
                        
                        if (equipString != nil )
                        {
                            [dictValuesForResult setObject:equipString forKey:@"{11}"];
                            NSAttributedString* string = [self createAttributeStringWithFormat:winEquipResultFormat strings:dictValuesForResult];
                            [result addObject:string];
                        }
                    }
                    
                    for(Item* item in brief.items)
                    {
                        NSAttributedString* itemString = [self stringFromItemType:[item.itemType intValue] level:0];
                        NSAttributedString* countString = [self stringWithString:[NSString stringWithFormat:@"%d", (int)item.itemCount] mode:BML_Normal];
                        if ( countString != nil )
                            [dictValuesForResult setObject:countString forKey:@"{12}"];
                        else
                            [dictValuesForResult removeObjectForKey:@"{12}"];
                        
                        if (itemString != nil )
                        {
                            [dictValuesForResult setObject:itemString forKey:@"{11}"];
                            NSAttributedString* string = [self createAttributeStringWithFormat:winItemResultFormat strings:dictValuesForResult];
                            [result addObject:string];
                        }
                    }
                    
                    self.results = result;
                }
                else
                {
                    NSString* formatBattleResult = [[StringConfig share] getLocalLanguage:@"battlog_result2"];
                    NSMutableDictionary* dictValuesForResult = [[NSMutableDictionary alloc]init];
                    
                    if( str0!= nil )
                        [dictValuesForResult setObject:str0 forKey:@"{0}"];
                    NSAttributedString* battleResult = [self createAttributeStringWithFormat:formatBattleResult strings:dictValuesForResult];
                    
                    self.results = [[NSArray alloc]initWithObjects:battleResult, nil];
                }
            }
            else if (brief.type == MineBattle )
            {
                if (brief.mine <= 0 )
                {
                    NSString* formatBattleResult = [[StringConfig share] getLocalLanguage:@"battlog_result3"];
                    NSMutableDictionary* dictValuesForResult = [[NSMutableDictionary alloc]init];
                    
                    if( str0!= nil )
                        [dictValuesForResult setObject:str0 forKey:@"{0}"];
                    NSAttributedString* battleResult = [self createAttributeStringWithFormat:formatBattleResult strings:dictValuesForResult];

                    self.results = [[NSArray alloc]initWithObjects:battleResult, nil];
                }
            }
            else if (brief.type == OpenBoxBattle )
            {
                if (brief.boxWon && brief.boxWon.count > 0 )
                {
                    NSMutableDictionary* dictValuesForResult = [[NSMutableDictionary alloc]init];
                    if( str0!= nil )
                        [dictValuesForResult setObject:str0 forKey:@"{0}"];
                    
                    NSMutableArray* result = [[NSMutableArray alloc]init];
                    
                    NSArray* allKeys = [brief.boxWon allKeys];
                    for(NSString* boxIDString in allKeys )
                    {
                        NSString* formatOpenBoxResult = [[StringConfig share] getLocalLanguage:@"battlog_result4"];
                        NSAttributedString* boxEmbededString = [self stringFromItemType:[boxIDString intValue] level:0];
                        if( boxEmbededString!= nil )
                            [dictValuesForResult setObject:boxEmbededString forKey:@"{11}"];
                        
                        ItemDef* item = [[ItemConfig share] getItemDefWithKey:[NSNumber numberWithInt:[boxIDString intValue]]];
                        if ( item )
                        {
                            if(item.typeNum2 != 0 && item.typeNum3 != 0 )
                            {
                                formatOpenBoxResult = [[StringConfig share] getLocalLanguage:@"battlog_result5"];
                                NSAttributedString* requirementString = [self stringFromItemType:item.typeNum2 level:0];
                                NSAttributedString* countString = [self stringWithString:[NSString stringWithFormat:@"%d", (int)item.typeNum3] mode:BML_Normal];
                                [dictValuesForResult removeObjectForKey:@"{14}"];
                                [dictValuesForResult removeObjectForKey:@"{12}"];
                                if( requirementString!= nil )
                                    [dictValuesForResult setObject:requirementString forKey:@"{14}"];
                                if( countString!= nil )
                                    [dictValuesForResult setObject:countString forKey:@"{12}"];
                            }
                            
                        }
                        
                        NSAttributedString* string = [self createAttributeStringWithFormat:formatOpenBoxResult strings:dictValuesForResult];
                        [result addObject:string];

                    }
                    self.results = result;
                }
                else if ( brief.boxFailed && brief.boxFailed.count > 0 )
                {
                    NSMutableDictionary* dictValuesForResult = [[NSMutableDictionary alloc]init];
                    if( str0!= nil )
                        [dictValuesForResult setObject:str0 forKey:@"{0}"];
                    
                    NSMutableArray* result = [[NSMutableArray alloc]init];
                    
                    NSArray* allKeys = [brief.boxFailed allKeys];
                    for(NSString* boxIDString in allKeys )
                    {
                        NSString* formatOpenBoxResult = [[StringConfig share] getLocalLanguage:@"battlog_result6"];
                        NSAttributedString* boxEmbededString = [self stringFromItemType:[boxIDString intValue] level:0];
                        if( boxEmbededString!= nil )
                            [dictValuesForResult setObject:boxEmbededString forKey:@"{11}"];
                        
                        ItemDef* item = [[ItemConfig share] getItemDefWithKey:[NSNumber numberWithInt:[boxIDString intValue]]];
                        if ( item )
                        {
                            if(item.typeNum2 != 0 && item.typeNum3 != 0 )
                            {
                                formatOpenBoxResult = [[StringConfig share] getLocalLanguage:@"battlog_result5"];
                                NSAttributedString* requirementString = [self stringFromItemType:item.typeNum2 level:0];
                                NSAttributedString* countString = [self stringWithString:[NSString stringWithFormat:@"%d", (int)item.typeNum3] mode:BML_Normal];
                                [dictValuesForResult removeObjectForKey:@"{14}"];
                                [dictValuesForResult removeObjectForKey:@"{12}"];
                                if( requirementString!= nil )
                                    [dictValuesForResult setObject:requirementString forKey:@"{14}"];
                                if( countString!= nil )
                                    [dictValuesForResult setObject:countString forKey:@"{12}"];
                            }
                            
                        }
                        
                        NSAttributedString* string = [self createAttributeStringWithFormat:formatOpenBoxResult strings:dictValuesForResult];
                        [result addObject:string];
                        
                    }
                    self.results = result;
                }
            }
        }
    }
    return self;
}



#pragma mark - 共用的方法
// 根据BattleActor 来创建一个NSAttributedString类型的name
-(NSAttributedString*)stringFromActor:(BattleActor*)actor anima:(BOOL)anima
{
    if ( actor == nil )
        return nil;
    UIColor* color = [UIColor colorWithRed:0.13f green:0.545f blue:0.1333f alpha:1.0f];
    UIFont* font = [GameUtility getNormalFont:14];
    NSString* name = actor.name;
    
    if ( actor.type == 0 || actor.type == 4 )
    {
        name = actor.name;
        HeroDef* hd = [[HeroConfig share] getHeroLevelDataWithLevel:[NSNumber numberWithInteger:actor.level]];
        color = anima ? hd.animaFontColor : hd.logFontColor;
        font = [GameUtility getNormalFont:anima ? hd.animaFontSize : hd.logFontSize];
    }
    else if ( actor.type == 1 )
    {
        PetDef* pd = [[PetConfig share] getPetDefWithPetId:actor.mid];
        if ( pd )
        {
            name = [[StringConfig share] getLocalLanguage:pd.petName];
            color = anima ?  pd.animaFontColor : pd.logFontColor;
            font = [GameUtility getNormalFont:anima ? pd.animaFontSize : pd.logFontSize];
        }
    }
    else if ( actor.type == 2 || actor.type == 3 || actor.type == 5 )
    {
        MobDef* md = [[MobConfig share] getMobDefById:actor.mid];
        if ( md )
        {
            name = [[StringConfig share] getLocalLanguage:md.mobName];
            color = anima ? md.animaFontColor : md.logFontColor;
            font = [GameUtility getNormalFont: anima ? md.animaFontSize : md.logFontSize];
        }
    }
    
    NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString* baseString = [[NSMutableAttributedString alloc]initWithString:name
                                                                                  attributes:@{
                                                                                               NSForegroundColorAttributeName : color,
                                                                                               NSParagraphStyleAttributeName : ps,
                                                                                               NSFontAttributeName : font,
                                                                                               }];
    return baseString;
}

+(NSAttributedString*)stringWithString:(NSString*)string mode:(BATTLE_MESSAGE_LEVEL)mode
{
    AttributeString* as = [[AttributeString alloc]init];
    return [as stringWithString:string mode:mode];
}

// 返回一个NSAttributedString
-(NSAttributedString*)stringWithString:(NSString*)string mode:(BATTLE_MESSAGE_LEVEL)mode
{
    UIColor* color = [AttributeString colorForMode:mode];
    NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    
//    NSShadow* ss = [[NSShadow alloc] init];
//    ss.shadowOffset = CGSizeMake(1,1);
//    ss.shadowBlurRadius = 1;
//    ss.shadowColor = [UIColor blackColor];
    int logFontSize = (int)[[ConstantsConfig share] getConstantsData].logFontSize;
    NSDictionary *attrsDictionary = @{
                                      NSForegroundColorAttributeName : color,
                                      NSParagraphStyleAttributeName : ps,
                                      NSFontAttributeName : [GameUtility getNormalFont:logFontSize],
//                                      NSShadowAttributeName:ss,
//                                      NSVerticalGlyphFormAttributeName :@0,
//                                      NSStrokeColorAttributeName: [UIColor blackColor],
//                                      NSStrokeWidthAttributeName: @-3,
                                      
                                      };
    NSAttributedString *attrString =[[NSAttributedString alloc] initWithString:string attributes:attrsDictionary];
    return attrString;
}

//
// 根据字典里面的值  去替换format字符串中的字符
//
-(NSAttributedString*)createAttributeStringWithFormat:(NSString*)format strings:(NSDictionary*)strings
{
    if ( format == nil )
        return nil;
    else
    {
        NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
        ps.lineBreakMode = NSLineBreakByWordWrapping;
        int logFontSize = (int)[[ConstantsConfig share] getConstantsData].logFontSize;
        NSMutableAttributedString* baseString = [[NSMutableAttributedString alloc]initWithString:format
                                                                                      attributes:@{
                                                                                                   NSForegroundColorAttributeName : [[self class] colorForMode:BML_Normal],
                                                                                                   NSParagraphStyleAttributeName : ps,
                                                                                                   NSFontAttributeName : [GameUtility getNormalFont:logFontSize],
                                                                                                   }];
        
        NSString* refString = [NSString stringWithString:format];
        NSArray* escapes = strings.allKeys; // {0}，{1}，{2}，{3}这些东西
        
        for(int i = 0 ; i < escapes.count; i ++)
        {
            NSString* escape = [escapes objectAtIndex:i];
            NSAttributedString* toReplace = [strings objectForKey:escape];
            if ( toReplace == nil )
                continue;
            
            while(true)
            {
                // {0}或者{1}...在refstring中的开始位置和长度
                NSRange range = [refString rangeOfString:escape];
                
                if ( range.length == 0 )
                    break;
                
                refString  = [refString stringByReplacingCharactersInRange:range withString:[toReplace string]];
                [baseString replaceCharactersInRange:range withAttributedString:toReplace];
            }
        }
        return [[NSAttributedString alloc] initWithAttributedString:baseString];
    }
}

// 根据技能获得字符串
-(NSAttributedString*)stringFromSkill:(int)sid withLevel:(int)lv
{
    SkillBase* sb = [[SkillConfig share] getSkillBaseWithTId:[NSNumber numberWithInt:sid] withLevel:[NSNumber numberWithInt:lv]];
    if ( sb == nil )
        return nil;
    NSString* skillname = [[StringConfig share] getLocalLanguage:sb.skillName];
    
    if ( skillname == nil )
        return nil;
    
    NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString* baseString = [[NSMutableAttributedString alloc]initWithString:skillname
                                                                                  attributes:@{
                                                                                               NSForegroundColorAttributeName : sb.logFontColor,
                                                                                               NSParagraphStyleAttributeName : ps,
                                                                                               NSFontAttributeName : [GameUtility getNormalFont:sb.logFontSize],
                                                                                               }];
    return baseString;
}

-(NSAttributedString*)stringFromBuff:(int)bid withLevel:(int)blv;
{
    BuffBase* bb = [[BuffConfig share] getBuffBaseWithTId:[NSNumber numberWithInt:bid] withLevel:[NSNumber numberWithInt:blv]];
    if ( bb == nil )
        return nil;
    
    NSString* buffname = [[StringConfig share] getLocalLanguage:bb.buffName];
    if ( buffname == nil )
        return nil;
    
    NSMutableParagraphStyle* ps = [[NSMutableParagraphStyle alloc] init];
    ps.lineBreakMode = NSLineBreakByWordWrapping;
    NSMutableAttributedString* baseString = [[NSMutableAttributedString alloc]initWithString:buffname
                                                                                  attributes:@{
                                                                                               NSForegroundColorAttributeName : bb.logFontColor,
                                                                                               NSParagraphStyleAttributeName : ps,
                                                                                               NSFontAttributeName : [GameUtility getNormalFont:bb.logFontSize],
                                                                                               }];
    return baseString;
}

+(NSAttributedString*)stringWithString:(NSString *)string fontSize:(float)fontSize fontBold:(BOOL)fontBold foregroundColor:(UIColor*)foregroundColor strokeColor:(UIColor*)strokeColor strokeSize:(float)strokeSize
{
    UIFont* font = fontBold ? [GameUtility getBoldFont:fontSize] : [GameUtility getNormalFont:fontSize];
    NSShadow* ss = [[NSShadow alloc] init];
    ss.shadowOffset = CGSizeMake(0,0);
    ss.shadowBlurRadius = fabs(strokeSize);
    ss.shadowColor = strokeColor;//[UIColor blackColor];
    NSAttributedString* str = [[NSAttributedString alloc]initWithString:string
                                                                attributes:@{
                                                                             NSFontAttributeName : font,
                                                                             NSForegroundColorAttributeName : foregroundColor,
                                                                             NSVerticalGlyphFormAttributeName : @0,
                                                                             NSShadowAttributeName : ss,
                                                                             //NSStrokeColorAttributeName : strokeColor,
                                                                             //NSStrokeWidthAttributeName : [NSNumber numberWithFloat:strokeSize],
                                                                             }];
    return str;
}
@end
