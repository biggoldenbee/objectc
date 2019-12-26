//
//  HpCharaInst.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpCharaInst.h"
#import "HpBaseMacros.h"
#import "HpCharactor.h"
#import "HpExtensionMacros.h"
#import "HpAnimVisitor.h"
#import "HpAnimaStatus.h"
#import "HpAttachPoint.h"
#import "HpAnimation.h"
#import "HpTimerManager.h"
#import "HpCharactorCache.h"

static CGFloat s_charainst_fps = 30.f;

@interface HpCharaInst () <HpTimerHanlder>
{
    HpCharactor* _charactor;
    BOOL _isDirty;

    UIView* _view;
    UIView* _animaview;
    UIView* _attachView;
    CCNode* _node;

    NSMutableArray* _attach_list;
}

@end


@implementation HpCharaInst
{

}

@synthesize view = _view;
@synthesize node = _node;

+ (instancetype)inst
{
    return autorelease([[HpCharaInst alloc] init]);
}

- (instancetype)init
{
    return [self initWithFile:@""];
}

+ (instancetype)instWithFile:(NSString*)instfile
{
    return autorelease([[HpCharaInst alloc] initWithFile:instfile]);
}

- (instancetype)initWithFile:(NSString*)instfile
{
    return [self initWithFile:instfile withScale:1.f];
}

+ (instancetype)instWithFile:(NSString*)instfile withScale:(CGFloat)scale
{
    return autorelease([[HpCharaInst alloc] initWithFile:instfile withScale:scale]);
}

- (instancetype)initWithFile:(NSString*)instfile withScale:(CGFloat)scale
{
    if (self = [super init]) {
        _status = [HpAnimaStatus status];
        _attach_list = [[NSMutableArray alloc] init];
        _cache = [[HpCharactorCache alloc] init];
        _FPS = s_charainst_fps;
        [self loadInstFile:instfile withScale:scale];
    }

    return self;
}

- (void)dealloc
{
    _delegate = nil;
    _currAnimation = nil;

    [HpAnimaStatus recycle:_status];

    release(_charactor);
    release(_instFileName);
    release(_currAnimaName);
    release(_attach_list);
    release(_animaview);
    release(_attachView);
    release(_node);
    release(_cache);
    super_dealloc();
}

- (UIView*)view
{
    NSAssert(_node == nil, @"The `view` is invalid when being had a `node`!");
    if (_view == nil) {
        _view = [[UIView alloc] init];
        _animaview = [[UIView alloc] init];
        _attachView = [[UIView alloc] init];
        [_view addSubview:_animaview];
        [_view addSubview:_attachView];
    }

    return _view;
}

- (CCNode*)node
{
    return _node;
}

- (void)playAnima:(NSString*)name isLoop:(BOOL)isLoop
{
    [self playAnima:name isLoop:isLoop isDestroy:NO];
}

- (void)playAnima:(NSString*)name isDestroy:(BOOL)isDestroy
{
    [self playAnima:name isLoop:NO isDestroy:isDestroy];
}

- (void)playEffect:(NSString*)name
{
    [self playAnima:name isLoop:NO isDestroy:YES];
}

- (void)playAnima:(NSString*)name isLoop:(BOOL)isLoop isDestroy:(BOOL)isDestroy
{
    if ([name isEqualToString:_currAnimaName] && isLoop == _loop && _loop) {
        _autoDestroy = isDestroy;
        return;
    }

    retain_set(_currAnimaName, name);
    _currAnimation = [_charactor.animas objectForKey:name];

    _loop = isLoop;
    _autoDestroy = isDestroy;
    _isDirty = YES;
    _firstAnimationFrame = YES;
    _currFrameTime = 0;
    _totalTime = 0;
    _deltaTime = 0;
    _currLoopCount = 0;
    _playing = YES;

    [self updateAttaches];

    [[HpTimerManager shareManager] addTimerHandler:self];
}


- (void)playAnima:(NSString *)name at:(NSTimeInterval)frametime
{
    [self playAnima:name isLoop:NO isDestroy:NO];

    _currFrameTime = frametime;

    [self update:0];
    [self stopAnima];
}


- (void)update:(CGFloat)dt
{
    [self onTimerUpdate:dt];
}

