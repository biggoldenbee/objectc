//
//  BattleAnimationView.m
//  Miner
//
//  Created by jim kaden on 14/12/29.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BattleAnimationView.h"
#import "BattleActorView.h"
#import "AnimationSequence.h"
#import "StringConfig.h"
#import "MapConfig.h"
#import "MobConfig.h"
#import "BattleAnimationCommonLabel.h"
#import "AttributeString.h"
@interface BattleAnimationView()
{
    int _turn;
}
@property(nonatomic, strong) BattleActorView* actorMe;
@property(nonatomic, strong) BattleActorView* actorPet1;
@property(nonatomic, strong) BattleActorView* actorPet2;
@property(nonatomic, strong) BattleActorView* actorEnemy1;
@property(nonatomic, strong) BattleActorView* actorEnemy2;
@property(nonatomic, strong) BattleActorView* actorEnemy3;
@property (weak, nonatomic) IBOutlet UILabel *labelResult;
@property (weak, nonatomic) IBOutlet UIImageView *imageBk;
@property (weak, nonatomic) IBOutlet UIView *effectView;
@property(nonatomic)NSArray* actorViews;
@property(nonatomic)NSArray* actorAllyViews;
@property(nonatomic)NSArray* actorEnemyViews;
-(void)initActors;
@end



@implementation BattleAnimationView

+(BattleAnimationView*)create:(id)owner
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleAnimationView" owner:owner options:nil];
    BattleAnimationView* view = (BattleAnimationView*)[array objectAtIndex:0];
    [view initActors];
    return view;
}

-(void)initActors
{
    self.actorMe = [BattleActorView create:self];
    self.actorMe.tag = 1;
    self.actorPet1 = [BattleActorView create:self];
    self.actorPet1.tag = 2;
    self.actorPet2 = [BattleActorView create:self];
    self.actorPet2.tag = 3;
    self.actorEnemy1 = [BattleActorView create:self];
    self.actorEnemy1.tag = 4;
    self.actorEnemy2 = [BattleActorView create:self];
    self.actorEnemy2.tag = 5;
    self.actorEnemy3 = [BattleActorView create:self];
    self.actorEnemy3.tag = 6;
    
    self.actorViews = @[self.actorMe, self.actorPet1, self.actorPet2, self.actorEnemy1, self.actorEnemy2, self.actorEnemy3];
    self.actorAllyViews = @[];
    self.actorEnemyViews = @[];

    [self arrangeActorViews];

    [self reset];
    
    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%@", filters);
    
    CIFilter* filter = [CIFilter filterWithName:@"CIColorMatrix"];
    [filter setDefaults];
    NSLog(@"%@", [filter attributes]);
    CIFilter* blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    [blurFilter setValue:[NSNumber numberWithFloat:50] forKey:@"inputRadius"];

    CALayer* layer = [CALayer layer];
    layer.filters = @[filter, blurFilter];
    [self.imageBk.layer addSublayer:layer];
    
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    float r = window.bounds.size.width / 320.f;
    for(BattleActorView* bav in self.actorViews)
    {
        bav.transform = CGAffineTransformMakeScale(r, r);
    }
}

-(void)reset
{
    for(BattleActorView* view in self.actorViews)
    {
        [view reset];
        view.hidden = YES;
        view.tag = 0;
    }
    self.labelResult.hidden = YES;
    _turn = 1;
}

-(void)setNewFrame:(CGRect)newFrame
{
    CGRect frame = newFrame;
    
    frame.origin.x = 0;
    frame.origin.y = 0;
    self.frame = frame;
    self.effectView.frame = frame;
    self.imageBk.frame = frame;
    CGRect f = self.labelResult.frame;
    f.size.width = 200;
    f.origin.x = (newFrame.size.width - f.size.width)/2;
    f.origin.y = frame.size.height - f.size.height - 25;
    self.labelResult.frame = f;
    [self arrangeActorViews];
}

