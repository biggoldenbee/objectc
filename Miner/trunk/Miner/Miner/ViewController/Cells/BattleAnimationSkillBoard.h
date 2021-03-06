//
//  BattleAnimationSkillBoard.h
//  Miner
//
//  Created by jim kaden on 15/1/6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabelEx : UILabel
@property (assign) BOOL stroke;
@property (strong) UIColor* strokeColor;
@property (assign) float strokeSize;
@end

@interface BattleAnimationSkillBoard : UIView
@property (weak) IBOutlet UILabelEx* labelName;
@property (weak) IBOutlet UIImageView* imageIcon;
+(BattleAnimationSkillBoard*)create:(UIView*)owner skill:(int)skill withLv:(int)lv;
@end
