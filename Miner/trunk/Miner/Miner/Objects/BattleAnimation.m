//
//  BattleAnimation.m
//  Miner
//
//  Created by zhihua.qian on 14-11-29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattleAnimation.h"
#import "BattleData.h"

#import "CommonDef.h"
//#import "GameNotification.h"

@implementation BattleAnimation
static BattleAnimation *theGlobalBattleAnimation = nil;

+(BattleAnimation *)sharedInstance
{
    if (theGlobalBattleAnimation == nil)
    {
        static dispatch_once_t onceBattleAnimation = 0;
        dispatch_once(&onceBattleAnimation, ^{ theGlobalBattleAnimation = [[BattleAnimation alloc]initInstance]; });
    }
    return theGlobalBattleAnimation;
}

-(id)initInstance
{
    self = [super init];
    if (self)
    {

    }
    
    return self;
}

#pragma mark - implementation protocol function
-(void) setActorsWithArray:(NSArray *)actors
{
    for (BattleActor* actor in actors)
    {
        
    }
}

-(void) playerWithSubAction:(BattleSubAction *)subAction
{
//    AttributeString *attiString = [[AttributeString alloc]initWithSubAction:subAction];
    
}

-(void) playerWithMine:(BattleMine *)mine
{
    
}

-(void) playerWithBrief:(BattleBrief *)brief
{
}

-(void) sendNotification:(NSDictionary *)data
{
//    [[[GameNotification sharedInstance] viewNotificationCenter] postNotificationName:kNotif_View_Mine_Battle_Anima object:data];
}
@end