-(void)arrangeActorViews
{
    CGRect frame = self.frame;
    CGRect r = self.actorMe.frame;
    
    int i = 0;
    int margin = 2;
    int xoffset = 8;
    for ( i = 0 ; i < self.actorAllyViews.count ; i ++)
    {
        int heightPerChild = (frame.size.height - 2 * margin) / self.actorAllyViews.count;
//        int diff = (heightPerChild - r.size.height)/2;
        
        r.origin.x = -xoffset;
        r.origin.y = i * heightPerChild + margin ;
        BattleActorView* view = (BattleActorView*)[self.actorAllyViews objectAtIndex:i];
        view.hidden = NO;
        view.frame = r;
        view.tag = (int)view.actor;
        [[view.actionAnimation getCharaInst] update:0.f];
    }

    for ( i = 0 ; i < self.actorEnemyViews.count ; i ++)
    {
        int heightPerChild = (frame.size.height - 2 * margin) / self.actorEnemyViews.count;
//        int diff = (heightPerChild - r.size.height)/2;
        r.origin.x = frame.size.width + xoffset - r.size.width;
        r.origin.y = i * heightPerChild + margin ;
        BattleActorView* view = (BattleActorView*)[self.actorEnemyViews objectAtIndex:i];
        view.hidden = NO;
        view.frame = r;
        view.tag = (int)view.actor;
        [[view.actionAnimation getCharaInst] update:0.f];
    }

    //[self setNeedsDisplay];
}

#pragma mark - implementation protocol function
-(void) setActorsWithArray:(NSArray *)actors
{
    [self reset];
    
    int ally = 0;
    int enemy = 0;
    NSMutableArray* allyArrays = [[NSMutableArray alloc]init];
    NSMutableArray* enemyArrays = [[NSMutableArray alloc]init];
    for (BattleActor *actor in actors)
    {
        if (actor.ally == 1)
        {
            if ( actor.type == 0 )
            {
                [self.actorMe setupActor:actor];
                [allyArrays addObject:self.actorMe];
            }
            else
            {
                if ( self.actorPet1.actor == nil )
                {
                    [self.actorPet1 setupActor:actor];
                    [allyArrays addObject:self.actorPet1];
                }
                else
                {
                    [self.actorPet2 setupActor:actor];
                    [allyArrays addObject:self.actorPet2];
                }
            }
            ally ++;
        }
        else if (actor.ally == 0)
        {
            BattleActorView* obj = nil;
            if ( self.actorEnemy1.actor == nil )
            {
                [self.actorEnemy1 setupActor:actor];
                obj = self.actorEnemy1;
            }
            else if ( self.actorEnemy2.actor == nil )
            {
                [self.actorEnemy2 setupActor:actor];
                obj = self.actorEnemy2;
            }
            else
            {
                [self.actorEnemy3 setupActor:actor];
                obj = self.actorEnemy3;
            }
            
            if ( actor.type == 3 || actor.type == 4 )
            {
                [enemyArrays insertObject:obj atIndex:0];
            }
            else
                [enemyArrays addObject:obj];

            enemy ++;
        }
    }
    self.actorAllyViews = allyArrays;
    self.actorEnemyViews = enemyArrays;
    [self arrangeActorViews];
//    [self requestForNextFrame];
    
    _currentSequence = [[AnimationSequence alloc]init:YES];
    _currentSequence.delegate = self;
    BattleDetail* bd = self.actorMe.actor.battle;
    int type = (int)bd.brief.type;
    NSAttributedString* sceneText = nil;
    if ( isBattleBriefType(type))
    {
        sceneText = [AttributeString stringWithString:[[StringConfig share] getLocalLanguage:@"battlog_start_battle"]
                                             fontSize:20
                                             fontBold:YES
                                      foregroundColor:[UIColor whiteColor]
                                          strokeColor:[UIColor blackColor]
                                           strokeSize:1];
        
    }
    else if (type == MineBattle )
    {
        sceneText = [AttributeString stringWithString:[[StringConfig share] getLocalLanguage:@"battlog_start_mine"]
                                             fontSize:20
                                             fontBold:YES
                                      foregroundColor:[UIColor whiteColor]
                                          strokeColor:[UIColor blackColor]
                                           strokeSize:1];
    }
    else if ( type == OpenBoxBattle )
    {
        sceneText = [AttributeString stringWithString:[[StringConfig share] getLocalLanguage:@"battlog_start_openbox"]
                                             fontSize:20
                                             fontBold:YES
                                      foregroundColor:[UIColor whiteColor]
                                          strokeColor:[UIColor blackColor]
                                           strokeSize:1];
    }
    
    [_currentSequence addInst:[self animationOfSceneText:sceneText delegate:_currentSequence]
                        anima:@"ui_zhandoukaishi"];
    
    [_currentSequence play];
}

-(NSInvocation*)invocation:(NSObject*)target selector:(SEL)selector
{
    if ( target == nil )
        return nil;
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:selector]];
    invocation.selector = selector;
    invocation.target = target;
    return invocation;
}

