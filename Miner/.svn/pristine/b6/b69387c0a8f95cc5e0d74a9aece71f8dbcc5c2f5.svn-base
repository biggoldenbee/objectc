//
//  AnimationSequence.h
//  Miner
//
//  Created by jim kaden on 15/1/6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AnimationSequence : NSObject<SequenceDelegate>
{
    NSMutableArray* _arrayOfInsts;
    NSMutableArray* _arrayOfTask;
    int _currentIndex ;
    BOOL _serial;
}
@property (nonatomic) NSObject<SequenceDelegate>* delegate;
-(void)addInst:(NSObject<BattleAnimationDelegate>*)inst anima:(NSString*)anima;
-(void)addSequence:(AnimationSequence*)sequence;
-(void)addInvocation:(NSInvocation*)invocation;
-(void)playInSerial;
-(void)playInParallel;
-(void)play;
-(id)init:(BOOL)serial;
@end
