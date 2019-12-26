//
//  BattlePlayer.m
//  Miner
//
//  Created by zhihua.qian on 14-11-29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattlePlayer.h"
#import "BattleManager.h"
#import "BattleLog.h"

#import "CommonDef.h"
//#import "GameNotification.h"
#import "GameUI.h"

/*
 这是处理每一场战斗的类。唯一
 
 处理流程：
    1）获取战斗信息
    2）解析战斗数据
    3) 准备战斗。也就是战前准备：人物，血量等
    3）利用NSTimer做循环发送（每循环 1 s）
        a. 结算自生的dot和hot。---------------这条是需要动画的
        b. 自身行为（攻击，跳过），附带伤害。-----这条是需要log出来的，并动画的
        c. 处理立即生效的buff。----------------这条是需要动画的
        d. 更新所有buff回合数。----------------这条是需要动画的
    对于本类的发送，都是一个subAction对象，简单吧！！！！！（给金大大一个赞）
 PS：如果有多个自身行为（即：b）,分享这个人员的一回合播放时间。
 */

@interface BattlePlayer ()

@property (nonatomic, assign) float playerSpeed;
@property (nonatomic, retain) NSArray *mines;
@property (nonatomic, retain) NSArray *actions;
@property (nonatomic, retain) BattleBrief *brief;

@property (nonatomic, retain) BattleMine *currentMine;      // 当前mine
@property (nonatomic, assign) int nMineCounter;             // 当前mine的下标

@property (nonatomic, retain) BattleAction *currentAction;  // 当前action
@property (nonatomic, assign) int nActionCounter;           // 当前action的下标
@property (nonatomic, retain) BattleSubAction *currentSubAction;    // 当前subaction
@property (nonatomic, assign) int nSubActionCounter;        // 当前subaction的下标

@property (nonatomic, assign) BRIEF_TYPE nextTarget;
@property (nonatomic, strong) id nextTargetData;
@property (assign) BOOL playingBattleLog;
@end

@implementation BattlePlayer

-(id)init
{
    self = [super init];
    if (self)
    {
        [self initPlayingSpeed:2.0];
        
//        self.battleAnimation = [BattleAnimation sharedInstance];
//        self.battleLog = [BattleLog sharedInstance];
        self.nMineCounter = 0;
        self.nActionCounter = 0;
        self.playingBattleLog = NO;
        self.nextTarget = NormalBattle;
        self.nextTargetData = [NSNumber numberWithInt:0];
        _array = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotif:) name:@"com.haypi.miner.battle.next" object:nil];
    }
    return self;
}

-(void)registerEventPlayer:(NSObject<BattleEvent>*) delegate
{
    if ( [_array containsObject:delegate] )
        return;
    [_array addObject:delegate];
}

-(void)initPlayingSpeed:(float)speed
{
    self.playerSpeed = speed;
}

