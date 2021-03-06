//
//  PackageManager.m
//  testMiner
//
//  Created by zhihua.qian on 14-11-21.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "PackageManager.h"
#import "CommonDef.h"
#import "NetManager.h"
#import "GameObject.h"
#import "GameConfig.h"
#import "GameUI.h"
#import "BattleManager.h"
#import "PackageError.h"

@interface PackageManager ()
{
    BOOL _requestingBattleInfo;
}
@property (nonatomic, strong) PackageError *packageError;   // 消息包裹错误处理对象

@end

@implementation PackageManager
static PackageManager *theGlobalPackageManager = nil;
+(PackageManager *)sharedInstance
{
    if (theGlobalPackageManager == nil)
    {
        static dispatch_once_t oncePackageManager = 0;
        dispatch_once(&oncePackageManager, ^{
            theGlobalPackageManager = [[PackageManager alloc]initInstance];
        });
    }
    return theGlobalPackageManager;
}
//
// 初始化
//
-(id)initInstance
{
    self = [super init];
    if (self != nil)
    {
        self.downloadFilesCounter = 0;
        _requestingBattleInfo = NO;
        if (self.packageError == nil)
        {
            self.packageError = [[PackageError alloc]init];
        }
    }
    return self;
}

#pragma mark - About Version Request & Response
-(void)versionsRequest
{
    // 正式调用
    NSDictionary *versions =  [[GameConfig sharedInstance] getAllVersions];
    
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_VERSION, getLastGameMode());
    [data setObject:@"1" forKey:@"Platform"];
    [data setObject:@"20140101" forKey:@"AppVersion"];
    [data setObject:versions forKey:@"ConfigVersions"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self versionsResponse:result];
     }];
}

-(void)versionsResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        // com的值 用来描述该申请再服务端出现的问题
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Url"])
        {
            // 如果走到这里，我们将很遗憾的告诉你，你要更新客户端了。
        }
        if ([result objectForKey:@"Vers"])
        {
            // 安心吧，这里只是更新一些配置而已
            NSDictionary *dictVers = [result objectForKey:@"Vers"];
            [[GameConfig sharedInstance] downloadNeedUpdateFiles:dictVers];
        }
        if ([result objectForKey:@"Funcs"])
        {
            // 这是个秘密哦！
        }
    }
    @catch (NSException *exception)
    {
    }
    @finally
    {
    }
}

#pragma mark - About Config Files Request & Response
-(void)configRequest:(NSDictionary*)params
{
    NSString* filename = [params objectForKey:@"ConfigName"];
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_CONFIG, getLastGameMode());
    [data setObject:@"1" forKey:@"Platform"];
    [data setObject:filename forKey:@"ConfigName"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self configResponse:result
                   configName:filename];
     }];
    
}

-(void)configResponse:(NSDictionary *)result configName:(NSString *)filename
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        // 处理确认码不为 0 时候的事件
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Url"])
        {
        }
        
        // 这儿应该设置进度条
        if ([result objectForKey:@"Data"])
        {
            self.downloadFilesCounter--;
            
            NSString *str = [result objectForKey:@"Data"];
            
            BOOL bResult = [[GameConfig sharedInstance] encodeConfigData:str Name:filename];
            
            if ( !bResult )
            {
                [[GameUI sharedInstance] showError:@"保存缓存文件出错！" title:@"Error"];
            }
            if (self.downloadFilesCounter == 0)
            {
                [[GameConfig sharedInstance] loadAllConfigs];
            }
        }
    }
    @catch (NSException *exception)
    {
    }
    @finally
    {
    }
    
}

#pragma mark - About User Info Request & Response
-(void)userInfoRequest
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_USERINFO, getLastGameMode());
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self userInfoResponse:result];
     }];
}

