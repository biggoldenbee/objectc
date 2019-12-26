//
//  Equip.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-3.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "Equipment.h"
#import "ConstantsConfig.h"
#import "AttriConfig.h"

@implementation AttributeData

-(NSString*)getAttriName
{
    AttriDef* def = [[AttriConfig share] getAttriDefById:[self attriId]];
    return [def attriName];
}
-(NSString*)getAttriIcon
{
    AttriDef* def = [[AttriConfig share] getAttriDefById:[self attriId]];
    return [def attriIcon];
}
-(NSString*)getAttriDesc
{
    AttriDef* def = [[AttriConfig share] getAttriDefById:[self attriId]];
    return [def attriDesc];
}

-(NSNumber*)getMaxExp:(NSNumber*)star
{
    return [[MainAttriLvConfig share] getLevelMaxExpWithLv:[self attriLevel] starNum:star];
}
-(NSNumber*)getTotalExp:(NSNumber*)star
{
    return [[MainAttriLvConfig share] getTotalExpWithLV:[self attriLevel] starNum:star];
}
-(NSNumber*)getRatio
{
    float ratio = [[[ConstantsConfig share] getMainAttriLvUpRatio] floatValue]/10000.0;
    return [NSNumber numberWithFloat:ratio];
}
@end




@implementation Equipment

-(void)setEquipDataWithDictionary:(NSDictionary *)data
{
    self.equipEId   = [data objectForKey:@"EID"];
    
    self.equipTId   = [data objectForKey:@"TID"];
    self.equipSlot  = [data objectForKey:@"Slot"];
    self.equipStar  = [data objectForKey:@"Star"];
    self.equipType  = [data objectForKey:@"IType"];
    self.equipBV    = [data objectForKey:@"BV"];
    
    if ([data objectForKey:@"PA"])
    {
        NSArray *primaryAttri = [data objectForKey:@"PA"];
        [self setEquipMainAttriWithArray:primaryAttri];
    }
    
    if ([data objectForKey:@"SA"])
    {
        NSArray *subAttri = [data objectForKey:@"SA"];
        [self setEquipSubAttriWithArray:subAttri];
    }
    
    if ([data objectForKey:@"SPA"])
    {
        NSArray* supAttri = [data objectForKey:@"SPA"];
        [self setEquipGodAttriWithArray:supAttri];
    }
}

-(void)setEquipMainAttriWithArray:(NSArray *)data
{
    if ( [data count] == 0 )
        return;
    
    self.mainAttri = [[AttributeData alloc]init];
    self.mainAttri.attriId      = [data objectAtIndex:0];
    self.mainAttri.attriLevel   = [data objectAtIndex:1];
    self.mainAttri.attriValue   = [data objectAtIndex:2];
    self.mainAttri.attriExp     = [data objectAtIndex:3];
}

-(void)setEquipSubAttriWithArray:(NSArray *)data
{
    if ([data count] == 0 || [data count]%3 != 0)
        return;
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    int i = 0;
    while (i< [data count])
    {
        AttributeData *attri = [[AttributeData alloc]init];
        attri.attriId       = [data objectAtIndex:i++];
        attri.attriValue    = [data objectAtIndex:i++];
        attri.attriLevel    = [data objectAtIndex:i++];
        
        [tempArr addObject:attri];
    }
    
    self.subAttri = [[NSArray alloc]initWithArray:tempArr];
}

-(void)setEquipGodAttriWithArray:(NSArray*)data
{
    if ([data count] == 0)
        return;
    
    self.godAttri = [[AttributeData alloc]init];
    self.godAttri.attriId       = [data objectAtIndex:0];
    self.godAttri.attriLevel    = [data objectAtIndex:1];
    self.godAttri.attriValue    = [data objectAtIndex:2];
    self.godAttri.attriExp      = [data objectAtIndex:3];
}

#pragma mark - The functions to get equip properties
-(NSString*)getEquipName
{
    EquipmentDef* def = [[EquipmentConfig share]getEquipmentDefWithKey:[self equipTId]];
    return [def equipName];
}
-(NSString*)getEquipIcon
{
    EquipmentDef* def = [[EquipmentConfig share]getEquipmentDefWithKey:[self equipTId]];
    return [def equipIcon];
}
-(NSString*)getEquipDesc
{
    EquipmentDef* def = [[EquipmentConfig share]getEquipmentDefWithKey:[self equipTId]];
    return [def equipDesc];
}
-(NSNumber*)getEquipDefSlot
{
    EquipmentDef* def = [[EquipmentConfig share]getEquipmentDefWithKey:[self equipTId]];
    return [NSNumber numberWithInteger:[def equipSlot]];
}
-(NSNumber*)getItemType
{
    EquipmentDef* def = [[EquipmentConfig share]getEquipmentDefWithKey:[self equipTId]];
    return [NSNumber numberWithInteger:[def itemType]];
}
-(NSNumber*)getSellPrice
{
    NSNumber* price = [[ConstantsConfig share] getEquipSellPriceWithStar:[self equipStar]];
    return price;
}

-(NSNumber*)getMainAttributeTotalExp
{
    NSNumber* totalExp = [[self mainAttri] getTotalExp:[self equipStar]];
    return totalExp;
}
-(NSNumber*)getMainAttributeBaseExp
{
    EquipmentDef* def = [[EquipmentConfig share]getEquipmentDefWithKey:[self equipTId]];
    return [NSNumber numberWithInteger:[def basicExp]];
}
-(NSNumber*)getMainAttributeRatio
{
    return [[self mainAttri] getRatio];
}
-(NSNumber*)getMainAttributeMaxExp
{
    NSNumber* maxExp = [[self mainAttri] getMaxExp:[self equipStar]];
    return maxExp;
}

-(NSNumber*)getGodAttributeMaxExp
{
    NSNumber* maxExp = [[self godAttri] getMaxExp:[self equipStar]];
    return maxExp;
}


-(void)changeEquipSlotFromDef
{
    EquipmentDef* def = [[EquipmentConfig share]getEquipmentDefWithKey:[self equipTId]];
    self.equipSlot = [NSNumber numberWithInteger:[def equipSlot]];
}

#pragma mark - This function is public.For EquipInfoView Use
-(NSString *)mainAttriInfoString
{
    return [NSString stringWithFormat:@" +%@\n", self.mainAttri.attriValue];
}
-(NSString *)subAttriInfoString
{
    NSMutableString *tempString = [[NSMutableString alloc]init];
    for (AttributeData *attri in self.subAttri)
    {
        NSString *stringDesc = [NSString stringWithFormat:@" +%@\n", attri.attriValue];
        [tempString appendString:stringDesc];
    }
    return tempString;
}
@end
