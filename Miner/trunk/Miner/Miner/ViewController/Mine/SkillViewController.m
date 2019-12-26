//
//  SkillViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "SkillViewController.h"
#import "SkillTableViewCell01.h"
#import "SkillTableViewCell02.h"
#import "SkillCommonTableViewCell.h"
#import "HeroConfig.h"
#import "Skill.h"
#import "SkillConfig.h"
#import "GameObject.h"
#import "GameUtility.h"
#import "QQSkillBtnUsing.h"
#import "GameUI.h"
#import "PackageManager.h"
#import "UtilityDef.h"

@interface SkillViewController ()

@property (strong, nonatomic) NSArray* topSkillViews;

@property (nonatomic, strong) NSArray *skillsAllArray;      // 所有配置的技能(SkillDef)
@property (nonatomic, strong) NSArray *skillsUsingArray;    // 装配上的技能(Skill)
@property (nonatomic, strong) NSArray *skillsUnusingArray;  // 所有技能 - 装备后的技能(SkillDef)
@property (strong, nonatomic) NSMutableArray* usingSkillCellArray;      // 使用技能的cell
@property (strong, nonatomic) NSMutableArray* unusingSkillCellArray;    // 未使用的技能cell

@property (assign, nonatomic) NSInteger skillSlots;         // 玩家可用技能槽数量

@property (strong, nonatomic) SkillTableViewCell01* tempSkillCell01;    // 嘿嘿
@property (strong, nonatomic) SkillTableViewCell02* tempSkillCell02;    // 嘿嘿

@property (strong, nonatomic) NSNumber* skillWillChange;
@property (assign, nonatomic) BOOL      isAdd;
@end

@implementation SkillViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    // 也许这儿可以大模块更新  不需要这么细节  根据主角的信息状态
    // 譬如  updateAllLabel
    [self setupTopUsingView];
    [self initUsingAndUnusingCellArray];
    
    self.tempSkillCell02 = [self createSelectSkillCell];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 装载上半部技能
-(void)setupTopUsingView
{
    self.topSkillViews = [NSArray arrayWithObjects:self.oneSkillView, self.secondSkillView, self.thirdSkillView, self.fourSkillView, nil];
    for (int i=0; i< [[self topSkillViews] count]; i++)
    {
        QQSkillBtnUsing* skillView = [self createSkillBtnUsing];
        [skillView resetAllControllers];
        [[[self topSkillViews] objectAtIndex:i] addSubview:skillView];
    }
}

// 初始 cell 数组
-(void)initUsingAndUnusingCellArray
{
    // 这里需要简化
    self.usingSkillCellArray =[[NSMutableArray alloc] init];
    self.unusingSkillCellArray = [[NSMutableArray alloc] init];
    
    SkillCommonTableViewCell* usingCell = [self createSKillCommoneCell];
    [usingCell setDataForController:@"Equiped:"];
    [[self usingSkillCellArray] addObject:usingCell];
    
    SkillCommonTableViewCell* unusingCell = [self createSKillCommoneCell];
    [unusingCell setDataForController:@"Optional:"];
    [[self unusingSkillCellArray] addObject:unusingCell];
}

// 排序方法
-(NSArray*)sortSkillArray:(NSArray*)array withKey:(NSString*)key asceding:(BOOL)isAsc
{
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:isAsc];
    NSArray* tempArr = [NSArray arrayWithObjects:descriptor, nil];
    return [array sortedArrayUsingDescriptors:tempArr];
}

#pragma mark - create cell and widgets
-(QQSkillBtnUsing*)createSkillBtnUsing
{
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"QQSkillBtnView" owner:self options:nil];
    QQSkillBtnUsing* cell = [nibs objectAtIndex:0];
    return cell;
}

-(SkillCommonTableViewCell*)createSKillCommoneCell
{
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"SkillCommonTableViewCell" owner:self options:nil];
    SkillCommonTableViewCell* cell = [nibs objectAtIndex:0];
    return cell;
}
-(SkillTableViewCell01*)createSkillCell
{
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"SkillTableViewCell01" owner:self options:nil];
    SkillTableViewCell01* cell = [nibs objectAtIndex:0];
    return cell;
}
-(SkillTableViewCell02*)createSelectSkillCell
{
    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"SkillTableViewCell02" owner:self options:nil];
    SkillTableViewCell02* cell = [nibs objectAtIndex:0];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - main functions
-(void)updateSkills
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.skillTableView scrollToRowAtIndexPath:indexPath
                               atScrollPosition:UITableViewScrollPositionBottom
                                       animated:NO];
//    if ([self isAdd])
//    {
//        // qzh 
//        [[[GameObject sharedInstance] player] addSkillWithId:[self skillWillChange] withLv:INT_TO_NUMBER(1)];
//    }
//    else
//    {
//        [[[GameObject sharedInstance] player] removeSkillWithId:[self skillWillChange]];
//    }
    [self initUsingAndUnusingCellArray];
    self.tempSkillCell01 = nil;
    [self setAllViewControllers];
}

