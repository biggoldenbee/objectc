//
//  GameObject.m
//  Miner
//
//  Created by jim kaden on 14/10/23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "GameObject.h"
#import "GameUI.h"
#import "Equipment.h"

@interface GameObject ()

@property (nonatomic, strong) Equipment* equipwillchanged;  // 需要被更换的装备
@property (nonatomic, strong) NSNumber* petId;              // 如果是宠物换装备的话  此值有效  默认为nil

@end

@implementation GameObject

static GameObject* theGlobalGameObject = nil;

+(GameObject*)sharedInstance
{
    if ( theGlobalGameObject == nil )
    {
        static dispatch_once_t gameObjectOnce = 0;
        dispatch_once(&gameObjectOnce, ^(void){
            theGlobalGameObject = [[GameObject alloc]initInstance];
        });
    }
    
    return theGlobalGameObject;
}

#pragma mark - About Init Something
-(id)initInstance
{
    self = [super init];
    if (self != nil)
    {
        self.player     = [[Hero alloc]init];
        self.bag        = [[Bag alloc]init];
        self.preHome    = [[Friend alloc]init];
        self.nextHomes  = [[NSMutableArray alloc]init];
        self.petId = nil;
    }
    return self;
}

#pragma mark - About Player Data
-(void)setPlayerWithDictionary:(NSDictionary *)data
{
    if (self.player == nil)
    {
        self.player = [[Hero alloc]init];
    }
    [self.player setHeroDataWithDictionary:data];
}

-(void)setInviteCodeWithObject:(NSString*)code
{
    [[self player] setInviteCodeWithObject:code];
}

-(NSArray*)getHeroSkillsArray
{
    return [[self player] heroSkillsArray];
}

-(NSArray*)getHeroEquipsArray
{
    return [[self player] heroEquitsArray];
}

#pragma mark - About Bag Data
-(void)setBagWithDictionary:(NSDictionary *)data
{
    if (self.bag == nil)
    {
        self.bag = [[Bag alloc]init];
    }
    [self.bag setBagDataWithDictionary:data];
}

-(NSArray*)getEquipsInBag
{
    return [[self bag] bagEquips];
}

#pragma mark - change and unload equip
-(void)setWillChangedEquipWithId:(NSNumber*)equipId withPetId:(NSNumber*)petId
{
    Equipment* equip = [self getEquipWithEId:equipId];
    if (equip == nil)
    {
        NSLog(@"未能更具ID找到相关的装备对象！！！！");
        return;
    }
    self.equipwillchanged = equip;
    self.petId = petId;
}
-(Equipment *)getWillChangedEquipment
{
    return self.equipwillchanged;
}

-(void)changeOneEquip
{
    if ([[self petId] intValue] == 0)
    {
        [self changeHeroOneEquip];
    }
    else
    {
        [self changePetOneEquip];
    }
}
-(void)changeHeroOneEquip
{
    NSNumber* slot = [[self equipwillchanged] equipSlot];
    Equipment* equip = [self.player getEquipmentWithSlot:slot withPetId:[NSNumber numberWithInt:0]];
    if (equip != nil)
    {
        [self moveEquipFromHeroToBag:equip];
    }
    [self moveEquipFromBagToHero];
    self.equipwillchanged = nil;
}
-(void)changePetOneEquip
{
    Pet* pet = [[self player] getPetWithIdentifier:[self petId]];
    NSNumber* slot = [[self equipwillchanged] equipSlot];
    Equipment* equip = [pet getEquipmentWithSlot:slot];
    if (equip != nil)
    {
        [self moveEquipFromPetToBag:equip];
    }
    [self moveEquipFromBagToPet];
    self.equipwillchanged = nil;
    self.petId = nil;
}

-(void)unloadOneEquip
{
    if ([[self petId] intValue] == 0)
    {
        [self unloadHeroOneEquip];
    }
    else
    {
        [self unloadPetOneEquip];
    }
}
-(void)unloadHeroOneEquip
{
    [self moveEquipFromHeroToBag:self.equipwillchanged];
    self.equipwillchanged = nil;
}
-(void)unloadPetOneEquip
{
    [self moveEquipFromPetToBag:self.equipwillchanged];
    self.equipwillchanged = nil;
    self.petId = nil;
}

