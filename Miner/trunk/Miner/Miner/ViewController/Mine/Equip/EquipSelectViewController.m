//
//  EquipSelectViewController.m
//  Miner
//
//  Created by zhihua.qian on 15-1-4.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "EquipSelectViewController.h"
#import "EquipSelectTableViewCell.h"
#import "GameObject.h"
#import "Bag.h"
#import "GameUI.h"
#import "Equipment.h"
#import "GameUtility.h"
#import "UtilityDef.h"

@interface EquipSelectViewController ()

@property (nonatomic, strong) NSArray* equipsInBag;

@property (nonatomic, strong) NSMutableArray* tableVIewCells;
@property (nonatomic, strong) NSMutableArray *equipIdList;      // 装备id数组

@property (nonatomic, strong) NSNumber* equipWillChange;
@property (strong, nonatomic) NSNumber* petId;

@property (assign, nonatomic) BOOL isGod;
@end

@implementation EquipSelectViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isGod          = NO;
    self.petId          = DefaultValue;
    self.tableVIewCells = [[NSMutableArray alloc] init];
    self.equipIdList    = [[NSMutableArray alloc] init];
    self.equipsInBag    = [[[GameObject sharedInstance] bag] bagEquips];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetEquipSelectAllData
{
    [EquipSelectTableViewCell resetSelectCount];
    [[self tableVIewCells] removeAllObjects];
    [[self equipIdList] removeAllObjects];
    self.equipsInBag = [[GameObject sharedInstance] getEquipsInBag];
    costMoney = 0;
    addExp = 0;
    
    
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
    SortParam* param1 = [[SortParam alloc]init];
    param1.paramName = @"equipStar";
    param1.ascending = NO;
    [tempDict setObject:param1 forKey:@"0"];
    SortParam* param2 = [[SortParam alloc]init];
    param2.paramName = @"equipTId";
    param2.ascending = NO;
    [tempDict setObject:param2 forKey:@"1"];
    SortParam* param3 = [[SortParam alloc]init];
    param3.paramName = @"equipBV";
    param3.ascending = NO;
    [tempDict setObject:param3 forKey:@"2"];
    self.equipsInBag = [GameUtility array:[self equipsInBag] sortArrayWithParams:tempDict];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setDataForSelectViewControllers:(NSDictionary*)data
{
    [self resetEquipSelectAllData];
    
    if ([data objectForKey:@"PetId"])
    {
        self.petId = [data objectForKey:@"PetId"];
    }
    
    if ([data objectForKey:@"God"])
    {
        self.isGod = [[data objectForKey:@"God"] boolValue];
    }

    if ([data objectForKey:@"EquipId"])
    {
        self.equipWillChange = [data objectForKey:@"EquipId"];
        Equipment* equip = [[GameObject sharedInstance]getEquipWithEId:[self equipWillChange]];
        if (equip == nil)
        {
            [[GameUI sharedInstance] showError:@"没有找到部件上的装备" title:@"error"];
            return;
        }
        else
        {
            NSMutableArray* tempArr = [NSMutableArray arrayWithArray:self.equipsInBag];
            [tempArr removeObject:equip];   // 如果升级背包里的装备的话
            self.equipsInBag = tempArr;
            
            if ([self isGod])
            {
                NSMutableArray* tempArr2 = [NSMutableArray arrayWithArray:self.equipsInBag];
                for (Equipment* tempEquip in [self equipsInBag])
                {
                    if ([tempEquip godAttri] == nil)
                    {
                        [tempArr2 removeObject:tempEquip];
                    }
                }
                self.equipsInBag = tempArr2;
            }
            
            self.currentLevelLabel.text = [[[equip mainAttri] attriLevel] stringValue];
            self.willChangeLevelLabel.text = [[self currentLevelLabel] text];
            
            [self.selectTabelView reloadData];
        }
    }
}

-(void)scrollToTopRowAtIndexPath
{
    if ([self.equipsInBag count] == 0)
    {
        return;
    }
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.selectTabelView scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionBottom
                                        animated:NO];
}

#pragma mark - table view
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView tag] == 12)
    {
        return [self.equipsInBag count];
    }
    return 0;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    EquipSelectTableViewCell* cell;
    if (row < [self.tableVIewCells count])
    {
        cell = [self.tableVIewCells objectAtIndex:row];
    }
    else
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"EquipSelectTableViewCell" owner:self options:nil];
        cell = [nibs objectAtIndex:0];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        [tempArr addObject:[self.equipsInBag objectAtIndex:row]];
        
        [cell setDataWithObject:tempArr];
        
        [self.tableVIewCells addObject:cell];
    }
    return cell;
}

#pragma mark - buttons event
- (IBAction)onCloseClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)onSequenceBtnClicked:(id)sender
{
    
    
}
- (IBAction)onOKBtnClicked:(id)sender
{
    [[GameUI sharedInstance] EquipSelectToEquipMain:[self equipIdList]];
    [self dismissViewControllerAnimated:NO completion:^{}];
}

#pragma mark - public functions
//
// 消息事件来自 cell （CommonTableViewCell01 类）
// 添加物品到队列（是cell选中的物品）
//
-(void)addObjectToList:(NSDictionary*)params
{
    if ([params objectForKey:@"EquipId"])
    {
        [self.equipIdList addObject:[params objectForKey:@"EquipId"]];
        Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[params objectForKey:@"EquipId"]];
        [self changeTotalExp:equip optionState:YES];
    }
}

//
// 消息事件来自 cell （CommonTableViewCell01 类）
// 移除物品从队列（是cell选择的物品）
//
-(void)substractObjectToList:(NSDictionary*)params
{
    if ([params objectForKey:@"EquipId"])
    {
        [self.equipIdList removeObject:[params objectForKey:@"EquipId"]];
        Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[params objectForKey:@"EquipId"]];
        [self changeTotalExp:equip optionState:NO];
    }
}

-(void)changeTotalExp:(Equipment*)equip optionState:(BOOL)isAdd
{
    NSInteger baseExp   = [[equip getMainAttributeBaseExp] integerValue];
    NSInteger totalExp  = [[equip getMainAttributeTotalExp] integerValue];
    float expRatio      = [[equip getMainAttributeRatio] floatValue];
    if (isAdd)
    {
        addExp += (baseExp + totalExp * expRatio);
    }
    else
    {
        addExp -= (baseExp + totalExp * expRatio);
    }
    
    [self updateMoneyByUpgrade];
}

-(void)updateMoneyByUpgrade
{
    costMoney = 0;
    
    Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[self equipWillChange]];
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
    
    self.willChangeLevelLabel.text  = [NSString stringWithFormat:@"%lu", curLv];
    self.needCostMoneyLabel.text    = [NSString stringWithFormat:@"%lu", costMoney];
}
@end
