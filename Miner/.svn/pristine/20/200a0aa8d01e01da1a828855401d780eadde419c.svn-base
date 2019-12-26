//
//  Item.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ItemConfig.h"

@class UIColor;

@interface Item : NSObject

@property (nonatomic, strong) NSNumber* itemIId;    // 物品唯一ID
@property (nonatomic, strong) NSNumber* itemIType;  // 物品类型
@property (nonatomic, strong) NSNumber* itemCount;  // 物品数量

@property (nonatomic, strong) NSNumber* itemTId;    // 物品配置ID
@property (nonatomic, strong) NSString* itemName;
@property (nonatomic, strong) NSString* itemIcon;
@property (nonatomic, strong) NSString* itemDesc;
@property (nonatomic, strong) NSNumber* itemUseLv;  // 玩家使用的等级
@property (nonatomic, strong) NSNumber* itemType;   // 1 基础资源类；2 材料；3 宝箱
@property (nonatomic, strong) NSNumber* itemStack;  // 单个叠加上限
@property (nonatomic, assign) BOOL      canSell;    // 0 不可出售；1 可出售
@property (nonatomic, strong) NSNumber* sellMoney;  // 出售获得的资源物品id
@property (nonatomic, strong) NSNumber* sellNum;    // 出售获得的资源物品数目
@property (nonatomic, assign) BOOL      useable;    // 0 不可使用； 1 可以使用
@property (nonatomic, strong) NSNumber* useType;    // 1 宝箱类；2 buff道具类
@property (nonatomic, strong) NSNumber* typeNum1;   //
@property (nonatomic, strong) NSNumber* typeNum2;   //
@property (nonatomic, strong) NSNumber* typeNum3;   //
@property (nonatomic, assign) BOOL      canTrade;      // 是否可交易
@property (nonatomic, strong) NSNumber* tradeMoneyType;     // 交易货币类型
@property (nonatomic, strong) NSNumber* tradePrice;         // 交易货币默认值
@property (nonatomic, strong) NSNumber* tradeLowerPrice;    // 交易价格下限
@property (nonatomic, strong) NSNumber* tradeUpperPrice;    // 交易价格上限
@property (nonatomic, strong) NSNumber* changeTradeLowerPrice; // 交易改价比例下限
@property (nonatomic, strong) NSNumber* changeTradeUpperPrice; // 交易改价比例上限
@property (nonatomic, strong) NSNumber* contributionPay;    // 挖到奖励贡献值
@property (nonatomic, strong) NSNumber* logFontSize;        // 字体大小
@property (nonatomic, strong) UIColor* logFontColor;        // 字体颜色

-(void)setItemDataWithDictionary:(NSDictionary *)data;  // 设置使用的道具属性
@end
