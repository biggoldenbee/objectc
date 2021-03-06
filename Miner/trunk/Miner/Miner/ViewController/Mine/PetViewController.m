//
//  PetViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "PetViewController.h"
#import "Pet.h"
#import "CommonDef.h"
#import "StringConfig.h"
#import "Equipment.h"
#import "Skill.h"
#import "GameObject.h"
#import "GameUI.h"
#import "GameUtility.h"
#import "QQEquipBtnDefault.h"
#import "PackageManager.h"
#import "StringConfig.h"
#import "SkillTableViewCell01.h"
#import "SkillTableViewCell02.h"
#import "BaseAttribute.h"

#define Part_Button_Xib     @"QQEquipBtnView"

@interface PetViewController ()

@property (nonatomic, assign) NSInteger nState; // 0 装备，1 技能

@property (nonatomic, strong) Pet* currentPet;
@property (nonatomic, weak) NSArray *petArray;
@property (strong, nonatomic) NSMutableDictionary* partViewDict;

@property (nonatomic, strong) NSMutableArray* petSkillCellsArray;
@property (nonatomic, strong) NSArray* petSkills;
@property (strong, nonatomic) SkillTableViewCell01* tempSkillCell01;    // 嘿嘿
@property (strong, nonatomic) SkillTableViewCell02* tempSkillCell02;    // 嘿嘿

@end

@implementation PetViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self attributeIcon1] setAttriID:1];
    [[self attributeIcon2] setAttriID:2];
    [[self attributeIcon3] setAttriID:3];
    [[self attributeIcon4] setAttriID:4];
    [[self attributeIcon5] setAttriID:5];
    [[self attributeIcon6] setAttriID:6];
    [[self attributeIcon7] setAttriID:7];
    [[self attributeIcon8] setAttriID:8];
    
    // 部件view
    [self setupAllPartViews];
    [self transformRightBtn];
    
    self.tempSkillCell02 = [self createSelectSkillCell];
    self.petSkillCellsArray = [[NSMutableArray alloc]init];
    self.nState = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - create
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

// custom function for init
// 初始8个装备部件的view
-(void)setupAllPartViews
{
    // 一共8个部位
    self.partViewDict = [[NSMutableDictionary alloc] init];
    [[self partViewDict] setObject:[self weaponView] forKey:[NSNumber numberWithInt:EQUIP_SLOT_WEAPON]];
    [[self partViewDict] setObject:[self headView] forKey:[NSNumber numberWithInt:EQUIP_SLOT_HEAD]];
    [[self partViewDict] setObject:[self bodyView] forKey:[NSNumber numberWithInt:EQUIP_SLOT_BODY]];
    [[self partViewDict] setObject:[self handView] forKey:[NSNumber numberWithInt:EQUIP_SLOT_HAND]];
    [[self partViewDict] setObject:[self backView] forKey:[NSNumber numberWithInt:EQUIP_SLOT_BACK]];
    [[self partViewDict] setObject:[self footView] forKey:[NSNumber numberWithInt:EQUIP_SLOT_FOOT]];
    [[self partViewDict] setObject:[self dectectorView] forKey:[NSNumber numberWithInt:EQUIP_SLOT_DECTECTOR]];
    [[self partViewDict] setObject:[self pickaxeView] forKey:[NSNumber numberWithInt:EQUIP_SLOT_PICKAXE]];
}
// 重置8个装备部件的view
-(void)resetAllPartViews
{
    NSArray* allKeys = [[self partViewDict] allKeys];
    for (NSNumber* num in allKeys)
    {
        QQEquipBtnDefault* ebd = [[self partViewDict] objectForKey:num];
        [ebd initViewWithPartType:[num intValue] withPetId:[[self currentPet] petId]];
    }
    
    [self.weaponView refreshState:1];
    [self.headView refreshState:2];
    [self.bodyView refreshState:3];
    [self.handView refreshState:4];
    [self.backView refreshState:5];
    [self.footView refreshState:6];
    [self.dectectorView refreshState:7];
    [self.pickaxeView refreshState:8];
}

-(void)transformRightBtn
{
    self.chooseNextBtn.transform = CGAffineTransformMakeRotation(M_PI);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)updatePetViewAllControllers
{
    self.petArray = [[GameObject sharedInstance] getAllPetsFromHero];
    self.currentPet = [[self petArray] objectAtIndex:0];
    for (Pet* pet in [self petArray])
    {
        if ([pet isBattle])
        {
            self.currentPet = pet;
            break;
        }
    }
    [self resetAllPartViews];
    [self showPetEquipment:YES];
    [self showPetSkill:NO];
}
-(void)changePetEquipViewAllControllers:(Pet*)pet
{
    self.currentPet = pet;
    [self showPetEquipment:YES];
    [self showPetSkill:NO];
}
-(void)changePetSkillViewAllControllers:(Pet*)pet
{
    self.currentPet = pet;
    [self showPetEquipment:NO];
    [self showPetSkill:YES];
}

