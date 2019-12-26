//
//  HpBaseMacros.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/23.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>

#if __has_feature(objc_arc)

static inline id __SELF__(id it) { return it; }

#   define retain(id)           (__SELF__(id))
#   define release(id)          (__SELF__(id))
#   define autorelease(id)      (__SELF__(id))
#   define super_dealloc()      do {} while(0)

#   define retain_set(a, b)     (a) = (b)

#else

#   define retain(id)           [(id) retain]
#   define release(id)          [(id) release]
#   define autorelease(id)      [(id) autorelease]
#   define super_dealloc()      [super dealloc]

#   define retain_set(a, b)     do {retain(b); release(a); (a)=(b);} while(0)

#endif


#define static_member_(type, var, insttype)    \
- (type)var    \
{\
static type s_##var = nil;   \
if (s_##var == nil) { s_##var = [[insttype alloc] init]; }  \
return s_##var;   \
}

#define static_member(type, var, insttype)    \
+ (type)var    \
{\
static type s_##var = nil;   \
if (s_##var == nil) { s_##var = [[insttype alloc] init]; }  \
return s_##var;   \
}
