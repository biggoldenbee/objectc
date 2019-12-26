//
//  UpGradeEquipViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "UpMainAttriViewController.h"
#import "GameObject.h"
#import "GameUI.h"
#import "PackageManager.h"
#import "GameUtility.h"
#import "UtilityDef.h"

#import "Equipment.h"

#import "QQProgressView.h"

#import "ConstantsConfig.h"
#import "AttriConfig.h"

#define DEFAULT_BACKGROUNDIAMGE_NAME    @"strengthen_equbar2"

#define PROGRESS_REAL                   @"strengthen_progress1"
#define PROGRESS_VIRTUAL                @"strengthen_progress2"
#define PROGRESS_BG                     @"equ_progressbg"

@interface UpMainAttriViewController ()

@property (nonatomic, strong) NSArray*  equipIdsForUpgrade;
@property (nonatomic, strong) NSMutableArray*  equipViewsArray;
@property (nonatomic, strong) NSNumber* equipIdWillUp;
@property (nonatomic, strong) NSNumber* petId;
@end

@implementation UpMainAttriViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.petId = DefaultValue;
    [self.attributeIcon setAttriID:1];
    [[self attriProgressView] setInitState];
    
    self.equipViewsArray = [[NSMutableArray alloc] init];
    [[self equipViewsArray] addObject:[self equipItem01]];
    [[self equipViewsArray] addObject:[self equipItem02]];
    [[self equipViewsArray] addObject:[self equipItem03]];
    [[self equipViewsArray] addObject:[self equipItem04]];
    [[self equipViewsArray] addObject:[self equipItem05]];
    [[self equipViewsArray] addObject:[self equipItem06]];
    
    [self resetUpMainAttriViewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetUpMainAttriViewData
{
    self.equipIdsForUpgrade = nil;
    costMoney = 0;
    addExp = 0;
    [self resetAllEquipViews];
}

-(void)resetAllEquipViews
{
    for (QQEquipBtnDefault* ebd in [self equipViewsArray])
    {
        [ebd initViewWithPartType:0 withPetId:[self petId]];
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

//
// 这个方法是给外部调用的，只在GameUI类里调用
// 是在界面弹出时做数据设置的工作。
//
-(void)showMainAttriView:(NSDictionary *)data
{
    if ([[self equipIdsForUpgrade] count] != 0)
    {
        [[GameObject sharedInstance] removeEquipsFromBagWithArray:[self equipIdsForUpgrade]];
    }
    
    if (costMoney != 0 )
    {
        [[[GameObject sharedInstance] player] reduceHeroMoney:costMoney];
        [[GameUI sharedInstance] updateHallView];
    }
    
    self.costMoneyLabel.text = @"0";
    
    [self resetUpMainAttriViewData];
    
    if ([data objectForKey:@"PetId"])
    {
        self.petId = [data objectForKey:@"PetId"];
    }
    
    if ([data objectForKey:@"EquipId"])
    {
        self.equipIdWillUp = [data objectForKey:@"EquipId"];
        Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[self equipIdWillUp]];
        
        self.attriLevelLabel.text = [[[equip mainAttri] attriLevel] stringValue];
        self.attriValueLabel.text = [[[equip mainAttri] attriValue] stringValue];
        
        [[self attributeIcon] setAttriID:[[[equip mainAttri] attriId] intValue]];
        
        self.attriLevelForUpLabel.text = self.attriLevelLabel.text;
        self.attriValueForUpLabel.text = self.attriValueLabel.text;
        
        UIImage* imageIcon = [GameUtility imageNamed:[equip getEquipIcon]];
        [[self equipIconImage] setImage:imageIcon];
        
        NSNumber* subAttriLv    = [[[equip subAttri] objectAtIndex:0] attriLevel];
        NSString* iconName      = [GameUtility getImageNameForEquipStrengthenWithStar:[subAttriLv intValue]];
        [self.equipColorImage setImage:[GameUtility imageNamed:iconName]];
        
        float fCurExp = [[[equip mainAttri] attriExp] floatValue];
        float fMaxExp = [[equip getMainAttributeMaxExp] floatValue];
        [self.attriProgressView setProgress0:fCurExp/fMaxExp animated:NO];
    }
}


#pragma mark - QQEquipBtnDefault Delegate
-(void)onClickedOnQQEquipDefaultView:(NSDictionary*)params
{
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:[self equipIdWillUp] forKey:@"EquipId"];
    [tempDict setObject:INT_TO_NUMBER(0) forKey:@"God"];
    [[GameUI sharedInstance] showEquipSelectView:tempDict];
}

#pragma mark - Button events Actions
- (IBAction)onAutoSelectClicked:(id)sender
{
    // 待续
    NSArray* equips = [[GameObject sharedInstance] getEquipsInBag];
    
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
    SortParam* param1 = [[SortParam alloc]init];
    param1.paramName = @"equipStar";
    param1.ascending = YES;
    [tempDict setObject:param1 forKey:@"0"];
    
    SortParam* param2 = [[SortParam alloc]init];
    param2.paramName = @"equipTId";
    param2.ascending = YES;
    [tempDict setObject:param2 forKey:@"1"];
    
    SortParam* param3 = [[SortParam alloc]init];
    param3.paramName = @"equipBV";
    param3.ascending = YES;
    [tempDict setObject:param3 forKey:@"2"];
    
    equips = [GameUtility array:equips sortArrayWithParams:tempDict];
    
    NSMutableArray* tempArr = [[NSMutableArray alloc] init];
    for (Equipment* equip in equips)
    {
        if ([tempArr count] == 6)
        {
            break;
        }
        
        if ([[equip equipEId] isEqualToNumber:[self equipIdWillUp]])
        {
            continue;
        }
        
        [tempArr addObject:[equip equipEId]];
    }
    
    costMoney = 0;
    addExp = 0;
    [self setOtherEquips:tempArr];
}
//
// 升级 发送升级请求  并收回当前界面
//
- (IBAction)onUpgradeClicked:(id)sender
{
    if (self.equipIdsForUpgrade != nil && [self.equipIdsForUpgrade count] > 0)
    {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        for (NSNumber* equipId in self.equipIdsForUpgrade)
        {
            [tempArr addObject:equipId];
        }
        [tempDict setObject:tempArr forKey:@"ID"];
        [tempDict setObject:[self equipIdWillUp] forKey:@"EID"];
        
        [[PackageManager sharedInstance] upgradeEquipMainAttriRequest:tempDict];
    }
    else
    {
        [[GameUI sharedInstance] showError:@"请选择升级材料！！！！" title:@"error"];
    }
}
- (IBAction)onCloseClicked:(id)sender
{
    [self resetUpMainAttriViewData];
    [[GameUI sharedInstance] showEquipInfoView:nil];
}

#pragma mark - received 
//
// 接受消息 kNotif_View_SelectedEquips 的处理
// 这个是从 CommonTableViewController 上发出的
//
//-(void)setOtherEquips:(NSNotification *)notify
-(void)setOtherEquips:(NSArray*)equipIds
{
    self.equipIdsForUpgrade = equipIds;
    
    for (int i=0;i<[equipIds count]; i++)
    {
        NSNumber* equipId = [equipIds objectAtIndex:i];
        if (i == 0)
        {
            [self.equipItem01 setEquipDataWithEId:equipId];
        }
        if (i == 1)
        {
            [self.equipItem02 setEquipDataWithEId:equipId];
        }
        if (i == 2)
        {
            [self.equipItem03 setEquipDataWithEId:equipId];
        }
        if (i == 3)
        {
            [self.equipItem04 setEquipDataWithEId:equipId];
        }
        if (i == 4)
        {
            [self.equipItem05 setEquipDataWithEId:equipId];
        }
        if (i == 5)
        {
            [self.equipItem06 setEquipDataWithEId:equipId];
        }
        
        Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:equipId];
        [self changeTotalExp:equip];
    }
}

