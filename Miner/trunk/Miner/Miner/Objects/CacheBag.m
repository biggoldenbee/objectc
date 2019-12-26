//
//  CacheBag.m
//  Miner
//
//  Created by zhihua.qian on 15/1/14.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "CacheBag.h"
#import "GameObject.h"

@interface CacheBag ()

@property (nonatomic, assign) NSInteger moneyWillCost;      // 人物身上的金币
@property (nonatomic, strong) Equipment* equipWillChanged;  // 背包内的单一装备
@property (nonatomic, strong) NSArray* equipsWillDestroied; // 背包内的多个装备
@property (nonatomic, strong) NSArray* itemsWillDestroied;  // 背包内的多个道具

@end

@implementation CacheBag
-(void)OprationCostMoney:(NSInteger)num stateType:(CACHE_OPERATION_TYPE)type
{
    switch (type)
    {
        case Be_Wait:
            self.moneyWillCost = num;
            break;
        case Be_Reduction:
        {
            [[[GameObject sharedInstance] player] addHeroMoney:[self moneyWillCost]];
            self.moneyWillCost = 0;
        }
            break;
        case Be_Destroy:
            self.moneyWillCost = 0;
            break;
    }
}

-(void)OprationOneEquip:(NSNumber*)equipId stateType:(CACHE_OPERATION_TYPE)type
{
    switch (type)
    {
        case Be_Wait:
            self.equipWillChanged = [[GameObject sharedInstance] getEquipWithEId:equipId];
            break;
        case Be_Reduction:
        {
            [[[GameObject sharedInstance] bag] addEquipToBag:[self equipWillChanged]];
            self.equipWillChanged = nil;
        }
            break;
        case Be_Destroy:
            self.equipWillChanged = nil;
            break;
    }
}

-(void)OprationEquips:(NSArray*)equipsArray stateType:(CACHE_OPERATION_TYPE)type
{
    switch (type)
    {
        case Be_Wait:
            self.equipsWillDestroied = equipsArray;
            break;
        case Be_Reduction:
        {
            [[[GameObject sharedInstance] bag] addEquipsToBag:[self equipsWillDestroied]];
            self.equipWillChanged = nil;
        }
            break;
        case Be_Destroy:
            self.equipWillChanged = nil;
            break;
    }
}

-(void)OprationItems:(NSArray*)itemsArray stateType:(CACHE_OPERATION_TYPE)type
{
    switch (type)
    {
        case Be_Wait:
            self.itemsWillDestroied = itemsArray;
            break;
        case Be_Reduction:
        {
            [[[GameObject sharedInstance] bag] addItemsToBag:[self itemsWillDestroied]];
            self.itemsWillDestroied = nil;
        }
            break;
        case Be_Destroy:
            self.itemsWillDestroied = nil;
            break;
    }
}
@end
