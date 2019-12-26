//
//  NetManager.m
//  Miner
//
//  Created by jim kaden on 14/10/23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "NetManager.h"
#import "SocketCommand.h"


@interface NetManager()

@property (nonatomic, strong) void (^passportCallbackHandler)(NSDictionary*);
@property (nonatomic, strong) HaypiSocket currentSocket;
@property (nonatomic, assign) int retryCount;
@property (nonatomic, weak)   NSNumber* currentHash;
@property (nonatomic, strong) NSMutableArray* cmdQueue;
@property (nonatomic, strong) NSMutableDictionary* cmdCache;
@property (nonatomic, assign) BOOL forceClosed;
@property (nonatomic, weak, readwrite)   NSNumber* uid;

-(void)netError:(NSDictionary*)error;
-(void)showAuthProgressView:(BOOL)show;
-(void)autoLogin:(BOOL)outSite;
-(void)login:(NSString *)name password:(NSString *)password outSite:(BOOL)outSite;
-(BOOL)dispatchCommand:(SocketCommand*)sc;
@end



@implementation NetManager
@synthesize passportCallbackHandler = _passportCallbackHandler;
@synthesize currentSocket = _currentSocket;
@synthesize currentHash = _currentHash;
@synthesize forceClosed = _forceClosed;

static NetManager* theGlobalNetManager = nil;

//
// 类方法：返回一个全局的静态变量 theGlobalNetManager
// 调用了自身 initInstance 方法
//
+(NetManager*)sharedInstance
{
    if ( theGlobalNetManager == nil )
    {
        theGlobalNetManager = [[NetManager alloc]initInstance];
    }
    return theGlobalNetManager;
}

//
// 不可调用init方法
//
//-(id)init
//{
//    SafeAssert(false, @"NetManager 不可以调用init");
//    return nil;
//}

//
// 初始化实例
// 这里会设置 passport 的地址
//
-(id)initInstance
{
    self = [super init];
    eanbleNetLog(1);
    [LoginFunctions setRegisterURL:@"http://b11.haypi.mobi/miner/passport/passport.php"];     // 设置注册的url
    [LoginFunctions setFakeRegisterURL:@"http://192.168.1.55/miner/passport/passport.php"]; // 设置假注册的url
    [LoginFunctions setDelegate:self];                  // 设置委托对象吧？？
    [LoginFunctions setLoginMainWindow:self];           // 设置登陆主窗口：不知道干啥
    [LoginFunctions setLoginWindow:self];               // 设置登陆窗口：又不知道干啥
    // 设置定时器：每隔0.5秒，调用实例自身的方法：handleTimer；有点像循环
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(handleTimer:) userInfo:nil repeats:YES];
    self.retryCount = 0;                                // 重试次数
    self.currentSocket = nil;                           // 当前套接字
    self.currentHash = nil;                             // 当前哈希
    self.passportCallbackHandler = nil;                 // passport回调处理
    self.uid = nil;                                     // uid
    self.cmdQueue = [[NSMutableArray alloc]init];       // ”命令队列“数组
    self.cmdCache = [[NSMutableDictionary alloc]init];  // “命令缓冲”字典
    return self;
}

//
// 显示auth登陆进度视图：参数为是否显示 YES or NO
//
-(void)showAuthProgressView:(BOOL)show
{
    // dispatch_async 这个方法是开启一个gcd异步操作：第一个参数指定gcd的队列，第二个参数是分配一个处理事务的程序块到该队列。
    // 参数1：dispatch_get_main_queue 获得gcd的主队列
    // 参数2：处理耗时操作的代码块，这是里通知消息中心。
    dispatch_async(dispatch_get_main_queue(), ^{
        // 一 推送消息的名称。已注册的消息监听者时的消息名称。
        // 二 发送消息的实体，这里为空
        // 三 发送消息时附带的上下文。给接收方法的参数（id）sender中的useinfo
        [[NSNotificationCenter defaultCenter] postNotificationName:show ? kNotif_Auth_StartHud : kNotif_Auth_StopHud
                                                            object:nil
                                                          userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:show]
                                                                                               forKey:show ? kNotif_Auth_StartHud : kNotif_Auth_StopHud]];
    });
}

//
// 重置登陆功能
//
-(void)reset
{
    [LoginFunctions resetAccount];
}

//
// 事件：点击账号按钮
//
-(void)onAccountClicked:(NSObject*)sender
{
    // do nothing
}

