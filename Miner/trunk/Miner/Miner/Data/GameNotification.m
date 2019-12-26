//
//  GameNotification.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-2.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "GameNotification.h"

@implementation GameNotification
static GameNotification* theGlobalGameNotification = nil;

+(GameNotification*)sharedInstance
{
    if ( theGlobalGameNotification == nil )
    {
        static dispatch_once_t gameNotificationOnce = 0;
        dispatch_once(&gameNotificationOnce, ^(void){
            theGlobalGameNotification = [[GameNotification alloc]initInstance];
        });
    }
    
    return theGlobalGameNotification;
}

-(id)initInstance
{
    self =[super init];
    
    self.viewNotificationCenter = [[NSNotificationCenter alloc]init];
    self.netNotificationCenter  = [[NSNotificationCenter alloc]init];
    self.eventNotificationCenter = [[NSNotificationCenter alloc]init];
    
    return self;
}

@end
