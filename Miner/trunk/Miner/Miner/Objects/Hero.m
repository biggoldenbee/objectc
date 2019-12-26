//
//  Hero.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-3.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "Hero.h"
#import "BaseAttribute.h"
#import "PortConfig.h"
#import "Equipment.h"
#import "Skill.h"
#import "Pet.h"
#import "Haypi/Haypi.h"

#import "GameUtility.h"
#import "UtilityDef.h"
#import "Bag.h"
#import "GameObject.h"
#import "NetManager.h"

@implementation Hero
#pragma mark - 人物属性的设置和重置
-(void)setHeroDataWithDictionary:(NSDictionary *)data
{
    if ([self heroName] == nil)
    {
        self.heroName   = getLastUser();
    }
    if ([data objectForKey:@"Level"])
    {
        self.heroLevel      = [data objectForKey:@"Level"];
        [self setBaseAttriValues:self.heroLevel];
        self.heroLevelData  = [[HeroConfig share] getHeroLevelDataWithLevel:self.heroLevel];
        self.heroMaxExp     = [[NSNumber alloc] initWithInteger:[self.heroLevelData heroExp]];
    }
    if ([data objectForKey:@"Zone"])
    {
        self.heroZone       = [data objectForKey:@"Zone"];
    }
    if ([data objectForKey:@"Icon"])
    {
        self.heroIcon       = [data objectForKey:@"Icon"];
    }
    if ([data objectForKey:@"Exp"])
    {
        self.heroCurrentExp = [data objectForKey:@"Exp"];
    }
    if ([data objectForKey:@"Map"])
    {
        self.heroMap        = [data objectForKey:@"Map"];
    }
    if ([data objectForKey:@"TopMap"])
    {
        self.heroTopMap     = [data objectForKey:@"TopMap"];
    }
    if ([data objectForKey:@"Coin"])
    {
        self.heroCoin       = [data objectForKey:@"Coin"];
    }
    if ([data objectForKey:@"Money"])
    {
        self.heroMoney      = [data objectForKey:@"Money"];
    }
    if ([data objectForKey:@"ETher"])
    {
        self.heroEther      = [data objectForKey:@"ETher"];
    }
    if ([data objectForKey:@"Cntrb"])
    {
        self.heroCntrb      = [data objectForKey:@"Cntrb"];
    }
    if ([data objectForKey:@"CLevel"])
    {
        self.heroCLevel     = [data objectForKey:@"CLevel"];
    }
    if ([data objectForKey:@"SP"])
    {
        self.heroSkillPoint = [data objectForKey:@"SP"];
    }
    if ([data objectForKey:@"Prestige"])
    {
        self.heroPrestige   = [data objectForKey:@"Prestige"];
    }
    if ([data objectForKey:@"BV"])
    {
        self.heroBv         = [data objectForKey:@"BV"];
    }
    if ([data objectForKey:@"RkLdr"])
    {
        self.heroRkldr      = [data objectForKey:@"RkLdr"];
    }
    if ([data objectForKey:@"Ldr"])
    {
        self.heroLdr        = [data objectForKey:@"Ldr"];
    }
    if ([data objectForKey:@"Qck"])
    {
        self.heroQck        = [data objectForKey:@"Qck"];
    }
    if ([data objectForKey:@"Boss"])
    {
        self.heroBoss       = [data objectForKey:@"Boss"];
    }

    self.heroVipLevel   = DefaultValue;
    
    if ([data objectForKey:@"Equip"])
    {
        NSArray *equipData = [data objectForKey:@"Equip"];
        [self setHeroEquipsWithArray:equipData];
    }
    if ([data objectForKey:@"Skill"])
    {
        NSArray *skillData = [data objectForKey:@"Skill"];
        [self setHeroSkillsDataWithArray:skillData];
    }
    if ([data objectForKey:@"Buff"])
    {
        // todo
    }
    if ([data objectForKey:@"Pet"])
    {
        NSArray *petData = [data objectForKey:@"Pet"];
        [self setHeroPetWithArray:petData];
    }
    
    self.heroIdentifier = [NetManager sharedInstance].uid;
}

-(void)setInviteCodeWithObject:(NSString*)code
{
    self.inviteCode = code;
}

-(void)changeEquipWithDictionary:(NSDictionary *)data isHero:(BOOL)sure
{
    if (sure)
    {
        NSNumber *id = [data objectForKey:@"EID"];
        for (Equipment *equip in self.heroEquitsArray)
        {
            if ([[equip equipEId] isEqualToNumber:id])
            {
                [equip setEquipDataWithDictionary:data];
            }
        }
    }
    else
    {
        NSNumber *petId = [data objectForKey:@"HID"];
        for (Pet *pet in self.heroPetArray)
        {
            if ([pet.petId isEqualToNumber:petId])
            {
                [pet changeEquipWithDictionary:data];
            }
        }
    }
}