//
// 开始游戏
//
-(void)startGame:(NSNumber*)from
{
    // 见上面方法内的详解
    dispatch_async(dispatch_get_main_queue(), ^{
        if ( self.passportCallbackHandler )
            self.passportCallbackHandler(@{
                                           kNotif_Auth_StartGame:from,
                                           TO_NS(kACTION) : [NSNumber numberWithInt:ACTION_LOGIN],
                                           TO_NS(kACTION_CONFIRM) : @"0",
                                           kErrorDomain: kED_Auth,
                                           });

        else
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_Auth_StartGame
                                                            object:nil
                                                          userInfo:[NSDictionary dictionaryWithObject:from forKey:kNotif_Auth_StartGame]];
    });
    
    [self showAuthProgressView:NO];
}

//
// 显示进度视图
//
-(void)showProgressView
{
    [self showAuthProgressView:YES];
}

/*
 填写用户名密码进行登陆的窗口的流程
 */
-(void)onNetFail:(char*)context
{
    // 竟然也有  try catch finally  不过都带@
    @try {
        // 将字符串通过strToJson  为什么返回的是个可变字典？
        NSMutableDictionary* dict = strToJson(context);
        if ( dict != nil )
        {
            [dict setObject:kED_Auth forKey:kErrorDomain];
            [self netError:dict];
        }
        else
        {
            NSDictionary* unknownDict = @{
                                          TO_NS(kACTION_CONFIRM):@"2000",
                                          kErrorDomain:kED_Auth,
                                          };
            [self netError:unknownDict];
        }
        [self showAuthProgressView:NO];
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

/*
 一般性登录流程回调，登陆错误代码
 */
- (void)loginErrorWithCode:(NSDictionary *)code
{
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] initWithDictionary:code];
    [dict setObject:kED_Auth forKey:kErrorDomain];  // 添加一对键值  @"error.domain" -- @"auth.passport"
    [self netError:dict];                           // 调用网络错误处理方法
    [self showAuthProgressView:NO];
}

/*
 更改用户名
 */
- (void)changeUserNameTo:(NSString *)newName
{
    //[LoginFunctions onChangeUserName:newName WithAuthKey:getLastAuthKey(getLastGameMode())];
}

/*
 接收服务器列表
 */
- (void)onReceiveServerList:(NSDictionary *)serverlist
{
    
}

/*
 接收最近一次的用户状态
 */
- (void)onReceiveLastUserState:(USER_STATE)state
{
    
}

/*
 接收
 */
- (void)onReceiveGCNameResponse:(NSDictionary*)response
{
    
}

#pragma mark -- Socket callback 套接字回调
//
//  用户登录成功
//
-(void)onUserLoggedIn:(NSNumber*)uid withHashCode:(NSNumber*)hashCode
{
    // 给uid和hashCode赋值
    self.uid = uid;
    self.currentHash = hashCode;
    
    
    @try {
        NSDictionary* unknownDict = @{
                                          TO_NS(kACTION) : [NSNumber numberWithInt:ACTION_LOGIN_GAMESERVER],
                                          TO_NS(kACTION_CONFIRM):@"0",
                                          kErrorDomain:kED_Game,
                                    };
        if ( self.passportCallbackHandler )     // 判断是否有回调
        {
            self.passportCallbackHandler(unknownDict);
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_Net_UserLoggin
                                                                object:nil];
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
    
}

//
// 接收到的Json用Base64解析
//
-(void)onReceiveJsonWithBase64Decoding:(HaypiJson)json withSocket:(HaypiSocket)socket    // 如果可以解析为Json结构，则调用此回调，否则调用onReceive
{
    if ( socket == nil || json == nil )
        return;
    
    uint64_t hashCode = getHashCodeFromHaypiSocketServer(socket);
    if ( hashCode != [_currentHash unsignedLongLongValue] || socket != _currentSocket )
        return;
    {
        // dispatch result from net
        // 发送来自服务器的结果
        NSDictionary* dictResult = (NSDictionary*)json;
        NSObject* obj = [dictResult objectForKey:TO_NS(kACTION_KEY)];
        if ( obj == nil )
        {
            // ignore
        }
        else
        {
            @try
            {
                NSNumber* actionKey = [NSNumber numberWithInt:[(NSNumber*)obj intValue]];
                SocketCommand* sc = [_cmdCache objectForKey: actionKey];    // 从缓冲队列里找出指令
                if ( sc != nil && [_cmdQueue containsObject:sc] )           // 检查指令数组里是否有该指令
                {
                    if ( [self checkValidResult:dictResult] )
                    {
                        // 给予调用者回调
                    }
                    sc.callbackHandler(dictResult); // 回调代码块  并将服务器结果字典传参
                    [_cmdQueue removeObject:sc];    // 数组里移除该指令
                }
                
                if ( sc )
                    [_cmdCache removeObjectForKey:actionKey];   // 缓冲字典里移除该指令
                
                sc = nil;
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
    }
}

//
//  响应接收上下文，通过套接字
//  一般不走这里，走这里就出错了
//
-(void)onReceive:(char*)context withSocket:(HaypiSocket)socket
{
//    SafeAssert (false, @"应该不会走到这里，走到这里就错了");
}

//
//  断开套接字  是否强制关闭
//
-(void)socketDisconnected:(HaypiSocket)socket forceClose:(BOOL)forceClose
{
    // 清空 hash 和 uid
    _currentHash = nil;
    _uid = nil;
    
    if ( forceClose )
    {
        if ( socket == _currentSocket )
        {
            // stop current socket
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_Net_ForceClosed object:nil];
        }
        _currentSocket = nil;
        _forceClosed = YES;
    }
    else
    {
        _currentSocket = nil;
        // reconnect
        if ( _forceClosed == NO && _retryCount < kNet_Max_Retry_Count )
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self connectToServer];
            });
        }
    }
}

