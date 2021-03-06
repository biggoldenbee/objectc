//
//  BattleData.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-3.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "BattleData.h"

#import "MobConfig.h"

#import "Equipment.h"
#import "Item.h"


// -----------------------------------------------------------------------------------------
#pragma mark - Class BattleBrief

@implementation BattleBrief
-(void)setDataWithDictionary:(NSDictionary *)data
{
    self.type = [[data objectForKey:@"Type"] integerValue];
    self.map = [[data objectForKey:@"Map"] integerValue];
    self.cnt = [[data objectForKey:@"Cnt"] integerValue];
    self.time = [[data objectForKey:@"Time"] integerValue];
    self.win = [[data objectForKey:@"Win"] integerValue];
    self.mine = [[data objectForKey:@"Mine"] integerValue];
    self.lost = [[data objectForKey:@"Lost"] integerValue];
    self.mlost = [[data objectForKey:@"MLost"] integerValue];
    self.run = [[data objectForKey:@"Run"] integerValue];
    self.exp = [[data objectForKey:@"Exp"] integerValue];
    self.money = [[data objectForKey:@"Money"] integerValue];
    self.skillPoint = [[data objectForKey:@"SP"] integerValue];
    self.boxWon = [data objectForKey:@"BoxW"];
    self.boxFailed = [data objectForKey:@"BoxF"];
    self.autoSells = [data objectForKey:@"AS"];
    
    NSArray *equipArr = [data objectForKey:@"Equip"];
    self.equips = [self setEquipsWithArray:equipArr];
    
    NSArray *itemArr = [data objectForKey:@"Item"];
    self.items = [self setItemsWithArray:itemArr];
}

-(NSArray *)setEquipsWithArray:(NSArray *)data
{
    if (data == nil || [data count] == 0)
        return nil;
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSDictionary *tempDict in data)
    {
        Equipment *equip = [[Equipment alloc]init];
        [equip setEquipDataWithDictionary:tempDict];
        [tempArr addObject:equip];
    }
    
    return tempArr;
}


-(NSArray *)setItemsWithArray:(NSArray *)data
{
    if (data == nil || [data count] == 0)
        return nil;
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSDictionary *tempDict in data)
    {
        Item *item = [[Item alloc]init];
        [item setItemDataWithDictionary:tempDict];
        [tempArr addObject:item];
    }
    
    return tempArr;
}

@end

// -----------------------------------------------------------------------------------------
#pragma mark - Class BattleActor

@implementation BattleActor

-(void)setDataWithDictionary:(NSDictionary *)data
{
    self.ally = [[data objectForKey:@"Ally"] integerValue];
    self.type = [[data objectForKey:@"Type"] integerValue];
    self.mid = [[data objectForKey:@"ID"] integerValue];
    self.level = [[data objectForKey:@"Level"] integerValue];
    
    MobDef* monster = [[MobConfig share] getMobDefById:self.mid];
    self.icon = monster.mobIcon;
    
//    MobDataDef* monsterData = [[MobDataConfig share] getMobDataDefById:monster.mobDataID];
    
//    self.hp = monsterData.hp + monsterData.hp_lv * self.level;
    self.hp = [[data objectForKey:@"Hp"] integerValue];
//    self.icon = [[data objectForKey:@"Icon"] integerValue];
    self.name = [data objectForKey:@"Name"];
}

@end

// -----------------------------------------------------------------------------------------
#pragma mark - Class BattleSubAction

@implementation BattleSubAction

-(void)setSubActionWithArray:(NSArray *)data
{
    int i=0;
    self.B = [[data objectAtIndex:i++] integerValue];
    self.type = [[data objectAtIndex:i++] integerValue];
    self.value1 = [[data objectAtIndex:i++] integerValue];
    self.value2 = [[data objectAtIndex:i++] integerValue];
    self.value3 = [[data objectAtIndex:i++] integerValue];
}

@end

// -----------------------------------------------------------------------------------------
#pragma mark - Class BattleAction

