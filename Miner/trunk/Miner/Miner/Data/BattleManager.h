//
//  BattleManager.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-3.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BattleData.h"

@class BattleDetail;
@class BattlePlayer;

@interface BattleManager : NSObject

+(BattleManager*)sharedInstance;

@property (nonatomic, strong) NSMutableArray *battleDatas;
@property (nonatomic, strong) BattlePlayer  *battlePlayer;

-(void)setLeftTime:(NSNumber *)leftTime;

-(void)setDetailWithDictionary:(NSDictionary *)data;    // 设置战斗详情
-(void)setBriefWithDictionary:(NSDictionary *)data;     // 设置简报信息

-(BattleDetail*)getFirstBattleDetailInArray;
-(void)playerWithTarget:(BRIEF_TYPE)type data:(id)data;
@end
