//
//  NetManager.h
//  Miner
//  NetManager
//  处理网络相关的一切消息
//  Created by jim kaden on 14/10/23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Haypi/Haypi.h"
#import "CommonDef.h"

@interface NetManager : NSObject < LoginFunctionProtocol, LoginMainWindowDelegate, LoginWindowDelegate, SocketReceiveDelegate >
{
}

@property (nonatomic, readonly, weak) NSNumber* uid;
@property (nonatomic, readonly, weak) NSNumber* busyTask;       // 发送后超过指定秒数任然没有回应的消息数量, 通过监控kNotif_Net_State可以获得通知刷新此变量
+(NetManager*)sharedInstance;

// Passport
// completion 是唯一的，全局的回调接口
-(void)reset;
-(void)start:(BOOL)isFake completion:(void (^)(NSDictionary*))completion;
-(void)login:(BOOL)isFake name:(NSString*)name password:(NSString*)password completion:(void (^)(NSDictionary*))completion;

// Game Server
// 每个消息都可以设置不同的completion
-(BOOL)connectToServer;
-(void)disconnect;
-(BOOL)sendMessage:(NSDictionary*)message packageLevel:(PACKAGE_LEVEL)packageLevel completion:(void (^)(NSDictionary*))completion;
@end