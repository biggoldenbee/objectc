//
//  Bag.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "Bag.h"
#import "UtilityDef.h"
#import "GameUtility.h"

#import "Equipment.h"
#import "Item.h"

@implementation Bag
-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.bagEquips = [[NSMutableArray alloc]init];
        self.bagItems = [[NSMutableArray alloc]init];
        self.visitedEquipment = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - function about custom initialization
//
// 根据字典信息，初始化背包信息，包括两个数组
//
-(void)setBagDataWithDictionary:(NSDictionary *)data
{
    if ([data objectForKey:@"Level"])   // 背包等级
    {
        self.bagLevel  = [data objectForKey:@"Level"];      // 背包等级
    }
    
    if ([data objectForKey:@"Num"])     // 背包最大格子数
    {
        self.bagExtent = [data objectForKey:@"Extent"];     // 背包已扩张次数
    }
    
    if ([data objectForKey:@"Extent"])  // 背包已扩张次数
    {
        self.bagMaxNum = [data objectForKey:@"Num"];        // 背包最大格子数
    }
    
    if ([data objectForKey:@"Equip"])
    {
        NSArray *tempEquip = [[NSArray alloc]initWithArray:[data objectForKey:@"Equip"]];
        [self setBagEquipsWithArray:tempEquip];
        self.bagEquipCount = [[NSNumber alloc] initWithUnsignedInteger:[self.bagEquips count]];
    }
    
    if ([data objectForKey:@"Item"])
    {
        NSArray *tempItem  = [[NSArray alloc]initWithArray:[data objectForKey:@"Item"]];
        [self setBagItemsWithArray:tempItem];
    }
    
    // 背包内装备占用的格子数（也就是装备总数）
    self.bagEquipCount = [NSNumber numberWithUnsignedInteger:[[self bagEquips] count]];
}

//
// 初始化装备数组
//
-(void)setBagEquipsWithArray:(NSArray *)equipArray
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]init];
    [self.bagEquips removeAllObjects];
    for (NSDictionary *equipInfo in equipArray)
    {
        Equipment *equip = [[Equipment alloc]init];
        [equip setEquipDataWithDictionary:equipInfo];
        [self.bagEquips addObject:equip];
        
        // 刷新访问字典
        NSDictionary* visited = [self.visitedEquipment objectForKey:equip.equipEId];
        if ( visited != nil )
        {
            NSNumber* oldBv = [visited objectForKey:@"bv"];
            if ( [oldBv integerValue] != [equip.equipBV integerValue] )
            {
                NSMutableDictionary* dictVisited = [visited mutableCopy];
                [dictVisited removeObjectForKey:@"visited"];
                [dictVisited setObject:equip.equipBV forKey:@"bv"];
                
                [dict setObject:dictVisited
                         forKey:equip.equipEId];
            }
            else
                [dict setObject:visited forKey:equip.equipEId];
        }
        else
        {
            EquipmentDef* ed = [[EquipmentConfig share] getEquipmentDefWithKey:equip.equipTId];
            [dict setObject:@{
                              @"bv" : equip.equipBV,
                              @"slot" : [NSNumber numberWithInteger:ed.equipSlot],
                              @"star" : equip.equipStar,
                              }
                     forKey:equip.equipEId];
        }
    }
    
    self.visitedEquipment = dict;
}

//
// 初始化物品数组
//
-(void)setBagItemsWithArray:(NSArray *)itemArray
{
    [self.bagItems removeAllObjects];
    for (NSDictionary *itemInfo in itemArray)
    {
        Item *item = [[Item alloc] init];
        [item setItemDataWithDictionary:itemInfo];
        [self.bagItems addObject:item];
    }
}

#pragma mark - function about equipment
-(BOOL)isEquipFull
{
    return [self.bagEquips count] == [self.bagMaxNum unsignedIntegerValue]? YES : NO;
}

-(void)addEquipToBag:(Equipment *)equip
{
    equip.equipSlot = [[NSNumber alloc]initWithInt:0];
    [[self bagEquips] addObject:equip];
}
-(void)addEquipsToBag:(NSArray *)equips
{
    [[self bagEquips] addObjectsFromArray:equips];
}

-(void)removeEquipFromBag:(Equipment *)equip
{
    [[self bagEquips] removeObject:equip];
}
-(void)removeEquipsFromBag:(NSArray *)equips
{
    for (NSNumber* equipId in equips)
    {
        Equipment* equip = [self getEquipmentWithId:equipId];
        [[self bagEquips] removeObject:equip];
    }
}
//
// 根据字典更改装备信息
//
-(void)changeEquipDataWithDictionary:(NSDictionary *)data
{
    NSNumber *identirier = [data objectForKey:@"EID"];
    for (Equipment *equip in self.bagEquips)
    {
        if ([[equip equipEId] isEqualToNumber:identirier])
        {
            [equip setEquipDataWithDictionary:data];
        }
    }
}

