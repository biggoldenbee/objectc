//
//  UpSubAttriViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "UpSubAttriViewController.h"
#import "GameObject.h"
#import "GameUI.h"
#import "GameUtility.h"
#import "PackageManager.h"
#import "UtilityDef.h"

#import "Equipment.h"
#import "Item.h"
#import "QQEquipBtnDefault.h"

@implementation CostItem

@end

@interface UpSubAttriViewController ()

@property (nonatomic, strong) NSNumber* equipIdWillChanged;
@property (nonatomic, strong) NSNumber* petId;

@property (nonatomic, strong) NSMutableArray* itemViewsArray;
@property (nonatomic, assign) BOOL isOkToUp;
@property (nonatomic, strong) NSMutableArray* itemsWillCost;

@end

@implementation UpSubAttriViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isOkToUp = false;
    self.petId = DefaultValue;
    
    self.itemViewsArray = [[NSMutableArray alloc] init];
    [[self itemViewsArray] addObject:[self item1View]];
    [[self itemViewsArray] addObject:[self item2View]];
    [[self itemViewsArray] addObject:[self item3View]];
    [[self itemViewsArray] addObject:[self item4View]];
    [[self itemViewsArray] addObject:[self item5View]];
    [[self itemViewsArray] addObject:[self item6View]];
    [self resetAllItemViews];
    [self hidenAllAttriLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)resetAllItemViews
{
    for (QQEquipBtnDefault* ebd in [self itemViewsArray])
    {
        [ebd initViewWithPartType:10 withPetId:[self petId]];
    }
}

-(void)hidenAllAttriLabel
{
    [self setHiddenSubAttribute1Controllers:YES];
    [self setHiddenSubAttribute2Controllers:YES];
    [self setHiddenSubAttribute3Controllers:YES];
}

-(void)setHiddenSubAttribute1Controllers:(BOOL)hidden
{
    self.subAttri1Identifier = nil;
    [self.subAttri1IconImage setHidden:hidden];
    [self.subAttri1ValueLabel setHidden:hidden];
    [self.subAttri1ArrowImage setHidden:hidden];
    [self.subNextAttri1ValueLabel setHidden:hidden];
    [self.attributeIcon1 setHidden:hidden];
}

-(void)setHiddenSubAttribute2Controllers:(BOOL)hidden
{
    self.subAttri2Identifier = nil;
    [self.subAttri2IconImage setHidden:hidden];
    [self.subAttri2ValueLabel setHidden:hidden];
    [self.subAttri2ArrowImage setHidden:hidden];
    [self.subNextAttri2ValueLabel setHidden:hidden];
    [self.attributeIcon2 setHidden:hidden];
}

-(void)setHiddenSubAttribute3Controllers:(BOOL)hidden
{
    self.subAttri3Identifier = nil;
    [self.subAttri3IconImage setHidden:hidden];
    [self.subAttri3ValueLabel setHidden:hidden];
    [self.subAttri3ArrowImage setHidden:hidden];
    [self.subNextAttri3ValueLabel setHidden:hidden];
    [self.attributeIcon3 setHidden:hidden];
}

