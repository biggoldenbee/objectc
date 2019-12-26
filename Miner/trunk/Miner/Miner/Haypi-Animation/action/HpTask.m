//
//  HpTask.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 15/1/16.
//  Copyright (c) 2015年 zhou gang. All rights reserved.
//

#import "HpTask.h"
#import "HpBaseMacros.h"
#import "HpCharaInst.h"

@interface HpTask () <NSCopying>

- (NSMutableSet*)taskSet;

@end


@implementation HpTask
{
    BOOL _isManaged;
}

static_member_(NSMutableSet*, taskSet, NSMutableSet);

+ (instancetype)task
{
    return autorelease([[HpTask alloc] init]);
}

- (id)copyWithZone:(NSZone *)zone
{
    return retain(self);
}

- (void)start
{
    [self startWithManaged:YES];
}

- (void)finish
{
    if (_taskDelegate && [_taskDelegate respondsToSelector:@selector(onCharaTaskFinished:)]) {
        [_taskDelegate onCharaTaskFinished:self];
    }

    if (_isManaged) {
        [self.taskSet removeObject:self];
    }
}

- (void)startWithManaged:(BOOL)isManaged
{
    _isManaged = isManaged;
    if (_isManaged) {
        [self.taskSet addObject:self];
    }
}

@end


@interface HpCharaTask () <HpCharaInstObserver>

@end


@implementation HpCharaTask

+ (instancetype)task
{
    return autorelease([[HpCharaTask alloc] init]);
}

- (id)init
{
    if (self = [super init]) {
        self.scale = 1.0f;
        self.FPS = [HpCharaInst defaultFPS];
        self.attachs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    release(_target);
    release(_instFile);
    release(_animaName);
    release(_superview);
    release(_attachs);
    _delegate = nil;
    super_dealloc();
}


- (void)startWithManaged:(BOOL)isManaged
{
    [super startWithManaged:isManaged];

    if (_target == nil) {
        _target = [[HpCharaInst alloc] initWithFile:_instFile withScale:_scale];
    }

    if (_superview && _target.view.superview != _superview) {
        [_superview addSubview:_target.view];
    }

    [_target setDelegate:self];
    [_target setFPS:_FPS];
    [_target setPosition:_position];
    [_target playAnima:_animaName isLoop:_loop isDestroy:_autoDestroy];

    for (HpAttach* attach in _attachs) {
        [_target attach:attach.view toLayer:attach.layer];
    }
}

- (void)charaInst:(HpCharaInst*)inst onCustomEvent:(NSString*)event
{
    if (_delegate && [_delegate respondsToSelector:@selector(charaInst:onCustomEvent:)]) {
        [_delegate charaInst:inst onCustomEvent:event];
    }
}

- (void)charaInst:(HpCharaInst*)inst onAnimationEnd:(NSString *)anima
{
    if (_delegate && [_delegate respondsToSelector:@selector(charaInst:onAnimationEnd:)]) {
        [_delegate charaInst:inst onAnimationEnd:anima];
    }

    [self finish];
}

@end


@implementation HpSelectorTask

+ (instancetype)taskWithInvocation:(NSInvocation*)invocation
{
    return autorelease([[HpSelectorTask alloc] initWithInvocation:invocation]);
}

- (instancetype)initWithInvocation:(NSInvocation*)invocation
{
    if (self = [super init]) {
        _invocation = retain(invocation);
    }
    return self;
}

+ (instancetype)taskWith:(id)target selector:(SEL)selector
{
    return autorelease([[HpSelectorTask alloc] initWith:target selector:selector]);
}

+ (instancetype)taskWith:(id)target selector:(SEL)selector args:(id)args
{
    return autorelease([[HpSelectorTask alloc] initWith:target selector:selector args:args]);
}

+ (instancetype)taskWith:(id)target selector:(SEL)selector arg1:(id)arg1 arg2:(id)arg2
{
    return autorelease([[HpSelectorTask alloc] initWith:target selector:selector arg1:arg1 arg2:arg2]);
}

- (instancetype)initWith:(id)target selector:(SEL)selector
{
    return [self initWith:target selector:selector args:nil];
}

- (instancetype)initWith:(id)target selector:(SEL)selector args:(id)args
{
    return [self initWith:target selector:selector arg1:args arg2:nil];
}

- (instancetype)initWith:(id)target selector:(SEL)selector arg1:(id)arg1 arg2:(id)arg2
{
    if (self = [super init]) {
        NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:selector]];
        invocation.selector = selector;
        invocation.target = target;
        if(arg1) [invocation setArgument:(void*)&arg1 atIndex:2];
        if(arg2) [invocation setArgument:(void*)&arg2 atIndex:3];
        [invocation retainArguments];
        _invocation = retain(invocation);
    }
    return self;
}

- (void)dealloc
{
    release(_invocation);
    super_dealloc();
}

- (void)startWithManaged:(BOOL)isManaged
{
    [super startWithManaged:isManaged];
    [_invocation invoke];
    [self finish];
}

@end


@interface HpSequenceTask () <HpTaskDelegate>

@end


@implementation HpSequenceTask
{
    int _currTaskIndex;
    id<HpTaskDelegate> _currTaskDelegate;
}

+ (instancetype)taskWithArray:(NSArray*)array
{
    return autorelease([[HpSequenceTask alloc] initWithArray:array]);
}

