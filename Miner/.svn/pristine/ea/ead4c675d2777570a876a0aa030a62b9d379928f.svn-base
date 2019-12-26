//
//  HpAnimaStatus.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HpKeyframe;
@class HpContentKeyframe;

@interface HpAnimaStatus : NSObject

@property(readwrite, nonatomic) uint layerIndex;
@property(readwrite, nonatomic) NSTimeInterval elapsed;

+ (id)status;
+ (void)recycle:(id)status;

- (void)recycle;

- (void)setLastGKey:(HpKeyframe*)gkey lastCKey:(HpContentKeyframe*)ckey;
- (HpKeyframe*)getLastGKey;
- (HpContentKeyframe*)getLastCKey;
- (void)clearSubAS;
- (HpAnimaStatus*)getSubAS;

@end



@interface HpLayerStatus : NSObject

@property(readwrite, nonatomic, assign) HpKeyframe* lastGKey;
@property(readwrite, nonatomic, assign) HpContentKeyframe* lastCKey;


+ (id)status;
- (void)recycle;
- (HpAnimaStatus*)getSubAS;

@end