//
// 根据装备位置来获取背包内对应的装备  用来给外部类调用的
// slot 1~8 为身上装备；0是根据道具类型（装备的类型编号是5）
//
-(NSArray *)getEquipmentsWithSlot:(NSNumber *)slot
{
    if (self.bagEquips == nil)
        return nil;
    
    if ([slot integerValue] > 0 && [slot integerValue] < 9)
    {
        return [self getEquipsFromBagWithPartSlot:slot];
    }
    
    if ([slot integerValue] == 0)
    {
        return [self getEquipsFromBagWithType:INTEGER_TO_NUMBER(5)];
    }
    
    return nil;
}

-(Equipment *)getEquipmentWithId:(NSNumber *)identifier
{
    for (Equipment *equip in self.bagEquips)
    {
        if ([[equip equipEId] isEqualToNumber:identifier])
        {
            return equip;
        }
    }
    return nil;
}

//
// 真正用slot来找装备
//
-(NSArray *)getEquipsFromBagWithPartSlot:(NSNumber *)slot
{
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (Equipment *equip in self.bagEquips)
    {
        if ([[equip getEquipDefSlot] isEqualToNumber:slot])
        {
            [tempArr addObject:equip];
        }
    }
    
    return tempArr;
}

//
// 根据物品类型来选背包内的物品
//
-(NSArray *)getEquipsFromBagWithType:(NSNumber *)type
{
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (Equipment *equip in self.bagEquips)
    {
        if ([[equip getItemType] isEqualToNumber:type])
        {
            [tempArr addObject:equip];
        }
    }
    
    return tempArr;
}

#pragma mark - function about item
-(void)addItemsToBag:(NSArray *)items
{
    [[self bagItems] addObjectsFromArray:items];
    
    SortParam* param = [[SortParam alloc] init];
    param.paramName = @"itemId";
    param.ascending = YES;
    NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:param,@"0", nil];
    NSArray* sortedArray = [GameUtility array:[self bagItems] sortArrayWithParams:tempDict];
    self.bagItems = [NSMutableArray arrayWithArray:sortedArray];
}

-(Item *)getItemWithTId:(NSNumber *)itemTId
{
    for (Item* item in self.bagItems)
    {
        if ( [[item itemTId] isEqualToNumber:itemTId])
        {
            return item;
        }
    }
    return nil;
}
-(Item *)getItemWithIId:(NSNumber *)itemIId
{
    for (Item* item in self.bagItems)
    {
        if ( [[item itemIId] isEqualToNumber:itemIId ])
        {
            return item;
        }
    }
    return nil;
}

-(void)changeItemDataWithId:(NSNumber*)itemIId withNum:(NSInteger)num
{
    for (Item* item in self.bagItems)
    {
        if ( [[item itemIId] isEqualToNumber:itemIId] )
        {
            NSInteger count = [[item itemCount] integerValue];
            item.itemCount = [NSNumber numberWithInteger:count];
        }
    }
}

-(void)clearVisitedFlag
{
    NSArray* allKeys = [self.visitedEquipment allKeys];
    NSMutableDictionary* dict = [self.visitedEquipment mutableCopy];
    for(NSNumber* key in allKeys)
    {
        NSMutableDictionary* content = [[self.visitedEquipment objectForKey:key] mutableCopy];
        [content removeObjectForKey:@"visited"];
        [dict setObject:content forKey:key];
    }
    self.visitedEquipment = dict;
}

-(void)setVisitedFlagToAll:(BOOL)visited slot:(int)slot tag:(NSString*)tag
{
    NSArray* allKeys = [self.visitedEquipment allKeys];
    NSMutableDictionary* dict = [self.visitedEquipment mutableCopy];
    for(NSNumber* key in allKeys)
    {
        NSMutableDictionary* content = [[self.visitedEquipment objectForKey:key] mutableCopy];
        NSNumber* s = [content objectForKey:@"slot"];
        if ( s.intValue != slot )
            continue;
        NSMutableDictionary* visitedDict = [[content objectForKey:@"visited"] mutableCopy];
        
        [visitedDict setObject:[NSNumber numberWithBool:visited] forKey:tag];
        
        [dict setObject:content forKey:key];
    }
    self.visitedEquipment = dict;
}

-(BOOL)hasBetterEquip:(int)slot current:(Equipment*)current tag:(NSString*)tag
{
    NSArray* allKeys = [self.visitedEquipment allKeys];
    for(NSNumber* key in allKeys)
    {
        NSDictionary* content = [self.visitedEquipment objectForKey:key];
        NSNumber* s = [content objectForKey:@"slot"];
        if ( s.intValue != slot )
            continue;
        
        NSDictionary* visited = [content objectForKey:@"visited"];
        if ( visited != nil )
        {
            NSNumber* tagVisited = [visited objectForKey:tag];
            if(tagVisited!=nil && tagVisited.boolValue)
                continue;
        }
        NSNumber* bv = [content objectForKey:@"bv"];
        if ( current == nil )
            return YES;
        NSNumber* star = [content objectForKey:@"star"];
        if ( star.intValue > current.equipStar.intValue )
            return YES;
        if ( star.intValue == current.equipStar.intValue && bv.integerValue > current.equipBV.integerValue )
            return YES;
    }
    
    return NO;
}
@end