#pragma mark - 计时器控制函数
-(void)createActionTimer
{
    self.battleActionTimer = [NSTimer scheduledTimerWithTimeInterval:self.playerSpeed target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    
}

-(void)pauseActionTimer
{
    if (![self.battleActionTimer isValid])
    {
        return ;
    }
    [self.battleActionTimer setFireDate:[NSDate distantFuture]];

}

-(void)resumeActionTimer
{
    if (![self.battleActionTimer isValid])
    {
        return ;
    }
    
    [self.battleActionTimer setFireDate:[NSDate date]];
    
}

-(void)resumeActionTimerLeftTimeOver
{
    self.currentDetail =nil;
    [self resumeActionTimer];
}


#pragma mark - 处理计时器函数
-(void)handleTimer:(NSTimer*)timer
{
    [self handleNextTarget];
    if (self.currentDetail == nil)
    {
        self.currentDetail = [[BattleManager sharedInstance] getFirstBattleDetailInArray];
        if (self.currentDetail == nil)
        {
            return;
        }
        
        BOOL bRet = [self parseCurrentDetail];
        if (bRet == NO)
            return;
    }
    else
    {
        /*
        if (self.battleType == BT_battle)
        {
            [self handleBattleAction];  // 每一秒调用一次action
        }
        else if (self.battleType == BT_mine)
        {
            [self handleBattleMine];    // 每一秒调用一次mine
        }*/
        //[self onNotif:nil];
    }
}

-(void)handleCountingTimer:(NSTimer*)timer
{
    NSDate* date = timer.userInfo;
    if ([date timeIntervalSinceNow] < 0 )
    {
        [self resumeActionTimerLeftTimeOver];
        [timer invalidate];
        for (NSObject<BattleEvent>* obj in _array)
        {
            if ( [obj respondsToSelector:@selector(stopPreparingCounting)] )
                [obj stopPreparingCounting];
        }
    }
}

-(void)onNotif:(NSNotification*)notif
{
    if ( self.currentDetail == nil )
        return;
    self.playingBattleLog = YES;
    if (self.battleType == BT_battle)
    {
        [self handleBattleAction];  // 每一秒调用一次action
    }
    else if (self.battleType == BT_mine)
    {
        [self handleBattleMine];    // 每一秒调用一次mine
    }
    else if ( self.battleType == BT_openbox )
    {
        [self handleBattleBrief];
    }
    else
        self.currentDetail = nil;
}

#pragma mark - 解析战斗数据
-(BOOL)parseCurrentDetail
{
    if ( self.currentDetail.leftTime > 0)
    {
        NSNumber* leftTime = [[NSNumber alloc]initWithInteger:self.currentDetail.leftTime];
//        NSArray *tempArr = [[NSArray alloc]initWithObjects:leftTime, nil];
//        [[GameUI sharedInstance] nextBattleMineView:tempArr];
        for (NSObject<BattleEvent>* obj in _array)
        {
            if ( [obj respondsToSelector:@selector(preparingBattle:)] )
                [obj preparingBattle:leftTime.intValue];
        }
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                       selector:@selector(handleCountingTimer:)
                                       userInfo:[NSDate dateWithTimeIntervalSinceNow:[leftTime integerValue]]
                                        repeats:YES];
        [self pauseActionTimer];
        self.playingBattleLog = NO;
        return NO;
    }
    
    //if (self.currentDetail.mine == nil && self.currentDetail.actors == nil && self.currentDetail.actions == nil && self.currentDetail.brief != nil)
    if ( self.currentDetail.brief != nil && self.currentDetail.brief.type == MultiSettlement )
    {
        // 弹出战斗简报窗口
        NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:self.currentDetail.brief,@"Brief", nil];
        [[GameUI sharedInstance] showBriefView:tempDict];
        
        self.currentDetail = nil;
        self.playingBattleLog = YES;
        return NO;
    }
    


    //if (self.currentDetail.actions == nil || [self.currentDetail.actions count] == 0 || self.currentDetail.brief.type == MineBattle )
    if ( self.currentDetail.brief != nil && self.currentDetail.brief.type == MineBattle )
    {
        self.battleType = BT_mine;
        self.nMineCounter = 0;
        self.mines = self.currentDetail.mine;
    }
    if ( self.currentDetail.brief != nil && self.currentDetail.brief.type == OpenBoxBattle )
    {
        self.battleType = BT_openbox;
    }
    
    //if (self.currentDetail.mine == nil || [self.currentDetail.mine count] == 0)
    if ( self.currentDetail.brief != nil && ( self.currentDetail.brief.type == NormalBattle || self.currentDetail.brief.type == BossBattle || self.currentDetail.brief.type == BigBossBattle || self.currentDetail.brief.type == UserBattle || self.currentDetail.brief.type == LadderBattle || self.currentDetail.brief.type == LadderNPCBattle ) )
    {
        self.battleType = BT_battle;
        self.nActionCounter = 0;
        self.nSubActionCounter = 0;
        self.actions = self.currentDetail.actions;
    }
    
    self.brief = self.currentDetail.brief;
    
    for (NSObject<BattleEvent>* obj in _array)
    {
        [obj setActorsWithArray:self.currentDetail.actors];
    }
    self.playingBattleLog = YES;
    return  YES;
}

#pragma mark - 处理播放战斗信息
-(void)handleBattleAction
{
    if ( self.nActionCounter < [self.actions count] )
    {
        self.currentAction = [self.actions objectAtIndex:self.nActionCounter];
        
        for(NSObject<BattleEvent>* obj in _array)
        {
            [obj playerWithAction:self.currentAction];
        }
        
        self.nActionCounter++;  // 一个action结束
    }
    else if ( self.nActionCounter == [self.actions count] )
    {
        [self handleBattleBrief];
    }
    else
    {
        self.currentDetail = nil;
    }
}

-(void)handlePerSubAction:(NSTimer*)timer
{
   
}

#pragma mark - 处理播放挖矿信息
-(void)handleBattleMine
{
    if ( self.nMineCounter < [self.mines count] )
    {
        self.currentMine = [self.mines objectAtIndex:self.nMineCounter];
        for(NSObject<BattleEvent>* obj in _array)
        {
            [obj playerWithMine:self.currentMine];
        }

        self.nMineCounter++;
    }
    else if ([self.mines count] == self.nMineCounter )
    {        
        [self handleBattleBrief];
    }
    else
    {
        self.currentDetail = nil;
    }
}

#pragma mark - 处理播发结果
-(void)handleBattleBrief
{
    for(NSObject<BattleEvent>* obj in _array)
    {
        [obj playerWithBrief:self.brief];
    }
    self.playingBattleLog = NO;
    self.battleType  = BT_none;
    //self.currentDetail = nil;
}

-(void) playerWithTarget:(BRIEF_TYPE)type data:(id)data
{
    self.nextTarget = type;
    self.nextTargetData = data;
    [self handleNextTarget];
}

-(void)handleNextTarget
{
    if ( self.playingBattleLog )
        return;
    if ( self.nextTargetData == nil )
        return;
    for(NSObject<BattleEvent>* obj in _array)
    {
        if ( [obj respondsToSelector:@selector(playerWithTarget:data:)] )
            [obj playerWithTarget:self.nextTarget data:self.nextTargetData];
    }
    self.nextTargetData = nil;
    self.nextTarget = NormalBattle;
}
@end
