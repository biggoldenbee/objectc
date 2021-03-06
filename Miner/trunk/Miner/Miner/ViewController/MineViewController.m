//
//  MineViewController.m
//  testMiner
//
//  Created by zhihua.qian on 14-12-2.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "MineViewController.h"
#import "GameObject.h"
#import "GameUI.h"
#import "PackageManager.h"
#import "CommonDef.h"
//#import "GameNotification.h"
#import "BattleTableViewCell01.h"

#import "BattleManager.h"
#import "BattlePlayer.h"

#import "QQActorViewController.h"

#import "BattleLogMessageCell.h"
#import "BattleLogActionCell.h"
#import "BattleLogCellBase.h"
#import "BattleLogCountingCell.h"

#import "BattleData.h"
#import "AttributeString.h"
#import "BattleAnimationView.h"
#import "MapConfig.h"
#import "StringConfig.h"
//#import "GameNotification.h"

#define FONT_SIZE           14.0f
#define CELL_CONTENT_WIDTH  320.0f
#define CELL_CONTENT_MARGIN 0.0f

@interface MineViewController ()

@property (strong, nonatomic) IBOutlet UILabel *sceneNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *sceneTaskBtn;
@property (strong, nonatomic) IBOutlet UIButton *sceneChestBtn;
@property (strong, nonatomic) IBOutlet UIButton *sceneBossBtn;

@property (strong, nonatomic) IBOutlet UITableView *battleLogTableView;
@property (nonatomic, retain) NSMutableArray    *battleTableViewCells;
@property (nonatomic, retain) NSMutableArray    *battleObjects;
@property (nonatomic, retain) NSObject* countingObject ;
@property (nonatomic, retain) NSTimer *leftTimer;

@property (nonatomic, strong) BattleAnimationView* animationView;
@property (nonatomic, strong) QQActorViewController* actorPet;
@property (nonatomic, strong) QQActorViewController* actorMob1;
@property (nonatomic, strong) QQActorViewController* actorMob2;
@property (nonatomic, strong) QQActorViewController* actorMob3;
@property (weak, nonatomic) IBOutlet UIView *animationContainerView;
@property (weak, nonatomic) IBOutlet UIImageView* markIcon;
@property (weak, nonatomic) IBOutlet UIImageView* markIconPet;
@end

@implementation MineViewController