-(void)changeTotalExp:(Equipment*)equip
{
    addExp += ([[equip getMainAttributeBaseExp] integerValue] + [[equip getMainAttributeTotalExp] integerValue]* [[equip getMainAttributeRatio] floatValue]);
    
    [self updateMoneyByUpgrade];
}
-(void)updateMoneyByUpgrade
{
    costMoney = 0;
    
    Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[self equipIdWillUp]];
    NSInteger curLv   = [[[equip mainAttri] attriLevel] integerValue];
    NSInteger curExp  = [[[equip mainAttri] attriExp] integerValue];
    
    NSInteger leftExp = addExp;
    do
    {
        NSInteger maxExp  = [[[MainAttriLvConfig share] getLevelMaxExpWithLv:INTEGER_TO_NUMBER(curLv) starNum:[equip equipStar]] integerValue];
        NSNumber* moneyRatio = [[MainAttriLvConfig share] getMoneyRatioWithLv:INTEGER_TO_NUMBER(curLv) starNum:[equip equipStar]];
        
        if (leftExp+curExp > maxExp)
        {
            costMoney += (maxExp - curExp) * [moneyRatio integerValue];
            leftExp -= (maxExp - curExp);
            curLv++;
            curExp = 0;
        }
        else
        {
            costMoney += leftExp * [moneyRatio integerValue];
            leftExp = 0;
        }
        
        if (curLv == [[[MainAttriLvConfig share] getMaxLevelWithStar:[equip equipStar]] integerValue])
        {
            break;
        }
    }while (leftExp > 0);
    
    self.attriLevelForUpLabel.text  = [NSString stringWithFormat:@"%lu", curLv];
    self.costMoneyLabel.text        = [NSString stringWithFormat:@"%lu", costMoney];
    
    NSNumber* attriValue = [[AttriConfig share] getAttriValueWithId:[[equip mainAttri] attriId] withLv:INTEGER_TO_NUMBER(curLv) withStar:[equip equipStar]];
    self.attriValueForUpLabel.text  = [attriValue stringValue];
}
@end
