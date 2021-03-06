//
//  BattlePlayer.h
//  Miner
//  2014-12-25, 根据策划要求，每次播放一个subaction改为每次播放一个action
//  Created by zhihua.qian on 14-11-29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleData.h"

@class BattleLog;

typedef enum
{
    BT_none,
    BT_battle,
    BT_mine,
    BT_openbox,
}
BATTLE_TYPR;


@protocol BattleEvent <NSObject>

@optional
-(void) preparingBattle:(int)seconds;
-(void) stopPreparingCounting;
-(void) setActorsWithArray:(NSArray *)actors;   // 显示战斗人员
-(void) playerWithAction:(BattleAction *)action;   // 播放战斗过程
-(void) playerWithMine:(BattleMine *)mine;      // 播放挖矿过程
-(void) playerWithBrief:(BattleBrief *)brief;   // 播放结果
-(void) playerWithSubAction:(BattleSubAction *)subAction;   // 播放战斗过程
-(void) playerWithTarget:(BRIEF_TYPE)type data:(id)data;    // 即将挑战某某某
@end


@interface BattlePlayer : NSObject
{
    NSMutableArray* _array;
}

@property (nonatomic, strong) BattleDetail *currentDetail;
@property (nonatomic, assign) BATTLE_TYPR   battleType;

@property (nonatomic, strong) NSTimer *battleActionTimer;
@property (nonatomic, strong) NSTimer *battleSubActionTimer;

-(void)createActionTimer;   // 创建计时器
-(void)pauseActionTimer;    // 暂停
-(void)resumeActionTimer;   // 继续
-(void)resumeActionTimerLeftTimeOver;
-(void)registerEventPlayer:(NSObject<BattleEvent>*) delegates;
-(void) playerWithTarget:(BRIEF_TYPE)type data:(id)data;
@end
