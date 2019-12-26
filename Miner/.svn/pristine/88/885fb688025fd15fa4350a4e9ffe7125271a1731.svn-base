//
//  PackageError.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-4.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "PackageError.h"
#import "ExtraConfig.h"
#import "GameUI.h"

@implementation PackageError

-(void)handleErrorWithComCode:(NSInteger)comCode
{
    ExtraDef* def = [[ExtraConfig share] getExtraDefWithResultValue:comCode];
    [[GameUI sharedInstance] showError:def.cn title:@"error"];
}

@end