-(void)socketConfirmError:(char*)context withSocket:(HaypiSocket)socket
{
    // do nothing
}

//
//  重连：套接字  是否需要确认   时间
//
-(NSString*)socketReconnected:(HaypiSocket)socket needConfirm:(BOOL*)needConfirm timer:(float*)timer
{
    _retryCount = 0;
    loginHaypiSocketServer(socket, ST_GameServer);
    return nil;
}

//
// 套接字错误：错误字符串  套接字对象
//
-(void)socketError:(char*)error withSocket:(HaypiSocket)socket
{
    @try
    {
        NSMutableDictionary* dict = strToJson(error);
        if ( dict != nil )
        {
            [dict setObject:kED_Game forKey:kErrorDomain];
            [self netError:dict];
        }
        else
        {
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

// 在极特殊的情况下，server会通过一些消息的返回值通知我们需要重新链接gateway，后者要重新登录
-(BOOL)checkValidResult:(NSDictionary*)dict
{
    BOOL ret = YES;
    if ( dict == nil )
        return NO;
    NSNumber* actionCom = [dict objectForKey:TO_NS(kACTION_CONFIRM)];
    
    if ( actionCom != nil )
    {
        if( actionCom.integerValue == kEC_Server_Mismatch )
        {
            if ( _currentSocket != nil )
                disconnect(_currentSocket);
            _currentSocket = nil;
            _currentHash = nil;
            _uid = nil;
            ret = NO;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self connectToServer];
            });

        }
    }
    
    return ret;
}
             
#pragma mark -- User interface
//
// 开始：是否内网（NO不是），回调代码块
//
- (void)start:(BOOL)isFake completion:(void (^)(NSDictionary*))completion;
{
    // 外网快速开始时的代码块 {[self handleResult:result isFake:NO]}  参数 result
    // 内网快速开始时的代码块 {[self handleResult:result isFake:YES]}  参数 result
    // 以上其中的self是LoginViewController
    self.passportCallbackHandler = completion;
    [self autoLogin:!isFake];
}

//
// 用户名密码登陆，是否内网（NO不是）
//
-(void)login:(BOOL)isFake name:(NSString*)name password:(NSString*)password completion:(void (^)(NSDictionary*))completion;
{
    self.passportCallbackHandler = completion;
    [self login:name password:password outSite:!isFake];
}

//
// 自动登陆：YES为外网，NO为内网
//
-(void)autoLogin:(BOOL)outSite
{
    if ( outSite )
    {
        [LoginFunctions setRegisterServerUrl:NO];
        [LoginFunctions start];
    }
    else
    {
        [LoginFunctions setRegisterServerUrl:YES];
        [LoginFunctions fakeStart];
    }
}

//
//  用用户名和密码  是否是外网 （YES是）
//
-(void)login:(NSString *)name password:(NSString *)password outSite:(BOOL)outSite
{
    if ( name != nil && [name length] > 0 && password != nil && [password length] > 0 )
    {
        // 用户名和密码有效
        [LoginFunctions setRegisterServerUrl:!outSite];
        [LoginFunctions requestLoginWithName:name Password:password];
    }
    else
    {
        if ( name == nil || [name length] == 0 )
        {
            // 用户名空
            [self loginErrorWithCode:@{TO_NS(kACTION_CONFIRM):[NSNumber numberWithInt:kEC_LoginName_Empty] }];
        }
        else if ( password == nil || [password length] == 0 )
        {
            // 密码空
            [self loginErrorWithCode:@{TO_NS(kACTION_CONFIRM):[NSNumber numberWithInt:kEC_LoginPasswd_Empty]}];
        }
    }
}

