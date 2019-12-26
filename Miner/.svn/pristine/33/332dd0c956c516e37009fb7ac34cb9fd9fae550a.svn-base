//
//  LoginViewController.m
//  testMiner
//
//  Created by zhihua.qian on 14-11-21.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "LoginViewController.h"
#import "CommonDef.h"
#import "GameUI.h"
#import "NetManager.h"
#import "PackageManager.h"
//#import "GameNotification.h"

@interface LoginViewController ()
-(void)handleResult:(NSDictionary*)result isFake:(BOOL)isFake;
@end

@implementation LoginViewController

// 故事版加载的时候会调用这个初始方法  要早于appdelegate的didFinishLaunchingWithOptions
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        [GameUI setLoginViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ( [[segue destinationViewController] isKindOfClass:[LoginAccountViewController class]]
//        && [sender isKindOfClass:[UIButton class]])
//    {
//        LoginAccountViewController* lavc = (LoginAccountViewController*)[segue destinationViewController];
//        lavc.delegate = self;
//        lavc.isFake = [sender tag] == 1 ? NO : YES;
//    }
//}

//
// 重置网络管理
//
- (IBAction)onResetClicked:(id)sender
{
    [[NetManager sharedInstance] reset];
}

//
// 快速开始（外网）
//
- (IBAction)onStartClicked:(id)sender
{
    [[NetManager sharedInstance] start:NO
                            completion:^(NSDictionary* result)
                            {
                                [self handleResult:result isFake:NO];
                            }];
}

//
// 账号登陆
//
- (IBAction)onAccountClicked:(id)sender
{
}

//
// 快速开始（内网）
//
- (IBAction)onFakeStartClicked:(id)sender
{
    [[NetManager sharedInstance] start:YES
                            completion:^(NSDictionary* result)
                            {
                                [self handleResult:result isFake:YES];
                            }];
}

//
// 内网账号登陆
//
- (IBAction)onFakeAccountClicked:(id)sender
{
}

//
// 处理回调结果
//
-(void)handleResult:(NSDictionary *)result isFake:(BOOL)isFake;
{
    if ([result objectForKey:kErrorDomain] == nil)
        return;
    
    NSString *ed = [result objectForKey:kErrorDomain];  // 获得错误域
    
    NSNumber *actionCom = [result objectForKey:TO_NS(kACTION_CONFIRM)]; // 获得确认码
    if (actionCom == nil)
    {
        // 无确认码  报错
        [[GameUI sharedInstance]showError:2000 extraInfo:nil];
    }
    else if ([actionCom intValue] != 0)
    {
        // 确认码不等于零  报错
        NSString *extraInfo = [result objectForKey:TO_NS(kExtraInfo)];  // 获取错误描述
        [[GameUI sharedInstance] showError:[actionCom intValue] extraInfo:extraInfo];
    }
    else
    {
        // 确认码等于零 OK
        // 域 如果等于  auth
        if ([ed isEqualToString:kED_Auth])
        {
            NSNumber *action = [result objectForKey:TO_NS(kACTION)];    // 获取行为码
            if ([action intValue] == ACTION_LOGIN)                      // 行为码为 101 登陆
            {
                [[NetManager sharedInstance] connectToServer];          // 去连接服务器
            }
        }
        else
        {
            NSNumber *action = [result objectForKey:TO_NS(kACTION)];    // 获取行为码
            if ([action intValue] == ACTION_LOGIN_GAMESERVER)           // 行为码为 104 登陆了游戏服务器
            {
                [[PackageManager sharedInstance] userInfoRequest];
            }
        }
    }
}
@end
