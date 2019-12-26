//
//  SkillConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-13.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "SkillConfig.h"
#import <UIKit/UIKit.h>

@implementation ItemFroSkillUp

@end

@implementation BuffFromSkill

@end

@implementation SkillBase
-(NSNumber*)getItemNumWithId:(NSNumber*)identifier
{
    ItemFroSkillUp* itemData = [[self itemDatas] objectForKey:[identifier stringValue]];
    if (itemData)
    {
        return [NSNumber numberWithInteger:[itemData itemIDNum]];
    }
    else
    {
        return [NSNumber numberWithInt:0];
    }
}
@end

@implementation SkillDef
-(BOOL)addSkillBaseIntoSkillDatas:(SkillBase*)base
{
    NSString *key = [NSString stringWithFormat:@"%lu", base.skillLv];
    SkillBase *tempDef = [self.skillDatas objectForKey:key];
    if (tempDef != nil)
    {
        return NO;
    }
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary:[self skillDatas]];
    [tempDict setValue:base forKey:key];
    self.skillDatas = tempDict;
    return YES;
}
@end


@implementation SkillConfig
static SkillConfig * _skillConfig = nil;

+(SkillConfig *)share
{
    if (_skillConfig == nil)
    {
        _skillConfig = [[SkillConfig alloc]init];
    }
    return _skillConfig;
}

-(void)dealloc
{
    Definitions = nil;
}

-(void)reset
{
    [super reset];
    Definitions = nil;
}
//
// 重载了父类的方法
//
-(void)initWithString:(NSString *)buffer
{
    NSArray *rows = [buffer componentsSeparatedByString:@"\r\n"];
    Definitions = [[NSMutableDictionary alloc]init];
    for (int k=1; k<[rows count]-1; k++)
    {
        NSArray *cols = [[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        
        int i=0;
        NSInteger skillId = [[cols objectAtIndex:i++] integerValue];
        SkillDef* def   = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", skillId]];
        if (def == nil)
        {
            def = [[SkillDef alloc] init];
            def.skillId = skillId;
            [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", skillId]];
        }
        
        SkillBase* base = [[SkillBase alloc] init];
        base.skillName   = [cols objectAtIndex:i++];
        base.skillDesc   = [cols objectAtIndex:i++];
        base.skillIcon   = [cols objectAtIndex:i++];
        base.needHeroLV  = [[cols objectAtIndex:i++] integerValue];
        base.skillLv     = [[cols objectAtIndex:i++] integerValue];
        
        NSMutableDictionary *tempDicForItem = [[NSMutableDictionary alloc]init];
        for(int j = 0 ; j < SKILL_UPGRADE_ITEM_NUM ; j ++ )
        {
            ItemFroSkillUp *ifsu = [[ItemFroSkillUp alloc]init];
            ifsu.needItemID      = [[cols objectAtIndex:i++] integerValue];
            if (ifsu.needItemID != 0)
            {
                ifsu.itemIDNum   = [[cols objectAtIndex:i++] integerValue];
                [tempDicForItem setObject:ifsu forKey:[NSString stringWithFormat:@"%lu", ifsu.needItemID]];
            }
            else
                i++ ;
        }
        base.itemDatas = tempDicForItem;
        
        base.skillCastVal    = [[cols objectAtIndex:i++] integerValue];
        base.skillTarget     = [[cols objectAtIndex:i++] integerValue];
        base.atkType         = [[cols objectAtIndex:i++] integerValue];
        base.attriID1         = [[cols objectAtIndex:i++] integerValue];
        base.skillNum1        = [[cols objectAtIndex:i++] integerValue];
        base.attriID2         = [[cols objectAtIndex:i++] integerValue];
        base.skillNum2        = [[cols objectAtIndex:i++] integerValue];
        base.skillCD         = [[cols objectAtIndex:i++] integerValue];
        
        NSMutableDictionary *tempDicForBuff = [[NSMutableDictionary alloc]init];
        for(int j = 0 ; j < SKILL_ACTIVE_BUFF_NUM ; j ++ )
        {
            BuffFromSkill *bfs = [[BuffFromSkill alloc]init];
            bfs.buffChance   = [[cols objectAtIndex:i++] integerValue];
            bfs.buffID         = [[cols objectAtIndex:i++] integerValue];
            bfs.buffIdLv   = [[cols objectAtIndex:i++] integerValue];
            bfs.buffTarget   = [[cols objectAtIndex:i++] integerValue];
            if (bfs.buffID != 0)
            {
                [tempDicForBuff setObject:bfs forKey:[NSString stringWithFormat:@"%lu", bfs.buffID]];
            }
        }
        base.buffDatas = tempDicForBuff;
        
        base.attackingAnimation          = [cols objectAtIndex:i++];
        base.attackingEffectAnimation    = [cols objectAtIndex:i++];
        base.defendingAnimation          = [cols objectAtIndex:i++];
        base.defendingEffectAnimation    = [cols objectAtIndex:i++];
        
        base.logFontSize = [[cols objectAtIndex:i++] integerValue];
        
        int r,g,b;
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        base.logFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        
        base.animaFontSize = [[cols objectAtIndex:i++] integerValue];
        
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        
        base.animaFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        
        if ( [base.attackingAnimation isEqualToString:@"0"] )
            base.attackingAnimation = nil;
        if ( [base.attackingEffectAnimation isEqualToString:@"0"] )
            base.attackingEffectAnimation = nil;
        if ( [base.defendingAnimation isEqualToString:@"0"] )
            base.defendingAnimation = nil;
        if ( [base.defendingEffectAnimation isEqualToString:@"0"] )
            base.defendingEffectAnimation = nil;
        
        [def addSkillBaseIntoSkillDatas:base];
    }
}

-(NSArray*)getAllSkillDefs
{
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    for (SkillDef* skilldef in [Definitions allValues])
    {
        BOOL isUesfull = YES;
        for (SkillBase* base in [[skilldef skillDatas] allValues])
        {
            if ([base needHeroLV] == 0)
            {
                isUesfull = NO;
                break;
            }
        }
        
        if (isUesfull)
        {
            [tempArr addObject:skilldef];
        }
    }
    
    return tempArr;
}

-(SkillBase *)getSkillBaseWithTId:(NSNumber*)identifier  withLevel:(NSNumber*)lv
{
    SkillDef *skill = [Definitions objectForKey:[identifier stringValue]];
    SkillBase* base = [[skill skillDatas] objectForKey:[lv stringValue]];
    return base;
}

-(BOOL)checkSkillIsMaxWithId:(NSNumber*)identifier andLevel:(NSNumber*)lv
{
    SkillDef *skill = [Definitions objectForKey:[identifier stringValue]];
    NSUInteger count = [[skill skillDatas] count];
    if ([lv unsignedIntegerValue] == count)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
@end