-(NSInvocation*)invocation:(NSObject*)target selector:(SEL)selector param1:(NSObject*)param1
{
    if ( target == nil )
        return nil;
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:selector]];
    invocation.selector = selector;
    invocation.target = target;
    [invocation setArgument:(void*)&param1 atIndex:2];
    [invocation retainArguments];
    return invocation;
}

-(NSInvocation*)invocation:(NSObject*)target selector:(SEL)selector param1:(NSObject*)param1 param2:(NSObject*)param2
{
    if ( target == nil )
        return nil;
    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:[[target class] instanceMethodSignatureForSelector:selector]];
    invocation.selector = selector;
    invocation.target = target;
    [invocation setArgument:(void*)&param1 atIndex:2];
    [invocation setArgument:(void*)&param2 atIndex:3];
    [invocation retainArguments];
    return invocation;
}

-(OneTimeUseAnimation*)animationOfSkill:(BattleActorView*)from to:(BattleActorView*)to delegate:(NSObject<SequenceDelegate>*)delegate
{
    CGRect rect = CGRectMake(0, 0, 228, 20);
    OneTimeUseAnimation* action = [[OneTimeUseAnimation alloc]init:self loop:NO offset:rect delegate:delegate];
    CGPoint ptFrom = [self convertPoint:[from skillAnchor] fromView:from];
    CGPoint ptTo = [self convertPoint:[to skillAnchor] fromView:to];
    [action setFrom:ptFrom to:ptTo];
    return action;
}

-(OneTimeUseAnimation*)animation:(NSObject<SequenceDelegate>*)delegate
{
//    CGRect rect = CGRectMake(0, 0, 100, 100);

    OneTimeUseAnimation* action = [[OneTimeUseAnimation alloc]init:self.effectView loop:NO offset:CGRectZero delegate:delegate];
    action.invocation = [self invocation:action selector:@selector(center)];
    return action;
}

-(OneTimeUseAnimation*)animationOfSceneText:(NSAttributedString*)string delegate:(NSObject<SequenceDelegate>*)delegate
{
    OneTimeUseAnimation* action = [[OneTimeUseAnimation alloc]init:self.effectView
                                                              loop:NO
                                                            offset:CGRectZero
                                                          delegate:_currentSequence];
    BattleAnimationCommonLabel* label = [BattleAnimationCommonLabel create:self];
    [label setupLabel:string stroke:YES];
    label.frame = CGRectMake(-label.frame.size.width/2, -label.frame.size.height/2, label.frame.size.width, label.frame.size.height);
    [[action getCharaInst] view];
    [[action getCharaInst] attach:label toLayer:@"ui_zhandoukaishi_1"];
    label.transform = CGAffineTransformMakeScale(0, 0);
    action.invocation = [self invocation:action selector:@selector(center)];
    return action;
}

