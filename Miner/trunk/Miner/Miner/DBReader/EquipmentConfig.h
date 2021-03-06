//
//  EquipmentConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"
#import <UIKit/UIKit.h>
typedef enum
{
    EQUIP_SLOT_WEAPON   = 1,
    EQUIP_SLOT_HEAD     = 2,
    EQUIP_SLOT_BODY     = 3,
    EQUIP_SLOT_HAND     = 4,
    EQUIP_SLOT_BACK     = 5,
    EQUIP_SLOT_FOOT     = 6,
    EQUIP_SLOT_DECTECTOR = 7,
    EQUIP_SLOT_PICKAXE  = 8,
}
EQUIP_SLOT;

@interface EquipmentDef : NSObject

@property (nonatomic, assign) NSInteger equipId;        // 装备ID
@property (nonatomic, copy)   NSString  *equipName;     // 装备名称
@property (nonatomic, copy)   NSString  *equipDesc;     // 装备描述
@property (nonatomic, copy)   NSString  *equipIcon;     // 装备icon
@property (nonatomic, assign) NSInteger equipStar;      // 装备星级
@property (nonatomic, assign) NSInteger equipSlot;      // 穿戴槽位
@property (nonatomic, assign) NSInteger itemType;       // 物品类型
@property (nonatomic, assign) NSInteger primaryAttri;   // 主属性
@property (nonatomic, assign) NSInteger subAttriGId;    // 副属性组ID
@property (nonatomic, assign) NSInteger subAttriUpID;   // 副属性升级id
@property (nonatomic, assign) NSInteger sellType;       // 出售货币类型
@property (nonatomic, assign) NSInteger basicExp;       // 基础经验
@property (nonatomic, assign) NSInteger specialAttri;   // 神器属性ID
@property (nonatomic, assign) NSInteger specialExp;     // 神器属性基础经验

@property (nonatomic, assign) NSInteger logFontSize;
@property (nonatomic, strong) UIColor* logFontColor;
@end

@interface EquipmentConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(EquipmentConfig *)share;
-(EquipmentDef *)getEquipmentDefWithKey:(NSNumber *)key;
@end
// -------------------------------------------------------------------------------

@interface MainBaseAttri : NSObject

@property (nonatomic, assign) NSInteger equipLv;        // 等级
@property (nonatomic, assign) NSInteger upgradeExp;     // 升到下级经验
@property (nonatomic, assign) NSInteger upgradeMoney;   // 升级所需货币类型
@property (nonatomic, assign) NSInteger moneyMulti;     // 升级所需货币系数

@end
//--------

@interface MainAttriLvDef : NSObject

@property (nonatomic, assign) NSInteger equipStar;          // 星级
@property (nonatomic, strong) NSDictionary  *baseAttriLvs;

-(BOOL)addMainBaseAttriIntoDictionary:(MainBaseAttri *)mba;

@end
//---------

@interface MainAttriLvConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(MainAttriLvConfig *)share;


-(NSNumber *)getLevelMaxExpWithLv:(NSNumber *)level starNum:(NSNumber *)star;
-(NSNumber *)getTotalExpWithLV:(NSNumber*)level starNum:(NSNumber*)star;
-(NSNumber *)getMoneyTypeWithLv:(NSNumber*)level starNum:(NSNumber*)star;
-(NSNumber *)getMoneyRatioWithLv:(NSNumber*)level starNum:(NSNumber*)star;
-(NSNumber *)getMaxLevelWithStar:(NSNumber*)star;
@end
// ---------------------------------------------------------------------------------

@interface SubAttriLvBase : NSObject

@property (nonatomic, assign) NSInteger subAttriLv;     // 等级
@property (nonatomic, assign) NSInteger costMoney;      // 升级所需游戏币
@property (nonatomic, assign) NSInteger item1id;        // 物品1id
@property (nonatomic, assign) NSInteger item1Num;       // 物品1个数
@property (nonatomic, assign) NSInteger item2id;        // 物品2id
@property (nonatomic, assign) NSInteger item2Num;       // 物品2个数
@property (nonatomic, assign) NSInteger item3id;        // 物品3id
@property (nonatomic, assign) NSInteger item3Num;       // 物品3个数
@property (nonatomic, assign) NSInteger item4id;        // 物品4id
@property (nonatomic, assign) NSInteger item4Num;       // 物品4个数
@property (nonatomic, assign) NSInteger item5id;        // 物品5id
@property (nonatomic, assign) NSInteger item5Num;       // 物品5个数
@property (nonatomic, assign) NSInteger item6id;        // 物品6id
@property (nonatomic, assign) NSInteger item6Num;       // 物品6个数
@property (nonatomic, copy)   NSString* frameName;      // 外框编号
@end

@interface SubAttriLvDef : NSObject

@property (nonatomic, assign) NSInteger subAttriUpID;   // 副属性升级id
@property (nonatomic, strong) NSDictionary  *baseAttriLvs;

-(BOOL)addSubAttriLvBaseIntoDictionary:(SubAttriLvBase *)sab;
@end

@interface SubAttriLvConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(SubAttriLvConfig *)share;

-(SubAttriLvBase *)getUpgradeItemsWithLevel:(NSNumber *)level subAttriUpID:(NSInteger)upId;
@end
// ---------------------------------------------------------------------------------

@interface SubAttriGDef : NSObject

@property (nonatomic, assign) NSInteger subAttriGID;    // 副属性组id
@property (nonatomic, assign) NSInteger attriID1;       // 属性1id
@property (nonatomic, assign) NSInteger attriID2;       // 属性2id
@property (nonatomic, assign) NSInteger attriID3;       // 属性3id
@property (nonatomic, assign) NSInteger attriID4;       // 属性4id

@end

@interface SubAttriGConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(SubAttriGConfig *)share;
@end

// ---------------------------------------------------------------------------------

@interface SpecialAttriLvDef : NSObject

@property (nonatomic, assign) NSInteger equipLv;        // 等级
@property (nonatomic, assign) NSInteger upgradeExp;     // 升到下级经验
@property (nonatomic, assign) NSInteger upgradeMoney;   // 升级所需货币类型
@property (nonatomic, assign) NSInteger moneyMulti;     // 升级所需货币系数

@end

@interface SpecialAttriLvConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(SubAttriGConfig *)share;
-(SpecialAttriLvDef *)getSpecialAttriLvDefWithLevel:(NSNumber *)lv;
@end

// ---------------------------------------------------------------------------------
#define TIER_ATTRI_NUM      10

@interface TierAttriDef : NSObject

@property (nonatomic, assign) NSInteger attriId;        // 属性ID
@property (nonatomic, assign) NSInteger attriValue;     // 属性值

@end

@interface TierDef : NSObject

@property (nonatomic, assign) NSInteger tierId;         // 套装等级id
@property (nonatomic, copy)   NSString* tierName;       // 套装名称
@property (nonatomic, strong) UIColor*  tierColor;      // 颜色
@property (nonatomic, strong) NSArray*  attriDatas; // 属性字典

@end

@interface TierConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(SubAttriGConfig *)share;
-(TierDef *)getTierDefWithId:(NSNumber *)identifier;
@end