//
//  PetConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "PetConfig.h"

@implementation PetDef

@end

@implementation PetConfig
static PetConfig * _petConfig = nil;

+(PetConfig *)share
{
    if (_petConfig == nil)
    {
        _petConfig = [[PetConfig alloc]init];
    }
    return _petConfig;
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
        PetDef *def = [[PetDef alloc]init];
        
        int i=0;
        def.petID       = [[cols objectAtIndex:i++] integerValue];
        def.petName     = [cols objectAtIndex:i++];
        def.petDes      = [cols objectAtIndex:i++];
        def.petIcon     = [cols objectAtIndex:i++];
        def.petDataID   = [[cols objectAtIndex:i++] integerValue];
        
        def.logFontSize = [[cols objectAtIndex:i++] integerValue];
        int r,g,b;
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        def.logFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        
        def.animaFontSize = [[cols objectAtIndex:i++] integerValue];
        
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        
        def.animaFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.petID]];
    }
}

// 根据宠物ID 获取宠物def
-(PetDef *)getPetDefWithPetId:(NSInteger)petId
{
    PetDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", petId]];
    return def;
}
@end

//-------------------------------------------------------------------------

@implementation PetDataDef
-(NSInteger)getSkillIdAtIndex:(int)index
{
    NSInteger skillId = 0;
    switch (index)
    {
        case 0:
            skillId = [self skillId1];
            break;
        case 1:
            skillId = [self skillId2];
            break;
        case 2:
            skillId = [self skillId3];
            break;
        case 3:
            skillId = [self skillId4];
            break;
    }
    return skillId;
}
-(NSInteger)getSkillUnlockLvWithIndex:(int)index
{
    NSInteger skillUnlockLv = 0;
    switch (index)
    {
        case 0:
            skillUnlockLv = [self skill1Unlocklv];
            break;
        case 1:
            skillUnlockLv = [self skill2Unlocklv];
            break;
        case 2:
            skillUnlockLv = [self skill3Unlocklv];
            break;
        case 3:
            skillUnlockLv = [self skill4Unlocklv];
            break;
    }
    return skillUnlockLv;
}
@end

@implementation PetDataConfig
static PetDataConfig * _petDataConfig = nil;

+(PetDataConfig *)share
{
    if (_petDataConfig == nil)
    {
        _petDataConfig = [[PetDataConfig alloc]init];
    }
    return _petDataConfig;
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
    NSMutableArray *rows = (NSMutableArray *)[buffer componentsSeparatedByString:@"\r\n"];
    Definitions = [[NSMutableDictionary alloc]init];
    for (int k=1; k<[rows count]-1; k++)
    {
        NSMutableArray *cols = (NSMutableArray *)[[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        PetDataDef *def = [[PetDataDef alloc]init];
        
        int i=0;
        def.petDataID       = [[cols objectAtIndex:i++] integerValue];
        def.hp              = [[cols objectAtIndex:i++] integerValue];
        def.hp_lv           = [[cols objectAtIndex:i++] integerValue];
        def.atk             = [[cols objectAtIndex:i++] integerValue];
        def.atk_lv          = [[cols objectAtIndex:i++] integerValue];
        def.def             = [[cols objectAtIndex:i++] integerValue];
        def.def_lv          = [[cols objectAtIndex:i++] integerValue];
        def.pdef            = [[cols objectAtIndex:i++] integerValue];
        def.pdef_lv         = [[cols objectAtIndex:i++] integerValue];
        def.mdef            = [[cols objectAtIndex:i++] integerValue];
        def.mdef_lv         = [[cols objectAtIndex:i++] integerValue];
        def.spd             = [[cols objectAtIndex:i++] integerValue];
        def.spd_lv          = [[cols objectAtIndex:i++] integerValue];
        def.cri             = [[cols objectAtIndex:i++] integerValue];
        def.cri_lv          = [[cols objectAtIndex:i++] integerValue];
        def.antiCri         = [[cols objectAtIndex:i++] integerValue];
        def.antiCri_lv      = [[cols objectAtIndex:i++] integerValue];
        def.hit             = [[cols objectAtIndex:i++] integerValue];
        def.hit_lv          = [[cols objectAtIndex:i++] integerValue];
        def.dodge           = [[cols objectAtIndex:i++] integerValue];
        def.dodge_lv        = [[cols objectAtIndex:i++] integerValue];
        def.parry           = [[cols objectAtIndex:i++] integerValue];
        def.parry_lv        = [[cols objectAtIndex:i++] integerValue];
        def.antiParry       = [[cols objectAtIndex:i++] integerValue];
        def.antiParry_lv    = [[cols objectAtIndex:i++] integerValue];
        def.skillId1        = [[cols objectAtIndex:i++] integerValue];
        def.skill1Unlocklv  = [[cols objectAtIndex:i++] integerValue];
        def.skillId2        = [[cols objectAtIndex:i++] integerValue];
        def.skill2Unlocklv  = [[cols objectAtIndex:i++] integerValue];
        def.skillId3        = [[cols objectAtIndex:i++] integerValue];
        def.skill3Unlocklv  = [[cols objectAtIndex:i++] integerValue];
        def.skillId4        = [[cols objectAtIndex:i++] integerValue];
        def.skill4Unlocklv  = [[cols objectAtIndex:i++] integerValue];
        def.normalAttackSkillID = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.petDataID]];
    }
}

// 根据宠物数据ID 获取对应的数据def
-(PetDataDef *)getPetDataDefWithDataId:(NSInteger)dataId
{
    PetDataDef *petDataDef = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", dataId]];
    return petDataDef;
}
@end
//-------------------------------------------------------------------------

@implementation PetLvDef

@end

@implementation PetLvConfig
static PetLvConfig * _petLvConfig = nil;

+(PetLvConfig *)share
{
    if (_petLvConfig == nil)
    {
        _petLvConfig = [[PetLvConfig alloc]init];
    }
    return _petLvConfig;
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
        PetLvDef *def = [[PetLvDef alloc]init];
        
        int i=0;
        def.petLv   = [[cols objectAtIndex:i++] integerValue];
        def.petExp  = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.petLv]];
    }
}

//
// 根据等级 获得等级对应的经验
//
-(PetLvDef *)getPetLvDefWithLevel:(NSNumber*)level
{
    PetLvDef *def = [Definitions objectForKey:[level stringValue]];
    return def;
}
@end //-------------------------------------------------------------------------