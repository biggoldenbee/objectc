//
//  QQIconAndStringViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-12-30.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TYPE_MONEY_ICON         @"base_icon_10"
#define TYPE_TICOIN_ICON        @"base_icon_11"
#define TYPE_DIAMOND_ICON       @"base_icon_12"

typedef enum
{
    Money_Type,
    TiCoin_Type,
    Diamond_Type,
}
IconAndString_Type;

@interface QQIconAndStringView : UIView

@property (strong, nonatomic) UIImageView *typeIconImage;
@property (strong, nonatomic) UILabel *stringNumLabel;

-(void)setDataForControllers:(IconAndString_Type)type numData:(NSNumber*)num;
@end