#pragma mark - 与 宠物 有关的方法
-(Pet *)getPetWithIdentifier:(NSNumber *)petId
{
    for (Pet *pet in self.heroPetArray)
    {
        if ([pet.petId isEqualToNumber:petId])
        {
            return pet;
        }
    }
    return nil;
}
-(Pet *)getPetWithType:(NSNumber *)type
{
    for (Pet* pet in self.heroPetArray)
    {
        if (pet.petDef.petID == [type integerValue])
        {
            return pet;
        }
    }
    return nil;
}

#pragma mark - 与 装备 有关的方法
-(Equipment *)getEquipmentWithIdentifier:(NSNumber *)equipId
{
    for (Equipment *equip in self.heroEquitsArray)
    {
        if ([[equip equipEId] isEqualToNumber:equipId])
        {
            return equip;
        }
    }
    
    for (Pet *pet in self.heroPetArray)
    {
        Equipment *equip = [pet getEquipmentWithIdentifier:equipId];
        if (equip)
        {
            return equip;
        }
    }
    
    return nil;
}

-(Equipment *)getEquipmentWithSlot:(NSNumber*)slot withPetId:(NSNumber*)petId
{
    if ([petId isEqualToNumber:DefaultValue])
    {
        for (Equipment *equip in self.heroEquitsArray)
        {
            if ([equip.equipSlot isEqualToNumber:slot])
            {
                return equip;
            }
        }
    }
    else
    {
        for (Pet* pet in [self heroPetArray])
        {
            if ([[pet petId] isEqualToNumber:petId])
            {
                for (Equipment *equip in [pet petEquitsArray])
                {
                    if ([equip.equipSlot isEqualToNumber:slot])
                    {
                        return equip;
                    }
                }
            }
        }
    }
    return nil;
}

-(void)addEquipToPet:(Equipment *)equip withPetId:(NSNumber*)identifier
{
    Pet* pet = [self getPetWithIdentifier:identifier];
    if (pet == nil)
    {
        return;
    }
    [pet addEquip:equip];
}

-(void)removeEquipFromPet:(Equipment *)equip withPetId:(NSNumber*)identifier
{
    Pet* pet = [self getPetWithIdentifier:identifier];
    if (pet == nil)
    {
        return;
    }
    [pet removeEquip:equip];
}

-(void)addEquipToHero:(Equipment *)equip
{
    if ([[equip equipSlot] integerValue] == 0)
    {
        [equip changeEquipSlotFromDef];
    }
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:self.heroEquitsArray];
    [tempArr addObject:equip];
    self.heroEquitsArray = [[NSArray alloc]initWithArray:tempArr];

    [self addBaseAttriValueByEquip:equip];
}
-(void)removeEquipFromHero:(Equipment *)equip
{
    NSMutableArray *tempArr = [[NSMutableArray alloc]initWithArray:self.heroEquitsArray];
    [tempArr removeObject:equip];
    self.heroEquitsArray = [[NSArray alloc]initWithArray:tempArr];
    
    [self reduceBaseAttriValueByEquip:equip];
}

#pragma mark - 获取需要计算的属性
-(float)getExpPercent
{
    float curExp = [self.heroCurrentExp floatValue];
    float maxExp = [self.heroMaxExp floatValue];
    return curExp/maxExp;
}

-(float)getCntrbPercent
{
    ContributionDef* conDef = [[ContributionConfig share] getContributionDefWithLevel:self.heroCLevel];
    
    // modified by jim
    // 判断除零错误
    if ( conDef == nil || conDef.conValue == 0 )
        return 0;
    
    NSNumber* conV = [[NSNumber alloc]initWithInteger:conDef.conValue];
    float curConV = [self.heroCntrb floatValue];
    float maxConV = [conV floatValue];
    return curConV/maxConV;
}

#pragma mark - 与 技能 有关的方法
-(void)addSkillWithId:(NSNumber*)skillId withLv:(NSNumber*)lv
{
    Skill* skill = [[Skill alloc]init];
    [skill setSkillDataWithSId:skillId withLevel:lv isActive:YES];
    
    NSMutableArray* tempArr = [[NSMutableArray alloc] initWithArray:[self heroSkillsArray]];
    [tempArr addObject:skill];
    self.heroSkillsArray = tempArr;
}
-(void)removeSkillWithId:(NSNumber*)skillId
{
    NSMutableArray* tempArr = [[NSMutableArray alloc] initWithArray:[self heroSkillsArray]];
    for (Skill* skill in [self heroSkillsArray])
    {
        if ([[skill skillTId] isEqualToNumber:skillId])
        {
            [tempArr removeObject:skill];
        }
    }
    self.heroSkillsArray = [[NSArray alloc] initWithArray:tempArr];
}

