//
//  BattleManager.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-3.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "BattleManager.h"
#import "BattleData.h"
#import "BattlePlayer.h"

#import "CommonDef.h"
#import "PackageManager.h"
//#import "GameObject.h"

@interface BattleManager ()

@property (nonatomic, assign) BOOL isRequest;
@end

@implementation BattleManager
static BattleManager *theGlobalBattleManager = nil;

+(BattleManager *)sharedInstance
{
    if (theGlobalBattleManager == nil)
    {
        static dispatch_once_t onceBattleManager = 0;
        dispatch_once(&onceBattleManager, ^{ theGlobalBattleManager = [[BattleManager alloc]initInstance]; });
    }
    return theGlobalBattleManager;
}

//
// 初始化
//
-(id)initInstance
{
    self = [super init];
    if (self != nil)
    {
        self.isRequest = NO;
        self.battleDatas = [[NSMutableArray alloc]init];
        self.battlePlayer = [[BattlePlayer alloc]init];
    }
    return self;
}

#pragma mark - 战斗等待的处理
-(void)setLeftTime:(NSNumber *)second
{
    if ([self.battleDatas count] != 0)
    {
        BattleDetail* lastDetail = [self.battleDatas lastObject];
        if (lastDetail.leftTime > 0)
        {
            return;
        }
    }
    
    NSMutableDictionary *temDict = [[NSMutableDictionary alloc]init];
    [temDict setObject:second forKey:@"Secs"];
    
    BattleDetail *detail = [[BattleDetail alloc]init];
    [detail setDataWithDictionary:temDict];
    
    [self.battleDatas addObject:detail];
}

#pragma mark - 战斗详情的处理
-(void)setDetailWithDictionary:(NSDictionary *)data
{
//    [self OleBattleParse:data];
    
    [self NewBattleParse:data];
}

-(void)NewBattleParse:(NSDictionary *)data
{
    BattleDetail *detail = [[BattleDetail alloc]init];
    [detail setDataWithDictionary:data];
    
    [self.battleDatas addObject:detail];
}

#pragma mark - 战斗简报的处理
-(void)setBriefWithDictionary:(NSDictionary *)data
{
    NSMutableDictionary *temDict = [[NSMutableDictionary alloc]init];
    [temDict setObject:data forKey:@"Brief"];
    
    BattleDetail *detail = [[BattleDetail alloc]init];
    [detail setDataWithDictionary:temDict];
    
    [self.battleDatas addObject:detail];
}

#pragma mark - 给 BattlePlayer 调用的方法
-(BattleDetail*)getFirstBattleDetailInArray
{
    
    
    if ([self.battleDatas count] == 0 )
    {
        [[PackageManager sharedInstance]battleInfoRequest];
//        if (!self.isRequest)
//        {
//            [[PackageManager sharedInstance]battleInfoRequest];
//            self.isRequest = YES;
//        }
        return nil;
    }
    else
    {
        BattleDetail* battleDetail = [self.battleDatas firstObject];
        [self.battleDatas removeObject:battleDetail];
        self.isRequest = NO;
        return battleDetail;
    }
    
    return nil;
}

-(void)playerWithTarget:(BRIEF_TYPE)type data:(id)data
{
    [self.battlePlayer playerWithTarget:type data:data];
}
@end
