//
//  Skill.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "Skill.h"
#import "UtilityDef.h"

@implementation Skill
+(NSArray*)createDefaultAllSkill
{
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    NSArray* allSkillDefs = [[SkillConfig share] getAllSkillDefs];
    for (SkillDef* skildef in allSkillDefs)
    {
        Skill* skill = [[Skill alloc] init];
        NSNumber* sid = [NSNumber numberWithInteger:[skildef skillId]];
        NSNumber* slv = [NSNumber numberWithInt:1];
        [skill setSkillDataWithSId:sid withLevel:slv isActive:NO];
        [tempArr addObject:skill];
    }
    return tempArr;
}

-(void)setSkillDataWithSId:(NSNumber *)sid withLevel:(NSNumber*)slv isActive:(BOOL)isAc
{
    self.skillTId   = sid;
    self.skillLv    = slv;
    
    SkillBase* base = [[SkillConfig share] getSkillBaseWithTId:sid withLevel:slv];
    self.skillName  = [base skillName];
    self.skillDesc  = [base skillDesc];
    self.skillIcon  = [base skillIcon];
    self.needHeroLV = INTEGER_TO_NUMBER([base needHeroLV]);
    self.itemDatas  = [NSDictionary dictionaryWithDictionary:[base itemDatas]];
    self.skillCastVal   = INTEGER_TO_NUMBER([base skillCastVal]);
    self.skillTarget    = INTEGER_TO_NUMBER([base skillTarget]);
    self.skillAtkType   = INTEGER_TO_NUMBER([base atkType]);
    self.attriID1    = INTEGER_TO_NUMBER([base attriID1]);
    self.skillNum1   = INTEGER_TO_NUMBER([base skillNum1]);
    self.attriID2    = INTEGER_TO_NUMBER([base attriID2]);
    self.skillNum2   = INTEGER_TO_NUMBER([base skillNum2]);
    self.skillCD    = INTEGER_TO_NUMBER([base skillCD]);
    self.buffDatas  = [NSDictionary dictionaryWithDictionary:[base buffDatas]];
    self.attackingAnimation         = [base attackingAnimation];
    self.attackingEffectAnimation   = [base attackingEffectAnimation];
    self.defendingAnimation         = [base defendingAnimation];
    self.defendingEffectAnimation   = [base defendingEffectAnimation];
    self.logFontSize    = INTEGER_TO_NUMBER([base logFontSize]);
    self.logFontColor   = [base logFontColor];
    self.animaFontSize  = INTEGER_TO_NUMBER([base animaFontSize]);
    self.animaFontColor = [base animaFontColor];
    
    self.skillIsActive  = isAc;
}
@end