#pragma mark - About Ladder
-(void)setLdrWithArray:(NSArray*)data
{
    for (NSDictionary* tempDict in data)
    {
        LadderCompetitor* ldrCom = [[LadderCompetitor alloc]init];
        [ldrCom setDataWithDictionary:tempDict];
        [self.ldrInfos addObject:ldrCom];
    }
}

#pragma mark - About Reward
-(void)setRewardWithArray:(NSArray*)data
{
    for (NSDictionary* tempDict in data)
    {
        Reward* reward = [[Reward alloc]init];
        [reward setDataWithDictionary:tempDict];
        [self.rewardInfos addObject:reward];
    }
}

#pragma mark - About Relation
-(void)setPreHomeWithDictionary:(NSDictionary *)data
{
    [self.preHome setDataWithDictionary:data];
}

-(void)setNextHomeWithArray:(NSArray *)data
{
    for (int i=0; i<[data count]; i++)
    {
        Friend* nextHome = [[Friend alloc]init];
        [nextHome setDataWithDictionary:[data objectAtIndex:i]];
        [self.nextHomes addObject:nextHome];
    }
}

-(void)removeNextHomeByIndex:(NSUInteger)index
{
    [self.nextHomes removeObjectAtIndex:index];
}

#pragma mark - About item
-(Item*)getItemWithIId:(NSNumber*)identifier
{
    Item* item = [self.bag getItemWithIId:identifier];
    return item;
}

-(Item*)getItemWithTId:(NSNumber*)identifier
{
    Item* item = [self.bag getItemWithTId:identifier];
    return item;
}

#pragma mark - About Pet
-(NSArray*)getAllPetsFromHero
{
    NSArray* tempArr = [[self player] heroPetArray];
    return tempArr;
}

-(Pet *)getPetWithIdentifier:(NSNumber *)identifier
{
    Pet *pet = [[self player] getPetWithIdentifier:identifier];
    return pet;
}
-(Pet *)getPetWithType:(NSNumber *)type
{
    Pet *pet = [self.player getPetWithType:type];
    return pet;
}

#pragma mark - About opration equipment
-(Equipment *)getEquipWithEId:(NSNumber *)identifier
{
    Equipment *equip = [self.player getEquipmentWithIdentifier:identifier];
    if (equip == nil)
    {
        equip = [self.bag getEquipmentWithId:identifier];
    }
    
    return equip;
}
-(NSArray*)getEquipsFromBagWithSlot:(NSNumber*)slot
{
    NSArray* tempArr = [[self bag] getEquipmentsWithSlot:slot];
    return tempArr;
}
-(Equipment*)getEquipmentWithSlot:(NSNumber*)slot withPetId:(NSNumber*)petId
{
    Equipment* equip = [[self player] getEquipmentWithSlot:slot withPetId:petId];
    return equip;
}

-(void)moveEquipFromPetToBag:(Equipment *)equip
{
    [self.bag addEquipToBag:equip];
    [self.player removeEquipFromPet:equip withPetId:[self petId]];
}
-(void)moveEquipFromBagToPet
{
    [self.player addEquipToPet:self.equipwillchanged withPetId:[self petId]];
    [self.bag removeEquipFromBag:self.equipwillchanged];
}

-(void)moveEquipFromHeroToBag:(Equipment *)equip
{
    [self.bag addEquipToBag:equip];
    [self.player removeEquipFromHero:equip];
}
-(void)moveEquipFromBagToHero
{
    [self.player addEquipToHero:self.equipwillchanged];
    [self.bag removeEquipFromBag:self.equipwillchanged];
}

-(void)removeEquipsFromBagWithArray:(NSArray *)listdata
{
    [self.bag removeEquipsFromBag:listdata];
}

-(void)changeEquipData:(NSDictionary *)equipData
{
    NSInteger htype = [[equipData objectForKey:@"HType"] integerValue];
    if (htype == 0)
    {
        [self changeBagEquip:equipData];
    }
    if (htype == 1)
    {
        [self changeHeroEquip:equipData];
    }
    if (htype == 2)
    {
        [self changePetEquip:equipData];
    }
    if (htype == 3)
    {
    }
}
-(void)changePetEquip:(NSDictionary *)equipData
{
    [self.player changeEquipWithDictionary:equipData isHero:NO];
}
-(void)changeBagEquip:(NSDictionary *)equipData
{
    [self.bag changeEquipDataWithDictionary:equipData];
}
-(void)changeHeroEquip:(NSDictionary *)equipData
{
    [self.player changeEquipWithDictionary:equipData isHero:YES];
}

@end
