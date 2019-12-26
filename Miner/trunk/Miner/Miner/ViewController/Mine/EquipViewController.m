//
//  EquipmentViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "EquipViewController.h"
#import "Equipment.h"
#import "StringConfig.h"
#import "GameObject.h"
#import "GameUI.h"
#import "UtilityDef.h"
#import "BaseAttribute.h"

#define Part_Button_Xib     @"QQEquipBtnView"

@interface EquipViewController ()

@property (nonatomic, weak)     Hero* player;
@property (nonatomic, strong)   NSMutableDictionary* partViewDict;

@end

@implementation EquipViewController
#pragma mark - init
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self.attriIcon01 setAttriID:1];
    [self.attriIcon02 setAttriID:2];
    [self.attriIcon03 setAttriID:3];
    [self.attriIcon04 setAttriID:4];
    [self.attriIcon05 setAttriID:5];
    [self.attriIcon06 setAttriID:6];
    [self.attriIcon07 setAttriID:7];
    [self.attriIcon08 setAttriID:8];
    
    self.partViewDict = [[NSMutableDictionary alloc] init];
    [[self partViewDict] setObject:[self weaponView] forKey:INT_TO_NUMBER(1)];
    [[self partViewDict] setObject:[self headView] forKey:INT_TO_NUMBER(2)];
    [[self partViewDict] setObject:[self bodyView] forKey:INT_TO_NUMBER(3)];
    [[self partViewDict] setObject:[self handView] forKey:INT_TO_NUMBER(4)];
    [[self partViewDict] setObject:[self backView] forKey:INT_TO_NUMBER(5)];
    [[self partViewDict] setObject:[self footView] forKey:INT_TO_NUMBER(6)];
    [[self partViewDict] setObject:[self dectectorView] forKey:INT_TO_NUMBER(7)];
    [[self partViewDict] setObject:[self pickaxeView] forKey:INT_TO_NUMBER(8)];
    [self resetAllPartViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.weaponView refreshState:1];
    [self.headView refreshState:2];
    [self.bodyView refreshState:3];
    [self.handView refreshState:4];
    [self.backView refreshState:5];
    [self.footView refreshState:6];
    [self.dectectorView refreshState:7];
    [self.pickaxeView refreshState:8];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 重置8个装备部件的view
-(void)resetAllPartViews
{
    NSArray* allKeys = [[self partViewDict] allKeys];
    for (NSNumber* partNum in allKeys)
    {
        QQEquipBtnDefault* ebd = [[self partViewDict] objectForKey:partNum];
        [ebd initViewWithPartType:[partNum intValue] withPetId:DefaultValue];
        ebd.deleate = self;
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

// 每次打开都调用
-(void)setEquipViewData
{
    [self updateEquipViewData];
    
    [self.weaponView refreshState:1];
    [self.headView refreshState:2];
    [self.bodyView refreshState:3];
    [self.handView refreshState:4];
    [self.backView refreshState:5];
    [self.footView refreshState:6];
    [self.dectectorView refreshState:7];
    [self.pickaxeView refreshState:8];
}

-(void)updateEquipViewData
{
    self.player = [[GameObject sharedInstance] player];
    [self resetAllPartViews];
    
    [self setHeroAttributeData];    // 设置上半部分属性值
    [self setHeroBVData];           // 计算玩家战斗力 并显示装备icon
}

-(void)setHeroAttributeData
{
    self.attackLabel.text   = [[self.player.heroAttributes attriAtkValue] stringValue];
    self.liveLabel.text     = [[self.player.heroAttributes attriHpMaxValue] stringValue];
    self.speedLabel.text    = [[self.player.heroAttributes attriSpdValue] stringValue];
    self.armorLabel.text    = [[self.player.heroAttributes attriDefValue] stringValue];
    self.pdefLabel.text     = [[self.player.heroAttributes attriPDefValue] stringValue];
    self.mdefLabel.text     = [[self.player.heroAttributes attriMDefValue] stringValue];
    self.probeLabel.text    = [[self.player.heroAttributes attriFoundValue] stringValue];
    self.excavateLabel.text = [[self.player.heroAttributes attriDigValue] stringValue];
    
    self.playerLevelLabel.text  = [[self.player heroLevel] stringValue];
    self.playerNameLabel.text   = [self.player heroName];
}
-(void)setHeroBVData
{
    // 初始战力
    int32_t bv = [[self.player heroBv] intValue];
    // 玩家身上装备数组
    NSArray* equipsData = [[GameObject sharedInstance] getHeroEquipsArray];
    for (Equipment *tempEquip in equipsData)
    {
        // 设置装备部件view
        [self setEquipPartBtnWithEquip:tempEquip];
        bv += [tempEquip.equipBV intValue];
    }
    self.miningForceLabel.text = [NSString stringWithFormat:@"%d", bv];
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

//#pragma mark - QQEquipBtnDefault Delegate
//-(void)onClickedOnQQEquipDefaultView:(NSDictionary*)params
//{
//    // 留着  以后也许会用到  相信我
//}

#pragma mark - Click events
- (IBAction)onClosedClicked:(id)sender
{
    [[GameUI sharedInstance] showMineView];
}

- (IBAction)onShowMoreAttriClicked:(id)sender
{
}
@end