-(void) playerWithSubAction:(BattleSubAction *)subAction
{
    if (subAction == nil)
    {
        return;
    }
    int sid = (int)subAction.action.sid;
    int slv = (int)subAction.action.slv;
    ANIMA_TYPE at = AT_DEFENDER_NORMAL;
    
    NSArray* actors = subAction.action.battle.actors;
    BattleActor* A = [actors objectAtIndex:subAction.action.A-1];
    BattleActor* B = [actors objectAtIndex:subAction.B-1];
    BattleActorView* AView = (BattleActorView*)[self viewWithTag:(int)A];
    BattleActorView* BView= (BattleActorView*)[self viewWithTag:(int)B];
    BView.actionAnimation.actionDelegate = _currentSequence;
    
    switch(subAction.type)
    {
        case 0:
        {
            switch (subAction.value1)
            {
                case -1:
                    break;
                case 0: // 普通攻击
                case 1: // 暴击
                case 2: // 招架
                case 3: // 闪避
                {
                    
                    int hp = (int)subAction.value2;
                    if ( sid <= 0 )
                    {
                        // normal
                        [_currentSequence addInst:BView.actionAnimation
                                            anima:[BView animaBySkill:sid withLv:slv type:AT_DEFENDER_NORMAL]];
                    }
                    else
                    {
                        [_currentSequence addInst:[self animationOfSkill:AView to:BView delegate:_currentSequence]
                                            anima:[AView animaBySkill:sid withLv:slv type:AT_ATTACK_SKILL_EFFECT]];
                        
                        [_currentSequence addInst:[BView tempActionAnimation:NO delegate:_currentSequence]
                                            anima:[BView animaBySkill:sid withLv:slv type:AT_DEFENDER_SKILL]];
                        
                        [_currentSequence addInst:BView.actionAnimation
                                            anima:[BView animaBySkill:sid withLv:slv type:AT_DEFENDER_NORMAL]];
                    }
                    if ( hp != 0 )
                    {
                        if (subAction.value1 == 1 )
                        {
                            at = AT_CRITICAL;
                            [_currentSequence addInst:[BView animationChangeHpInCritical:-hp delegate:_currentSequence]
                                                anima:[BView animaBySkill:sid withLv:slv type:at]];

                        }
                        else if ( subAction.value1 == 2 )
                        {
                            at = AT_PARRY;
                            [_currentSequence addInst:[BView animationDodgeParry:YES delegate:_currentSequence]
                                                anima:[BView animaBySkill:sid withLv:slv type:at]];

                        }
                        else
                        {
                            at = AT_HEAL;
                            [_currentSequence addInst:[BView animationChangeHp:-hp delegate:_currentSequence]
                                                anima:[BView animaBySkill:sid withLv:slv type:at]];

                        }
                        
                        [_currentSequence addInvocation:[self invocation:BView selector:@selector(changeHp:)
                                                                  param1:[NSNumber numberWithInt:-hp]]];
                    }
                    if ( subAction.value1 == 3 )
                    {
                        // 闪避
                        [_currentSequence addInst:[BView animationDodgeParry:NO delegate:_currentSequence]
                                            anima:[BView animaBySkill:sid withLv:slv type:AT_DODGE]];
                        
                    }
                }
                    break;
                case 4:
                {
                    int hp = (int)subAction.value2;
                    
                    [_currentSequence addInst:BView.actionAnimation
                                        anima:[BView animaByType:AT_HEAL]];
                    [_currentSequence addInst:[BView animationChangeHp:hp delegate:_currentSequence]
                                        anima:[BView animaBySkill:sid withLv:slv type:AT_HEAL]];
                    [_currentSequence addInvocation:[self invocation:BView selector:@selector(changeHp:)
                                                              param1:[NSNumber numberWithInt:hp]]];
                    
                }
                    break;
                default:
                    break;
            }
            break;
        }
        case 1:
        {
            // B 对 A反作用，产生伤害或者加血
            int hp = (int)subAction.value2;
            if ( subAction.value1 == 0 )
            {
                // B 攻击 A
//                [_currentSequence addInst:[BView tempActionAnimation:NO delegate:_currentSequence]
//                                    anima:[BView animaBySkill:sid type:AT_ATTACK_NORMAL]];
                [_currentSequence addInst:[AView tempActionAnimation:NO delegate:_currentSequence]
                                    anima:[AView animaBySkill:sid withLv:slv type:AT_DEFENDER_NORMAL]];
                
                [_currentSequence addInst:[AView animationChangeHp:-hp delegate:_currentSequence]
                                    anima:[AView animaBySkill:sid withLv:slv type:AT_HEAL]];
                [_currentSequence addInvocation:[self invocation:AView selector:@selector(changeHp:)
                                                          param1:[NSNumber numberWithInt:-hp]]];
            }
            else
            {
                // B buff A
//                [_currentSequence addInst:[BView tempActionAnimation:NO delegate:_currentSequence]
//                                    anima:[BView animaBySkill:sid type:AT_ATTACK_NORMAL]];
                [_currentSequence addInst:[AView animationChangeHp:hp delegate:_currentSequence]
                                    anima:[AView animaBySkill:sid withLv:slv type:AT_HEAL]];
                [_currentSequence addInvocation:[self invocation:AView selector:@selector(changeHp:)
                                                          param1:[NSNumber numberWithInt:hp]]];
            }

        }
            break;
        case 2:
        {
            // Buff 作用
            int buffID = subAction.value1 > 0 ? (int)subAction.value1 : (int)-subAction.value1;
            int buffLV = (int)subAction.value3;
            BOOL loop = [BView animaContinurousByBuff:(int)buffID withLv:(int)buffLV];

            if ( subAction.value1 > 0 )
            {
                // 挂上buff, 大动画
                if ( subAction.value2 == 0 ) // first add
                {
                    BattleBuffAnimation* bba = [BView addBuff:buffID withLv:buffLV];
                    [_currentSequence addInvocation:[self invocation:BView selector:@selector(refreshBuff)]];
                    if ( bba )
                    {
                        if ( loop )
                        {
                            NSObject<BattleAnimationDelegate>* attachedInst = [BView tempActionAnimation:loop
                                                                                                delegate:_currentSequence];
                            [_currentSequence addInst:attachedInst
                                                anima:[BView animaByBuff:buffID withLv:buffLV]];
                            bba.attachedInst = attachedInst;
                        }
                        
                        [_currentSequence addInst:bba
                                            anima:@"ui_buff"];

                    }
                }
            }
            else
            {
                // 去掉buff
                if ( subAction.value2 == 0 ) // buff off
                {
                    [BView minusBuff:buffID];
                    [_currentSequence addInvocation:[self invocation:BView selector:@selector(refreshBuff)]];
                }
            }

            if ( subAction.value2 != 0 )
            {
                [_currentSequence addInst:[BView animationChangeHp:(int)subAction.value2 delegate:_currentSequence]
                                    anima:[BView animaBySkill:sid withLv:slv type:AT_HEAL]];
                [_currentSequence addInvocation:[self invocation:BView selector:@selector(changeHp:)
                                                          param1:[NSNumber numberWithInt:(int)subAction.value2]]];
            }

        }
            break;
        case 3:
        {
            switch (subAction.value1)
            {
                case 0:
                    // A 死亡
                    [_currentSequence addInst:AView.actionAnimation
                                        anima:[AView animaBySkill:sid withLv:slv type:AT_DEAD]];
                    [_currentSequence addInvocation:[self invocation:AView selector:@selector(die:)
                                                              param1:[NSNumber numberWithInt:0]]];

                    break;
                case 1:
                    [_currentSequence addInvocation:[self invocation:BView selector:@selector(die:)
                                                              param1:[NSNumber numberWithInt:0]]];
                    [_currentSequence addInst:BView.actionAnimation
                                        anima:[BView animaBySkill:sid withLv:slv type:AT_DEAD]];
                    break;
                default:
                {
                    // 特殊状态
                    //BOOL loop = [BView animaContinurousByAttri:(int)subAction.value1];
                    [_currentSequence addInst:[BView tempActionAnimation:NO
                                                                delegate:_currentSequence]
                                        anima:[BView animaByAttri:(int)subAction.value1]];
                    
                    if ( subAction.value1 == 255 )
                    {
                        [_currentSequence addInst:[BView animationChangeHp:(int)subAction.value2 delegate:_currentSequence]
                                            anima:[BView animaBySkill:sid withLv:slv type:AT_HEAL]];
                        [_currentSequence addInvocation:[self invocation:BView selector:@selector(changeHp:)
                                                                  param1:[NSNumber numberWithInt:(int)subAction.value2]]];
                    }
                }
                    break;
            }
        }
            break;
    }
}

