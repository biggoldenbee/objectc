//
//  ItemConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "ItemConfig.h"

@implementation ItemDef

@end

@implementation ItemConfig

static ItemConfig * _itemConfig = nil;

+(ItemConfig *)share
{
    if (_itemConfig == nil)
    {
        _itemConfig = [[ItemConfig alloc]init];
    }
    return _itemConfig;
}

-(void)dealloc
{
    Definitions = nil;
}

-(void)reset
{
    [super reset];
    Definitions = nil;
}

//
// 重载了父类的方法
//
-(void)initWithString:(NSString *)buffer
{
    NSArray *rows = [buffer componentsSeparatedByString:@"\r\n"];
    Definitions = [[NSMutableDictionary alloc]init];
    for (int k=1; k<[rows count]-1; k++)
    {
        NSArray *cols = [[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        ItemDef *def = [[ItemDef alloc]init];
        
        int i=0;
        def.itemId      = [[cols objectAtIndex:i++] integerValue];
        def.itemName    = [cols objectAtIndex:i++];
        def.itemDesc    = [cols objectAtIndex:i++];
        def.itemIcon    = [cols objectAtIndex:i++];
        def.playerLv    = [[cols objectAtIndex:i++] integerValue];
        def.itemType    = [[cols objectAtIndex:i++] integerValue];
        def.stack       = [[cols objectAtIndex:i++] integerValue];
        def.canSell     = [[cols objectAtIndex:i++] boolValue];
        def.sellMoney   = [[cols objectAtIndex:i++] integerValue];
        def.sellNum     = [[cols objectAtIndex:i++] integerValue];
        def.useable     = [[cols objectAtIndex:i++] boolValue];
        def.useType     = [[cols objectAtIndex:i++] integerValue];
        def.typeNum1    = [[cols objectAtIndex:i++] integerValue];
        def.typeNum2    = [[cols objectAtIndex:i++] integerValue];
        def.typeNum3    = [[cols objectAtIndex:i++] integerValue];
        def.trade       = [[cols objectAtIndex:i++] boolValue];             // 是否可交易
        def.tradeMoneyType = [[cols objectAtIndex:i++] integerValue];       // 交易货币类型
        def.tradePrice  = [[cols objectAtIndex:i++] integerValue];          // 交易货币默认值
        def.tradeLowerPrice = [[cols objectAtIndex:i++] integerValue];      // 交易价格下限
        def.tradeUpperPrice = [[cols objectAtIndex:i++] integerValue];      // 交易价格上限
        def.changeTradeLowerPrice   = [[cols objectAtIndex:i++] integerValue]; // 交易改价比例下限
        def.changeTradeUpperPrice   = [[cols objectAtIndex:i++] integerValue]; // 交易改价比例上限	挖到奖励贡献值
        def.contributionPay         = [[cols objectAtIndex:i++] integerValue]; //挖到奖励贡献值

        def.logFontSize     = [[cols objectAtIndex:i++] integerValue];
        int r,g,b;
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        def.logFontColor    = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];

        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.itemId]];
    }
}

-(ItemDef *)getItemDefWithKey:(NSNumber *)key
{
    ItemDef *def = [Definitions objectForKey:[key stringValue]];
    return def;
}
@end