-(void)userInfoResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Hero"])
        {
            // 主角信息
            NSDictionary *playerData = [result objectForKey:@"Hero"];
            [[GameObject sharedInstance] setPlayerWithDictionary:playerData];
        }
    
        if ([result objectForKey:@"Bag"])
        {
            // 背包信息
            NSDictionary *bagData = [result objectForKey:@"Bag"];
            [[GameObject sharedInstance] setBagWithDictionary:bagData];
        }
    
        if ([result objectForKey:@"Battle"])
        {
            // 这个不知道要不要了  听说是不要 但是文档里还有
        }
        
        if ([result objectForKey:@"Config"])
        {
            // 战斗配置
            NSDictionary *configData = [result objectForKey:@"Config"];
            [[GameConfig sharedInstance] setBattleConfigWithDictionary:configData];
        }
        
        if ([result objectForKey:@"InviteCode"])
        {
            // 邀请码
            [[GameObject sharedInstance] setInviteCodeWithObject:[result objectForKey:@"InviteCode"]];
        }
        
        // 默认显示大厅界面
        [[GameUI sharedInstance] showHallView];
    }
    @catch (NSException *exception)
    {
        NSLog(@"userInfoResponse : %@", exception);
    }
}

#pragma mark - About Ladder Info Request & Response
-(void)ladderInfoRequest
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_LADDERINFO, getLastGameMode());
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self ladderInfoResponse:result];
     }];
}

-(void)ladderInfoResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Competitor"])
        {
            NSArray* competitorArr = [result objectForKey:@"Competitor"];
            [[GameObject sharedInstance] setLdrWithArray:competitorArr];
        }
        
        if ([result objectForKey:@"Ldr"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:result];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"ladderInfoResponse : %@", exception);
    }
    @finally
    {
    }
}

#pragma mark - About Relation Info Request & Response
-(void)relationInfoRequest
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_RELATIONINFO, getLastGameMode());
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self relationInfoResponse:result];
     }];
}

-(void)relationInfoResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Parent"])
        {
            NSDictionary* friend = [result objectForKey:@"Parent"];
            [[GameObject sharedInstance]setPreHomeWithDictionary:friend];
        }
        
        if ([result objectForKey:@"Child"])
        {
            NSArray* homs = [result objectForKey:@"Child"];
            [[GameObject sharedInstance]setNextHomeWithArray:homs];
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"relationInfoResponse : %@", exception);
    }
    @finally
    {
    }
}

#pragma mark - About Reward Info Request & Response
-(void)rewardInfoRequest
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_REWARDINFO, getLastGameMode());
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self rewardInfoResponse:result];
     }];
}

-(void)rewardInfoResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Reward"])
        {
            NSArray* rewards = [result objectForKey:@"Reward"];
            [[GameObject sharedInstance]setRewardWithArray:rewards];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"relationInfoResponse : %@", exception);
    }
    @finally
    {
    }
}

#pragma mark - About Trade Request & Response
-(void)tradeRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_TRADE, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:@"" forKey:@"Type"];
//    [data setObject:@"" forKey:@"Page"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self tradeResponse:result];
     }];
}

-(void)tradeResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Trades"])
        {
            NSArray* rewards = [result objectForKey:@"Trades"];
            [[GameObject sharedInstance]setRewardWithArray:rewards];
        }
        if ([result objectForKey:@"Next"])
        {
            
        }
        if ([result objectForKey:@"Page"])
        {
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"tradeResponse : %@", exception);
    }
    @finally
    {
    }
}

#pragma mark - About Trade By self Request & Response
-(void)tradeBySelfRequest
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_SELFTRADE, getLastGameMode());
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self tradeBySelfResponse:result];
     }];
}

-(void)tradeBySelfResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Trades"])
        {
            NSArray* rewards = [result objectForKey:@"Trades"];
            [[GameObject sharedInstance]setRewardWithArray:rewards];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"tradeResponse : %@", exception);
    }
    @finally
    {
    }
}

#pragma mark - About Reward Request & Response
-(void)rewardRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_REWARD, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:@"" forKey:@"RID"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self rewardResponse:result];
     }];
}

-(void)rewardResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
        if ([result objectForKey:@"Drop"])
        {
//            [[GameObject sharedInstance] changeDropInfo:[result objectForKey:@"Drop"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"tradeResponse : %@", exception);
    }
    @finally
    {
    }
}

#pragma mark - About Add Pre-Home Request & Response
-(void)addPreHomeRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_ADD_PREHOME, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:name forKey:@"Name"];
//    [data setObject:code forKey:@"Code"];
//    [data setObject:hsid forKey:@"HSID"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self addPreHomeResponse:result];
     }];
}

-(void)addPreHomeResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
}

#pragma mark - About Del Next-Home Request & Response
-(void)delNextHomeRequest
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_DEL_NEXTHOME, getLastGameMode());
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self delNextHomeResponse:result];
     }];
}

