//
//  BattleAnimationDodgeParry.h
//  Miner
//
//  Created by jim kaden on 15/1/26.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UILabelEx;

@interface BattleAnimationCommonLabel : UIView

+(BattleAnimationCommonLabel*)create:(UIView*)owner dodge:(BOOL)dodge;
+(BattleAnimationCommonLabel*)create:(UIView*)owner;

@property(weak) IBOutlet UILabelEx* labelName;

-(void)setupLabel:(NSAttributedString*)string stroke:(BOOL)stroke;

@end
