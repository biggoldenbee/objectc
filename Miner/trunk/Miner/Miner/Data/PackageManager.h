//
//  PackageManager.h
//  testMiner
//
//  Created by zhihua.qian on 14-11-21.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageManager : NSObject
+(PackageManager*)sharedInstance;

@property (nonatomic, assign) NSInteger downloadFilesCounter;   // 下载配置文件计数器


-(void)versionsRequest;
-(void)configRequest:(NSDictionary*)params;
-(void)userInfoRequest;
-(void)ladderInfoRequest;
-(void)relationInfoRequest;
-(void)rewardInfoRequest;
-(void)tradeRequest:(NSDictionary*)params;
-(void)tradeBySelfRequest;
-(void)rewardRequest:(NSDictionary*)params;
-(void)addPreHomeRequest:(NSDictionary*)params;
-(void)delNextHomeRequest;
-(void)auctionRequest:(NSDictionary*)params;
-(void)buyFromAuctionRequest:(NSDictionary*)params;
-(void)queryFromAuctionRequest:(NSDictionary*)params;
-(void)queryItemPriceRequest:(NSDictionary*)params;
-(void)battleInfoRequest;
-(void)quickBattleRequest:(NSDictionary*)params;
-(void)bossRequest:(NSDictionary*)params;
-(void)athleticsRequest:(NSDictionary*)params;
-(void)battleSettingRequest:(NSDictionary*)params;
-(void)changeMapRequest:(NSDictionary*)params;
-(void)changePetRequest:(NSDictionary*)params;
-(void)changeSkillRequest:(NSDictionary*)params;
-(void)ladderRequest:(NSDictionary*)params;
-(void)sweepRequest:(NSDictionary*)params;
-(void)upgradeSkillRequest:(NSDictionary*)params;
-(void)changeEquipRequest:(NSDictionary*)params;
-(void)upgradeEquipMainAttriRequest:(NSDictionary*)params;
-(void)upgradeEquipSubAttriRequest:(NSDictionary*)params;
-(void)unloadEquipRequest:(NSDictionary*)params;
-(void)upgradeEquipGodAttriRequest:(NSDictionary*)params;
-(void)expandBagRequest;
-(void)sellItemOrEquipFromBagRequest:(NSDictionary*)params;
-(void)usedItemOrOpenChestRequest:(NSDictionary*)params;

-(void)storeQueryGoods:(NSDictionary*)params;
-(void)storeBuyGoods:(NSDictionary*)params;
-(void)storeRefreshGoods:(NSDictionary*)params;

@end
