//
//  StageSubViewController.m
//  Miner
//
//  Created by zhihua.qian on 15/1/7.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "StageInfoViewController.h"
#import "StageCollectionViewCell.h"
#import "MapConfig.h"
#import "StringConfig.h"
#import "GameObject.h"
#import "DropConfig.h"
#import "QuickBattleConfig.h"
#import "ItemConfig.h"
#import "PackageManager.h"
#import "GameUI.h"

@interface StageInfoViewController ()

@property (nonatomic, strong) MapDef* currentMapDef;
@property (nonatomic, strong) Hero* currentPlayer;

@property (nonatomic, assign) NSInteger maxQuickCount;
@property (nonatomic, assign) NSInteger curQuickCount;
@property (nonatomic, assign) NSInteger curQuickCost;

@property (nonatomic, strong) NSMutableArray* battleTcArray;
@property (nonatomic, strong) NSMutableArray* bossTcArray;
@end

@implementation StageInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self stageQuickFightingOutputCollectionView] registerClass:[StageCollectionViewCell class] forCellWithReuseIdentifier:@"PropsChip"];
    [[self stageQuickBossFightingOutputCollectionView] registerClass:[StageCollectionViewCell class] forCellWithReuseIdentifier:@"PropsChip"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)updateStageInfoView
{
    [self setDataInfoInViewControllers:[NSNumber numberWithInteger:[[self currentMapDef] mapID]]];
}

-(void)closeStageInfoView
{
    NSNumber* mapId = [NSNumber numberWithInteger:[[self currentMapDef] mapID]];
    NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:mapId,@"Map", nil];
    [[GameObject sharedInstance] setPlayerWithDictionary:tempDict];
    
    [self dismissViewControllerAnimated:NO completion:^{}];
    [[GameUI sharedInstance] showMineView];
}

-(void)setDataInfoInViewControllers:(NSNumber*)mapId
{
    self.currentMapDef  = [[MapConfig share] getMapDefWithID:mapId];
    self.currentPlayer  = [[GameObject sharedInstance] player];
    
    [[self stageNameLabel] setText:[[StringConfig share] getLocalLanguage:[[self currentMapDef] mapName]]];
    
    QuickBattleDef* def = [[QuickBattleConfig share] getQuickBattleDefWithLevel:[[[self currentPlayer] heroVipLevel] integerValue]];
    self.maxQuickCount  = [[def levelDatas] count];
    self.curQuickCount  = [[[self currentPlayer] heroQck] integerValue];
    NSInteger costNum   = [self maxQuickCount] - [self curQuickCount] + 1;
    self.curQuickCost   = [[[def levelDatas] objectForKey:[NSString stringWithFormat:@"%lu",(long)costNum]] moneyNum];
    
    [[self stageQuickFightingSpendLabel] setText:[NSString stringWithFormat:@"%lu", (long)[self curQuickCost]]];
    [[self stageQuickFightingNumLabel] setText:[NSString stringWithFormat:@"%lu/%lu", (long)[self curQuickCount],(long)[self maxQuickCount]]];
    
    [self setupBattleTcArrayWithId:[[self currentMapDef] battleTcID]];
    [self setupBossTcArrayWithId:[[self currentMapDef] bossTcID]];
}

-(void)setupBattleTcArrayWithId:(NSInteger)tcId
{
    self.battleTcArray = [[NSMutableArray alloc] init];
    TcDef* tcdef = [[TcConfig share] getTcDefWithId:tcId];
    NSArray* tcBases = [[tcdef tcDatas] allValues];
    for (TcBase* tcbase in tcBases)
    {
        NSInteger dropId = [tcbase dropID];
        DropDef* dropdef = [[DropConfig share] getDropDefWithId:dropId];
        [[self battleTcArray] addObject:dropdef];
    }
    
    NSSortDescriptor* idDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dropId" ascending:YES];
    NSArray* descriptors = [NSArray arrayWithObjects:idDescriptor, nil];
    NSArray* tempArr = [[self battleTcArray] sortedArrayUsingDescriptors:descriptors];
    [self setBattleTcArray:[NSMutableArray arrayWithArray:tempArr]];
    
    [[self stageQuickFightingOutputCollectionView] reloadData];
}
-(void)setupBossTcArrayWithId:(NSInteger)tcId
{
    self.bossTcArray = [[NSMutableArray alloc] init];
    TcDef* tcdef = [[TcConfig share] getTcDefWithId:tcId];
    NSArray* tcBases = [[tcdef tcDatas] allValues];
    for (TcBase* tcbase in tcBases)
    {
        NSInteger dropId = [tcbase dropID];
        DropDef* dropdef = [[DropConfig share] getDropDefWithId:dropId];
        [[self bossTcArray] addObject:dropdef];
    }
    
    NSSortDescriptor* idDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dropId" ascending:YES];
    NSArray* descriptors = [NSArray arrayWithObjects:idDescriptor, nil];
    NSArray* tempArr = [[self battleTcArray] sortedArrayUsingDescriptors:descriptors];
    [self setBattleTcArray:[NSMutableArray arrayWithArray:tempArr]];
    
    [[self stageQuickBossFightingOutputCollectionView] reloadData];
}

#pragma mark - collection view
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView tag] == 1)
    {
        return [[self battleTcArray] count];
    }
    else if ([collectionView tag] == 2)
    {
        return [[self bossTcArray] count];
    }
    else
    {
        return 0;
    }
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StageCollectionViewCell* cell = (StageCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"PropsChip" forIndexPath:indexPath];
    NSInteger row = [indexPath row];
    if ([collectionView tag] == 1)
    {
        [cell setupDataWithDropDef:[[self battleTcArray] objectAtIndex:row]];
    }
    
    if ([collectionView tag] == 2)
    {
        [cell setupDataWithDropDef:[[self bossTcArray] objectAtIndex:row]];
    }
    
    return cell;
}

#pragma mark - buttons events
- (IBAction)onEnterStageClicked:(id)sender
{
    NSNumber* currentmapId = [[[GameObject sharedInstance] player] heroMap];
    NSNumber* mapId = [NSNumber numberWithInteger:[[self currentMapDef] mapID]];
    
    if ([currentmapId isEqualToNumber:mapId])
    {
        return;
    }
    
    NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:mapId,@"Map", nil];
    [[PackageManager sharedInstance] changeMapRequest:tempDict];
}

- (IBAction)onEnterQuickFightingClicked:(id)sender
{
    if ([self curQuickCount] == 0)
    {
        return;
    }
    NSNumber* mapId = [NSNumber numberWithInteger:[[self currentMapDef] mapID]];
    NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:mapId,@"Map", nil];
    [[PackageManager sharedInstance] quickBattleRequest:tempDict];
}

- (IBAction)onOnceQuickBossFightingClicked:(id)sender
{
    [self sweepBossFighting:1];
}

- (IBAction)onTenTimesQuickBossFightingClicked:(id)sender
{
    [self sweepBossFighting:10];
}
-(void)sweepBossFighting:(int)count
{
    NSNumber* mapId = [NSNumber numberWithInteger:[[self currentMapDef] mapID]];
    NSNumber* cnt = [NSNumber numberWithInt:count];
    NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:cnt,@"Cnt",mapId,@"Map", nil];
    [[PackageManager sharedInstance] sweepRequest:tempDict];
}

- (IBAction)onCloseClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{}];
}
@end
