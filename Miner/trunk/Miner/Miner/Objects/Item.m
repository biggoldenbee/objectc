//
//  Item.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "Item.h"
#import "UtilityDef.h"

@implementation Item

-(void)setItemDataWithDictionary:(NSDictionary *)data
{
    self.itemIId    = [data objectForKey:@"IID"];
    self.itemIType  = [data objectForKey:@"IType"];
    self.itemCount  = [data objectForKey:@"Cnt"];
    
    self.itemTId    = [data objectForKey:@"TID"];
    ItemDef* itemDef = [[ItemConfig share] getItemDefWithKey:[self itemTId]];
    self.itemName   = itemDef.itemName;
    self.itemIcon   = itemDef.itemIcon;
    self.itemDesc   = itemDef.itemDesc;
    self.itemUseLv  = INTEGER_TO_NUMBER(itemDef.playerLv);
    self.itemType   = INTEGER_TO_NUMBER(itemDef.itemType);
    self.itemStack  = INTEGER_TO_NUMBER(itemDef.stack);
    self.canSell    = itemDef.canSell;
    self.sellMoney  = INTEGER_TO_NUMBER(itemDef.sellMoney);
    self.sellNum    = INTEGER_TO_NUMBER(itemDef.sellNum);
    self.useable    = itemDef.useable;
    self.useType    = INTEGER_TO_NUMBER(itemDef.useType);
    self.typeNum1   = INTEGER_TO_NUMBER(itemDef.typeNum1);
    self.typeNum2   = INTEGER_TO_NUMBER(itemDef.typeNum2);
    self.typeNum3   = INTEGER_TO_NUMBER(itemDef.typeNum3);
    self.canTrade   = itemDef.trade;
    self.tradeMoneyType     = INTEGER_TO_NUMBER(itemDef.tradeMoneyType);
    self.tradePrice         = INTEGER_TO_NUMBER(itemDef.tradePrice);
    self.tradeLowerPrice    = INTEGER_TO_NUMBER(itemDef.tradeLowerPrice);
    self.tradeUpperPrice    = INTEGER_TO_NUMBER(itemDef.tradeUpperPrice);
    self.changeTradeLowerPrice   = INTEGER_TO_NUMBER(itemDef.changeTradeLowerPrice);
    self.changeTradeUpperPrice   = INTEGER_TO_NUMBER(itemDef.changeTradeUpperPrice);
    self.contributionPay    = INTEGER_TO_NUMBER(itemDef.contributionPay);
    self.logFontSize        = INTEGER_TO_NUMBER(itemDef.logFontSize);
    self.logFontColor       = itemDef.logFontColor;
}


@end
