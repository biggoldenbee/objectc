//
//  SocketCommand.h
//  Miner
//
//  Created by jim kaden on 14/10/24.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Haypi/Haypi.h"

@interface SocketCommand : NSObject
@property (nonatomic, strong) void (^callbackHandler)(NSDictionary*);   // 回调处理（参数是一个字典）
@property (nonatomic, strong) NSDictionary* message;                    // 消息内容字典
@property (nonatomic, assign) PACKAGE_LEVEL packageLevel;               // 消息包等级
@property (nonatomic, assign) int sentCount;                            // 发送总数
@property (nonatomic, assign) CFAbsoluteTime dispatchTime;              // 函数调度时间
@property (nonatomic, assign) CFAbsoluteTime attachTime;              // 第一次提交请求时间
@property (nonatomic, weak) NSNumber* uid;                              // user id
@end
