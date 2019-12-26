//
//  BattleAnimationView.h
//  Miner
//
//  Created by jim kaden on 14/12/29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BattleData.h"
#import "BattlePlayer.h"
#import "HpCharaInst.h"
#import "BattleActorView.h"

@class AnimationSequence;

@interface BattleAnimationView : UIView<BattleEvent, SequenceDelegate>
{
    AnimationSequence* _currentSequence;
}
-(void)setNewFrame:(CGRect)frame;
+(BattleAnimationView*)create:(id)owner;
@end

