//
//  HpAnimation.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpAnimation.h"
#import "HpLayer.h"
#import "HpBaseMacros.h"


@interface HpAnimation (private)

-(id)initWithHpAnimation:(HpAnimation*)ani;
-(int)findLayerByName:(NSString*)name;

@end

@implementation HpAnimation

-(id)initWithName:(NSString*)name length:(NSInteger)len
{
    if (self = [super init])
    {
        _name = retain(name);
        _length = len;
        _layers = [[NSMutableArray alloc] init];
    }
    return self;
}

-(id)initWithHpAnimation:(HpAnimation *)ani
{
    if (self = [super init]) {
        _length = ani.length;
        _name = retain(ani.name);
        _layers = [[NSMutableArray alloc] init];
        for (HpLayer* src_layer in ani.layers) {
            HpLayer* l = [src_layer clone];
            [_layers addObject:l];
            release(l);
        }
    }
    return self;
}

-(HpAnimation*)clone
{
    return [[HpAnimation alloc] initWithHpAnimation:self];
}

-(void)dealloc
{
    release(_name);
    release(_layers);
    super_dealloc();
}

-(HpLayer*)getLayerByName:(NSString *)name
{
    for (HpLayer* layer in self.layers) {
        if ([layer.name isEqualToString:name]) {
            return layer;
        }
    }
    return nil;
}


-(BOOL)insertLayer:(HpLayer *)layer beforeLayer:(NSString *)target
{
    if (layer == nil) {
        return NO;
    }

    int idx = [self findLayerByName:target];
    if (idx == self.layers.count) {
        return NO;
    }

    [self.layers insertObject:layer atIndex:idx];
    return YES;
}

-(BOOL)replaceLayer:(NSString *)target with:(HpLayer *)layer
{
    if (layer == nil) {
        return NO;
    }
    int idx = [self findLayerByName:target];
    if (idx == self.layers.count) {
        return NO;
    }

    [self.layers replaceObjectAtIndex:idx withObject:layer];
    return YES;
}

-(void)replaceContent:(NSString *)content inLayer:(NSString *)layer with:(HpContentKeyframe *)ckf
{
    if (layer) {
        HpLayer* l = [self getLayerByName:layer];
        if (l) {
            [l replaceContent:content with:ckf];
        }
    }
    else {
        for (HpLayer* l in self.layers) {
            [l replaceContent:content with:ckf];
        }
    }
}

-(int)findLayerByName:(NSString*)name
{
    if (name == nil) {
        return (int)self.layers.count;
    }

    int i = 0;
    for (HpLayer* l in self.layers) {
        if ([l.name isEqualToString:name]) {
            break;
        }
        ++ i;
    }
    return i;
}

@end