-(void)delNextHomeResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
}

#pragma mark - About Auction Request & Response
-(void)auctionRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_AUCTION, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:@"" forKey:@"Type"];
//    [data setObject:@"" forKey:@"UP"];
//    [data setObject:@"" forKey:@"Cnt"];
//    [data setObject:@"" forKey:@"Dura"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self auctionResponse:result];
     }];
}

-(void)auctionResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
        
        // 通知有关界面更新
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }
    @finally
    {
        
    }
}

#pragma mark - About Buy From Auction Request & Response
-(void)buyFromAuctionRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_BUYAUCTION, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:@"" forKey:@"TID"];
//    [data setObject:@"" forKey:@"Enter"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self buyFromAuctionResponse:result];
     }];
}

-(void)buyFromAuctionResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
        
        // 通知有关界面更新
    }
    @catch (NSException *exception)
    {
        NSLog(@"buyFromAuctionResponse : %@", exception);
    }
    @finally
    {
        
    }
}

#pragma mark - About Query From Auction Request & Response
-(void)queryFromAuctionRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_QUERYAUCTION, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:@"" forKey:@"Type"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self queryFromAuctionResponse:result];
     }];
}

-(void)queryFromAuctionResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Trade"])
        {
//            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        
        // 通知有关界面更新
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
    }
    @finally
    {
        
    }
}

#pragma mark - About Query Item Price Request & Response
-(void)queryItemPriceRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_QUERYPRICE, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:@"" forKey:@"Types"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self queryItemPriceResponse:result];
     }];
}

-(void)queryItemPriceResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"UPs"])
        {
            
//          [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        
        // 通知有关界面更新
    }
    @catch (NSException *exception)
    {
        NSLog(@"queryItemPriceResponse : %@", exception);
    }
    @finally
    {
        
    }
}

#pragma mark - About Battle Info Request & Response
-(void)battleInfoRequest
{
    if ( _requestingBattleInfo )
        return;
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_BATTLEINFO, getLastGameMode());
    _requestingBattleInfo = [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self battleInfoResponse:result];
         _requestingBattleInfo = NO;
     }];
}

-(void)battleInfoResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Secs"])
        {
            NSNumber *leftTime = [result objectForKey:@"Secs"];
            if ([leftTime integerValue] != 0)
            {
                [[BattleManager sharedInstance] setLeftTime:leftTime];
            }
        }
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
        if ([result objectForKey:@"Detail"])
        {
            [[BattleManager sharedInstance] setDetailWithDictionary:[result objectForKey:@"Detail"]];
        }
        if ([result objectForKey:@"Brief"])
        {
            [[BattleManager sharedInstance] setBriefWithDictionary:[result objectForKey:@"Brief"]];
        }
        
        // 通知有关界面更新
        [[GameUI sharedInstance] updateHallView];
    }
    @catch (NSException *exception)
    {
        NSLog(@"battleInfoResponse : %@", exception);
    }
    @finally
    {
        
    }
}

#pragma mark - About Quick Battle Request & Response
-(void)quickBattleRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_QUICKBATTLE, getLastGameMode());
    [data addEntriesFromDictionary:params];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self quickBattleResponse:result];
     }];
}

-(void)quickBattleResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {        
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
        
        if ([result objectForKey:@"Brief"])
        {
            [[BattleManager sharedInstance] setBriefWithDictionary:[result objectForKey:@"Brief"]];
        }
        
        // 通知有关界面更新
        [[GameUI sharedInstance] updateHallView];
        [[GameUI sharedInstance] updateBagView];
        [[GameUI sharedInstance] updateTheStageInfoView];
    }
    @catch (NSException *exception)
    {
        NSLog(@"quickBattleResponse : %@", exception);
    }
    @finally {
        
    }
}

#pragma mark - About Boss Request & Response
-(void)bossRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_BOSS, getLastGameMode());
    [data addEntriesFromDictionary:params];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self bossResponse:result];
     }];
}

-(void)bossResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    // 通知有关界面更新
}

#pragma mark - About Athletics Request & Response
-(void)athleticsRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_ATHLETICS, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:[[NSNumber alloc] initWithInt:[targetId intValue]] forKey:@"Map"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self athleticeResponse:result];
     }];
}

-(void)athleticeResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    // 通知有关界面更新
}

