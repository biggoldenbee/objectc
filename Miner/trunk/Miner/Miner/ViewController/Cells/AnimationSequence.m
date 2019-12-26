//
//  AnimationSequence.m
//  Miner
//
//  Created by jim kaden on 15/1/6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//
#import "BattleAnimationView.h"
#import "BattleActorView.h"
#import "AnimationSequence.h"

@implementation AnimationSequence

-(id)init:(BOOL)serial
{
    self = [super init];
    _serial = serial;
    _arrayOfInsts = [[NSMutableArray alloc]init];
    _arrayOfTask = [[NSMutableArray alloc]init];
    return self;
}

-(void)dealloc
{
//    NSLog(@"dealloc %@", self);
}
-(void)addInst:(NSObject<BattleAnimationDelegate>*)view anima:(NSString*)anima
{
    if ( view == nil || anima == nil )
        return;
    
    NSDictionary* content = @{
                              @"View": view,
                              @"Anima" : anima,
                              };

    [_arrayOfInsts addObject:content];
    //NSLog(@"Adding Inst %@, %@", anima, view);
}

-(void)addSequence:(AnimationSequence*)sequence
{
    [_arrayOfInsts addObject:sequence];
}

-(void)addInvocation:(NSInvocation*)invocation
{
    if ( invocation == nil )
        return;
    [_arrayOfInsts addObject:invocation];
}

-(void)play
{
    
    if ( _serial )
    {
        _currentIndex = 0;
        [self playInSerial];
    }
    else
    {
        [_arrayOfTask removeAllObjects];
        [self playInParallel];
    }
}

-(void)playInSerial
{
    if ( _currentIndex >= _arrayOfInsts.count )
    {
        [self.delegate sequenceFinished:self];
    }
    else
        [self playInst:[_arrayOfInsts objectAtIndex:_currentIndex]];
}

-(void)playInParallel
{
    for( NSObject* obj in _arrayOfInsts )
    {
        [_arrayOfTask addObject:obj];
        [self playInst:obj];
    }
}

-(void)playInst:(NSObject*)obj
{
    if ( [obj isKindOfClass:[self class]] )
    {
        AnimationSequence* as = (AnimationSequence*)obj;
        as.delegate = self;
        [as play];
    }
    else if ( [obj isKindOfClass:[NSInvocation class]])
    {
        NSInvocation* invoke = (NSInvocation*)obj;
        [invoke invoke];
        [self performSelector:@selector(finishPlay:) withObject:obj afterDelay:0.01];
    }
    else
    {
        NSDictionary* dict = (NSDictionary*)obj;
        NSObject<BattleAnimationDelegate>* view = (NSObject<BattleAnimationDelegate>*)[dict objectForKey:@"View"];
        NSString* anima = [dict objectForKey:@"Anima"];
        if ( [view isKindOfClass:[BattleAnimationBase class]])
        {
            BattleAnimationBase* bab = (BattleAnimationBase*)view;
            bab.delegate = self;
        }
        //NSLog(@"Play inst %@, %@", obj, anima);
        [view play:anima];
        
    }
}

-(void)sequenceFinished:(id)seqID
{
    [self finishPlay:seqID];
}

-(void)finishPlay:(NSObject*)obj
{

    if ( [obj isKindOfClass:[self class]] )
    {
        AnimationSequence* as = (AnimationSequence*)obj;
        as.delegate = nil;
    }
    else if ( [obj isKindOfClass:[NSInvocation class]] )
    {
        
    }
    else if ( [obj isKindOfClass:[BattleAnimationBase class]]  )
    {
        BattleAnimationBase* bad = (BattleAnimationBase*)obj;
        bad.delegate = nil;
        //NSLog(@"finishPlay %@", obj);
    }
    
    if ( _serial )
    {
        _currentIndex ++;
        [self performSelector:@selector(playInSerial) withObject:nil afterDelay:0];
//        [self playInSerial];
    }
    else
    {
        if ( [obj isKindOfClass:[self class]] )
        {
            AnimationSequence* as = (AnimationSequence*)obj;
            if([_arrayOfTask containsObject:as])
                [_arrayOfTask removeObject:as];
        }
        else if ( [obj isKindOfClass:[NSInvocation class]] )
        {
            if([_arrayOfTask containsObject:obj])
                [_arrayOfTask removeObject:obj];
        }
        else
        {
            NSObject<BattleAnimationDelegate>* view = (NSObject<BattleAnimationDelegate>*)obj;
            
            NSObject* objFound = nil;
            for(NSObject* obj2 in _arrayOfTask)
            {
                if ( [obj2 isKindOfClass:[NSDictionary class]] )
                {
                    NSDictionary* dict2 = (NSDictionary*)obj2;
                    NSObject<BattleAnimationDelegate>* view2 = (NSObject<BattleAnimationDelegate>*)[dict2 objectForKey:@"View"];
                    if ( view == view2 )
                    {
                        objFound = obj2;
                        break;
                    }
                }
            }
            
            if ( objFound )
            {
                [_arrayOfTask removeObject:objFound];
            }
        }
        if ( _arrayOfTask.count == 0 )
        {
            [self.delegate sequenceFinished:self];
        }
    }
}
@end
