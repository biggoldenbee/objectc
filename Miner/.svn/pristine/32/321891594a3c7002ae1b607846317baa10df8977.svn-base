//
//  HpLayer.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpLayer.h"
#import "HpKeyframe.h"
#import "HpNullKeyframe.h"
#import "HpImageKeyframe.h"
#import "HpAnimaKeyframe.h"

#import "HpBaseMacros.h"

@interface HpLayer (private)

-(id)initWithHpLayer:(HpLayer*)layer;
-(void)indexGeneralKeys;
-(void)buildContentKeys;

@end

@implementation HpLayer

-(id)initWithName:(NSString *)name
{
    if (self = [super init])
    {
        _name = retain(name);
        _duration = 0;
        _keys = [[NSMutableArray alloc] init];
        _indexer = [[NSMutableArray alloc] init];
        _indexOffset = 0;
        _contentKeys = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithHpLayer:(HpLayer *)layer
{
    if (self = [super init]) {
        _name = retain(layer.name);
        _duration = layer.duration;
        _keys = retain(layer.keys);
        _indexer = retain(layer.indexer);
        _indexOffset = layer.indexOffset;
        _contentKeys = [[NSMutableArray alloc] initWithCapacity:layer.contentKeys.count];
        for (HpContentKeyframe* ckf in layer.contentKeys) {
            HpContentKeyframe* new_ckf = [ckf clone];
            [self.contentKeys addObject:new_ckf];
            release(new_ckf);
        }
    }
    return self;
}

-(HpLayer*)clone
{
    return [[HpLayer alloc] initWithHpLayer:self];
}

-(void)dealloc
{
    release(_name);
    release(_contentKeys);
    release(_indexer);
    release(_keys);
    super_dealloc();
}

-(void)buildContentKeys
{
    HpKeyframe* last = nil;
    for (HpKeyframe* k in self.keys) {
        if (last == nil || k.contentType != last.contentType || ![k.content isEqualToString:last.content]) {
            HpContentKeyframe* cf = nil;
            if (k.contentType == HpContentType_Image) {
                cf = [[HpImageKeyframe alloc] init];
            }
            else if (k.contentType == HpContentType_Anima) {
                cf = [[HpAnimaKeyframe alloc] init];
            }
            else {
                cf = [[HpNullKeyframe alloc] init];
            }
            cf.time = k.time;
            cf.contentName = k.content;
            [self.contentKeys addObject:cf];
            release(cf);
        }
        last = k;
    }
}

-(void)indexGeneralKeys
{
    if (self.keys.count == 0) {
        _indexOffset = 0;
        _duration = 0;
    }
    else {
        int i = 0;
        int gindex_start = _indexOffset = ((HpKeyframe*)[_keys objectAtIndex:0]).time;
        for (HpKeyframe* k in self.keys) {

            for (int j = gindex_start; j < k.time; ++ j) {
                [self.indexer addObject:[self.keys objectAtIndex:i - 1]];
            }
            gindex_start = k.time;
            ++ i;
        }
        [self.indexer addObject:[_keys objectAtIndex:_keys.count - 1]];
        _duration = (int)self.indexer.count + self.indexOffset;
    }

}

-(void)build
{
    if (_contentKeys.count == 0) {
        [self indexGeneralKeys];
        [self buildContentKeys];
    }
}


-(HpKeyframe*)getKeyframeAt:(int)idx
{
    if (self.duration == 0 || self.indexer == NULL || idx < self.indexOffset)
        return NULL;
    if (idx >= self.duration)
        idx = self.duration - 1;
    return [self.indexer objectAtIndex:idx - self.indexOffset];
}

-(HpContentKeyframe*)getContentKeyframeAt:(float)idx
{
    if ([self.contentKeys count] == 0)return nil;

    int i = (int)self.contentKeys.count - 1;
    HpContentKeyframe* ck = [self.contentKeys objectAtIndex:i];
    while (idx < ck.time) {
        if (i == 0)
            return  nil;
        ck = [self.contentKeys objectAtIndex:-- i];
    }
    return ck;
}

-(void)replaceContent:(NSString *)name with:(HpContentKeyframe *)content
{
    for (int i = 0; i < self.contentKeys.count; ++ i) {
        HpContentKeyframe* ck = [self.contentKeys objectAtIndex:i];
        if ([ck.contentName isEqualToString:name]) {
            HpContentKeyframe* new = [content clone];
            new.contentName = ck.contentName;
            new.time = ck.time;
            [self.contentKeys replaceObjectAtIndex:i withObject:new];
            release(new);
        }
    }
}
@end