#pragma mark - about equip view
-(void)showPetEquipment:(BOOL)isShow
{
    if (isShow)
    {
        [self resetAllPartViews];
        
        self.petNameLabel.text  = [[StringConfig share] getLocalLanguage:[[self currentPet] petName]];
        NSString* lv = [NSString stringWithFormat:@"Lv. %@", [[[self currentPet] petLevel] stringValue]];
        self.petLevelLabel.text = lv;
        
        self.attackLabel.text   = [[[[self currentPet] basicAttri] attriAtkValue] stringValue];
        self.armorLabel.text    = [[[[self currentPet] basicAttri] attriDefValue] stringValue];
        self.pdefLabel.text     = [[[[self currentPet] basicAttri] attriPDefValue] stringValue];
        self.mdefLabel.text     = [[[[self currentPet] basicAttri] attriMDefValue] stringValue];
        self.liveLabel.text     = [[[[self currentPet] basicAttri] attriHpMaxValue] stringValue];
        self.probeLabel.text    = [[[[self currentPet] basicAttri] attriFoundValue] stringValue];
        self.speedLabel.text    = [[[[self currentPet] basicAttri] attriSpdValue] stringValue];
        self.excavateLabel.text = [[[[self currentPet] basicAttri] attriDigValue] stringValue];
        
        [self setActiveBtnBackgroundImageWithAcitve:[[self currentPet] isBattle]];
        
        [self setPetBVData];
    }
    [[self petEquipView] setHidden:!isShow];
}
-(void)setPetBVData
{
    // 初始战力
    int32_t bv = [[self.currentPet petBV] intValue];
    // 玩家身上装备数组
    NSArray* equipsData = [[self currentPet] petEquitsArray];
    for (Equipment *tempEquip in equipsData)
    {
        [self setEquipPartBtnWithEquip:tempEquip];
        bv += [tempEquip.equipBV intValue];
    }
    self.combatLabel.text = [NSString stringWithFormat:@"%d", bv];
}
-(void)setEquipPartBtnWithEquip:(Equipment*)equip
{
    QQEquipBtnDefault* tempView = [[self partViewDict] objectForKey:[equip equipSlot]];
    if (tempView == nil)
    {
        NSString* slotString    = [[equip equipSlot] stringValue];
        NSString* errString     = [NSString stringWithFormat:@"未找到部件 %@ 窗口view", slotString];
        [[GameUI sharedInstance] showError:errString title:@"error"];
        return;
    }
    
    [tempView setEquipDataWithEId:[equip equipEId]];
}

#pragma mark - about skill view
-(void)showPetSkill:(BOOL)isShow
{
    if (isShow)
    {
        self.petSkills = [[self currentPet] skillsArray];
        self.petSkillCellsArray = [[NSMutableArray alloc] init];
        [[self petSkillTableView] reloadData];
    }
    [[self petSkillView] setHidden:!isShow];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self petSkills] count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SkillTableViewCell01* cell = nil;
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    if (row < [[self petSkillCellsArray] count])
    {
         cell = [[self petSkillCellsArray] objectAtIndex:row];
    }
    else
    {
        cell = [self createSkillCell];
        cell.sectionInTableView = section;
        cell.rowInTableView = row;
        Skill* skill = [[self petSkills] objectAtIndex:row];
        [cell setDataInfoForAllControllers:[skill skillTId] skillLV:[skill skillLv] superViewController:self];
        [[self petSkillCellsArray] addObject:cell];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 58;
    NSInteger row = [indexPath row];

    if (row < [[self petSkillCellsArray] count])
    {
        height = [[[self petSkillCellsArray] objectAtIndex:row] frame].size.height;
    }

    return height;
}

#pragma mark - the functions are used by cell
-(void)resetTempSkillCell02WithId:(NSNumber*)identifier skillLv:(NSNumber*)skillLv inSection:(NSInteger)section atRow:(NSInteger)row
{
    self.tempSkillCell02.sectionInTableView = section;
    self.tempSkillCell02.rowInTableView = row;
    [self.tempSkillCell02 setDataInfoForAllControllers:identifier withLv:skillLv superViewController:self];
}
-(void)didSelectRowInSection:(NSInteger)section atRow:(NSInteger)row
{
    SkillTableViewCell01* cell01 = nil;

    if ( [[[self petSkillCellsArray] objectAtIndex:row] isKindOfClass:[SkillTableViewCell01 class]] )
    {
        [self usingAndUnusingCellArray];
        cell01 = [[self petSkillCellsArray] objectAtIndex:row];
        [self resetTempSkillCell02WithId:[cell01 skillId]
                                 skillLv:[cell01 skillLv]
                               inSection:section
                                   atRow:row];
        [[self petSkillCellsArray] replaceObjectAtIndex:row withObject:[self tempSkillCell02]];
        self.tempSkillCell01 = cell01;
    }
    else
    {
        [self usingAndUnusingCellArray];
    }
    
    [[self petSkillTableView] reloadData];
}
-(void)usingAndUnusingCellArray
{
    if ([self tempSkillCell01] != nil)
    {
        SkillTableViewCell02* cell02 = nil;

        cell02 = [[self petSkillCellsArray] objectAtIndex:[[self tempSkillCell01] rowInTableView]];
        [[self petSkillCellsArray] replaceObjectAtIndex:[[self tempSkillCell01] rowInTableView] withObject:[self tempSkillCell01]];

        self.tempSkillCell01 = nil;
    }
}

