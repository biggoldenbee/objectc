//
//  HpCharactor.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpCharactor.h"
#import "HpAnimation.h"
#import "HpAnimVisitor.h"
#import "HpBaseMacros.h"

@implementation HpCharactor

-(id)init
{
    if (self=[super init]) {
        _plists = [[NSMutableArray alloc] init];
        _animas = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc
{
    release(_plists);
    release(_animas);
    super_dealloc();
}

@end
