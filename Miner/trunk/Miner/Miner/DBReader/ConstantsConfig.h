//
//  ConstantsConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BaseDBReader.h"

@interface ConstantsDef : NSObject

@property (nonatomic, assign) NSInteger bagMaxNum;      // 背包上限
@property (nonatomic, assign) NSInteger bagBuyNum;      // 兵营背包购买个数
@property (nonatomic, assign) NSInteger subAttri1Num;   // 1星装备副属性个数
@property (nonatomic, assign) NSInteger subAttri2Num;   // 2星装备副属性个数
@property (nonatomic, assign) NSInteger subAttri3Num;   // 3星装备副属性个数
@property (nonatomic, assign) NSInteger subAttri4Num;   // 4星装备副属性个数
@property (nonatomic, assign) NSInteger subAttri5Num;   // 5星装备副属性个数
@property (nonatomic, assign) NSInteger heroLV;         // 英雄等级上限
@property (nonatomic, assign) NSInteger petLV;          // 宠物等级上限
@property (nonatomic, assign) NSInteger logGap;         // 所有战斗log间隔
@property (nonatomic, assign) NSInteger normalTurn;     // 普通战斗回合上限
@property (nonatomic, assign) NSInteger bossTurn;       // boss战回合上限
@property (nonatomic, assign) NSInteger mineTime;       // 挖矿时间上限
@property (nonatomic, assign) NSInteger criRate;        // 基础暴击率
@property (nonatomic, assign) NSInteger antiCriRate;    // 基础韧性率
@property (nonatomic, assign) NSInteger hitRate;        // 基础命中率
@property (nonatomic, assign) NSInteger dodgeRate;      // 基础闪避率
@property (nonatomic, assign) NSInteger antiparryRate;  // 基础精准率
@property (nonatomic, assign) NSInteger parryRate;      // 基础招架率
@property (nonatomic, assign) NSInteger mdodgeRate;     // 相对闪避率上限
@property (nonatomic, assign) NSInteger mparryRate;     // 相对招架率上限
@property (nonatomic, assign) NSInteger mcriRate;       // 相对暴击率上限
@property (nonatomic, assign) NSInteger cridmgRate;     // 基础暴击伤害加成
@property (nonatomic, assign) NSInteger parrydmgRate;   // 基础招架伤害加成
@property (nonatomic, assign) NSInteger equ1price;      // 1星装备出售价格
@property (nonatomic, assign) NSInteger equ2price;      // 2星装备出售价格
@property (nonatomic, assign) NSInteger equ3price;      // 3星装备出售价格
@property (nonatomic, assign) NSInteger equ4price;      // 4星装备出售价格
@property (nonatomic, assign) NSInteger equ5price;      // 5星装备出售价格
@property (nonatomic, assign) NSInteger familyNum;      // 关系人数上限
@property (nonatomic, assign) NSInteger familyBuyGoldEtherRatio;    // 下线充值，上线获得以太金比例
@property (nonatomic, assign) NSInteger familydigMedalEtherRario;   // 下线挖到贵金属获得以太金比例
@property (nonatomic, assign) NSInteger etherDollar;        // 以太金和美金比例
@property (nonatomic, assign) NSInteger tradeTaxRatio;      // 交易税比例
@property (nonatomic, assign) NSInteger tradeMinPrice;      // 交易最小单位
@property (nonatomic, assign) NSInteger tradeTime1;         // 寄卖时间单位1
@property (nonatomic, assign) NSInteger tradeTime2;         // 寄卖时间单位2
@property (nonatomic, assign) NSInteger tradeTime3;         // 寄卖时间单位3
@property (nonatomic, assign) NSInteger protMaxLv;          // 港口等级上限
@property (nonatomic, assign) NSInteger portCurrentMaxLv;   // 港口开发等级上限
@property (nonatomic, assign) NSInteger mainAttriLvupRatio; // 主属性升级折损经验系数
@property (nonatomic, assign) NSInteger petMineExploreRatio;    // 宠物发现值加成百分比
@property (nonatomic, assign) NSInteger petMineDigRatio;    // 宠物挖掘值加成百分比
@property (nonatomic, assign) NSInteger petSlot1Unlock;     // 宠物槽位1解锁关卡ID
@property (nonatomic, assign) NSInteger petSlot2Unlock;     // 宠物槽位2解锁关卡ID
@property (nonatomic, assign) NSInteger logFontSize;        // 常规字体大小
@property (nonatomic, assign) NSInteger normalShopRefreshTime1;  // 普通商店刷新时间1
@property (nonatomic, assign) NSInteger normalShopRefreshTime2;  // 普通商店刷新时间2
@property (nonatomic, assign) NSInteger normalShopRefreshTime3;  // 普通商店刷新时间3
@property (nonatomic, assign) NSInteger normalShopRefreshNeedItenID;    // 普通商店立即刷新所需物品id
@property (nonatomic, assign) NSInteger normalShopRefreshNeedItenNum;   // 普通商店立即刷新所需物品数目
@property (nonatomic, assign) NSInteger blackShopRefreshTime1;  // 黑市商店刷新时间1
@property (nonatomic, assign) NSInteger blackShopRefreshTime2;  // 黑市商店刷新时间2
@property (nonatomic, assign) NSInteger blackShopRefreshTime3;  // 黑市商店刷新时间3
@property (nonatomic, assign) NSInteger blackShopRefreshNeedItenID;     // 黑市商店立即刷新所需物品id
@property (nonatomic, assign) NSInteger blackShopRefreshNeedItenNum;    // 黑市商店立即刷新所需物品数目
@property (nonatomic, assign) NSInteger mainAttriLvupMoneyRatio;        // 主属性升级折损钱系数

@end

//
// 读取constants.dat文件
//
@interface ConstantsConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(ConstantsConfig *)share;

-(ConstantsDef *)getConstantsData;
-(NSNumber *)getEquipSellPriceWithStar:(NSNumber *)star;
-(NSNumber *)getMainAttriLvUpRatio;
@end
