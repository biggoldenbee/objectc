//
//  LadderCompetitor.m
//  Miner
//
//  Created by zhihua.qian on 14-12-19.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "LadderCompetitor.h"
#import "Equipment.h"
#import "Pet.h"

@implementation LadderCompetitor

-(void)setDataWithDictionary:(NSDictionary*)data
{
    self.ldrType    = [data objectForKey:@"Type"];
    self.ldrMid     = [data objectForKey:@"MID"];
    self.ldrLevel   = [data objectForKey:@"Level"];
    self.ldrName    = [data objectForKey:@"Name"];
    self.ldrIcon    = [data objectForKey:@"Icon"];
    self.ldrExp     = [data objectForKey:@"Exp"];
    self.ldrPrestige    = [data objectForKey:@"Prestige"];
    self.ldrBV      = [data objectForKey:@"BV"];
    self.ldrRkLdr   = [data objectForKey:@"RkLdr"];
    
    if ([data objectForKey:@"Pet"])
    {
        NSArray *petData = [data objectForKey:@"Pet"];
        [self setHeroPetWithArray:petData];
    }
    
    if ([data objectForKey:@"Equip"])
    {
        NSArray *equipData = [data objectForKey:@"Equip"];
        [self setHeroEquipsWithArray:equipData];
    }
}

-(void)setHeroEquipsWithArray:(NSArray *)data
{
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSDictionary *temp in data)
    {
        Equipment *equip = [[Equipment alloc]init];
        [equip setEquipDataWithDictionary:temp];
        [tempArray addObject:equip];
    }
    self.ldrEquips = [[NSArray alloc]initWithArray:tempArray];
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
    
    self.ldrPets = [[NSArray alloc]initWithArray:tempPet];
}
@end
