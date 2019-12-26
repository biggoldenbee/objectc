//
//  EquipmentConfig.m
//  Miner
//
//  Created by zhihua.qian on 14-11-12.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "EquipmentConfig.h"

@implementation EquipmentDef

@end

@implementation EquipmentConfig
static EquipmentConfig * _equipmentConfig = nil;

+(EquipmentConfig *)share
{
    if (_equipmentConfig == nil)
    {
        _equipmentConfig = [[EquipmentConfig alloc]init];
    }
    return _equipmentConfig;
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
        EquipmentDef *def = [[EquipmentDef alloc]init];
        
        int i=0;
        def.equipId         = [[cols objectAtIndex:i++] integerValue];
        def.equipName       = [cols objectAtIndex:i++];
        def.equipDesc       = [cols objectAtIndex:i++];
        def.equipIcon       = [cols objectAtIndex:i++];
        def.equipStar       = [[cols objectAtIndex:i++] integerValue];
        def.equipSlot       = [[cols objectAtIndex:i++] integerValue];
        def.itemType        = [[cols objectAtIndex:i++] integerValue];
        def.primaryAttri    = [[cols objectAtIndex:i++] integerValue];
        def.subAttriGId     = [[cols objectAtIndex:i++] integerValue];
        def.subAttriUpID    = [[cols objectAtIndex:i++] integerValue];
        def.sellType        = [[cols objectAtIndex:i++] integerValue];
        def.basicExp        = [[cols objectAtIndex:i++] integerValue];
        def.specialAttri    = [[cols objectAtIndex:i++] integerValue];
        def.specialExp      = [[cols objectAtIndex:i++] integerValue];
        
        def.logFontSize = [[cols objectAtIndex:i++] integerValue];
        
        int r,g,b;
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        def.logFontColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];

//        [self addRow:def];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu",def.equipId]];
    }
}

-(EquipmentDef *)getEquipmentDefWithKey:(NSNumber *)key
{
    EquipmentDef *temp = [Definitions objectForKey:[key stringValue]];
    return temp;
}
@end

// -----------------------------------------------------------------------------------

@implementation MainBaseAttri
-(id)init
{
    self = [super init];
    if (self)
    {
        self.equipLv = 0;
        self.upgradeExp = 0;
        self.upgradeMoney = 0;
        self.moneyMulti = 0;
    }
    return self;
}
@end

@implementation MainAttriLvDef

-(id)init
{
    self = [super init];
    if (self)
    {
        self.baseAttriLvs = [[NSDictionary alloc]init];
    }
    return self;
}

-(BOOL)addMainBaseAttriIntoDictionary:(MainBaseAttri *)mba
{
    NSString *key = [NSString stringWithFormat:@"%lu", mba.equipLv];
    MainBaseAttri *tempMba = [self.baseAttriLvs objectForKey:key];
    if (tempMba != nil)
    {
        return NO;
    }
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:self.baseAttriLvs];
    [tempDict setValue:mba forKey:key];
    self.baseAttriLvs = [[NSDictionary alloc]initWithDictionary:tempDict];
    
    return YES;
}

@end

@implementation MainAttriLvConfig
static MainAttriLvConfig * _mainAttriLvConfig = nil;
+(MainAttriLvConfig *)share
{
    if (_mainAttriLvConfig == nil)
    {
        _mainAttriLvConfig = [[MainAttriLvConfig alloc]init];
    }
    return _mainAttriLvConfig;
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
        
        int i=0;
        NSInteger star      = [[cols objectAtIndex:i++] integerValue];
        MainAttriLvDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", star]];
        if (def == nil)
        {
            def = [[MainAttriLvDef alloc]init];
            def.equipStar = star;
            [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.equipStar]];
        }
        
        MainBaseAttri *mba  = [[MainBaseAttri alloc]init];
        mba.equipLv         = [[cols objectAtIndex:i++] integerValue];
        mba.upgradeExp      = [[cols objectAtIndex:i++] integerValue];
        mba.upgradeMoney    = [[cols objectAtIndex:i++] integerValue];
        mba.moneyMulti      = [[cols objectAtIndex:i++] integerValue];
        [def addMainBaseAttriIntoDictionary:mba];
    }
}

