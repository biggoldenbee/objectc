//
//  QQIconAndStringViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-30.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "QQIconAndStringView.h"

#define Default_Width   61
#define Default_Height  13

@interface QQIconAndStringView ()

@end

@implementation QQIconAndStringView
-(void)setDataForControllers:(IconAndString_Type)type numData:(NSNumber*)num
{
    [self setBounds:CGRectMake(0, 0, Default_Width, Default_Height)];
    
    UIImageView* iconView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Default_Height, Default_Height)];
    [self addSubview:iconView];
    NSString* iconName = [self getIconNameWithType:type];
    if (iconName == nil)
    {
        NSLog(@"没有找到需要的icon");
        return;
    }
    UIImage* icon = [UIImage imageNamed:iconName];
    [iconView setImage:icon];
    
    // ****************************************************************
    
    UILabel* label = [[UILabel alloc]init];
    [self addSubview:label];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    NSString* labelString = [self convertNumberToString:num];
    [label setText:labelString];
}

-(NSString*)getIconNameWithType:(IconAndString_Type)type
{
    switch (type)
    {
        case Money_Type:
            return TYPE_MONEY_ICON;
            break;
        case TiCoin_Type:
            return TYPE_TICOIN_ICON;
            break;
        case Diamond_Type:
            return TYPE_DIAMOND_ICON;
            break;
        default:
            return nil;
            break;
    }
}

-(NSString*)convertNumberToString:(NSNumber*)num
{
    NSString* tempString = [num stringValue];
    
    
    return tempString;
}
@end
