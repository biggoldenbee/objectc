//
//  HpStack.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HpStack : NSObject
{
    NSMutableArray* _array;
}

- (id)init;
- (id)initWithCapacity:(NSUInteger)numItems;
- (void)dealloc;

- (void)push:(id)item;
- (id)pop;
- (id)peek;
- (void)clear;

- (NSInteger)count;
- (NSArray*)toArray;


@end