//
// 网络错误处理
//
-(void)netError:(NSDictionary*)error
{
    // 判断当前线程是否为主线程
    if ( [[NSThread currentThread] isMainThread] == NO )
    {
        // 非主线程  将代码块丢入主队列中
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.passportCallbackHandler)
                self.passportCallbackHandler(error);
        });
    }
    else
    {
        // 是主线程  运行代码块
        if(self.passportCallbackHandler)
            self.passportCallbackHandler(error);
    }
}

//
// 连接服务器
//
-(BOOL)connectToServer
{
    // 判断当前是否有套接字
    if ( _currentSocket != nil )
        return NO;
    char*  server = getCLastUserGC(getLastGameMode());  // 获取玩家最近登陆过的游戏服务器
    short port = getCLastUserGCPort(getLastGameMode()); // 获取玩家最近登陆过的游戏服务器端口
    if ( server == NULL )
        return NO;
    _forceClosed = NO;
//    SafeNSLog(@"Connecting to server %s:%d", server, port);
    _currentSocket = connectServer(server, port, CM_Plain, self, ST_HaypiServer, PT_TCP, YES);  // 连接到服务器的套接字
    return _currentSocket != nil;
}

//
// 断开与服务器的连接
//
-(void)disconnect
{
    _forceClosed = YES;
    disconnect(_currentSocket);
}

//
//  发送消息：内容字典、包的等级、回调代码块
//
-(BOOL)sendMessage:(NSDictionary*)dict packageLevel:(PACKAGE_LEVEL)packageLevel completion:(void (^)(NSDictionary*))completion
{
    if ( dict == nil )
    {
        return NO;  // 内容为空  不发送
    }
    
    if ( _currentSocket == nil || _currentHash == nil )
        return NO;  // 无套接字  或者  当前hash为空  不发送
    
    if ( [dict objectForKey:TO_NS(kACTION)] == nil )
        return NO;  // 无行为号码  不发送
    
    if ( [dict objectForKey:@"Hash"] != nil )
    {
        uint64_t hash = [[dict objectForKey:@"Hash"] unsignedLongLongValue];
        if ( hash != [_currentHash unsignedLongLongValue] )     // 包内的hash值和当前的hash值作比较
        {
//            SafeNSLog(@"Invalid HashCode: current %@, sent %@", _currentHash, dict);
            return NO;  // 不同的hash值  不发送
        }
    }
    
    NSMutableDictionary* dictToSend = [[NSMutableDictionary alloc] initWithDictionary:dict];
    
    if ( [dictToSend objectForKey:TO_NS(kACTION_KEY)] == nil )
    {   // 添加行为键值
        [dictToSend setObject:[NSNumber numberWithInt:getActionKey()] forKey:TO_NS(kACTION_KEY)];
    }
    if ( [dictToSend objectForKey:@"Hash"] == nil )
    {   // 添加hash值
        [dictToSend setObject:_currentHash forKey:@"Hash"];
    }
    if ([dictToSend objectForKey:@"DE_USER_ID"] == nil)
    {   // 添加玩家的uid
        [dictToSend setObject:_uid forKey:@"DE_USER_ID"];
    }

    SocketCommand *sc = [[SocketCommand alloc]init];
    sc.callbackHandler = completion;
    sc.message = dictToSend;
    sc.packageLevel = packageLevel;
    sc.dispatchTime = CFAbsoluteTimeGetCurrent();
    sc.attachTime = sc.dispatchTime;
    sc.uid = _uid;
    return [self dispatchCommand:sc];
}

//
// 发送指令
//
-(BOOL)dispatchCommand:(SocketCommand *)sc
{
    if ( _currentSocket == nil || _currentHash == nil )
        return NO;  // 无套接字  或者  当前hash为空  不发送
    if ( [_uid intValue] != [sc.uid intValue])
        return NO;  // uid检验是否相等
    BOOL ret = sendCmdToHaypiServer(_currentSocket, (HaypiJson)sc.message);
    if ( ret )
    {
        // 判断当前线程是否是主线程
        if ( [[NSThread currentThread] isMainThread] == NO )
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if ( [_cmdQueue containsObject:sc] == NO )
                {   // 将 套接字指令  放入指令数组 和 指令字典中
                    [_cmdQueue addObject:sc];
                    [_cmdCache setObject:sc forKey:[sc.message objectForKey:TO_NS(kACTION_KEY)]];
                }
            });
        }
        else
        {
            if ( [_cmdQueue containsObject:sc] == NO )
            {   // 将 套接字指令  放入指令数组 和 指令字典中
                [_cmdQueue addObject:sc];
                [_cmdCache setObject:sc forKey:[sc.message objectForKey:TO_NS(kACTION_KEY)]];
            }
        }
        sc.dispatchTime = CFAbsoluteTimeGetCurrent();   // 记录发送时间
        sc.sentCount ++;    // 记录发送次数
    }
    return ret;
}

