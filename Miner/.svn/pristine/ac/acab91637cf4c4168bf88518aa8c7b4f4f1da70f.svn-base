//
//  BattleAnimationDodgeParry.m
//  Miner
//
//  Created by jim kaden on 15/1/26.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BattleAnimationCommonLabel.h"
#import "BattleAnimationSkillBoard.h"
#import "StringConfig.h"
#import "AttributeString.h"

@implementation BattleAnimationCommonLabel
+(BattleAnimationCommonLabel*)create:(id)owner dodge:(BOOL)dodge
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleAnimationCommonLabel" owner:owner options:nil];
    BattleAnimationCommonLabel* view = (BattleAnimationCommonLabel*)[array objectAtIndex:0];
    [view setup:dodge];
    return view;
}

+(BattleAnimationCommonLabel*)create:(id)owner
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleAnimationCommonLabel" owner:owner options:nil];
    BattleAnimationCommonLabel* view = (BattleAnimationCommonLabel*)[array objectAtIndex:0];
    return view;
}

-(void)setup:(BOOL)dodge
{
    NSString* text = nil;
    UIColor* color = nil;
    int fontSize = 20/2;
    if ( dodge )
    {
        text = [[StringConfig share] getLocalLanguage:@"ui_mine_battle_dodge"];
        color = [UIColor colorWithRed:254/255.0 green:181/255.0 blue:0/255.0 alpha:1.0f];
    }
    else
    {
        text = [[StringConfig share] getLocalLanguage:@"ui_mine_battle_parry"];
        color = [UIColor colorWithRed:254/255.0 green:181/255.0 blue:0/255.0 alpha:1.0f];
    }
    
    NSAttributedString* string = [AttributeString stringWithString:text
                                                          fontSize:fontSize
                                                          fontBold:YES
                                                   foregroundColor:color
                                                       strokeColor:[UIColor blackColor]
                                                        strokeSize:-1];
    [self setupLabel:string stroke:YES];
}

-(void)setupLabel:(NSAttributedString*)string stroke:(BOOL)stroke
{
    self.labelName.attributedText = string;
    self.labelName.stroke = stroke;
    
    CGSize constraint = CGSizeMake(20000.0f , 20000.0f);
    CGRect rect = [string boundingRectWithSize:constraint
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                       context:nil];
    CGRect f = self.frame;
    f.size.width = rect.size.width + 10;
    f.size.height = rect.size.height;
    self.frame = f;
    self.labelName.frame = f;
    [self setNeedsDisplay];
}

@end
