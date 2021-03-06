//
//  StageViewController.m
//  Miner
//
//  Created by zhihua.qian on 15-1-6.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "StageViewController.h"
#import "StageTableViewCell.h"
#import "MapConfig.h"
#import "GameObject.h"
#import "GameUI.h"

@interface StageViewController ()

@property (nonatomic, strong) NSMutableArray* stageCellsArr;
@property (nonatomic, strong) NSArray* stagesArr;

@property (nonatomic, strong) NSMutableArray* mapCellsArr;
@property (nonatomic, strong) NSArray* mapsArr;

@property (nonatomic, assign) STAGE_TYPE currentType;

@property (nonatomic, strong) NSNumber* currentMapId;
@property (nonatomic, strong) NSNumber* maxMapId;
@end

@implementation StageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentType = Type_None;
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

-(void)updateStageViewAllControllers
{
    [self updateStageView];
}

-(void)updateStageView
{
    self.currentType    = Type_Stage;
    self.stagesArr      = [[MapConfig share] getAllMapdef];
    
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:@"mapID" ascending:YES];
    NSArray* tempArr    = [NSArray arrayWithObjects:descriptor, nil];
    self.stagesArr      = [[self stagesArr] sortedArrayUsingDescriptors:tempArr];
    self.stageCellsArr  = [[NSMutableArray alloc]init];
    
    self.currentMapId   = [[[GameObject sharedInstance] player] heroMap];
    self.maxMapId       = [[[GameObject sharedInstance] player] heroTopMap];
    
    [[self stageTableView] reloadData];
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.stageTableView scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:NO];
}

-(void)updateOtherView
{
    self.currentType    = Type_Map;
    self.mapsArr        = [[NSArray alloc] init];
    self.mapCellsArr    = [[NSMutableArray alloc]init];
    
    [[self stageTableView] reloadData];
}

#pragma mark - table view 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger dataCount =0;
    if ([self currentType] == Type_Stage)
    {
        dataCount = [[self stagesArr] count];
    }
    else if ([self currentType] == Type_Map)
    {
        dataCount = [[self mapsArr] count];
    }
    
    return dataCount;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StageTableViewCell* cell    = nil;
    NSInteger row               = [indexPath row];
    if ([self currentType] == Type_Stage)
    {
        if (row >= [[self stageCellsArr] count])
        {
            NSString* className = NSStringFromClass([StageTableViewCell class]);
            NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:className  owner:self options:nil];
            cell = [nibs objectAtIndex:0];
            
            [cell setupDataWithDef:[[self stagesArr] objectAtIndex:row]
                      isCurrentMap:[self currentMapId]
                          isMaxMap:[self maxMapId]];
            
            [[self stageCellsArr] addObject:cell];
        }
        else
        {
            cell = [[self stageCellsArr] objectAtIndex:row];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if ([self currentType] == Type_Stage)
    {
        [[GameUI sharedInstance] showStageInfoView:[NSNumber numberWithInteger:[[[self stagesArr] objectAtIndex:row] mapID]]];
    }
}

#pragma mark - buttons events
- (IBAction)onStageClicked:(id)sender
{
    [self resetStageAndOtherBtn];
    [[self stageBtn] setSelected:YES];
    [self updateStageView];
}

- (IBAction)onOtherClicked:(id)sender
{
    [self resetStageAndOtherBtn];
    [[self otherBtn] setSelected:YES];
    [self updateOtherView];
}

-(void)resetStageAndOtherBtn
{
    [[self stageBtn] setSelected:NO];
    [[self otherBtn] setSelected:NO];
}

- (IBAction)onCloseClicked:(id)sender
{
    [[GameUI sharedInstance] showMineView];
}
@end