- (void)onTimerUpdate:(NSTimeInterval)dt
{
    if (!_playing) {
        return;
    }

    if (_firstAnimationFrame) {
        _deltaTime = 0;
        _totalTime += 0;
        _currFrameTime += 0;
    }
    else
    {
        _deltaTime = dt;
        _totalTime += dt;
        _currFrameTime += dt * _FPS;

        if (_currFrameTime >[_currAnimation length]) {
            _currFrameTime = [_currAnimation length];
        }
    }

    [[_cache render] begin:self];
    [[_cache render] visitAnima:_currAnimation firstly:_firstAnimationFrame at:_currFrameTime];
    [[_cache render] end];


    for (HpAttachPoint* ap in _attach_list) {
        [ap clear];
    }

    for (HpAttachPoint* ap in _attach_list) {
        [ap apply];
    }

    _firstAnimationFrame = false;

    if (_currFrameTime >= [_currAnimation length]) {
        _currLoopCount++;
        [self onAnimationEnd:NO];
        _currFrameTime = 0;
    }
}

- (void)stopAnima
{
    _playing = NO;
}

- (void)stopAnimaAndCleanup
{
    _playing = NO;

    [_cache.render begin:self];
    [_cache.render end];

    [self.view removeFromSuperview];
    [[HpTimerManager shareManager] removeTimerHandler:self];
}

- (void)loadInstFile:(NSString*)instfile
{
    [self loadInstFile:instfile withScale:1.f];
}

- (void)loadInstFile:(NSString*)instfile withScale:(CGFloat)scale
{
    _scale = scale;
    retain_set(_instFileName, instfile);
    retain_set(_charactor, [_cache addCharatorFile:instfile]);
}

- (void)unloadInstFile:(NSString*)instfile
{
    HpCharactor* chr = retain([_cache charactorByFile:instfile]);
    [_cache removeCharatorFile:instfile];

    if (chr == _charactor) {
        [self stopAnima];
    }

    release(chr);
}

- (void)clearAllInstFile
{
    [_cache removeAllCache];
    [self stopAnima];
}

//
- (void)onAnimationEnd:(BOOL)destroy
{
    if (!_loop) {
        [self stopAnima];
    }
    
    if (_delegate && [_delegate conformsToProtocol:@protocol(HpCharaInstObserver)]) {
        [_delegate charaInst:self onAnimationEnd:_currAnimaName];
    }

    if (!_loop && !_playing && _autoDestroy) {
        [self stopAnimaAndCleanup];
    }
}

- (void)onCustomEvent:(NSString*)event
{
    if (event == nil || event.length == 0) {
        return;
    }

    if (event.length > 2 && [event hasPrefix:@"m:"]) {
        NSString* sound = [event substringFromIndex:2];
        [[NSNotificationCenter defaultCenter] postNotificationName:HPANIMATION_SOUND_EVENT
                                                            object:self
                                                          userInfo:@{HP_SOUND_EVENT_KEY : sound}];
    }
    
    if (_delegate && [_delegate conformsToProtocol:@protocol(HpCharaInstObserver)]) {
        [_delegate charaInst:self onCustomEvent:event];
    }
}

-(void)attach:(UIView *)child toLayer:(NSString *)layer
{
    if (child == nil || layer == nil) {
        return;
    }
    HpAttachPoint* aspeicfied = nil;
    for (HpAttachPoint* ap in _attach_list) {
        if ([ap.layerName isEqualToString:layer]) {
            aspeicfied = ap;
            break;
        }
    }
    if (aspeicfied == nil) {
        aspeicfied = [[HpAttachPoint alloc] init];
        aspeicfied.LayerName = layer;
        aspeicfied.LayerInst = [[_charactor.animas objectForKey:_currAnimaName] getLayerByName:layer];
        [_attach_list addObject:aspeicfied];
        release(aspeicfied);
    }
    [aspeicfied attach:child];

    if (child.superview == nil) {
        [_attachView addSubview:child];
    }
}

-(void)unattach:(UIView*)child
{
    if (child == nil) {
        return;
    }
    for (HpAttachPoint* ap in _attach_list) {
        [ap remove:child];
    }
    [child removeFromSuperview];
}

-(void)updateAttaches
{
    for (HpAttachPoint* ap in _attach_list) {
        ap.layerInst = [[_charactor.animas objectForKey:_currAnimaName] getLayerByName:ap.layerName];
    }
}

+ (void)setDefaultFPS:(CGFloat)fps
{
    s_charainst_fps = fps;
}

+ (CGFloat)defaultFPS
{
    return s_charainst_fps;
}

- (NSDictionary*)animas
{
    return _charactor.animas;
}

static_member(HpCharactorCache*, cache, HpCharactorCache);

+ (void)preloadInstFile:(NSString*)instfile
{
    [[HpCharaInst cache] addCharatorFile:instfile];
}

+ (void)unloadInstFile:(NSString*)instfile
{
    [[HpCharaInst cache] removeCharatorFile:instfile];
}

+ (void)clearAllInstFile
{
    [[HpCharaInst cache] removeAllCache];
}

@end