#pragma mark - About Battle Setting Request & Response
-(void)battleSettingRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_BATTLESETTING, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:dict forKey:@"BattleConfig"];
    [[NetManager sharedInstance] sendMessage:data
                                    packageLevel:Package_Fatal
                                      completion:^(NSDictionary *result)
    {
        NSLog(@"Result is %@", result);
        [self battleSettingResponse:result];
    }];
}

-(void)battleSettingResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    // 通知有关界面更新
}

#pragma mark - About Change Map Request & Response
-(void)changeMapRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_CHANGEMAP, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:[[NSNumber alloc] initWithInt:[mapId intValue]] forKey:@"Map"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self changeMapResponse:result];
     }];
}

-(void)changeMapResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    // 通知有关界面更新
    [[GameUI sharedInstance] closeTheStageInfoView];
}

#pragma mark - About Change Pet Request & Response
-(void)changePetRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_CHANGEPET, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:[[NSNumber alloc] initWithInt:[petId intValue]] forKey:@"Pet"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self changePetResponse:result];
     }];
}
-(void)changePetResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    // 通知有关界面更新
    [[GameUI sharedInstance] updatePetActiveBtnController];
}

#pragma mark - About Change Skill Request & Response
-(void)changeSkillRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_CHANGESKILL, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:skills forKey:@"Skill"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self changeSkillResponse:result];
     }];
}
-(void)changeSkillResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
            [[GameUI sharedInstance] updateHallView];
        }
        
        // 通知有关界面更新
        [[GameUI sharedInstance] updateSkillView];
    }
    @catch (NSException *exception)
    {
        NSLog(@"quickBattleResponse : %@", exception);
    }
    @finally {
        
    }
}

#pragma mark - About Ladder Request & Response
-(void)ladderRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_LADDER, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:place forKey:@"Rank"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self changeSkillResponse:result];
     }];
}
-(void)ladderResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    // 通知有关界面更新
}

#pragma mark - About Sweep Request & Response
-(void)sweepRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_SWEEP, getLastGameMode());
    [data addEntriesFromDictionary:params];
    //    [data setObject:num forKey:@"Cnt"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self sweepResponse:result];
     }];
}
-(void)sweepResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
        
        if ([result objectForKey:@"Brief"])
        {
            [[BattleManager sharedInstance] setBriefWithDictionary:[result objectForKey:@"Brief"]];
        }
        
        // 通知有关界面更新
        [[GameUI sharedInstance] updateHallView];
        [[GameUI sharedInstance] updateBagView];
        [[GameUI sharedInstance] updateTheStageInfoView];
    }
    @catch (NSException *exception)
    {
        NSLog(@"quickBattleResponse : %@", exception);
    }
    @finally {
        
    }
}

#pragma mark - About Upgrage Skill Request & Response
-(void)upgradeSkillRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_UPGRADESKILL, getLastGameMode());
    [data addEntriesFromDictionary:params];
    //    [data setObject:num forKey:@"SID"];
    //    [data setObject:num forKey:@"PID"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self upgradeSkillRespone:result];
     }];
}
-(void)upgradeSkillRespone:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
            [[GameUI sharedInstance] updateHallView];
        }
        
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
            [[GameUI sharedInstance] updateBagView];
        }
        
        // 通知有关界面更新
        [[GameUI sharedInstance] updateSkillView];
    }
    @catch (NSException *exception)
    {
        NSLog(@"quickBattleResponse : %@", exception);
    }
    @finally {
        
    }
}

#pragma mark - About Change\Upgrade\Unload Equip Request & Response
-(void)changeEquipRequest:(NSDictionary*)params
{
    NSNumber *equipId       = [params objectForKey:@"EID"];
    NSNumber *slot          = [params objectForKey:@"Slot"];
    NSNumber *petId         = [params objectForKey:@"Pet"];
    
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_CHANGEEQUIP, getLastGameMode());
    [data setObject:equipId forKey:@"EID"];
    [data setObject:slot forKey:@"Slot"];
    if ([petId intValue] > 0)
    {
        [data setObject:petId forKey:@"Pet"];
    }
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self changeEquipResponse:result petId:petId];
     }];
}
-(void)changeEquipResponse:(NSDictionary *)result petId:(NSNumber*)petId
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        // 数据变更
        [[GameObject sharedInstance] changeOneEquip];
        
        // 通知有关界面更新
        [[GameUI sharedInstance] closeTheEquipChangeView];
        [[GameUI sharedInstance] closeEquipInfoView];
        if ([petId intValue] > 0)
        {
            [[GameUI sharedInstance] showPetView];
        }
        else
        {
            [[GameUI sharedInstance] showEquipView];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"changeEquipResponse : %@", exception);
    }
    @finally
    {
    }
}

