//
//  BattleData.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-3.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BattleBrief;
/*
 BattleDetail
        |
        -------BattleBrief
        |
        -------BattleActor数组
        |
        -------BattleAction数组
        |               |
        |               --------BattleSubAction数组
        |
        -------BattleMine数组 
 */

//
// 战斗详情
//
@interface BattleDetail : NSObject
@property (atomic) BattleBrief* brief;
@property (atomic) NSArray* actors;
@property (atomic) NSArray* actions;
@property (atomic) NSArray* mine;
@property (assign) NSInteger leftTime;

-(void)setDataWithDictionary:(NSDictionary *)data;
@end


typedef enum
{
    MultiSettlement = -1,
    NormalBattle = 0,
    BossBattle = 1,
    UserBattle = 2,
    BigBossBattle = 3,
    MineBattle = 4,
    OpenBoxBattle = 5,
    LadderBattle = 6,
    LadderNPCBattle = 7,
}
BRIEF_TYPE;

#define isBattleBriefType(a) \
((a)== NormalBattle || (a) == BossBattle || (a) == UserBattle || (a) == BigBossBattle || (a) == LadderBattle || (a) == LadderNPCBattle )

//
// 简报
//
@interface BattleBrief : NSObject
@property (weak) BattleDetail* battle;
@property (assign) NSInteger type;
@property (assign) NSInteger map;
@property (assign) NSInteger cnt;
@property (assign) NSInteger time;
@property (assign) NSInteger win;
@property (assign) NSInteger mine;
@property (assign) NSInteger lost;
@property (assign) NSInteger mlost;
@property (assign) NSInteger run;
@property (assign) NSInteger exp;
@property (assign) NSInteger money;
@property (assign) NSInteger skillPoint;
@property (strong) NSDictionary* boxWon;
@property (strong) NSDictionary* boxFailed;
@property (atomic) NSArray* items;
@property (atomic) NSArray* equips;
@property (atomic) NSArray* boxs;
@property (atomic) NSArray* autoSells;
-(void)setDataWithDictionary:(NSDictionary *)data;
@end

//
// 战斗人员（玩家，宠物，怪物，boss）属性
//
@interface BattleActor : NSObject
@property (weak) BattleDetail* battle;
@property (assign) NSInteger ally;
@property (assign) NSInteger type;
@property (assign) NSInteger mid;
@property (assign) NSInteger level;
@property (assign) NSInteger hp;
@property (copy) NSString* icon;
@property (copy) NSString* name;
-(void)setDataWithDictionary:(NSDictionary *)data;
@end

//
// 战斗行为
//
@interface BattleAction : NSObject
@property (weak) BattleDetail* battle;
@property (assign) NSInteger A;
@property (assign) NSInteger type;
@property (assign) NSInteger sid;
@property (assign) NSInteger slv;
@property (assign) NSInteger turn;
@property (atomic) NSArray* subActions;
-(void)setDataWithDictionary:(NSDictionary *)data;
@end

//
// 战斗细节行为
//
@interface BattleSubAction : NSObject
@property (weak) BattleAction* action;
@property (assign) NSInteger B;
@property (assign) NSInteger type;
@property (assign) NSInteger value1;
@property (assign) NSInteger value2;
@property (assign) NSInteger value3;
-(void)setSubActionWithArray:(NSArray *)data;
@end

//
// 挖矿行为
//
@interface BattleMine : NSObject
@property (weak) BattleDetail* battle;
@property (assign) NSInteger A;
@property (assign) NSInteger mid;
@property (assign) NSInteger ret;
@end