-(void)setAllViewControllers
{
    [self setupUsingSkillArray];
    [self setupUnsuingSkillArray];
    
    Hero* player = [[GameObject sharedInstance] player];
    self.skillSlots = [[player heroLevelData] skillNum];
    NSString* strSP = [NSString stringWithFormat:@"Point: %@", [player.heroSkillPoint stringValue]];
    [[self skillPointLabel] setText:strSP];
    [self initTopUsingView];
    [self.skillTableView reloadData];
}

-(void)setupUsingSkillArray
{
    NSArray* allSkills = [[GameObject sharedInstance] getHeroSkillsArray];
    
    NSMutableArray* temparr = [[NSMutableArray alloc] init];
    for (Skill* skill in allSkills)
    {
        if ([skill skillIsActive])
        {
            [temparr addObject:skill];
        }
    }
    self.skillsUsingArray = temparr;
    self.skillsUsingArray = [self sortSkillArray:[self skillsUsingArray] withKey:@"skillTId" asceding:YES];
}

-(void)setupUnsuingSkillArray
{
    NSArray* allSkills = [[GameObject sharedInstance] getHeroSkillsArray];
    
    NSMutableArray* temparr = [[NSMutableArray alloc] init];
    for (Skill* skill in allSkills)
    {
        if (![skill skillIsActive])
        {
            [temparr addObject:skill];
        }
    }
    self.skillsUnusingArray = temparr;
    self.skillsUnusingArray = [self sortSkillArray:[self skillsUnusingArray] withKey:@"skillTId" asceding:YES];
}

// 初始上半部分技能数据，并显示
-(void)initTopUsingView
{
    // 重置
    for (int i=0; i< [[self topSkillViews] count]; i++)
    {
        QQSkillBtnUsing* skillView = [[[[self topSkillViews] objectAtIndex:i] subviews] objectAtIndex:0];
        [skillView resetAllControllers];
    }
    
    // 开锁
    for (int i=0; i<[self skillSlots]; i++)
    {
        NSArray* subviews = [[[self topSkillViews] objectAtIndex:i] subviews];
        QQSkillBtnUsing* skillView = [subviews objectAtIndex:0];
        [skillView openTheLockSlot];
    }
    
    // 显示界面
    for (int i=0; i < [[self skillsUsingArray] count]; i++)
    {
        Skill* skill = [[self skillsUsingArray] objectAtIndex:i];
        
        NSArray* subviews = [[[self topSkillViews] objectAtIndex:i] subviews];
        QQSkillBtnUsing* skillView = [subviews objectAtIndex:0];
        [skillView setDataForAllControllersWithSkill:skill atSlot:i+1 supViewController:self];
    }
}

// 在未使用队列中移除使用的技能数据
-(NSArray*)removeUsingSkillFromUnusingArray
{
    NSMutableArray* tempArr = [NSMutableArray arrayWithArray:[self skillsAllArray]];
    for (Skill* skill in [self skillsUsingArray])
    {
        NSNumber* skillId = [skill skillTId];
        for (Skill* skillDef in [self skillsAllArray])
        {
            if ([[skillDef skillTId] isEqualToNumber:skillId])
            {
                [tempArr removeObject:skillDef];
            }
        }
    }
    return tempArr;
}

#pragma mark - Skill Table View
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.skillTableView)
    {
        return 2;
    }
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.skillTableView)
    {
        if (section == 0 )
        {
            return [[self skillsUsingArray] count]+1;
        }
        else
        {
            return [[self skillsUnusingArray] count] + 1;
        }
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.skillTableView)
    {
        SkillTableViewCell01* cell = nil;
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
        if (section == 0)
        {
            if (row < [[self usingSkillCellArray] count])
            {
                cell = [[self usingSkillCellArray] objectAtIndex:row];
            }
            else
            {
                cell = [self createSkillCell];
                cell.sectionInTableView = section;
                cell.rowInTableView = row;
                Skill* skill = [[self skillsUsingArray] objectAtIndex:row-1];
                [cell setDataInfoForAllControllers:[skill skillTId] skillLV:[skill skillLv] superViewController:self];
                [[self usingSkillCellArray] addObject:cell];
            }
        }
        else
        {
            if (row < [[self unusingSkillCellArray] count])
            {
                cell = [[self unusingSkillCellArray] objectAtIndex:row];
            }
            else
            {
                cell = [self createSkillCell];
                cell.sectionInTableView = section;
                cell.rowInTableView = row;
                Skill* skill = [[self skillsUnusingArray] objectAtIndex:row-1];
                [cell setDataInfoForAllControllers:[skill skillTId] skillLV:[skill skillLv] superViewController:self];
                [[self unusingSkillCellArray] addObject:cell];
            }
        }
        return cell;
    }
    else
    {
        return [[UITableViewCell alloc]init];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.skillTableView)
    {
        CGFloat height = 58;
        NSInteger section = [indexPath section];
        NSInteger row = [indexPath row];
        if (section == 0)
        {
            if (row < [[self usingSkillCellArray] count])
            {
                height = [[[self usingSkillCellArray] objectAtIndex:row] frame].size.height;
            }
        }
        else
        {
            if (row < [[self unusingSkillCellArray] count])
            {
                height = [[[self unusingSkillCellArray] objectAtIndex:row] frame].size.height;
            }
        }
        return height;
    }
    else
    {
        return 0;
    }
}