//
// 处理计时器的方法 （似乎主要是处理超时指令的方法）
//
-(void)handleTimer:(NSTimer*)timer
{
//    SafeAssert([[NSThread currentThread] isMainThread], @"这个定时器只能在主线程创建");
    CFAbsoluteTime ct = CFAbsoluteTimeGetCurrent();                 // 记录函数调用开始时间
    NSMutableArray* removeArray = [[NSMutableArray alloc]init];     // 移除数组
    NSMutableArray* resentArray = [[NSMutableArray alloc]init];     // 重发数组
    
    // 遍历指令数组
    int totalRecall = 0;
    for(SocketCommand* sc in _cmdQueue)
    {
        if ( [sc.uid intValue] != [_uid intValue] )
        {
            [removeArray addObject:sc]; // uid不符合  添加到移除数组中
            continue;
        }
        if ( sc.dispatchTime >= ct )
            continue;

        
        if ( (ct - sc.dispatchTime) > kNet_TimeOut )  // 当前时间-发送时间  大于10秒 超时
        {
            switch(sc.packageLevel)     // 根据包的等级
            {
                case Package_Normal:    // 普通包  超时移除
                    [removeArray addObject:sc];
                    break;
                case Package_Warning:   // 警告包  发送两次后移除  不然重新发送
                    if ( sc.sentCount >= 2 )
                    {
                        [removeArray addObject:sc];
                    }
                    else
                    {
                        [resentArray addObject:sc]; // 添加到重发数组
                    }
                    break;
                case Package_Fatal:     // 致命包  发送五次后移除  不然重新发送
                    if ( sc.sentCount >= 5 )
                    {
                        [removeArray addObject:sc];
                    }
                    else
                    {
                        [resentArray addObject:sc]; // 添加到重发数组
                    }
                    break;
                case Package_Restart:   // 重新包  发送两次后移除  不然重新发送
                    if ( sc.sentCount >= 2 )
                    {
                        [removeArray addObject:sc];
                    }
                    else
                    {
                        [resentArray addObject:sc]; // 添加到重发数组
                    }
                    break;
                    
            }
        }
    }// 遍历数组完毕
    
    [_cmdQueue removeObjectsInArray:removeArray];   // 移除“移出数组”
    // 遍历移除数组
    for ( SocketCommand* sc2 in removeArray )
    {
        // 从缓冲字典中移除超时指令
        [_cmdCache removeObjectForKey:[sc2.message objectForKey:TO_NS(kACTION_KEY)]];
        
        switch(sc2.packageLevel)
        {
            case Package_Normal:
                // do nothing
                break;
            case Package_Warning:
                sc2.callbackHandler(@{
                                      // 字典两个键值
                                      // 一  行为确认键和确认编码
                                      // 二  数据键和包内容
                                      TO_NS(kACTION_CONFIRM):[NSNumber numberWithInt:kEC_Timeout],
                                      @"Data":sc2.message,
                                      }
                                 );
                break;
            case Package_Restart:
            case Package_Fatal:
                sc2.callbackHandler(@{
                                      TO_NS(kACTION_CONFIRM):[NSNumber numberWithInt:kEC_Timeout_Relogin],
                                      @"Data" : sc2.message ,
                                      }
                                    );
                break;
        }
    }// 遍历数组完毕
    
    // 遍历重发数组
    for ( SocketCommand* sc3 in resentArray )
    {
        // 重新发送
        [self dispatchCommand:sc3];
    }
    
    for(SocketCommand* sc in _cmdQueue)
    {
        if ( (ct - sc.attachTime) > kNet_ShowBusy_TimeOut )
            totalRecall ++;
    }
    
    if ( self.busyTask.intValue  != totalRecall  )
    {
        _busyTask = [NSNumber numberWithInt:totalRecall];
    
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotif_Net_State object:nil userInfo:nil];
    }
}

@end