-(void) playerWithAction:(BattleAction *)action
{
    _currentSequence = [[AnimationSequence alloc]init:YES];
    _currentSequence.delegate = self;
    int sid = (int)action.sid;
    int slv = (int)action.slv;
    BOOL hasAnyRealAttack = NO;
    NSArray* actors = action.battle.actors;
    BattleActor* A = [actors objectAtIndex:action.A-1];
    BattleActorView* AView = (BattleActorView*)[self viewWithTag:(int)A];
    AView.actionAnimation.actionDelegate = _currentSequence;
    if ( sid > 0 )
    {
        [_currentSequence addInst:[AView animationSkillBoard:sid withLv:slv delegate:_currentSequence]
                            anima:[AView animaBySkill:sid withLv:slv type:AT_PREPARE_SKILL]];
    }
    
    for(BattleSubAction* sa in action.subActions)
    {
        if ( sa.type == 0 && sa.value1 > -1 )
        {
            hasAnyRealAttack = YES;
            break;
        }
    }
    
    if ( hasAnyRealAttack )
        [_currentSequence addInst:AView.actionAnimation anima:[AView animaBySkill:sid withLv:slv type:AT_ATTACK_SKILL]];

    for(BattleSubAction* sa in action.subActions)
    {
        [self playerWithSubAction:sa];
    }
    [_currentSequence addInvocation:[self invocation:AView selector:@selector(turnChanged)]];
    [_currentSequence addInvocation:[self invocation:AView selector:@selector(refreshBuff)]];

    [_currentSequence play];
    
    
}

