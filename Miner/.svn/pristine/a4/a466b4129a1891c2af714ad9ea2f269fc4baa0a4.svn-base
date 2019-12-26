//
//  HpTimerManager.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 15/1/5.
//  Copyright (c) 2015年 zhou gang. All rights reserved.
//

#import "HpTimerManager.h"
#include <sys/time.h>

@implementation HpTimerManager
{
    NSTimer* _timer;
    NSMutableSet* _timerHandlerCache;

    NSMutableSet* _timerHandlerWillAdd;
    NSMutableSet* _timerHandlerWillRemove;
    BOOL _timerIsValid;

    /* last time the main loop was updated */
    struct timeval _lastUpdate;
    /* delta time since last tick to main loop */
    NSTimeInterval _dt;
    /* whether or not the next delta time will be zero */
    BOOL _nextDeltaTimeZero;
}

+ (instancetype)shareManager
{
    static HpTimerManager* s_instance = nil;
    if (s_instance == nil) {
        s_instance = [[HpTimerManager alloc] init];
    }
    return s_instance;
}

- (id)init
{
    if (self = [super init]) {
        _timerHandlerCache = [[NSMutableSet alloc] init];
        _timerHandlerWillAdd = [[NSMutableSet alloc] init];
        _timerHandlerWillRemove = [[NSMutableSet alloc] init];
        _nextDeltaTimeZero = YES;
        _timerIsValid = NO;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive)
                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
    }

    return self;
}

- (void)addTimerHandler:(id<HpTimerHanlder>)target
{
    if ([_timerHandlerWillRemove member:target]) {
        [_timerHandlerWillRemove removeObject:target];
    }
    if (![_timerHandlerWillAdd member:target]) {
        [_timerHandlerWillAdd addObject:target];

        if ([_timerHandlerWillAdd count] == 1 && [_timerHandlerCache count] == 0) {
            [self startTimer];
        }
    }
}
- (void)removeTimerHandler:(id<HpTimerHanlder>)target
{
    if ([_timerHandlerWillAdd member:target]) {
        [_timerHandlerWillAdd removeObject:target];
    }
    else {
        [_timerHandlerWillRemove addObject:target];
    }
}

- (void)startTimer
{
    if (!_timerIsValid) {
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1/30.f target:self selector:@selector(onTimerUpdate) userInfo:nil repeats:YES];
        }

        [_timer setFireDate:[NSDate date]];

        _nextDeltaTimeZero = YES;
        _timerIsValid = YES;
    }
}

- (void)stopTimer
{
    if (_timerIsValid) {
        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:INT_MAX]];
        _timerIsValid = NO;
    }
}

- (void)onTimerUpdate
{
    [self calculateDeltaTime];

    [_timerHandlerCache unionSet:_timerHandlerWillAdd];
    [_timerHandlerWillAdd removeAllObjects];


    [_timerHandlerCache minusSet:_timerHandlerWillRemove];
    [_timerHandlerWillRemove removeAllObjects];


//    NSLog(@"calculateDeltaTime: %f\tFPS: %f count:%d", _dt, 1/_dt, (int)_timerHandlerCache.count);

    for (id<HpTimerHanlder> obj in _timerHandlerCache) {
        if ([obj respondsToSelector:@selector(onTimerUpdate:)]) {
            [obj onTimerUpdate:_dt];
        }
    }

    if ([_timerHandlerCache count] == 0) {
        [self stopTimer];
    }
}

-(void) calculateDeltaTime
{
    struct timeval now;

    if( gettimeofday( &now, NULL) != 0 ) {
        _dt = 0;
        return;
    }

    // new delta time
    if( _nextDeltaTimeZero ) {
        _dt = 0;
        _nextDeltaTimeZero = NO;
    } else {
        _dt = (now.tv_sec - _lastUpdate.tv_sec) + (now.tv_usec - _lastUpdate.tv_usec) / 1000000.0f;
        _dt = MAX(0,_dt);
    }

#ifdef DEBUG
    // If we are debugging our code, prevent big delta time
    if( _dt > 0.2f )
        _dt = 1/60.0f;
#endif

    _lastUpdate = now;
}

- (void)applicationDidEnterBackground
{
    if (_timerIsValid) {
        [self stopTimer];
        _timerIsValid = YES;
    }
}

- (void)applicationDidBecomeActive
{
    if (_timerIsValid) {
        _timerIsValid = NO;
        [self startTimer];
    }
}

@end
