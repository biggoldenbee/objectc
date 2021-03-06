//
//  MineViewController.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-2.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "BaseViewController.h"
//#import "BattleLog.h"
#import "BattlePlayer.h"
@class Hero;

@interface MineViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, BattleEvent>

@property (nonatomic, strong) NSMutableArray *messageArray; // 存放的是attributestring

@property (nonatomic, weak) Hero *player;
@property (nonatomic, strong) NSDate* leftTime;

-(void)setAllControllersData;

-(void)updateViewControllers;
-(void)updateNextBattleTime:(NSArray*)params;
-(void)updateBattleAnimation;
-(void)updateBattleLog:(NSArray *)arrayOfLog;
@end
