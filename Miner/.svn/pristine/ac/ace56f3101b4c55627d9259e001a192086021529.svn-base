//
//  Bag.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Equipment;
@class Item;

@interface Bag : NSObject

@property (nonatomic, strong) NSNumber  *bagLevel;      // 背包等级
@property (nonatomic, strong) NSNumber  *bagExtent;     // 已扩展次数
@property (nonatomic, strong) NSNumber  *bagEquipCount; // 背包格子数（只计算装备的）
@property (nonatomic, strong) NSNumber  *bagMaxNum;     // 背包最大格子数

@property (nonatomic, strong) NSMutableArray *bagEquips;   // 背包内装备数组
@property (nonatomic, strong) NSMutableArray *bagItems;    // 背包内物品数组
@property (nonatomic, strong) NSMutableDictionary* visitedEquipment; // 记录所有与当前穿戴好的装备进行比较的结果
#pragma mark - function about custom initialization
-(void)setBagDataWithDictionary:(NSDictionary *)data;   // 根据字典信息初始化背包

#pragma mark - function about item
-(void)addItemsToBag:(NSArray *)items;              // 根据数组添加道具
-(Item *)getItemWithIId:(NSNumber *)itemIId;        // 根据IId获取道具
-(Item *)getItemWithTId:(NSNumber *)itemTId;        // 根据TId获取道具
-(void)changeItemDataWithId:(NSNumber*)itemIId withNum:(NSInteger)num;  // 更改道具信息

#pragma mark - function about equipment
-(BOOL)isEquipFull;                                 // 装备是否满了
-(void)addEquipToBag:(Equipment *)equip;            // 添加装备到背包
-(void)addEquipsToBag:(NSArray *)equips;            // 根据数组添加装备
-(void)removeEquipFromBag:(Equipment *)equip;       // 从背包移除装备
-(void)removeEquipsFromBag:(NSArray *)equips;       // 根据数组移除装备
-(void)changeEquipDataWithDictionary:(NSDictionary *)data;  // 根据字典信息更改背包里的装备信息

-(NSArray *)getEquipmentsWithSlot:(NSNumber *)slot;         // 根据位置来获取装备数组
-(Equipment *)getEquipmentWithId:(NSNumber *)identifier;    // 根据装备ID获取装备
-(void)clearVisitedFlag;
-(void)setVisitedFlagToAll:(BOOL)visited slot:(int)slot tag:(NSString*)tag;
-(BOOL)hasBetterEquip:(int)slot current:(Equipment*)current tag:(NSString*)tag;
@end
