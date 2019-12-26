//
//  BattleLog.m
//  Miner
//
//  Created by zhihua.qian on 14-12-8.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattleLog.h"
#import "BattleData.h"
#import "AttributeString.h"

#import "CommonDef.h"
//#import "GameNotification.h"
#import "GameUI.h"

@implementation BattleLog
static BattleLog *theGlobalBattleLog = nil;

+(BattleLog *)sharedInstance
{
    if (theGlobalBattleLog == nil)
    {
        static dispatch_once_t onceBattleLog = 0;
        dispatch_once(&onceBattleLog, ^{ theGlobalBattleLog = [[BattleLog alloc]initInstance]; });
    }
    return theGlobalBattleLog;
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
    for (BattleActor *actor in actors)
    {
        if (actor.ally == 0)
        {
            AttributeString *attiString = [[AttributeString alloc]initWithActor:actor];
            [self sendNotification:[attiString attrString]];
        }
    }
}

-(void) playerWithSubAction:(BattleSubAction *)subAction
{
    if (subAction == nil)
    {
        return;
    }
    AttributeString *attiString = [[AttributeString alloc]initWithSubAction:subAction];
    if (attiString == nil)
    {
        NSLog(@"AttributeString is nil in playerWithSubAction");
        return;
    }
    
    [self sendNotification:[attiString attrString]];
}

-(void) playerWithMine:(BattleMine *)mine
{
    AttributeString *attiString = [[AttributeString alloc]initWithMine:mine];
    if (attiString == nil)
    {
        NSLog(@"AttributeString is nil in playerWithMine");
        return;
    }
    [self sendNotification:[attiString attrString]];
}

-(void) playerWithBrief:(BattleBrief *)brief
{
    AttributeString *attiString = [[AttributeString alloc]initWithBrief:brief];
    if (attiString == nil)
    {
        NSLog(@"AttributeString is nil in playerWithMine");
        return;
    }
    for (NSAttributedString* tempAttriString in [attiString results])
    {
        [self sendNotification:tempAttriString];
    }
    
    if ([attiString.results count] > 1) // 多条的时候  设置成胜利
    {
        [[GameUI sharedInstance] updateMineView];
//        [[[GameNotification sharedInstance] viewNotificationCenter]postNotificationName:kNotif_View_Mine_Update object:nil];
    }
}

-(void) sendNotification:(NSAttributedString *)string
{
    NSArray  *tempArray = [[NSArray alloc]initWithObjects:string, nil];
    [[GameUI sharedInstance] updateBattleMineView:tempArray];
//    [[[GameNotification sharedInstance] viewNotificationCenter] postNotificationName:kNotif_View_Mine_Battle_Update object:tempArray];
}
@end