-(NSNumber*)getCurrentPetId
{
    return [[self currentPet] petId];
}

#pragma mark - update functions
-(void)updatePetEquipViewControllers
{
    self.petArray = [[GameObject sharedInstance] getAllPetsFromHero];
    [self showPetEquipment:YES];
}

-(void)updatePetSkillViewAllControllers
{
    self.petArray = [[GameObject sharedInstance] getAllPetsFromHero];
    [self showPetSkill:YES];
}

-(void)updatePetActiveBtnControllers
{
    BOOL isActive = NO;
    if ([[[[self activeBtn] titleLabel] text] isEqualToString:@"Active"])
    {
        isActive = YES;
    }
    else
    {
        isActive = NO;
    }
    
    [self setActiveBtnBackgroundImageWithAcitve:isActive];
    [[self currentPet] setIsBattle:isActive];
}
#pragma mark - commone buttons events
- (IBAction)onEquipBtnClicked:(id)sender
{
    [self resetCommonBtnState];
    [[self equipmentBtn] setSelected:YES];
    [self showPetEquipment:YES];
    [self showPetSkill:NO];
    self.nState = 0;
}
- (IBAction)onSkillBtnClicked:(id)sender
{
    [self resetCommonBtnState];
    [[self skillBtn] setSelected:YES];
    [self showPetEquipment:NO];
    [self showPetSkill:YES];
    self.nState = 1;
}
-(void)resetCommonBtnState
{
    [[self equipmentBtn] setSelected:NO];
    [[self skillBtn] setSelected:NO];
}

- (IBAction)ocCloseBtnClicked:(id)sender
{
    [[GameUI sharedInstance] showMineView];
}

#pragma mark - equip view buttons events
- (IBAction)onMoreInfoBtnClicked:(id)sender
{
}

- (IBAction)onActivePetBtnClicked:(id)sender
{
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:[[self currentPet] petId] forKey:@"Pet"];
    NSInteger activeNum = 0;
    if ([[self currentPet] isBattle])
    {
        activeNum = 0;
    }
    else
    {
        activeNum = 1;
    }
    [tempDict setObject:[NSNumber numberWithInteger:activeNum] forKey:@"Active"];
    [[PackageManager sharedInstance] changePetRequest:tempDict];
}
- (IBAction)onPrePetBtnClicked:(id)sender
{
    NSUInteger petIndex = [[self petArray] indexOfObject:[self currentPet]];
    if (petIndex == 0)
    {
        return;
    }
    else
    {
        petIndex--;
    }
    if ([self nState] == 0)
    {
        [self changePetEquipViewAllControllers:[[self petArray] objectAtIndex:petIndex]];
    }
    else
    {
        [self changePetSkillViewAllControllers:[[self petArray] objectAtIndex:petIndex]];
    }
}
- (IBAction)onNextPetBtnClicked:(id)sender
{
    NSUInteger petIndex = [[self petArray] indexOfObject:[self currentPet]];
    if (petIndex == [[self petArray] count] - 1)
    {
        return;
    }
    else
    {
        petIndex++;
    }
    if ([self nState] == 0)
    {
        [self changePetEquipViewAllControllers:[[self petArray] objectAtIndex:petIndex]];
    }
    else
    {
        [self changePetSkillViewAllControllers:[[self petArray] objectAtIndex:petIndex]];
    }
}

#pragma mark - privated function
-(void)setActiveBtnBackgroundImageWithAcitve:(BOOL)isActive
{
    if (!isActive)
    {
        [[self activeBtn] setTitle:@"Active" forState:UIControlStateNormal];
        [[self activeBtn] setTitle:@"Active" forState:UIControlStateHighlighted];
        [[self activeBtn] setBackgroundImage:[GameUtility imageNamed:@"base_button13_a"] forState:UIControlStateNormal];
        [[self activeBtn] setBackgroundImage:[GameUtility imageNamed:@"base_button13_b"] forState:UIControlStateHighlighted];
    }
    else
    {
        [[self activeBtn] setTitle:@"Rest" forState:UIControlStateNormal];
        [[self activeBtn] setTitle:@"Rest" forState:UIControlStateHighlighted];
        [[self activeBtn] setBackgroundImage:[GameUtility imageNamed:@"base_button12_a"] forState:UIControlStateNormal];
        [[self activeBtn] setBackgroundImage:[GameUtility imageNamed:@"base_button12_b"] forState:UIControlStateHighlighted];
    }
    
    [[self activeImage] setHidden:!isActive];
}
@end
