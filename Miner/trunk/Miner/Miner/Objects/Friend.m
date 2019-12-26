//
//  Friend.m
//  Miner
//
//  Created by zhihua.qian on 14-12-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(void)setDataWithDictionary:(NSDictionary*)data
{
    self.friendId = [data objectForKey:@"MID"];
    self.friendName = [data objectForKey:@"Name"];
    self.portId = [data objectForKey:@"HID"];
}

@end
