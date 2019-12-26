//
//  HpRenderVisitorStack.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpRenderVisitorStack.h"
#import "HpBaseMacros.h"

@implementation HpAffineTransformStack

-(id)initWithCapacity:(int)capacity
{
    if (self = [super init])
    {
        _capacity = MAX(1, capacity);
        _top = 0;
        _array = malloc(_capacity * sizeof(CGAffineTransform));
    }
    return self;
}

-(void)dealloc
{
    free(_array);
    super_dealloc();
}

-(CGAffineTransform*)pop
{
    if (_top > 0)
        return &_array[-- _top];
    return NULL;
}

-(CGAffineTransform*)peek
{
    if (_top > 0)
        return &_array[_top - 1];
    return NULL;
}

-(void)push:(CGAffineTransform*)tf
{
    if (_capacity == _top)
        [self resize:2 * _capacity];
    _array[_top ++] = *tf;
}

-(void)resize:(int)capacity
{
    if (capacity < MAX(_top, 1))
        return;
    CGAffineTransform* new_array = malloc(capacity * sizeof(CGAffineTransform));
    memcpy(new_array, _array, _top * sizeof(CGAffineTransform));
    free(_array);
    _array = new_array;
}

@end

@implementation HpColorStack

-(id)initWithCapacity:(int)capacity
{
    if (self = [super init])
    {
        _capacity = MAX(1, capacity);
        _top = 0;
        _array = [[NSMutableArray alloc] initWithCapacity:_capacity];
    }
    return self;
}

-(void)dealloc
{
    release(_array);
    super_dealloc();
}

-(UIColor*)pop
{
    if (_top > 0)
        return _array[-- _top];
    return NULL;
}

-(UIColor*)peek
{
    if (_top > 0)
        return _array[_top - 1];
    return NULL;
}

-(void)push:(UIColor*)tac
{
    if (_capacity == _top)
        [self resize:2 * _capacity];
    _array[_top ++] = tac;
}

-(void)resize:(int)capacity
{
    if (capacity < MAX(_top, 1))
        return;

    for (int i=_capacity; i<capacity; i++) {
        [_array addObject:[NSNull null]];
    }

    _capacity = capacity;

}

@end
