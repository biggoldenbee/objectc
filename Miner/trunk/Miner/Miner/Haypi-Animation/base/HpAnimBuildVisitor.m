//
//  HpAnimBuildVisitor.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpAnimBuildVisitor.h"
#import "HpAnimation.h"
#import "HpLayer.h"
#import "HpInterpHolder.h"
#import "HpImageKeyframe.h"
#import "HpAnimaKeyframe.h"
#import "HpCharactor.h"
#import "HpBaseMacros.h"
#import "HpCharactorCache.h"


@interface HpAnimBuildVisitor ()
{
    HpCharactorCache* _cache;
}

@end

@implementation HpAnimBuildVisitor

-(id)init
{
    if (self = [super init]) {

    }
    return self;
}

-(void)dealloc
{
    _cache = nil;
    super_dealloc();
}

-(void)begin:(id)map
{
    NSAssert([map isKindOfClass:[HpCharactorCache class]], @"Invalid target-HpAnimBuildVistor:Begin");
    _cache = map;
}

-(void)end
{
    _cache = nil;
}

-(void)visitAnima:(HpAnimation*)ani firstly:(BOOL)first at:(float)time
{
    for (HpLayer* layer in ani.layers)
        [self visitLayer:layer firstly:first at:time];
}

-(void)visitLayer:(HpLayer*)layer firstly:(BOOL)first at:(float)time
{
    [layer build];

    for (int i = 0; i < layer.keys.count; ++ i)
    {
        HpKeyframe* frm = [layer.keys objectAtIndex:i];
        if (frm.interps) {
            HpKeyframe* next_frm = [layer.keys objectAtIndex:i + 1];
            [frm.interps setTarget:next_frm];
        }
    }

    for (HpContentKeyframe* k in layer.contentKeys) {
        [k visitBy:self with:nil at:0];
    }
}


-(void)visitNullKey:(HpNullKeyFrame*)nkf with:(HpKeyframe*)frm at:(float)time
{

}

-(void)visitImageKey:(HpImageKeyframe*)ikf with:(HpKeyframe*)frm at:(float)time
{
    ikf.spriteframe = [_cache spriteFrameByName:ikf.contentName];
}

-(void)visitAnimaKey:(HpAnimaKeyframe*)akf with:(HpKeyframe*)frm at:(float)time
{
    akf.anima = [_cache animtionByName:akf.contentName];

}

@end
