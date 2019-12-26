//
//  HpLinearInterpolator.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpLinearInterpolator.h"
#import "HpBaseMacros.h"

@implementation HpLinearInterp

-(float)getFactorWithStart:(int)t1 end:(int)t2 at:(float)t;
{
    return (float)(t - t1)/(t2 - t1);
}

static HpLinearInterp* s_linearInterp = nil;

+(id)interp
{
    if (s_linearInterp == nil)
        s_linearInterp = [[HpLinearInterp alloc] init];
    return s_linearInterp;
}

+(void)purge
{
    release(s_linearInterp);
}

@end