-(void) playerWithMine:(BattleMine *)mine
{
//    [self addBattleObject:mine];
    
    _currentSequence = [[AnimationSequence alloc]init:YES];
    _currentSequence.delegate = self;

    NSArray* actors = mine.battle.actors;
    BattleActor* A = [actors objectAtIndex:mine.A-1];
    BattleActorView* AView = (BattleActorView*)[self viewWithTag:(int)A];
    AView.actionAnimation.actionDelegate = _currentSequence;
//    if ( mine.ret > 0 )
    {
        [_currentSequence addInst:[self animation:_currentSequence]
                            anima:@"ui_map_dig_zd"];
    }
    
    [_currentSequence play];
}

-(void) playerWithBrief:(BattleBrief *)brief
{
    // show result
    
    
    _currentSequence = [[AnimationSequence alloc]init:YES];
    _currentSequence.delegate = self;
    
    if ( isBattleBriefType(brief.type) )
    {
        self.labelResult.hidden = YES;
        if ( brief.win > 0 )
        {
            NSAttributedString* string = [AttributeString stringWithString:[[StringConfig share] getLocalLanguage:@"battlog_anima_result1"]
                                                                  fontSize:20
                                                                  fontBold:YES
                                                           foregroundColor:[UIColor whiteColor]
                                                               strokeColor:[UIColor blackColor]
                                                                strokeSize:1];
            
            [_currentSequence addInst:[self animationOfSceneText:string delegate:_currentSequence]
                                anima:@"ui_zhandoukaishi"];
            
        }
        else
        {
//            self.labelResult.text = [[StringConfig share] getLocalLanguage:@"battlog_anima_result2"];
            NSAttributedString* string = [AttributeString stringWithString:[[StringConfig share] getLocalLanguage:@"battlog_anima_result2"]
                                                                  fontSize:20
                                                                  fontBold:YES
                                                           foregroundColor:[UIColor whiteColor]
                                                               strokeColor:[UIColor blackColor]
                                                                strokeSize:1];
            
            [_currentSequence addInst:[self animationOfSceneText:string delegate:_currentSequence]
                                anima:@"ui_zhandoukaishi"];
        }
    }
    else if ( brief.type == MineBattle )
    {
        /*
        if ( brief.mine > 0 )
            self.labelResult.text = [[StringConfig share] getLocalLanguage:@"battlog_anima_result3"];
        else
            self.labelResult.text = [[StringConfig share] getLocalLanguage:@"battlog_anima_result4"];
         */
    }
    else if ( brief.type == OpenBoxBattle )
    {
        self.labelResult.hidden = YES;
        
        if ( brief.boxWon && brief.boxWon.count > 0 )
        {
            //self.labelResult.text = [[StringConfig share] getLocalLanguage:@"battlog_anima_result5"];
            [_currentSequence addInst:[self animation:_currentSequence]
                                anima:@"ui_map_chest_open"];
        }
        else
        {
            //self.labelResult.text = [[StringConfig share] getLocalLanguage:@"battlog_anima_result6"];
            [_currentSequence addInst:[self animation:_currentSequence]
                                anima:@"ui_map_chest_open"];
        }
    }
    
    [_currentSequence play];
}

-(void)preparingBattle:(int)seconds
{
    //
}

-(void)stopPreparingCounting
{
    //
}

-(void)playerWithTarget:(BRIEF_TYPE)type data:(id)data
{
    switch (type)
    {
        case BossBattle:
        case BigBossBattle:
        {
            self.labelResult.hidden = NO;
            int map = [data intValue];
            MapDef* md = [[MapConfig share] getMapDefWithID:(NSNumber*)data];
            if ( md == nil )
                return;
            int boss = (int)md.bossID;
            MobDef* mdd = [[MobConfig share] getMobDefById:boss];
            if ( mdd == nil )
                return;
            
            self.labelResult.text = [NSString stringWithFormat:@"即将挑战Lv. %d Boss %@", map, [[StringConfig share] getLocalLanguage:mdd.mobName]];
        }
            break;
        case NormalBattle:
            self.labelResult.hidden = NO;
            self.labelResult.text = [NSString stringWithFormat:@"正在搜寻..."];
            break;
        default:
            
            break;
    }
}

-(void)sequenceFinished:(id)seqID
{
    //NSLog(@"sequenceFinished called %@, %@", seqID, _currentSequence);
    if ( seqID == _currentSequence )
    {
        _currentSequence = nil;
        [HpCharaInst clearAllInstFile];
        [self performSelector:@selector(requestForNextFrame) withObject:nil afterDelay:2.0];
    }
}

-(void)requestForNextFrame
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.haypi.miner.battle.next" object:nil];
}
@end

