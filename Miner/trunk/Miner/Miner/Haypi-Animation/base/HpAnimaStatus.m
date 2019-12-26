//
//  HpAnimaStatus.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpAnimaStatus.h"
#import "HpBaseMacros.h"
#import "HpStack.h"

@interface HpStatusCache : NSObject

+ (id)shareCache;

- (void)recycleAS:(id)status;
- (id)requestAS;

- (void)recycleLS:(id)status;
- (id)requestLS;

@end

// ==== HpLayerStatus ================================
#pragma HpLayerStatus

@implementation HpLayerStatus
{
    HpAnimaStatus* _subani_status;
}

+ (id)status
{
    return [[HpStatusCache shareCache] requestLS];
}

- (void)recycle
{
    if (_subani_status) {
        [[HpStatusCache shareCache] recycleAS:_subani_status];
        _subani_status = nil;
    }
}

- (HpAnimaStatus*)getSubAS
{
    if (_subani_status == nil) {
        _subani_status = [[HpStatusCache shareCache] requestAS];
    }
    return _subani_status;
}

@end

// ==== HpAnimaStatus ================================
#pragma HpAnimaStatus

@implementation HpAnimaStatus
{
    NSMutableArray* _layer_status_list;
}

+ (id)status
{
    return [[HpStatusCache shareCache] requestAS];
}

- (id)init
{
    if (self = [super init]) {
        _layer_status_list = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    release(_layer_status_list);
    super_dealloc();
}


+ (void)recycle:(id)status
{
    [[HpStatusCache shareCache] recycleAS:status];
}

- (void)recycle
{
    for (HpLayerStatus* ls in _layer_status_list) {
        [[HpStatusCache shareCache] recycleLS:ls];
    };
    [_layer_status_list removeAllObjects];
}

- (void)setLastGKey:(HpKeyframe *)gkey lastCKey:(HpContentKeyframe *)ckey
{
    if (self.layerIndex > _layer_status_list.count) {
        NSAssert(0, @"Invalid LayIndex - HpAnimaStatus:SetLastGKey LastCkey");
    }
    if (self.layerIndex == _layer_status_list.count) {
        HpLayerStatus* ls = [[HpStatusCache shareCache] requestLS];
        ls.LastGKey = gkey;
        ls.LastCKey = ckey;
        [_layer_status_list addObject:ls];
    }
    else {
        HpLayerStatus* ls = [_layer_status_list objectAtIndex:self.layerIndex];
        ls.LastGKey = gkey;
        ls.LastCKey = ckey;
    }
}

- (void)clearSubAS
{
    [[_layer_status_list objectAtIndex:self.layerIndex] recycle];
}

- (HpAnimaStatus*)getSubAS
{
    return [[_layer_status_list objectAtIndex:self.layerIndex] getSubAS];
}

- (HpKeyframe*)getLastGKey
{
    HpLayerStatus* ls = [_layer_status_list objectAtIndex:self.layerIndex];
    return ls.lastGKey;
}

- (HpContentKeyframe*)getLastCKey
{
    HpLayerStatus* ls = [_layer_status_list objectAtIndex:self.layerIndex];
    return ls.lastCKey;
}

@end


// ==== HpStatusCache ================================
#pragma HpStatusCache

@implementation HpStatusCache
{
    HpStack* _layer_status_pool;
    HpStack* _anima_status_pool;
}

+ (id)shareCache
{
    static HpStatusCache* s_cache = nil;
    if (s_cache == nil) {
        s_cache = [[HpStatusCache alloc] init];
    }
    return s_cache;
}

- (id)init
{
    if (self = [super init]) {
        _layer_status_pool = [[HpStack alloc] init];
        _anima_status_pool = [[HpStack alloc] init];
    }
    return self;
}

- (void) dealloc
{
    release(_layer_status_pool);
    release(_anima_status_pool);
    super_dealloc();
}

- (id)requestAS
{
    if (_anima_status_pool.count > 0) {
        return [_anima_status_pool pop];
    }
    return [[HpAnimaStatus alloc] init];
}

- (void)recycleAS:(id)as
{
    if ([as isKindOfClass:[HpAnimaStatus class]]) {
        [as recycle];
        [_anima_status_pool push:as];
    }
}

- (id)requestLS
{
    if (_layer_status_pool.count > 0) {
        return [_layer_status_pool pop];
    }
    return [[HpLayerStatus alloc] init];
}

- (void)recycleLS:(id)ls
{
    if ([ls isKindOfClass:[HpLayerStatus class]]) {
        [ls recycle];
        [_layer_status_pool push:ls];
    }
}

@end