-(void)unloadEquipRequest:(NSDictionary*)params
{
    NSNumber *equipId = [params objectForKey:@"EID"];
    NSNumber *petId = [params objectForKey:@"Pet"];
    
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_UNLOADEQUIP, getLastGameMode());
    [data setObject:equipId forKey:@"EID"];
    if ([petId intValue] > 0)
    {
        [data setObject:petId forKey:@"Pet"];
    }
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self unloadEquipResponse:result petId:petId];
     }];
}
-(void)unloadEquipResponse:(NSDictionary *)result petId:(NSNumber*)petId
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        [[GameObject sharedInstance] unloadOneEquip];
        [[GameUI sharedInstance] closeEquipInfoView];
        if ([petId intValue] > 0)
        {
            [[GameUI sharedInstance] showPetView];
        }
        else
        {
            [[GameUI sharedInstance] showEquipView];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"unloadEquipResponse : %@", exception);
    }
    @finally
    {
    }
}

-(void)upgradeEquipMainAttriRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_UPGRADEMAINATTRI, getLastGameMode());
    [data addEntriesFromDictionary:params];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self upgradeEquipMainAttriResponse:result];
     }];
}
-(void)upgradeEquipMainAttriResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Equip"])
        {
            NSDictionary *equipData = [result objectForKey:@"Equip"];
            [[GameObject sharedInstance] changeEquipData:equipData];
            
            // 在这儿需要告诉一些界面去更新相关的装备信息
            [[GameUI sharedInstance] updateEquipInfoView];
            [[GameUI sharedInstance] updateEquipMainAttribute:[equipData objectForKey:@"EID"]];
            [[GameUI sharedInstance] updateEquipView];
        }
        
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
            [[GameUI sharedInstance] updateHallView];
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"upgradeEquipMainAttriResponse : %@", exception);
    }
    @finally
    {
    }
}

//-(void)upgradeEquipSubAttriRequest:(NSNotification *)notify
-(void)upgradeEquipSubAttriRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_UPGRADESUBATTRI, getLastGameMode());
    [data addEntriesFromDictionary:params];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self upgradeEquipSubAttriRespone:result];
     }];
}
-(void)upgradeEquipSubAttriRespone:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Equip"])
        {
            NSDictionary *equipData = [result objectForKey:@"Equip"];
            [[GameObject sharedInstance] changeEquipData:equipData];
            
            // 在这儿需要告诉一些界面去更新相关的装备信息
            [[GameUI sharedInstance] updateEquipInfoView];
            [[GameUI sharedInstance] updateEquipSubAttribute:[equipData objectForKey:@"EID"]];
        }
        
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
            [[GameUI sharedInstance] updateHallView];
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"upgradeEquipSubAttriRespone : %@", exception);
    }
    @finally
    {
    }
}

//-(void)upgradeEquipGodAttriRequest:(NSNotification*)notify
-(void)upgradeEquipGodAttriRequest:(NSDictionary*)params
{
//    NSDictionary *tempDict = [notify object];
//    NSNumber *equipId = [tempDict objectForKey:@"EID"];
//    NSArray *equips = [tempDict objectForKey:@"ID"];
    
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_UNLOADEQUIP, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:equipId forKey:@"EID"];
//    [data setObject:equips forKey:@"ID"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self upgradeEquipGodAttriResponse:result];
     }];
}
-(void)upgradeEquipGodAttriResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Equip"])
        {
            NSDictionary *equipData = [result objectForKey:@"Equip"];
            [[GameObject sharedInstance] changeEquipData:equipData];
            
            // 在这儿需要告诉一些界面去更新相关的装备信息
            [[GameUI sharedInstance] updateEquipGodAttribute:[equipData objectForKey:@"EID"]];
        }
        
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
            [[GameUI sharedInstance] updateHallView];
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"upgradeEquipSubAttriRespone : %@", exception);
    }
    @finally
    {
    }
}

