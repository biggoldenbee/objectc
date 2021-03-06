//
//  Pet.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "Pet.h"
#import "Equipment.h"
#import "Skill.h"
#import "BaseAttribute.h"
#import "UtilityDef.h"


@implementation Pet
-(void)setPetDataWithDictionary:(NSDictionary *)data
{
    self.petId = [data objectForKey:@"PID"];    //  实例ID
    
    NSInteger typeId = [[data objectForKey:@"TID"] integerValue];
    self.petDef   = [[PetConfig share] getPetDefWithPetId:typeId];
    self.petName = self.petDef.petName;  //
    self.petDesc = self.petDef.petDes;   //
    self.petIcon = self.petDef.petIcon;  //
    
    self.petLevel = [data objectForKey:@"Level"];  //
    
    self.basicAttri = [[BaseAttribute alloc]init];
    [[self basicAttri] setPetDataWithId:[data objectForKey:@"TID"] atLevel:[self petLevel]];
    
    self.curExp = [data objectForKey:@"Exp"];   //
    PetLvDef* def = [[PetLvConfig share] getPetLvDefWithLevel:self.petLevel];
    self.maxExp = [NSNumber numberWithInteger:[def petExp]];  //
    
    self.petBV = [data objectForKey:@"BV"];    //
    
    if ([data objectForKey:@"Equip"])
    {
        NSArray *equips = [data objectForKey:@"Equip"];
        [self setPetEquipDataWithArray:equips];
    }
    
    if ([data objectForKey:@"Skill"])
    {
        NSArray *skills = [data objectForKey:@"Skill"];
        [self setPetSkillsDataWithArray:skills];
    }
    
    NSInteger activeCode = [[data objectForKey:@"Active"] integerValue];
    if (activeCode == 0)
    {
        self.isBattle = NO;
    }
    else
    {
        self.isBattle = YES;
    }
    
}


-(void)changeEquipWithDictionary:(NSDictionary *)data
{
    NSNumber *identifier = [data objectForKey:@"EID"];
    for (Equipment *equip in self.petEquitsArray)
    {
        if ([[equip equipEId] isEqualToNumber:identifier])
        {
            [equip setEquipDataWithDictionary:data];
        }
    }
}

-(Equipment *)getEquipmentWithIdentifier:(NSNumber *)identifier
{
    for (Equipment *equip in self.petEquitsArray)
    {
        if ([[equip equipEId] isEqualToNumber:identifier])
        {
            return equip;
        }
    }
    
    return nil;
}
-(Equipment *)getEquipmentWithSlot:(NSNumber*)slot
{
    for (Equipment *equip in self.petEquitsArray)
    {
        if ([[equip equipSlot] isEqualToNumber:slot])
        {
            return equip;
        }
    }
    
    return nil;
}

-(void)addEquip:(Equipment *)equip
{
    if ([[equip equipSlot] integerValue] == 0)
    {
        [equip changeEquipSlotFromDef];
    }
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:self.petEquitsArray];
    [tempArr addObject:equip];
    self.petEquitsArray = [[NSArray alloc]initWithArray:tempArr];
    
    [self addBaseAttriValueByEquip:equip];
}

-(void)removeEquip:(Equipment *)equip
{
    equip.equipSlot = DefaultValue;
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:self.petEquitsArray];
    [tempArr removeObject:equip];
    self.petEquitsArray = [[NSArray alloc]initWithArray:tempArr];
    
    [self reduceBaseAttriValueByEquip:equip];
}

#pragma mark - privated function
-(void)setPetEquipDataWithArray:(NSArray *)data
{
    if ([data count] == 0)
    {
        self.petEquitsArray = [[NSArray alloc] init];
        return;
    }
    
    for (NSDictionary *temp in data)
    {
        Equipment *equip = [[Equipment alloc]init];
        [equip setEquipDataWithDictionary:temp];
        [self addEquip:equip];
    }
}

-(void)setPetSkillsDataWithArray:(NSArray *)data
{
    [self setPetSkillDataWithArray];

    int count = (int)[data count];
    // 2015-01-24
    // jim modified here
    // 内部有i++，for中不能再i ++了
    for (int i=0; i<count; /* i++ */)
    {
        NSNumber* tempid = [data objectAtIndex:i++];
        NSNumber* templv = [data objectAtIndex:i++];
        BOOL tempac      = [[data objectAtIndex:i++] boolValue];
        
        for (Skill* skill in [self skillsArray])
        {
            if ([[skill skillTId] isEqualToNumber:tempid])
            {
                [skill setSkillDataWithSId:tempid withLevel:templv isActive:tempac];
            }
        }
    }
}

-(void)setPetSkillDataWithArray
{
    // 宠物数据
    PetDataDef* def = [[PetDataConfig share] getPetDataDefWithDataId:[[self petDef] petDataID]];
    
    NSMutableArray *tempSkill = [[NSMutableArray alloc]init];
    int i=0;
    while (YES)
    {
        NSInteger skillId = [def getSkillIdAtIndex:i];
        if (skillId == 0)
        {
            break;
        }
        NSInteger skillUnlockLv = [def getSkillUnlockLvWithIndex:i];
        
        Skill *skill = [[Skill alloc]init];
        [skill setSkillDataWithSId:INTEGER_TO_NUMBER(skillId) withLevel:INT_TO_NUMBER(1) isActive:YES];
        if (skillUnlockLv > [[self petLevel] integerValue])
        {
            skill.isLocked = YES;
        }
        else
        {
            skill.isLocked = NO;
        }
        [tempSkill addObject:skill];
        i++;
    }
    self.skillsArray = tempSkill;
}

-(void)addBaseAttriValueByEquip:(Equipment*)equip
{
    int type = [[[equip mainAttri] attriId] intValue];
    int value = [[[equip mainAttri] attriValue] intValue];
    [[self basicAttri] scaleBaseAttriWithValueCode:type addValue:value];
    
    for (AttributeData* subAttri in [equip subAttri])
    {
        type = [[subAttri attriId] intValue];
        value = [[subAttri attriValue] intValue];
        [[self basicAttri] scaleBaseAttriWithValueCode:type addValue:value];
    }
}
-(void)reduceBaseAttriValueByEquip:(Equipment*)equip
{
    int type = [[[equip mainAttri] attriId] intValue];
    int value = [[[equip mainAttri] attriValue] intValue];
    [[self basicAttri] scaleBaseAttriWithValueCode:type addValue:-value];
    
    for (AttributeData* subAttri in [equip subAttri])
    {
        type = [[subAttri attriId] intValue];
        value = [[subAttri attriValue] intValue];
        [[self basicAttri] scaleBaseAttriWithValueCode:type addValue:-value];
    }
}
@end