- (instancetype)init
{
    if (self = [super init]) {
        _tasks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray*)array
{
    if (self = [super init]) {
        _tasks = [[NSMutableArray alloc] initWithArray:array];
    }
    return self;
}

- (void)dealloc
{
    release(_tasks);
    super_dealloc();
}

- (void)startWithManaged:(BOOL)isManaged
{
    [super startWithManaged:isManaged];
    [self startTaskAtIndex:0];
}

- (void)startTaskAtIndex:(int)idx
{
    if (idx < _tasks.count) {
        _currTaskIndex = idx;
        HpTask* task = [_tasks objectAtIndex:idx];
        _currTaskDelegate = task.taskDelegate;
        task.taskDelegate = self;
        [task startWithManaged:NO];
    }
    else {
        [self finish];
    }
}

- (void)onCharaTaskFinished:(HpTask*)task
{
    task.taskDelegate = _currTaskDelegate;
    if (task.taskDelegate && [task.taskDelegate respondsToSelector:@selector(onCharaTaskFinished:)]) {
        [task.taskDelegate onCharaTaskFinished:task];
    }

    [self startTaskAtIndex:_currTaskIndex+1];

}

@end


@interface HpRepeatTask () <HpTaskDelegate>

@end


@implementation HpRepeatTask
{
    id<HpTaskDelegate> _innerTaskDelegate;
    int _curRepeatNum;
}

+ (instancetype)taskWithTask:(HpTask*)task times:(int)times
{
    return autorelease([[HpRepeatTask alloc] initWithTask:task times:times]);
}

- (instancetype)initWithTask:(HpTask*)task times:(int)times
{
    if (self = [super init]) {
        _task = retain(task);
        _times = times;
    }
    return self;
}

- (void)dealloc
{
    release(_task);
    super_dealloc();
}

- (void)startWithManaged:(BOOL)isManaged
{
    [super startWithManaged:isManaged];
    _innerTaskDelegate = _task.taskDelegate;
    _task.taskDelegate = self;
    _curRepeatNum = 0;

    [_task startWithManaged:NO];
}

- (void)onCharaTaskFinished:(HpTask*)task
{
    if (_innerTaskDelegate && [_innerTaskDelegate respondsToSelector:@selector(onCharaTaskFinished:)]) {
        [_innerTaskDelegate onCharaTaskFinished:task];
    }

    _curRepeatNum++;

    if (_curRepeatNum == _times) {
        _task.taskDelegate = _innerTaskDelegate;
        [self finish];
    }
    else {
        [_task startWithManaged:NO];
    }
}

@end


@interface HpRepeatForeverTask () <HpTaskDelegate>

@end


@implementation HpRepeatForeverTask
{
    id<HpTaskDelegate> _innerTaskDelegate;
}

+ (instancetype)taskWithTask:(HpTask*)task
{
    return autorelease([[HpRepeatForeverTask alloc] initWithTask:task]);
}

- (instancetype)initWithTask:(HpTask*)task
{
    if (self = [super init]) {
        _task = retain(task);
    }
    return self;
}

- (void)dealloc
{
    release(_task);
    super_dealloc();
}

- (void)startWithManaged:(BOOL)isManaged
{
    [super startWithManaged:isManaged];
    _innerTaskDelegate = _task.taskDelegate;
    _task.taskDelegate = self;

    [_task startWithManaged:NO];
}

- (void)onCharaTaskFinished:(HpTask*)task
{
    if (_innerTaskDelegate && [_innerTaskDelegate respondsToSelector:@selector(onCharaTaskFinished:)]) {
        [_innerTaskDelegate onCharaTaskFinished:task];
    }

    [_task startWithManaged:NO];
}

@end


@interface HpSpawnTask () <HpTaskDelegate>


@end


@implementation HpSpawnTask
{
    int _tasktaskDelegateNum;
    NSMutableDictionary* _taskDelegateMap;

}

+ (instancetype)taskWithArray:(NSArray*)array
{
    return autorelease([[HpSpawnTask alloc] initWithArray:array]);
}

- (instancetype)init
{
    if (self = [super init]) {
        _tasks = [[NSMutableArray alloc] init];
        _taskDelegateMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray*)array
{
    if (self = [super init]) {
        _tasks = [[NSMutableArray alloc] initWithArray:array];
        _taskDelegateMap = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    release(_tasks);
    super_dealloc();
}

- (void)startWithManaged:(BOOL)isManaged
{
    [super startWithManaged:isManaged];
    _tasktaskDelegateNum = 0;

    for (HpTask* task in _tasks) {
        [_taskDelegateMap setObject:task.taskDelegate ? (id)task.taskDelegate : [NSNull null] forKey:task];
    }

    for (HpTask* task in _tasks) {
        [task startWithManaged:NO];
    }
}

- (void)onCharaTaskFinished:(HpTask*)task
{
    id<HpTaskDelegate> innerTaskDelegate = _taskDelegateMap[task];
    if (innerTaskDelegate && [innerTaskDelegate respondsToSelector:@selector(onCharaTaskFinished:)]) {
        [innerTaskDelegate onCharaTaskFinished:task];
    }

    _tasktaskDelegateNum++;

    if (_tasktaskDelegateNum == _tasks.count) {
        for (HpTask* task in _tasks) {
            task.taskDelegate = _taskDelegateMap[task] == [NSNull null] ? nil : _taskDelegateMap[task];
        }
        [_taskDelegateMap removeAllObjects];
        [self finish];
    }
}


@end