#pragma mark - 与 钱币 有关的方法
-(void)addHeroMoney:(NSInteger)count
{
    NSInteger leftMoney = [self.heroMoney integerValue] + count;
    self.heroMoney = [NSNumber numberWithInteger:leftMoney];
}
-(void)reduceHeroMoney:(NSInteger)count
{
    NSInteger leftMoney = [self.heroMoney integerValue] - count;
    self.heroMoney = [NSNumber numberWithInteger:leftMoney];
}

#pragma mark - private function
-(void)setBaseAttriValues:(NSNumber*)level
{
    self.heroAttributes = [[BaseAttribute alloc]init];
    [[self heroAttributes] setHeroDataWithLevel:level];
}
-(void)addBaseAttriValueByEquip:(Equipment*)equip
{
    int type = [[[equip mainAttri] attriId] intValue];
    int value = [[[equip mainAttri] attriValue] intValue];
    [[self heroAttributes] scaleBaseAttriWithValueCode:type addValue:value];
    
    for (AttributeData* subAttri in [equip subAttri])
    {
        type = [[subAttri attriId] intValue];
        value = [[subAttri attriValue] intValue];
        [[self heroAttributes] scaleBaseAttriWithValueCode:type addValue:value];
    }
}
-(void)reduceBaseAttriValueByEquip:(Equipment*)equip
{
    int type = [[[equip mainAttri] attriId] intValue];
    int value = [[[equip mainAttri] attriValue] intValue];
    [[self heroAttributes] scaleBaseAttriWithValueCode:type addValue:-value];
    
    for (AttributeData* subAttri in [equip subAttri])
    {
        type = [[subAttri attriId] intValue];
        value = [[subAttri attriValue] intValue];
        [[self heroAttributes] scaleBaseAttriWithValueCode:type addValue:-value];
    }
}

-(void)setHeroSkillsDataWithArray:(NSArray *)data
{
    NSArray* allSkills = [Skill createDefaultAllSkill];
    
    int count = (int)[data count];
    for (int i=0; i<count;)
    {
        NSNumber* tempid = [data objectAtIndex:i++];
        NSNumber* templv = [data objectAtIndex:i++];
        BOOL tempAc      = [[data objectAtIndex:i++] boolValue];
        
        for (Skill* skill in allSkills)
        {
            if ([[skill skillTId] isEqualToNumber:tempid])
            {
                [skill setSkillDataWithSId:tempid withLevel:templv isActive:tempAc];
            }
        }
    }
    self.heroSkillsArray = allSkills;
}

-(void)setHeroEquipsWithArray:(NSArray *)data
{
    for (NSDictionary *temp in data)
    {
        Equipment *equip = [[Equipment alloc]init];
        [equip setEquipDataWithDictionary:temp];
        [self addEquipToHero:equip];
        
        NSInteger baseBv = [self.heroBv integerValue];
        NSInteger equipBv = [equip.equipBV integerValue];
        self.heroBv = [NSNumber numberWithInteger:(baseBv+equipBv)];
    }
}

-(void)setHeroPetWithArray:(NSArray *)data
{
    NSMutableArray *tempPet = [[NSMutableArray alloc]init];
    for (int i=0; i<[data count]; i++)
    {
        Pet *pet = [[Pet alloc]init];
        [pet setPetDataWithDictionary:[data objectAtIndex:i]];
        [tempPet addObject:pet];
    }
    
    SortParam* param = [[SortParam alloc]init];
    param.paramName = @"petId";
    param.ascending = YES;
    NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:param,@"0", nil];
    self.heroPetArray = [GameUtility array:tempPet sortArrayWithParams:tempDict];
}

-(BOOL)hasBetterEquipment:(NSArray*)equipArray tag:(NSString*)tag
{
    int slots[]={0,0,0,0,0,0,0,0};
    Bag* bag = [GameObject sharedInstance].bag;
    for(Equipment* equip in equipArray)
    {
        if([bag hasBetterEquip:equip.equipSlot.intValue current:equip tag:tag])
            return YES;
        slots[equip.equipSlot.intValue-1] = 1;
    }
    
    for(int i = 0 ; i < 8 ; i ++)
    {
        if ( slots[i] != 0 )
            continue;
        if ( [bag hasBetterEquip:i+1 current:nil tag:tag])
            return YES;
    }
    
    return NO;

}

-(BOOL)hasBetterEquipmentForHero
{
    return [self hasBetterEquipment:self.heroEquitsArray tag:[self.heroIdentifier stringValue]];
}

-(BOOL)hasBetterEquipmentForPet
{
    for(Pet* p in self.heroPetArray)
    {
        NSString* tag = [[self.heroIdentifier stringValue] stringByAppendingFormat:@"_%@", p.petId];
        BOOL ret = [self hasBetterEquipment:p.petEquitsArray tag:tag];
        if ( ret )
            return YES;
    }
    
    return NO;
}
@end
