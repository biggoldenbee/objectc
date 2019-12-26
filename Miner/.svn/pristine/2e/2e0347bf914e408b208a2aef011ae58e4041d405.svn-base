//
//  HpStack.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpStack.h"
#import "HpBaseMacros.h"

@implementation HpStack

- (id)init
{
    if (self = [super init])
        _array = [[NSMutableArray alloc] init];
    return self;
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    if (self = [super init])
        _array = [[NSMutableArray alloc] initWithCapacity:numItems];
    return self;
}

- (void)dealloc
{
    release(_array);
    super_dealloc();
}

- (void)push:(id)item
{
    [_array addObject:item];
}

- (id)pop
{
    if (_array.count > 0)
    {
        id item = [_array objectAtIndex:_array.count - 1];
        [_array removeObjectAtIndex:_array.count - 1];
        return item;
    }
    return nil;
}

- (id)peek
{
    if (_array.count > 0)
    {
        return [_array objectAtIndex:_array.count - 1];
    }
    return nil;
}

- (void)clear
{
    [_array removeAllObjects];
}

- (NSInteger)count
{
    return _array.count;
}

- (NSArray*)toArray
{
    return _array;
}

@end