-(void)clearItemsWillCost
{
    if ([self isOkToUp])
    {
        if ([self itemsWillCost] != nil && [[self itemsWillCost] count] > 0)
        {
            for (CostItem* costItem in [self itemsWillCost])
            {
                [[[GameObject sharedInstance] bag] changeItemDataWithId:[costItem itemIId] withNum:-[costItem itemNum]];
            }
        }
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
-(void)setDataInfoInViewControllers:(NSDictionary *)data;
{
    if ([data objectForKey:@"PetId"])
    {
        self.petId = [data objectForKey:@"PetId"];
    }
    else
    {
        self.petId = DefaultValue;
    }
    
    if ([data objectForKey:@"EquipId"])
    {
        [self resetAllItemViews];
        [self hidenAllAttriLabel];
        [self clearItemsWillCost];
        
        self.equipIdWillChanged = [data objectForKey:@"EquipId"];
        Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[self equipIdWillChanged]];
        
        NSNumber* subAttriLv    = [[[equip subAttri] objectAtIndex:0] attriLevel];
        NSString* iconName      = [GameUtility getImageNameForEquipStrengthenWithStar:[subAttriLv intValue]];
        [self.equipStarImage setImage:[GameUtility imageNamed:iconName]];
        [self.equipIconImage setImage:[GameUtility imageNamed:[equip getEquipIcon]]];
        
        self.moneyLabel.text = INT_TO_STRING(0);
        
        // 显示需要的升级道具和数量
        [self setUpgradeItems:equip];
        
        // 显示副属性数值
        for (int i= 0; i<[equip.subAttri count]; i++)
        {
            AttributeData* attri = [[equip subAttri] objectAtIndex:i];
            [self showAttribute:attri AtSlot:i+1];
        }
        
    }
    else
    {
        NSLog(@"你也倒是给我一个装备EID啊！╮(╯▽╰)╭");
    }
}

-(void)setUpgradeItems:(Equipment*)equip
{
    self.isOkToUp           = true;
    self.itemsWillCost      = [[NSMutableArray alloc] init];
    
    // 获取升级物品
    NSNumber* subAttriLevel = [[[equip subAttri] objectAtIndex:0] attriLevel];
    EquipmentDef* equipDef  = [[EquipmentConfig share] getEquipmentDefWithKey:[equip equipTId]];
    SubAttriLvBase* items   = [[SubAttriLvConfig share] getUpgradeItemsWithLevel:subAttriLevel subAttriUpID:[equipDef subAttriUpID]];
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%lu", items.costMoney];
    self.subAttriLevelLabel.text = [NSString stringWithFormat:@"%lu", items.subAttriLv];
    self.subNextAttriLevelLabel.text = self.subAttriLevelLabel.text;
    
    if (items.item1id != 0)
    {
        [[self item1View] setItemDataWithTId:[NSNumber numberWithInteger:items.item1id] countNum:items.item1Num];
        self.isOkToUp &= [[self item1View] checkEnough];
        
        [self setCostItemArrayWithId:items.item1id withNum:items.item1Num];
    }
    
    if (items.item2id != 0)
    {
        [[self item2View] setItemDataWithTId:[NSNumber numberWithInteger:items.item2id] countNum:items.item2Num];
        self.isOkToUp &= [[self item2View] checkEnough];
        
        [self setCostItemArrayWithId:items.item2id withNum:items.item2Num];
    }
    
    if (items.item3id != 0)
    {
        [[self item3View] setItemDataWithTId:[NSNumber numberWithInteger:items.item3id] countNum:items.item3Num];
        self.isOkToUp &= [[self item3View] checkEnough];
        
        [self setCostItemArrayWithId:items.item3id withNum:items.item3Num];
    }
    
    if (items.item4id != 0)
    {
        [[self item4View] setItemDataWithTId:[NSNumber numberWithInteger:items.item4id] countNum:items.item4Num];
        self.isOkToUp &= [[self item4View] checkEnough];
        
        [self setCostItemArrayWithId:items.item4id withNum:items.item4Num];
    }
    
    if (items.item5id != 0)
    {
        [[self item5View] setItemDataWithTId:[NSNumber numberWithInteger:items.item5id] countNum:items.item5Num];
        self.isOkToUp &= [[self item5View] checkEnough];
        
        [self setCostItemArrayWithId:items.item5id withNum:items.item5Num];
    }
    
    if (items.item6id != 0)
    {
        [[self item6View] setItemDataWithTId:[NSNumber numberWithInteger:items.item6id] countNum:items.item6Num];
        self.isOkToUp &= [[self item6View] checkEnough];
        
        [self setCostItemArrayWithId:items.item6id withNum:items.item6Num];
    }
}

-(void)setCostItemArrayWithId:(NSInteger)itemId withNum:(NSInteger)itemNum
{
    Item* item = [[GameObject sharedInstance] getItemWithTId:[NSNumber numberWithInteger:itemId]];
    CostItem* costItem = [[CostItem alloc] init];
    costItem.itemIId = item.itemIId;
    costItem.itemNum = itemNum;
    [[self itemsWillCost] addObject:costItem];
}

-(void)showAttribute:(AttributeData*)attri AtSlot:(int)slot
{
    switch (slot)
    {
        case 1:
        {
            [self setHiddenSubAttribute1Controllers:NO];
            [self showAttribute1:attri];
        }
            break;
        case 2:
        {
            [self setHiddenSubAttribute2Controllers:NO];
            [self showAttribute2:attri];
        }
            break;
        case 3:
        {
            [self setHiddenSubAttribute3Controllers:NO];
            [self showAttribute3:attri];
        }
            break;
        default:
            break;
    }
}

-(void)showAttribute1:(AttributeData*)attr
{
    self.subAttri1Identifier = attr.attriId;
    [self.subAttri1IconImage setImage:[GameUtility imageNamed:[attr getAttriIcon]]];
    self.subAttri1ValueLabel.text = [attr.attriValue stringValue];
    self.subNextAttri1ValueLabel.text = self.subAttri1ValueLabel.text;
    [self.attributeIcon1 setAttriID:[attr.attriId intValue]];
}
-(void)showAttribute2:(AttributeData*)attr
{
    self.subAttri2Identifier = attr.attriId;
    [self.subAttri2IconImage setImage:[GameUtility imageNamed:[attr getAttriIcon]]];
    self.subAttri2ValueLabel.text = [attr.attriValue stringValue];
    self.subNextAttri2ValueLabel.text = self.subAttri2ValueLabel.text;
    [self.attributeIcon2 setAttriID:[attr.attriId intValue]];
}
-(void)showAttribute3:(AttributeData*)attr
{
    self.subAttri3Identifier = attr.attriId;
    [self.subAttri3IconImage setImage:[GameUtility imageNamed:[attr getAttriIcon]]];
    self.subAttri3ValueLabel.text = [attr.attriValue stringValue];
    self.subNextAttri3ValueLabel.text = self.subAttri3ValueLabel.text;
    [self.attributeIcon3 setAttriID:[attr.attriId intValue]];
}

#pragma mark - button events
- (IBAction)onCloseClicked:(id)sender
{
    [[GameUI sharedInstance] showEquipInfoView:nil];
}

- (IBAction)onUpgradeSubClicked:(id)sender
{
    if (self.isOkToUp)
    {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:[self equipIdWillChanged] forKey:@"EID"];
        [[PackageManager sharedInstance] upgradeEquipSubAttriRequest:tempDict];
    }
    else
    {
        [[GameUI sharedInstance] showError:@"需要的物品不够" title:@"临时错误提示"];
    }
}

#pragma mark - notification
-(void)updateEquipInfo:(NSNumber*)equipId
{
    NSDictionary* tempDict = nil;
    if ([equipId isEqualToNumber:[self equipIdWillChanged]])
    {
        tempDict = [[NSDictionary alloc] initWithObjectsAndKeys:equipId,@"EquipId", nil];
        [self setDataInfoInViewControllers:tempDict];
    }
}
@end
