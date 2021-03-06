//
//  CommonDef.h
//  Miner
//
//  Created by jim kaden on 14/10/23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#ifndef Miner_CommonDef_h
#define Miner_CommonDef_h

#import "ErrorCode.h"
//#import "ViewNotifiDef.h"
//#import "NetNotifiDef.h"
//#import "EventNotifDef.h"

#ifdef DEBUG
#define SafeNSLog NSLog
#define SafeAssert NSAssert
#else
#define SafeNSLog(...) (void)(...)
#define SafeAssert(...)  (void)(...)
#endif

#define kErrorDomain         @"error.domain"
#define kErrorInfo           @"error.info"

#define kED_Auth             @"auth.passport"
#define kED_Game             @"game.socket"


#define kNet_Max_Retry_Count            10
#define kNet_ShowBusy_TimeOut           1
#define kNet_TimeOut                    10
// notification


#define kNotif_Auth_StartGame           @"com.haypi.miner.auth.startgame"
#define kNotif_Auth_StartHud            @"com.haypi.miner.auth.starthud"
#define kNotif_Auth_StopHud             @"com.haypi.miner.auth.stopthud"

#define kNotif_Net_State                @"com.haypi.miner.net.state"
#define kNotif_Net_Error                @"com.haypi.miner.net.error"
#define kNotif_Net_Closed               @"com.haypi.miner.net.closed"
#define kNotif_Net_ForceClosed          @"com.haypi.miner.net.forceclosed"
#define kNotif_Net_UserLoggin           @"com.haypi.miner.net.userloggin"

#define kACTION_CODE_VERSION            4001    // 版本核对          请求
#define kACTION_CODE_CONFIG             4002    // 获取配置          请求
#define kACTION_CODE_USERINFO           5001    // 获取用户信息       请求
#define kACTION_CODE_LADDERINFO         5002    // 获取天梯信息       请求
#define kACTION_CODE_RELATIONINFO       5003    // 获取上下级信息     请求
#define kACTION_CODE_REWARDINFO         5004    // 获取奖励信息       请求
#define kACTION_CODE_TRADE              5005    // 获取交易列表       请求
#define kACTION_CODE_SELFTRADE          5006    // 获取玩家挂出的物品  请求
#define kACTION_CODE_VOTEINFO           5007    // 获取最近一期选举信息请求
#define kACTION_CODE_REWARD             5051    // 领取奖励          请求
#define kACTION_CODE_ADD_PREHOME        5101    // 设置上家          请求
#define kACTION_CODE_DEL_NEXTHOME       5102    // 删除下家          请求
#define kACTION_CODE_AUCTION            5151    // 拍卖物品          请求
#define kACTION_CODE_BUYAUCTION         5152    // 购买拍卖物品       请求
#define kACTION_CODE_QUERYAUCTION       5153    // 查询成交记录       请求
#define kACTION_CODE_QUERYPRICE         5154    // 查询物品价格       请求
//#define 
#define kACTION_CODE_BATTLEINFO         6001    // 获取战斗信息       请求
#define kACTION_CODE_QUICKBATTLE        6002    // 获取快速战斗信息    请求
#define kACTION_CODE_BOSS               6004    // 挑战BOSS          请求
#define kACTION_CODE_ATHLETICS          6005    // 竞技战斗          请求
#define kACTION_CODE_BATTLESETTING      6006    // 战斗设置          请求
#define kACTION_CODE_CHANGEMAP          6007    // 设置挂机地图       请求
#define kACTION_CODE_CHANGEPET          6008    // 设置宠物出战       请求
#define kACTION_CODE_CHANGESKILL        6009    // 设置技能          请求
#define kACTION_CODE_LADDER             6010    // 天梯挑战          请求
#define kACTION_CODE_SWEEP              6011    // 扫荡             请求
#define kACTION_CODE_UPGRADESKILL       6012    // 升级技能          请求
#define kACTION_CODE_CHANGEEQUIP        7001    // 更换装备          请求
#define kACTION_CODE_UPGRADEMAINATTRI   7002    // 升级装备主属性      请求
#define kACTION_CODE_UPGRADESUBATTRI    7003    // 升级装备副属性      请求
#define kACTION_CODE_UNLOADEQUIP        7004    // 卸载装备          请求
#define kACTION_CODE_STOREQUERYGOODS    7501    // 查看商店物品       请求
#define kACTION_CODE_STOREBUYGOODS      7502    // 购买商店物品       请求
#define kACTION_CODE_STOREREFRESHGOODS  7503    // 刷新商店物品       请求
#define kACTION_CODE_EXPANDBAG          8001    // 扩展背包          请求
#define kACTION_CODE_SELLFROMBAG        8002    // 出售背包内物品      请求
#define kACTION_CODE_USINGOROPEN        8003    // 使用或者打开       请求
//#define kACTION_CODE_BOSS               6004
//#define kACTION_CODE_BOSS               6004
#endif
