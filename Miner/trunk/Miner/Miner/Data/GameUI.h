//
//  GameUI.h
//  Miner
//  处理一些通用UI，调度等
//  Created by jim kaden on 14/10/28.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//
//  PS：管理所有的view.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "WaitingViewController.h"

@class LoginViewController;

@interface GameUI : NSObject
{
    signed int _waitingCount;   // 等待次数
//    WaitingViewController* _waitingVC;
}

//-(void)showWaiting:(NSString*)progress;
//-(void)hideWaiting;

-(void)showError:(NSString*)error title:(NSString*)title;           // 显示错误
-(void)showError:(int)errorCode extraInfo:(NSString *)extraInfo;    // 显示错误

+(GameUI*)sharedInstance;

/*
 设置LoginViewController，因为它是在storybroad中，会早于GameUI生成
 */
+(void)setLoginViewController:(LoginViewController *)viewController;
-(void)initAllViewControllers;  // 初始化所有View Controller（注意：他们内部的控件还没有被生成）

#pragma mark - 大厅有关的操作
-(void)showHallView;
-(void)updateHallView;

#pragma mark - 港口有关的操作
-(void)showPortView;

#pragma mark - 挖矿挂机有关的操作
-(void)showMineView;
-(void)updateMineView;
-(void)updateBattleMineView:(NSArray*)data;
-(void)nextBattleMineView:(NSArray*)params;

#pragma mark -- 战斗有关的操作
-(void)showBriefView:(NSDictionary*)params;

#pragma mark -- 地图有关的操作
-(void)showStageView;
-(void)showStageInfoView:(NSNumber*)mapId;
-(void)updateTheStageInfoView;
-(void)closeTheStageInfoView;

#pragma mark -- 装备有关的操作
-(void)showEquipView;
-(void)updateEquipView;

-(void)showEquipInfoView:(NSDictionary*)params;
-(void)updateEquipInfoView;
-(void)closeEquipInfoView;

-(void)showEquipMainView:(NSDictionary*)params;
-(void)updateEquipMainAttribute:(NSNumber*)equipId;

-(void)showEquipSubView:(NSDictionary*)params;
-(void)updateEquipSubAttribute:(NSNumber*)equipId;

-(void)showEquipGodView:(NSDictionary*)params;
-(void)updateEquipGodAttribute:(NSNumber*)equipId;

-(void)showEquipChangeView:(NSDictionary*)params;
-(void)updateEquipChangeView:(NSDictionary*)data;
-(void)closeTheEquipChangeView;

-(void)showEquipSelectView:(NSDictionary*)params;

-(void)EquipSelectToEquipMain:(NSArray*)data;
-(void)changeEquipListInSelectView:(NSNumber*)equipId option:(BOOL)isAdd;

#pragma mark -- 技能有关的操作
-(void)showSkillView;
-(void)updateSkillView;

-(void)showPetView;
-(void)updatePetView;
-(void)updatePetActiveBtnController;

#pragma mark - 商店有关的操作
-(void)setStoreView:(NSDictionary*)data;
-(void)showStoreView;

#pragma mark - 新闻有关的操作
-(void)showNewsView;

#pragma mark - 背包有关的操作
-(void)showPackView;
-(void)showBlukSellView;
-(void)showFilterView;
-(void)showPropInfoView:(NSDictionary*)params;
-(void)closeThePropInfoView;
-(void)updateBagView;
-(void)updateBlukView;

#pragma mark - 设置有关的操作
-(void)showSetView;

@end
