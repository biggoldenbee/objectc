//
//  GameUtility.h
//  Miner
//
//  Created by jim kaden on 14/10/29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SortParam : NSObject

@property (nonatomic, strong) NSString* paramName;
@property (nonatomic, assign) BOOL ascending;

@end

@interface GameUtility : NSObject

+(NSString*)getImageNameForEquipViewWithType:(int)type;
+(NSString*)getImageNameForEquipStrengthenWithStar:(int)star;
+(NSString*)getImageNameForBagOrSelectViewWithStar:(int)star;
+(NSString*)getImageNameForAtrribute:(int)attriId;

+(UIImage*)imageNamed:(NSString*)name;          // 类方法：图片名字
+(NSString*)localizedString:(NSString*)string;  // 类方法：本地化的字符串

+(UIColor*)getColorWithStar:(int)star;          // 获得五星的颜色
+(UIColor*)getColorWithLv:(int)level;

+(UIFont*)getNormalFont:(float)size;              // 获得普通字体
+(UIFont*)getBoldFont:(float)size;                // 获得黑体字体
+(UIFont*)getFont:(float)size fontName:(NSString*)fontName;              // 获得字体

+(NSArray*)array:(NSArray*)willSortArray sortArrayWithParams:(NSDictionary*)paramDict;

// 用于属性计算
+(float)scaleAttributeVlaue:(NSNumber*)attriVal targetLv:(NSNumber*)level;
@end
