//
//  HpKeyframe.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/23.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpKeyframe.h"
#import "HpBaseMacros.h"
#import "HpInterpHolder.h"


@implementation HpKeyframe

-(id)init
{
    if (self = [super init])
    {

    }
    return self;
}

-(void)dealloc
{
    release(self.content);
    release(self.event);
    release(self.color);
    release(self.interps);
    super_dealloc();
}


-(CGPoint)getCenterAt:(float)time
{
    if (self.interps) {
        return [self.interps getCenterAt:time between:self];
    }
    return self.center;
}

-(CGPoint)getScaleAt:(float)time
{
    if (self.interps) {
        return [self.interps getScaleAt:time between:self];
    }
    return self.scale;
}

-(CGPoint)getSkewAt:(float)time
{
    if (self.interps) {
        return [self.interps getSkewAt:time between:self];
    }
    return self.skew;
}

-(CGPoint)getTransAt:(float)time
{
    if (self.interps) {
        return [self.interps getTransAt:time between:self];
    }
    return self.trans;
}

-(CGFloat)getRotAt:(float)time
{
    if (self.interps) {
        return [self.interps getRotAt:time between:self];
    }
    return self.rot;
}

-(UIColor*)getColorAt:(float)time
{
    if (self.interps) {
        return [self.interps getColorAt:time between:self];
    }
    return self.color;
}
@end


//----------------------------------------------------------------------------------------

@implementation HpContentKeyframe

-(void)dealloc
{
    release(self.contentName);
    super_dealloc();
}

-(void)visitBy:(id <HpAnimVisitor>)visitor with:(HpKeyframe*)frm at:(float)time
{

}

-(HpContentKeyframe*)clone
{
    return nil;
}
@end