@implementation BattleAction

-(void)setDataWithDictionary:(NSDictionary *)data
{
    self.A = [[data objectForKey:@"A"] integerValue];
    self.turn = [[data objectForKey:@"T"] integerValue];
    self.type = [[data objectForKey:@"Type"] integerValue];
    self.sid = [[data objectForKey:@"SID"] integerValue];
    self.slv = [[data objectForKey:@"SLV"] integerValue];
    NSArray *subAction = [data objectForKey:@"B"];
    [self subActionsWithArray:subAction];
}

-(void)subActionsWithArray:(NSArray *)data
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSArray *tempDict in data)
    {
        BattleSubAction *subAct = [[BattleSubAction alloc]init];
        subAct.action = self;
        [subAct setSubActionWithArray:tempDict];
        [tempArray addObject:subAct];
    }
    self.subActions = [[NSArray alloc]initWithArray:tempArray];
}

@end

// -----------------------------------------------------------------------------------------
#pragma mark - Class BattleMine

@implementation BattleMine

-(void)setDataWithDictionary:(NSDictionary *)data
{
    self.A = [[data objectForKey:@"A"] integerValue];
    self.mid = [[data objectForKey:@"ID"] integerValue];
    self.ret = [[data objectForKey:@"Ret"] integerValue];
}

@end

// -----------------------------------------------------------------------------------------
#pragma mark - Class BattleDetail

@implementation BattleDetail

-(void)setDataWithDictionary:(NSDictionary *)data
{
    if ([data objectForKey:@"Secs"])
    {
        self.leftTime = [[data objectForKey:@"Secs"] integerValue];
    }
    else
    {
        self.leftTime = 0;
    }
    
    if ([data objectForKey:@"Action"])
    {
        NSArray *actionData = [data objectForKey:@"Action"];
        [self setActionArrayWithArray:actionData];
    }
    
    if ([data objectForKey:@"Actor"])
    {
        NSArray *actorData = [data objectForKey:@"Actor"];
        [self setActorArrayWithArray:actorData];
    }
    
    if ([data objectForKey:@"Brief"])
    {
        NSDictionary *briefData = [data objectForKey:@"Brief"];
        [self setBriefDataWithDictionay:briefData];
    }
    
    if ([data objectForKey:@"Mine"])
    {
        NSArray *mineData = [data objectForKey:@"Mine"];
        [self setMineArrayWithArray:mineData];
    }
}

-(void)setActionArrayWithArray:(NSArray *)data
{
    if (data == nil || [data count] == 0)
        return;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSDictionary *tempDict in data)
    {
        BattleAction *battleAction = [[BattleAction alloc]init];
        battleAction.battle = self;
        [battleAction setDataWithDictionary:tempDict];
        [tempArray addObject:battleAction];
    }
    self.actions = [[NSArray alloc]initWithArray:tempArray];
}

-(void)setActorArrayWithArray:(NSArray *)data
{
    if (data == nil || [data count] == 0)
        return;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSDictionary *tempDict in data)
    {
        BattleActor *battleActor = [[BattleActor alloc]init];
        battleActor.battle = self;
        [battleActor setDataWithDictionary:tempDict];
        [tempArray addObject:battleActor];
    }
    self.actors = [[NSArray alloc]initWithArray:tempArray];
}

-(void)setBriefDataWithDictionay:(NSDictionary *)data
{
    if (data == nil || [data count] == 0)
        return;
    
    self.brief = [[BattleBrief alloc]init];
    self.brief.battle = self;
    [self.brief setDataWithDictionary:data];
}

-(void)setMineArrayWithArray:(NSArray *)data
{
    if (data == nil || [data count] == 0)
        return;
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSDictionary *tempDict in data)
    {
        BattleMine *battleMine = [[BattleMine alloc]init];
        battleMine.battle = self;
        [battleMine setDataWithDictionary:tempDict];
        [tempArray addObject:battleMine];
    }
    self.mine = [[NSArray alloc]initWithArray:tempArray];
}
@end