#pragma mark - the functions are used by cell
-(void)resetTempSkillCell02WithId:(NSNumber*)identifier withLv:(NSNumber*)skillLv inSection:(NSInteger)section atRow:(NSInteger)row
{
    self.tempSkillCell02.sectionInTableView = section;
    self.tempSkillCell02.rowInTableView = row;
    [self.tempSkillCell02 setDataInfoForAllControllers:identifier withLv:skillLv superViewController:self];
}

-(void)didSelectRowInSection:(NSInteger)section atRow:(NSInteger)row
{
    SkillTableViewCell01* cell01 = nil;
    [self selectedTopViewWithId:[[self tempSkillCell01] skillId] isSelected:NO];
    if (section == 0)
    {
        if ( [[[self usingSkillCellArray] objectAtIndex:row] isKindOfClass:[SkillTableViewCell01 class]] )
        {
            [self usingAndUnusingCellArray];
            cell01 = [[self usingSkillCellArray] objectAtIndex:row];
            [self resetTempSkillCell02WithId:[cell01 skillId]
                                      withLv:[cell01 skillLv]
                                   inSection:section
                                       atRow:row];
            [[self usingSkillCellArray] replaceObjectAtIndex:row withObject:[self tempSkillCell02]];
            self.tempSkillCell01 = cell01;
            [self selectedTopViewWithId:[cell01 skillId] isSelected:YES];
        }
        else
        {
            [self usingAndUnusingCellArray];
        }
    }
    else
    {
        if ( [[[self unusingSkillCellArray] objectAtIndex:row] isKindOfClass:[SkillTableViewCell01 class]] )
        {
            [self usingAndUnusingCellArray];
            cell01 = [[self unusingSkillCellArray] objectAtIndex:row];
            [self resetTempSkillCell02WithId:[cell01 skillId]
                                      withLv:[cell01 skillLv]
                                   inSection:section
                                       atRow:row];
            [[self unusingSkillCellArray] replaceObjectAtIndex:row withObject:[self tempSkillCell02]];
            self.tempSkillCell01 = cell01;
        }
        else
        {
            [self usingAndUnusingCellArray];
        }
    }
    
    [[self skillTableView] reloadData];
}

-(void)usingAndUnusingCellArray
{
    if ([self tempSkillCell01] != nil)
    {
        SkillTableViewCell02* cell02 = nil;
        if ([[self tempSkillCell01] sectionInTableView] == 0)
        {
            cell02 = [[self usingSkillCellArray] objectAtIndex:[[self tempSkillCell01] rowInTableView]];
            [[self usingSkillCellArray] replaceObjectAtIndex:[[self tempSkillCell01] rowInTableView] withObject:[self tempSkillCell01]];
        }
        else
        {
            cell02 = [[self unusingSkillCellArray] objectAtIndex:[[self tempSkillCell01] rowInTableView]];
            [[self unusingSkillCellArray] replaceObjectAtIndex:[[self tempSkillCell01] rowInTableView] withObject:[self tempSkillCell01]];
        }
        self.tempSkillCell01 = nil;
    }
}

-(void)unloadSkillWithId:(NSNumber*)skillId
{
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    for (Skill* skill in [self skillsUsingArray])
    {
        if ([[skill skillTId] isEqualToNumber:skillId])
        {
            self.skillWillChange = skillId;
            self.isAdd = false;
            continue;
        }
        
        [tempArr addObject:[skill skillTId]];
    }
    
    NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:tempArr,@"Skill", nil];
    [[PackageManager sharedInstance] changeSkillRequest:tempDict];
}

-(void)loadSkillWithId:(NSNumber*)skillId
{
    if ([[self skillsUsingArray] count] == [self skillSlots] )
    {
        NSLog(@"技能已经装满，请先卸载^_^！");
        return;
    }
    
    self.skillWillChange = skillId;
    self.isAdd = YES;
    
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    for (Skill* skill in [self skillsUsingArray])
    {        
        [tempArr addObject:[skill skillTId]];
    }
    [tempArr addObject:skillId];
    
    NSDictionary* tempDict = [NSDictionary dictionaryWithObjectsAndKeys:tempArr,@"Skill", nil];
    [[PackageManager sharedInstance] changeSkillRequest:tempDict];
}

#pragma mark - top view manager
-(void)selectedTopViewWithId:(NSNumber*)skillId isSelected:(BOOL)isSel
{
    if (skillId == nil)
    {
        return;
    }
    
    QQSkillBtnUsing* sbu = nil;
    for (UIView* topview in [self topSkillViews])
    {
        sbu = [[topview subviews] objectAtIndex:0];
        [sbu setSelectedState:NO];
        if ([[sbu getSkillIdentifier] isEqualToNumber:skillId])
        {
            [sbu setSelectedState:isSel];
        }
    }
}

#pragma mark - buttons events
- (IBAction)onClosedClicked:(id)sender
{
    [[GameUI sharedInstance] showMineView];
}
@end
