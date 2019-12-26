//
//  HpInterpHolder.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/23.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpInterpHolder.h"
#import "HpKeyframe.h"

#import "HpBaseMacros.h"
#import "HpExtensionMacros.h"

@implementation HpInterpHolder

-(id)init
{
    self = [super init];
    return self;
}

-(void)dealloc
{

    self.centerInterp = nil;
    self.scaleInterp = nil;
    self.transInterp = nil;
    self.skewInterp = nil;
    self.rotInterp = nil;
    self.colorInterp = nil;
    self.target = nil;
    super_dealloc();
}

-(CGPoint)getCenterAt:(float)time between:(HpKeyframe *)sender
{
    float f = [self.centerInterp getFactorWithStart:sender.time end:self.target.time at:time];
    return CGPointLerp(sender.center, self.target.center, f);
}

-(CGPoint)getScaleAt:(float)time between:(HpKeyframe *)sender
{
    float f = [self.scaleInterp getFactorWithStart:sender.time end:self.target.time at:time];
    return CGPointLerp(sender.scale, self.target.scale, f);
}

-(CGPoint)getSkewAt:(float)time between:(HpKeyframe *)sender
{
    float f = [self.skewInterp getFactorWithStart:sender.time end:self.target.time at:time];
    return CGPointLerp(sender.skew, self.target.skew, f);
}

-(CGPoint)getTransAt:(float)time between:(HpKeyframe *)sender
{
    float f = [self.transInterp getFactorWithStart:sender.time end:self.target.time at:time];
    return CGPointLerp(sender.trans, self.target.trans, f);
}

-(float)getRotAt:(float)time between:(HpKeyframe *)sender
{
    float f = [self.rotInterp getFactorWithStart:sender.time end:self.target.time at:time];
    return CGFloatLerp(sender.rot, self.target.rot, f);
}

-(UIColor*)getColorAt:(float)time between:(HpKeyframe *)sender
{
    float f = [self.colorInterp getFactorWithStart:sender.time end:self.target.time at:time];
    return UIColorLerp(sender.color, self.target.color, f);
}


@end