-(id)init
{
    self = [super init];
    if (self)
    {
        self.messageArray = [[NSMutableArray alloc]init];
        self.battleTableViewCells = [[NSMutableArray alloc]init];
        self.battleObjects = [[NSMutableArray alloc]init];
        self.countingObject = nil;
        
        [[[BattleManager sharedInstance] battlePlayer] registerEventPlayer:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.battleLogTableView.backgroundColor = [UIColor colorWithRed:0.898 green:0.898 blue:0.898 alpha:1.0];
    // 添加主角、宠物和怪物的头像，需要隐藏
    // 获取主角对象
    self.player = [[GameObject sharedInstance] player];

    if ( self.animationView == nil )
    {
        self.animationView = [BattleAnimationView create:self];
        
    }
    [self.animationContainerView addSubview:self.animationView];
    
    [[[BattleManager sharedInstance] battlePlayer] createActionTimer];
    [[[BattleManager sharedInstance] battlePlayer] registerEventPlayer:self];
    [[[BattleManager sharedInstance] battlePlayer] registerEventPlayer:self.animationView];
    [self setAllControllersData];
    
    [self.animationView setNewFrame:self.animationContainerView.frame];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.markIcon.hidden = ![[GameObject sharedInstance].player hasBetterEquipmentForHero];
    self.markIconPet.hidden = ![[GameObject sharedInstance].player hasBetterEquipmentForPet];
    
    if ([self.battleObjects count] == 0)
    {
        return;
    }
    
    [self.battleLogTableView reloadData];
    
    [self tableViewRollToBottom];
}

-(void)viewDidLayoutSubviews
{
    [self.animationView setNewFrame:self.animationContainerView.frame];
    
    CGRect f = self.battleLogTableView.frame;
    
    for(UITableViewCell* tc in self.battleTableViewCells)
    {
        CGRect frame = tc.frame;
        frame.size.width = f.size.width;
        tc.frame = frame;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 接收处理消息的方法
-(void)updateViewControllers
{
    [self setAllControllersData];
}

-(void)preparingBattle:(int)seconds
{
    self.leftTime = [NSDate dateWithTimeIntervalSinceNow:seconds];   // 计数
    
    BattleLogCounting* blc = [[BattleLogCounting alloc]init];
    blc.originalTimer = seconds;
    [blc start];
    self.countingObject = blc;
    
    [self addBattleObject:blc];
    self.leftTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceLeftTime:) userInfo:nil repeats:YES];
    [[BattleManager sharedInstance] playerWithTarget:NormalBattle data:self.player.heroMap];
}

-(void)stopPreparingCounting
{
    [self.leftTimer invalidate];
    self.leftTimer = nil;
}
//-(void)updateNextBattleTime:(NSArray*)params
//{
////    NSArray *tempArr = [notify object];
//    self.leftTime = [NSDate dateWithTimeIntervalSinceNow:[[params objectAtIndex:0] integerValue]];   // 计数
//
//    BattleLogCounting* blc = [[BattleLogCounting alloc]init];
//    blc.originalTimer = (int)[[params objectAtIndex:0] integerValue];
//    [blc start];
//    self.countingObject = blc;                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
//    
//    [self addBattleObject:blc];
//    self.leftTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reduceLeftTime:) userInfo:nil repeats:YES];
//    [[BattleManager sharedInstance] playerWithTarget:NormalBattle data:self.player.heroMap];
//}

-(void)updateBattleAnimation
{
    // 为播放动画所留
}

-(void)reduceLeftTime:(NSTimer *)timer
{
    // TODO 下场战斗的倒计时
    if ( self.countingObject == nil )
        return;
    BattleLogCounting* blc = (BattleLogCounting*)self.countingObject;
    [blc countDown];
    
    NSUInteger row = [self.battleObjects indexOfObject:self.countingObject];
    if ( row >= 0 ) // 有没有多余的嫌疑  无符号整数肯定大于0啊
    {
        BattleLogCountingCell* cell = [self.battleTableViewCells objectAtIndex:row];
        if ( cell != nil )
        {
            [cell refreshMessage:blc];
        }
    }
    
//    if ([self.leftTime timeIntervalSinceNow] < 0 )
//    {
//        //[[[BattleManager sharedInstance] battlePlayer] resumeActionTimerLeftTimeOver];
//        [self.leftTimer invalidate];
//        self.leftTimer = nil;
//    }
}

#pragma mark - 刷新界面上的空间数据
-(void)setAllControllersData
{
//    self.sceneNameLabel.text = [self.player.heroMap stringValue];
    [self setCurrentMap:[self.player.heroMap intValue]];
    [self resetActorView];
}

-(void)resetActorView
{
//    [self.actorPlayer reset];   // 加满血条
}

-(void)tableViewRollToBottom
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:[self.battleObjects count]-1 inSection:0];
    [self.battleLogTableView scrollToRowAtIndexPath:indexPath
                                   atScrollPosition:UITableViewScrollPositionBottom
                                           animated:NO];
}


#pragma mark - UITableViewDataSoure
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.battleObjects count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    UITableViewCell* cell = [self.battleTableViewCells objectAtIndex:row];
    if ( cell != nil )// row < [self.battleTableViewCells count])
    {
        return cell;
    }
    else
    {
        NSObject* obj = [self.battleObjects objectAtIndex:row];
        if ( obj == nil )
            return nil;
        cell = [self createCell:obj];

        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    BattleLogCellBase* cell = (BattleLogCellBase*)[self.battleTableViewCells objectAtIndex:row];
    CGFloat height = cell.cellHeight;
    return ceilf(height) ;
}


#pragma mark - Button Actions On View
- (IBAction)onTaskBtnClicked:(id)sender
{
}
- (IBAction)onChestBtnClicked:(id)sender
{
}
- (IBAction)onBossBtnClicked:(id)sender
{
    NSDictionary* tempDict = [[NSDictionary alloc]initWithObjectsAndKeys:self.player.heroMap,@"Map", nil];
    [[PackageManager sharedInstance] bossRequest:tempDict];
    [[BattleManager sharedInstance] playerWithTarget:BossBattle data:self.player.heroMap];
}

- (IBAction)onMapBtnClicked:(id)sender
{
    [[GameUI sharedInstance] showStageView];
}
- (IBAction)onQuickBtnClicked:(id)sender
{
}
- (IBAction)onEquipBtnClicked:(id)sender
{
    [[GameUI sharedInstance] showEquipView];
}
- (IBAction)onSkillBtnClicked:(id)sender
{
    [[GameUI sharedInstance] showSkillView];
}
- (IBAction)onPetBtnClicked:(id)sender
{
    NSInteger count = [[[self player] heroPetArray] count];
    if (count == 0)
    {
        [[GameUI sharedInstance] showError:@"找金大大要宠物去！" title:@"你还没有宠物！"];
        return;
    }
    [[GameUI sharedInstance] showPetView];
}

-(void)setCurrentMap:(int)map
{
    NSString* nameKey = [[MapConfig share]getMapDefWithID:[NSNumber numberWithInt:map]].mapName;
    
    self.sceneNameLabel.text = [NSString stringWithFormat:@"Lv. %d %@", map, [[StringConfig share] getLocalLanguage:nameKey]];

}

