//
//  BattleAnimationHpChange.h
//  Miner
//
//  Created by jim kaden on 15/1/6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UILabelEx;

@interface BattleAnimationHpChange : UIView
{}
@property (weak) IBOutlet UILabelEx* labelHp;
+(BattleAnimationHpChange*)create:(UIView*)owner hp:(int)hp critical:(BOOL)critical;
@end
