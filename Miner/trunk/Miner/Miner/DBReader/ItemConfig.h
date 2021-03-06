//
//  ItemConfig.h
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDBReader.h"
#import <UIKit/UIKit.h>

@interface ItemDef : NSObject

@property (nonatomic, assign) NSInteger itemId;     // 物品id
@property (nonatomic, copy)   NSString* itemName;   // 物品名字  来自 resource表
@property (nonatomic, copy)   NSString* itemDesc;   // 物品描述  来自 resource表
@property (nonatomic, copy)   NSString* itemIcon;   // 图片名称  来自 resource表
@property (nonatomic, assign) NSInteger playerLv;   // 玩家使用的等级
@property (nonatomic, assign) NSInteger itemType;   // 1 基础资源类；2 材料；3 宝箱
@property (nonatomic, assign) NSInteger stack;      // 单个各自叠加上限
@property (nonatomic, assign) BOOL      canSell;    // 0 不可出售；1 可出售
@property (nonatomic, assign) NSInteger sellMoney;  // 出售获得的资源物品id
@property (nonatomic, assign) NSInteger sellNum;    // 出售获得的资源物品数目
@property (nonatomic, assign) BOOL      useable;    // 0 不可使用； 1 可以使用
@property (nonatomic, assign) NSInteger useType;    // 1 宝箱类；2 buff道具类型
@property (nonatomic, assign) NSInteger typeNum1;   //
@property (nonatomic, assign) NSInteger typeNum2;   //
@property (nonatomic, assign) NSInteger typeNum3;   //
@property (nonatomic, assign) BOOL      trade;      // 是否可交易
@property (nonatomic, assign) NSInteger tradeMoneyType; // 交易货币类型
@property (nonatomic, assign) NSInteger tradePrice;     // 交易货币默认值
@property (nonatomic, assign) NSInteger tradeLowerPrice; // 交易价格下限
@property (nonatomic, assign) NSInteger tradeUpperPrice; // 交易价格上限
@property (nonatomic, assign) NSInteger changeTradeLowerPrice; // 交易改价比例下限
@property (nonatomic, assign) NSInteger changeTradeUpperPrice; // 交易改价比例上限	挖到奖励贡献值
@property (nonatomic, assign) NSInteger contributionPay; //挖到奖励贡献值
@property (nonatomic, assign) NSInteger logFontSize;
@property (nonatomic, strong) UIColor*  logFontColor;
@end

@interface ItemConfig : BaseDBReader
{
    NSMutableDictionary *Definitions;
}

+(ItemConfig *)share;

-(ItemDef *)getItemDefWithKey:(NSNumber *)key;
@end
