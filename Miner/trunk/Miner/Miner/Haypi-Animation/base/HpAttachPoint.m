//
//  HpAttachPoint.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpAttachPoint.h"
#import "HpLayer.h"
#import "HpBaseMacros.h"

@implementation HpAttachPoint


-(id)init
{
    if (self = [super init]) {
        _object_attached = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc
{
    release(_layerName);
    release(_layerInst);
    super_dealloc();
}

-(void)attach:(id)obj
{
    int i = 0;
    for (; i < _object_attached.count; ++ i) {
        if ([_object_attached objectAtIndex:i] == obj) {
            break;
        }
    }
    if (i == _object_attached.count) {
        [_object_attached addObject:obj];
    }
}

-(void)apply
{
    if (self.layerInst) {
        for (UIView* obj in _object_attached) {
            obj.transform = CGAffineTransformConcat(obj.transform, _layerInst.transform);
        }
    }
}

-(void)clear
{
    if (self.layerInst) {
        for (UIView* obj in _object_attached) {
            obj.transform = CGAffineTransformIdentity;
        }
    }
}

-(void)remove:(id)obj
{
    [_object_attached removeObject:obj];
}
@end
