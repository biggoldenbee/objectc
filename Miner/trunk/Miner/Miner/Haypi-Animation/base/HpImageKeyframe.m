//
//  HpImageKeyframe.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpImageKeyframe.h"
#import "HpBaseMacros.h"

@interface HpImageKeyframe (private)
-(id)initWithHpImageKeyframe:(HpImageKeyframe*)image;
@end

@implementation HpImageKeyframe

-(void)dealloc
{
    release(_spriteframe);
    super_dealloc();
}

-(void)visitBy:(id<HpAnimVisitor>)visitor with:(HpKeyframe*)frm at:(float)time
{
    return [visitor visitImageKey:self with:frm at:time];
}

-(HpContentKeyframe*)clone
{
    return [[HpImageKeyframe alloc] initWithHpImageKeyframe:self];
}

-(id)initWithHpImageKeyframe:(HpImageKeyframe *)image
{
    if (self = [super init]) {
        self.time = image.time;
        self.contentName = image.contentName;
        self.spriteframe = image.spriteframe;
    }
    return self;
}
@end
