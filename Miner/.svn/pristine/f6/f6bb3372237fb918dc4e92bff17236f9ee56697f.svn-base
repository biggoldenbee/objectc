//
//  BattleAnimationHpChange.m
//  Miner
//
//  Created by jim kaden on 15/1/6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BattleAnimationHpChange.h"
#import "AttributeString.h"
#import "BattleAnimationSkillBoard.h"
@implementation BattleAnimationHpChange

+(BattleAnimationHpChange*)create:(id)owner hp:(int)hp critical:(BOOL)critical
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleAnimationHpChange" owner:owner options:nil];
    BattleAnimationHpChange* view = (BattleAnimationHpChange*)[array objectAtIndex:0];
    [view setHp:hp critical:critical];
    return view;
}

-(void)setHp:(int)hp critical:(BOOL)critical
{
    NSString* hpText = nil;
    UIColor* color = nil;
    int fontSize = 25/2;
    if ( hp > 0 )
    {
        hpText = [NSString stringWithFormat:@"+%d", hp];
        color = [UIColor colorWithRed:6/255.0 green:254/255.0 blue:6/255.0 alpha:1.0f];
    }
    else
    {
        hpText = [NSString stringWithFormat:@"-%d", -hp];
        if ( critical )
        {
            color = [UIColor colorWithRed:253.0/255.0 green:110 / 255.0 blue:0 alpha:1.0f];
            fontSize = 30/2;
        }
        else
            color = [UIColor colorWithRed:254.0/255.0 green:0 blue:0 alpha:1.0f];
    }
    
    NSAttributedString* string = [AttributeString stringWithString:hpText
                                                          fontSize:fontSize
                                                          fontBold:YES
                                                   foregroundColor:color
                                                       strokeColor:[UIColor blackColor]
                                                        strokeSize:-4];
    self.labelHp.attributedText = string;
    self.labelHp.stroke = YES;
    //self.labelHp.transform = CGAffineTransformMakeScale(2, 2);
}

@end
