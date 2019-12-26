//
//  GameUtility.m
//  Miner
//
//  Created by jim kaden on 14/10/29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "GameUtility.h"
#import <Foundation/Foundation.h>

@implementation SortParam
@end

@implementation GameUtility
static NSMutableDictionary* gFontsCache = nil;

+(UIImage*)imageNamed:(NSString*)name
{
    NSString* realname = name;
    if ( [name hasSuffix:@"png"] == false ) // 判断字符串是否以“png”结尾
        realname = [name stringByAppendingPathExtension:@"png"];
    UIImage* image = [UIImage imageNamed:name];
    if ( image == nil )
    {
        // 临时处理一下，有些代图是jpg的
        if ( [name hasSuffix:@"jpg"] == false )
            realname = [name stringByAppendingPathExtension:@"jpg"];
        image = [UIImage imageNamed:realname];
    }
    return image;
}

+(NSString*)localizedString:(NSString*)string
{
    return NSLocalizedString(string, string);
}

+(NSString*)getImageNameForEquipViewWithType:(int)type
{
    NSString* name = [NSString stringWithFormat:@"equ_icon_0%d", type];
    return name;
}

+(NSString*)getImageNameForEquipStrengthenWithStar:(int)star
{
    NSString* aid = @"";
    if (star < 10)
    {
        aid = [NSString stringWithFormat:@"0%d", star];
    }
    else
    {
        aid = [NSString stringWithFormat:@"%d", star];
    }
    NSString* name = [NSString stringWithFormat:@"base_propsframe3_%@", aid];
    return name;
}
+(NSString*)getImageNameForBagOrSelectViewWithStar:(int)star
{
    NSString* name = [NSString stringWithFormat:@"base_propsbar2_%d", star];
    return name;
}

+(NSString*)getImageNameForAtrribute:(int)attriId
{
    NSString* aid = @"";
    if (attriId < 10)
    {
        aid = [NSString stringWithFormat:@"0%d", attriId];
    }
    else
    {
        aid = [NSString stringWithFormat:@"%d", attriId];
    }
    NSString* name = [NSString stringWithFormat:@"attri_icon_%@", aid];
    return name;
}

+(UIColor*)getColorWithLv:(int)level
{
    /*
     白 195,196,196 1-10
     绿 0,184,82 11-20
     蓝59,186,255 21-40
     紫 255,0,255 41-70
     橙 255,162,0 71+
     */
    UIColor* colorLevel10 = [UIColor colorWithRed:195/255.0 green:196/255.0 blue:196.0/255.0f alpha:1.0];
    UIColor* colorLevel20 = [UIColor colorWithRed:0/255.0 green:184/255.0 blue:82/255.0f alpha:1.0];
    UIColor* colorLevel40 = [UIColor colorWithRed:59/255.0 green:186/255.0 blue:255/255.0f alpha:1.0];
    UIColor* colorLevel70 = [UIColor colorWithRed:255/255.0 green:0/255.0 blue:255/255.0f alpha:1.0];
    UIColor* colorLevel100 = [UIColor colorWithRed:255/255.0 green:162/255.0 blue:0/255.0f alpha:1.0];
    
    if( level <=1 )
        return colorLevel10;
    else if ( level <= 2 )
        return colorLevel20;
    else if ( level <= 4 )
        return colorLevel40;
    else if ( level <= 7 )
        return colorLevel70;
    else
        return colorLevel100;
}

+(UIColor*)getColorWithStar:(int)star
{
    switch (star)
    {
        case 1:
            return [UIColor lightGrayColor];
        case 2:
            return [UIColor greenColor];
        case 3:
        case 4:
            return [UIColor blueColor];
        case 5:
        case 6:
        case 7:
            return [UIColor purpleColor];
        case 8:
        case 9:
        case 10:
            return [UIColor orangeColor];
        default:
            return [UIColor darkGrayColor];
    }
}

// 参数 paramDict的格式 ： 序号 <-> 参数类
+(NSArray*)array:(NSArray*)willSortArray sortArrayWithParams:(NSDictionary*)paramDict
{
    NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
    for (int i=0; i<[paramDict count]; i++)
    {
        NSString* key = [NSString stringWithFormat:@"%d",i];
        SortParam* param = [paramDict objectForKey:key];
        NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:[param paramName] ascending:[param ascending]];
        [sortDescriptors addObject:descriptor];
    }
    
    return [willSortArray sortedArrayUsingDescriptors:sortDescriptors];
}

//  用于属性计算
+(float)scaleAttributeVlaue:(NSNumber*)attriVal targetLv:(NSNumber*)lv
{
    float rate = [attriVal floatValue] / ([attriVal floatValue] + 50 + 3 * [lv floatValue] * [lv floatValue] + 3 * [lv floatValue]);
    return rate;
}

+(UIFont*)getNormalFont:(float)size
{
#define NORMAL_FONT_NAME @"Arial"
    return [self getFont:size fontName:NORMAL_FONT_NAME];
}


+(UIFont*)getBoldFont:(float)size
{
#define BOLD_FONT_NAME @"Arial-BoldMT" //@"Verdana-Bold" //@"STHeitiSC-Medium" //
    return [self getFont:size fontName:BOLD_FONT_NAME];
}

+(UIFont*)getFont:(float)size fontName:(NSString*)fontName
{
    @synchronized(self)
    {
        if(gFontsCache)
            gFontsCache = [[NSMutableDictionary alloc]init];
        NSMutableDictionary* fonts = [gFontsCache objectForKey:fontName];
        if ( fonts == nil )
        {
            fonts = [[NSMutableDictionary alloc]init];
            [gFontsCache setObject:fonts forKey:fontName];
        }
        UIFont* fnt = [fonts objectForKey:[NSNumber numberWithFloat:size]];
        if ( fnt == nil )
        {
            fnt = [UIFont fontWithName:fontName size:size];
            [fonts setObject:fnt forKey:[NSNumber numberWithFloat:size]];
        }
        return fnt;
    }
}


@end
