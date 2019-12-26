//
//  GameNotification.h
//  testMiner
//
//  Created by zhihua.qian on 14-12-2.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameNotification : NSObject
+(GameNotification*)sharedInstance;

@property (nonatomic, strong) NSNotificationCenter *viewNotificationCenter;     // 负责界面之间的消息传递
@property (nonatomic, strong) NSNotificationCenter *netNotificationCenter;      // 负责网络消息的请求
@property (nonatomic, strong) NSNotificationCenter *eventNotificationCenter;    // 负责界面之间的事件传递

@end