#pragma mark - implementation protocol function
-(void) setActorsWithArray:(NSArray *)actors
{
    
    for (BattleActor *actor in actors)
    {
        if (actor.ally == 0)
        {
            [self addBattleObject:actor];
        }
        
        if ( actor.ally == 1 && actor.type == 0 )
        {
            if(actor.battle.brief.map > 0 )
            {
                [self setCurrentMap:(int)actor.battle.brief.map];
            }
        }
    }
}

-(void) playerWithSubAction:(BattleSubAction *)subAction
{
    if (subAction == nil)
    {
        return;
    }
    [self addBattleObject:subAction];
}

-(void) playerWithAction:(BattleAction *)action
{
    if (action == nil)
    {
        return;
    }
    [self addBattleObject:action];
}

-(void) playerWithMine:(BattleMine *)mine
{
    [self addBattleObject:mine];
}

-(void) playerWithBrief:(BattleBrief *)brief
{
    [self addBattleObject:brief];
    
    AttributeString *attiString = [[AttributeString alloc]initWithBrief:brief];
    if (attiString == nil)
    {
        NSLog(@"AttributeString is nil in playerWithMine");
        return;
    }
    if ([attiString.results count] > 1) // 多条的时候  设置成胜利
    {
        [self updateViewControllers];
    }
}

-(void) addBattleObject:(NSObject *)obj
{
    UITableViewCell* cell = [self createCell:obj];
    if ( cell != nil )
    {
        [self.battleTableViewCells addObject:cell];
        [self.battleObjects addObject:obj];
    }
    while(self.battleTableViewCells.count > 50 )
          [self.battleTableViewCells removeObjectAtIndex:0];
    while(self.battleObjects.count > 50 )
        [self.battleObjects removeObjectAtIndex:0];
    
    [self.battleLogTableView reloadData];
    [self tableViewRollToBottom];
}

-(UITableViewCell*) createCell:(NSObject*)obj
{
    UITableViewCell* cell = nil;
    CGFloat width = self.battleLogTableView.frame.size.width;
    CGRect minFrame = CGRectMake(0, 0, width, 1);
    if ( [obj isKindOfClass:[BattleActor class]])
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleLogMessageCell" owner:self options:nil];
        BattleLogMessageCell* msgCell = (BattleLogMessageCell*)[array objectAtIndex:0];
        msgCell.frame = CGRectUnion(msgCell.frame, minFrame);
        AttributeString* attriString = [[AttributeString alloc]initWithActor: (BattleActor*)obj];
        [msgCell setupMessage:attriString.attrString];
        cell = msgCell;
    }
    else if ( [obj isKindOfClass:[BattleBrief class]])
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleLogMessageCell" owner:self options:nil];
        BattleLogMessageCell* msgCell = (BattleLogMessageCell*)[array objectAtIndex:0];
        msgCell.frame = CGRectUnion(msgCell.frame, minFrame);
        AttributeString* attriString = [[AttributeString alloc]initWithBrief:(BattleBrief*)obj];
        NSMutableAttributedString* string = [[NSMutableAttributedString alloc]init];
        int i = 1;
        for (NSAttributedString* tempAttriString in [attriString results])
        {
            [string appendAttributedString:tempAttriString];
            if ( i < [attriString results].count)
                [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] ];
            i ++;
        }
        [msgCell setupMessage:string];
        cell = msgCell;
    }
    else if ( [obj isKindOfClass:[BattleMine class]])
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleLogMessageCell" owner:self options:nil];
        BattleLogMessageCell* msgCell = (BattleLogMessageCell*)[array objectAtIndex:0];
        msgCell.frame = CGRectUnion(msgCell.frame, minFrame);
        AttributeString* attriString = [[AttributeString alloc]initWithMine:(BattleMine*)obj];
        [msgCell setupMessage:attriString.attrString];
        cell = msgCell;
    }
    else if ( [obj isKindOfClass:[BattleLogCounting class]] )
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleLogCountingCell" owner:self options:nil];
        BattleLogCountingCell* msgCell = (BattleLogCountingCell*)[array objectAtIndex:0];
        msgCell.frame = CGRectUnion(msgCell.frame, minFrame);
        [msgCell refreshMessage:(BattleLogCounting*)obj];
        cell = msgCell;
        
    }
    else if ( [obj isKindOfClass:[BattleAction class]] )
    {
        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BattleLogActionCell" owner:self options:nil];
        BattleLogActionCell* actionCell = (BattleLogActionCell*)[array objectAtIndex:0];
        [actionCell setNewFrame:CGRectUnion(actionCell.frame, minFrame)];
        [actionCell setupAction:(BattleAction*)obj];
        cell = actionCell;
    }
    
    return cell;
}

-(void)updateBattleLog:(NSArray *)arrayOfLog
{

}
@end
