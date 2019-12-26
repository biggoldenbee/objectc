//
//  BattleAnimationBuffIcon.m
//  Miner
//
//  Created by jim kaden on 15/1/6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BattleAnimationBuffIcon.h"
#import "GameUtility.h"
#import "BuffConfig.h"

@implementation BattleAnimationBuffIcon

+(BattleAnimationBuffIcon*)create:(UIView*)owner buff:(int)buff buffLv:(int)lv
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleAnimationBuffIcon" owner:owner options:nil];
    BattleAnimationBuffIcon* view = (BattleAnimationBuffIcon*)[array objectAtIndex:0];
    [view setBuff:buff withLv:lv];
    return view;
}

-(void)setBuff:(int)buff withLv:(int)lv
{
    BuffBase* bb = [[BuffConfig share] getBuffBaseWithTId:[NSNumber numberWithInt:buff] withLevel:[NSNumber numberWithInt:lv]];
    if ( bb == nil )
        return;
    self.imageIcon.image = [GameUtility imageNamed:bb.buffIcon];
    _buffID = buff;
    _buffLV = lv;
    _count = (int)bb.buffLast;
    [self refresh];
}

-(int)changeCount:(int)cnt
{
    _count += cnt;
    if ( _count < 0 )
        _count = 0;
    [self refresh];
    return _count;
}

-(void)resetCount
{
    BuffBase* bb = [[BuffConfig share] getBuffBaseWithTId:[NSNumber numberWithInt:_buffID] withLevel:[NSNumber numberWithInt:_buffLV]];
    if ( bb == nil )
        return;
    _count = (int)bb.buffLast;
    [self refresh];
}

-(void)clearCount
{
    _count = 0;
}


-(void)refresh
{
    self.labelCount.text = [NSString stringWithFormat:@"%d", _count];
}

@end