// 根据星级、等级，获得升到下一级需要的经验
-(NSNumber *)getLevelMaxExpWithLv:(NSNumber *)level starNum:(NSNumber *)star
{
    MainAttriLvDef *def = [Definitions objectForKey:[star stringValue]];
    MainBaseAttri *base = [def.baseAttriLvs objectForKey:[level stringValue]];
    
    return [NSNumber numberWithInteger:base.upgradeExp];
}
// 从1~level等级一共需要要的经验
-(NSNumber *)getTotalExpWithLV:(NSNumber*)level starNum:(NSNumber*)star
{
    MainAttriLvDef* def = [Definitions objectForKey:[star stringValue]];
    NSUInteger expTotal = 0;
    for (int i=0; i<[level intValue]-1; i++)
    {
        MainBaseAttri* base = [def.baseAttriLvs objectForKey:[NSString stringWithFormat:@"%d",i+1]];
        expTotal += base.upgradeExp;
    }
    return [NSNumber numberWithUnsignedInteger:expTotal];
}
// 根据星级、等级，获得升级需要的货币总数
-(NSNumber *)getMoneyTypeWithLv:(NSNumber*)level starNum:(NSNumber*)star
{
    MainAttriLvDef *def = [Definitions objectForKey:[star stringValue]];
    MainBaseAttri *base = [def.baseAttriLvs objectForKey:[level stringValue]];
    
    return [NSNumber numberWithInteger:base.upgradeMoney];
}
// 根据星级、等级，获得升级所需货币的系数
-(NSNumber *)getMoneyRatioWithLv:(NSNumber*)level starNum:(NSNumber*)star
{
    MainAttriLvDef *def = [Definitions objectForKey:[star stringValue]];
    MainBaseAttri *base = [def.baseAttriLvs objectForKey:[level stringValue]];
    
    return [NSNumber numberWithInteger:base.moneyMulti];
}
// 根据星际，获得装备（主属性）的最大等级
-(NSNumber *)getMaxLevelWithStar:(NSNumber*)star
{
    MainAttriLvDef *def = [Definitions objectForKey:[star stringValue]];
    NSUInteger cnt = [[def baseAttriLvs] count];
    return [NSNumber numberWithUnsignedInteger:cnt];
}
@end

// -----------------------------------------------------------------------------------

@implementation SubAttriLvBase

@end

@implementation SubAttriLvDef

-(id)init
{
    self = [super init];
    if (self != nil)
    {
        self.baseAttriLvs = [[NSDictionary alloc]init];
    }
    return self;
}

-(BOOL)addSubAttriLvBaseIntoDictionary:(SubAttriLvBase *)sab
{
    NSString *key = [NSString stringWithFormat:@"%lu", sab.subAttriLv];
    SubAttriLvBase *tempSab = [self.baseAttriLvs objectForKey:key];
    if (tempSab != nil)
    {
        return NO;
    }
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithDictionary:self.baseAttriLvs];
    [tempDict setValue:sab forKey:key];
    self.baseAttriLvs = [[NSDictionary alloc]initWithDictionary:tempDict];
    
    return YES;
}

@end

@implementation SubAttriLvConfig

static SubAttriLvConfig * _subAttriLvConfig = nil;

+(SubAttriLvConfig *)share
{
    if (_subAttriLvConfig == nil)
    {
        _subAttriLvConfig = [[SubAttriLvConfig alloc]init];
    }
    return _subAttriLvConfig;
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

-(SubAttriLvDef*)rowAtIndex:(int)said
{
    for (SubAttriLvDef* def in _DB)
    {
        if ([def subAttriUpID] == said)
        {
            return def;
        }
    }
    return nil;
}

//
// 重载了父类的方法
//
-(void)initWithString:(NSString *)buffer
{
    NSArray *rows = [buffer componentsSeparatedByString:@"\r\n"];
    Definitions = [[NSMutableDictionary alloc] init];
    for (int k=1; k<[rows count]-1; k++)
    {
        NSArray *cols = [[rows objectAtIndex:k] componentsSeparatedByString:@"\t"];
        
        int i=0;
        NSInteger saupid    = [[cols objectAtIndex:i++] integerValue];
        SubAttriLvDef *def  = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", saupid]];
        if (def == nil)
        {
            def = [[SubAttriLvDef alloc]init];
            def.subAttriUpID = saupid;
            [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.subAttriUpID]];
        }
        
        SubAttriLvBase *sab = [[SubAttriLvBase alloc]init];
        sab.subAttriLv      = [[cols objectAtIndex:i++] integerValue];
        sab.costMoney       = [[cols objectAtIndex:i++] integerValue];
        sab.item1id         = [[cols objectAtIndex:i++] integerValue];
        sab.item1Num        = [[cols objectAtIndex:i++] integerValue];
        sab.item2id         = [[cols objectAtIndex:i++] integerValue];
        sab.item2Num        = [[cols objectAtIndex:i++] integerValue];
        sab.item3id         = [[cols objectAtIndex:i++] integerValue];
        sab.item3Num        = [[cols objectAtIndex:i++] integerValue];
        sab.item4id         = [[cols objectAtIndex:i++] integerValue];
        sab.item4Num        = [[cols objectAtIndex:i++] integerValue];
        sab.item5id         = [[cols objectAtIndex:i++] integerValue];
        sab.item5Num        = [[cols objectAtIndex:i++] integerValue];
        sab.item6id         = [[cols objectAtIndex:i++] integerValue];
        sab.item6Num        = [[cols objectAtIndex:i++] integerValue];
        sab.frameName       = [cols objectAtIndex:i++];
        [def addSubAttriLvBaseIntoDictionary:sab];
    }
}

