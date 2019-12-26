//
//  HpTimerManager.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 15/1/5.
//  Copyright (c) 2015年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HpTimerHanlder <NSObject>

@required
- (void)onTimerUpdate:(NSTimeInterval)dt;

@end


@interface HpTimerManager : NSObject

+ (instancetype)shareManager;

- (void)addTimerHandler:(id<HpTimerHanlder>)target;
- (void)removeTimerHandler:(id<HpTimerHanlder>)target;

@end
