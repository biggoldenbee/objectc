//
//  HpAnimaKeyframe.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpAnimaKeyframe.h"
#import "HpBaseMacros.h"

@interface HpAnimaKeyframe (private)
-(id)initWithHpAnimaKeyframe:(HpAnimaKeyframe*)anima;
@end

@implementation HpAnimaKeyframe

-(void)dealloc
{
    release(_anima);
    super_dealloc();
}

-(void)visitBy:(id<HpAnimVisitor>)visitor with:(HpKeyframe*)frm at:(float)time
{
    [visitor visitAnimaKey:self with:frm at:time];
}

-(HpContentKeyframe*)clone
{
    return [[HpAnimaKeyframe alloc] initWithHpAnimaKeyframe:self];
}

-(id)initWithHpAnimaKeyframe:(HpAnimaKeyframe *)anima
{
    if (self = [super init]) {
        self.time = anima.time;
        self.contentName = anima.contentName;
        self.anima = anima.anima;
    }
    return self;
}

@end