-(SubAttriLvBase *)getUpgradeItemsWithLevel:(NSNumber *)level subAttriUpID:(NSInteger)upId
{
    SubAttriLvDef *def = [Definitions objectForKey:[NSString stringWithFormat:@"%lu", upId]];
    return [def.baseAttriLvs objectForKey:[level stringValue]];
}
@end

// -----------------------------------------------------------------------------------

@implementation SubAttriGDef

@end

@implementation SubAttriGConfig

static SubAttriGConfig * _subAttriGConfig = nil;

+(SubAttriGConfig *)share
{
    if (_subAttriGConfig == nil)
    {
        _subAttriGConfig = [[SubAttriGConfig alloc]init];
    }
    return _subAttriGConfig;
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
        SubAttriGDef *def = [[SubAttriGDef alloc]init];
        
        int i=0;
        def.subAttriGID = [[cols objectAtIndex:i++] integerValue];
        def.attriID1    = [[cols objectAtIndex:i++] integerValue];
        def.attriID2    = [[cols objectAtIndex:i++] integerValue];
        def.attriID3    = [[cols objectAtIndex:i++] integerValue];
        def.attriID4    = [[cols objectAtIndex:i++] integerValue];
        
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu", def.subAttriGID]];
    }
}
@end

// ---------------------------------------------------------------------------------------------

@implementation SpecialAttriLvDef

@end

@implementation SpecialAttriLvConfig
static SpecialAttriLvConfig * _specialAttriLvConfig = nil;

+(SpecialAttriLvConfig *)share
{
    if (_specialAttriLvConfig == nil)
    {
        _specialAttriLvConfig = [[SpecialAttriLvConfig alloc]init];
    }
    return _specialAttriLvConfig;
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
        SpecialAttriLvDef *def = [[SpecialAttriLvDef alloc]init];
        
        int i=0;
        def.equipLv        = [[cols objectAtIndex:i++] integerValue];
        def.upgradeExp        = [[cols objectAtIndex:i++] integerValue];
        def.upgradeMoney    = [[cols objectAtIndex:i++] integerValue];
        def.moneyMulti      = [[cols objectAtIndex:i++] integerValue];
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu",def.equipLv]];
    }
}

-(SpecialAttriLvDef *)getSpecialAttriLvDefWithLevel:(NSNumber *)lv
{
    SpecialAttriLvDef *temp = [Definitions objectForKey:[lv stringValue]];
    return temp;
}
@end

// ---------------------------------------------------------------------------------------------

@implementation TierAttriDef

@end

@implementation TierDef

@end

@implementation TierConfig
static TierConfig * _tierConfig = nil;

+(TierConfig *)share
{
    if (_tierConfig == nil)
    {
        _tierConfig = [[TierConfig alloc]init];
    }
    return _tierConfig;
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
        TierDef *def = [[TierDef alloc]init];
        
        int i=0;
        def.tierId          = [[cols objectAtIndex:i++] integerValue];
        def.tierName        = [cols objectAtIndex:i++];
        
        int r,g,b;
        r = [[cols objectAtIndex:i++] intValue];
        g = [[cols objectAtIndex:i++] intValue];
        b = [[cols objectAtIndex:i++] intValue];
        def.tierColor = [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
        
        NSMutableArray* tempArr = [[NSMutableArray alloc]init];
        for (int i = 0; i < TIER_ATTRI_NUM; i++)
        {
            TierAttriDef* attdef = [[TierAttriDef alloc] init];
            attdef.attriId      = [[cols objectAtIndex:i++] integerValue];
            attdef.attriValue   = [[cols objectAtIndex:i++] integerValue];
            [tempArr addObject:attdef];
        }
        def.attriDatas = tempArr;
        
        [Definitions setObject:def forKey:[NSString stringWithFormat:@"%lu",def.tierId]];
    }
}

-(TierDef *)getTierDefWithId:(NSNumber *)identifier
{
    TierDef *def = [Definitions objectForKey:[identifier stringValue]];
    return def;
}
@end