#pragma mark - About Expand Bag Request & Response
-(void)expandBagRequest
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_EXPANDBAG, getLastGameMode());
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self expandBagResponse:result];
     }];
}
-(void)expandBagResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        [[GameObject sharedInstance] setBagWithDictionary:result];
        
        // 通知有关界面更新
        [[GameUI sharedInstance] updateBagView];
    }
    @catch (NSException *exception)
    {
    }
    @finally
    {
    }
}

#pragma mark - About Sell Item or Equip Bag Request & Response
-(void)sellItemOrEquipFromBagRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_SELLFROMBAG, getLastGameMode());
    [data addEntriesFromDictionary:params];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self sellItemOrEquipFromBagResponse:result];
     }];
}
-(void)sellItemOrEquipFromBagResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        
        // 通知有关界面更新
        [[GameUI sharedInstance] closeEquipInfoView];
        [[GameUI sharedInstance] updateBagView];
        [[GameUI sharedInstance] updateHallView];
        [[GameUI sharedInstance] updateBlukView];
    }
    @catch (NSException *exception)
    {
        NSLog(@"sellItemOrEquipFromBagResponse : %@", exception);
    }
    @finally
    {
    }
}

#pragma mark - About Use or Open Chest Request & Response
-(void)usedItemOrOpenChestRequest:(NSDictionary*)params
{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_USINGOROPEN, getLastGameMode());
    [data addEntriesFromDictionary:params];
//    [data setObject:identifier forKey:@"ID"];
//    [data setObject:count forKey:@"Num"];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self usedItemOrOpenChestResponse:result];
     }];
}
-(void)usedItemOrOpenChestResponse:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Drop"])
        {
            
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
        }
        
        // 通知有关界面更新
        [[GameUI sharedInstance] updateHallView];
        [[GameUI sharedInstance] updateBagView];
        [[GameUI sharedInstance] closeThePropInfoView];
    }
    @catch (NSException *exception)
    {
        NSLog(@"usedItemOrOpenChestResponse : %@", exception);
    }
    @finally
    {
    }
}

-(void)storeQueryGoods:(NSDictionary*)params{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_STOREQUERYGOODS, getLastGameMode());
    [data addEntriesFromDictionary:params];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self quickStoreQueryGoods:result];
     }];
}

-(void)quickStoreQueryGoods:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Shop"])
        {
            [[GameUI sharedInstance] setStoreView:result];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"quickStoreQueryGoods : %@", exception);
    }
    @finally {
        
    }
}


-(void)storeBuyGoods:(NSDictionary*)params{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_STOREBUYGOODS, getLastGameMode());
    [data addEntriesFromDictionary:params];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self quickStoreBuyGoods:result];
     }];
}

-(void)quickStoreBuyGoods:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Shop"])
        {
            [[GameUI sharedInstance] setStoreView:result];
        }
        if ([result objectForKey:@"Hero"])
        {
            [[GameObject sharedInstance] setPlayerWithDictionary:[result objectForKey:@"Hero"]];
            [[GameUI sharedInstance] updateHallView];
        }
        if ([result objectForKey:@"Bag"])
        {
            [[GameObject sharedInstance] setBagWithDictionary:[result objectForKey:@"Bag"]];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"quickStoreBuyGoods : %@", exception);
    }
    @finally {
        
    }
}


-(void)storeRefreshGoods:(NSDictionary*)params{
    HaypiJson data = createJsonOnlyWithAction(kACTION_CODE_STOREREFRESHGOODS, getLastGameMode());
    [data addEntriesFromDictionary:params];
    [[NetManager sharedInstance] sendMessage:data
                                packageLevel:Package_Fatal
                                  completion:^(NSDictionary *result)
     {
         NSLog(@"Result is %@", result);
         [self quickStoreRefreshGoods:result];
     }];
}

-(void)quickStoreRefreshGoods:(NSDictionary *)result
{
    NSInteger com = [[result objectForKey:TO_NS(kACTION_CONFIRM)] integerValue];
    if (com != 0)
    {
        [self.packageError handleErrorWithComCode:com];
        return;
    }
    
    @try
    {
        if ([result objectForKey:@"Shop"])
        {
            [[GameUI sharedInstance] setStoreView:result];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"quickStoreRefreshGoods : %@", exception);
    }
    @finally {
        
    }
}

@end
