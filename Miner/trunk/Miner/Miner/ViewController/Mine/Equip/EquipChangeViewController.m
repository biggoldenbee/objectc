//
//  CommonTableViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "EquipChangeViewController.h"
#import "EquipChangeTableViewCell.h"

#import "GameObject.h"
#import "GameUtility.h"
#import "GameUI.h"
#import "PackageManager.h"
#import "StringConfig.h"

#import "Equipment.h"
#import "UtilityDef.h"

@interface EquipChangeViewController ()

@property (nonatomic, strong) NSArray *tableViewDatas;
@property (nonatomic, strong) NSMutableArray *tableViewCells;
@property (nonatomic, strong) NSString *cellIdentifier;
@property (nonatomic, strong) NSNumber *petId;  // 如果是从宠物界面来的话

@end

@implementation EquipChangeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.petId = DefaultValue;
    
    [[self attributeIcon1] setAttriID:1];
    [[self attributeIcon2] setAttriID:1];
    [[self attributeIcon3] setAttriID:1];
    [[self attributeIcon4] setAttriID:1];
    [[self attributeIcon5] setAttriID:1];
    
    self.tableViewCells = [[NSMutableArray alloc]init];
    
    [self.topViewRectView setHidden:YES];
    [self.bottomViewRectView setHidden:YES];
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

//
// 该方法用于被外部类调用  主要用于  GameUI  的调用
// 设置 tableview 需要显示的类型  更换装备  还是  多选装备
//
-(void)setEquipChangeViewData:(NSDictionary *)data;
{
    if ([data objectForKey:@"PetId"])
    {
        self.petId = [data objectForKey:@"PetId"];
    }
    
    if ([data objectForKey:@"EquipSlot"])
    {
        NSNumber *slot = [data objectForKey:@"EquipSlot"];
        if ([slot integerValue] > 0 && [slot integerValue] < 9)
        {
            [self setAllTopViewControllers:slot];
        }
        else
        {
            NSString* err = [NSString stringWithFormat:@"没有这个部位 %@", [slot stringValue]];
            [[GameUI sharedInstance] showError:err title:@"error"];
        }
        self.tableViewDatas = [[GameObject sharedInstance] getEquipsFromBagWithSlot:slot];
        [self sortTabelViewDatas:NO];
    }
    [self.changeTableview reloadData];
}

-(void)sortTabelViewDatas:(BOOL)isAscending
{
    NSSortDescriptor* descriptor = [[NSSortDescriptor alloc] initWithKey:@"equipBV" ascending:isAscending];
    NSArray* sortDescriptors = [NSArray arrayWithObjects:descriptor, nil];
    
    self.tableViewDatas = [[self tableViewDatas] sortedArrayUsingDescriptors:sortDescriptors];
}

-(void)setAllTopViewControllers:(NSNumber*)slot
{
    Equipment* equip = [[GameObject sharedInstance] getEquipmentWithSlot:slot withPetId:[self petId]];
    if (equip != nil)
    {
        [self.topView setHidden:NO];
        self.equipNameLabel.text    = [[StringConfig share] getLocalLanguage:[equip getEquipName]];
        self.equipScoreLabel.text   = [[equip equipBV] stringValue];
        self.equipLvLabel.text      = [[[equip mainAttri] attriLevel] stringValue];
        self.equipMainValueLabel.text = [[[equip mainAttri] attriValue] stringValue];
        
        NSNumber* saLevel = ((AttributeData*)[equip.subAttri objectAtIndex:0]).attriLevel;
        
        self.equipLvLabel.textColor = [GameUtility getColorWithLv:[saLevel intValue]];
        self.textLvLabel.textColor  = [GameUtility getColorWithLv:[saLevel intValue]];
        
        NSString* starIconName = [GameUtility getImageNameForEquipStrengthenWithStar:[[equip equipStar] intValue]];
        [self.equipStarIcon setImage:[GameUtility imageNamed:starIconName]];
        [self.equipIcon setImage:[GameUtility imageNamed:[equip getEquipIcon]]];
        [[self attributeIcon1] setAttriID:[[[equip mainAttri] attriId] intValue]];
        
        [self setSubAttribute:equip.subAttri];
        [self setGodAttribute:equip.godAttri];
        
        [self.topView setHidden:NO];
    }
    else
    {
        [self.topView setHidden:YES];
        [self scaleBottomViewFrame];
    }
    
}
-(void)setSubAttribute:(NSArray*)subAttributes
{
    [self hiddenSubAtrricontrollers];
    if (subAttributes != nil)
    {
        for (int i=0; i<[subAttributes count]; i++)
        {
            AttributeData* attri = [subAttributes objectAtIndex:i];
            if (i == 0)
            {
                [self.equipSub1Icon setHidden:NO];
                [self.equipSub1ValueLabel setHidden:NO];
                [[self attributeIcon2] setHidden:NO];
                self.equipSub1ValueLabel.text = [attri.attriValue stringValue];
                [self.equipSub1Icon setImage:[GameUtility imageNamed:[attri getAttriIcon]]];
                [[self attributeIcon2] setAttriID:[[attri attriId] intValue]];
            }
            if (i == 1)
            {
                [self.equipSub2Icon setHidden:NO];
                [self.equipSub2ValueLabel setHidden:NO];
                [[self attributeIcon3] setHidden:NO];
                self.equipSub2ValueLabel.text = [attri.attriValue stringValue];
                [self.equipSub2Icon setImage:[GameUtility imageNamed:[attri getAttriIcon]]];
                [[self attributeIcon3] setAttriID:[[attri attriId] intValue]];
            }
            if (i == 2)
            {
                [self.equipSub3Icon setHidden:NO];
                [self.equipSub3ValueLabel setHidden:NO];
                [[self attributeIcon4] setHidden:NO];
                self.equipSub3ValueLabel.text = [attri.attriValue stringValue];
                [self.equipSub3Icon setImage:[GameUtility imageNamed:[attri getAttriIcon]]];
                [[self attributeIcon4] setAttriID:[[attri attriId] intValue]];
            }
        }
    }
}
-(void)hiddenSubAtrricontrollers
{
    [[self equipSub1Icon] setHidden:YES];
    [[self equipSub1ValueLabel] setHidden:YES];
    [[self attributeIcon2] setHidden:YES];
    
    [[self equipSub2Icon] setHidden:YES];
    [[self equipSub2ValueLabel] setHidden:YES];
    [[self attributeIcon3] setHidden:YES];
    
    [[self equipSub3Icon] setHidden:YES];
    [[self equipSub3ValueLabel] setHidden:YES];
    [[self attributeIcon4] setHidden:YES];
}

-(void)setGodAttribute:(AttributeData*)attri
{
    if (attri == nil)
    {
        [[self equipGodIcon] setHidden:YES];
        [[self equipGodValueLabel] setHidden:YES];
        [[self attributeIcon5] setHidden:YES];
        return;
    }
    
    [self.equipGodIcon setHidden:NO];
    [self.equipGodValueLabel setHidden:NO];
    [[self attributeIcon5] setHidden:NO];
    self.equipGodValueLabel.text = [attri.attriValue stringValue];
    [self.equipGodIcon setImage:[GameUtility imageNamed:[attri getAttriIcon]]];
    [[self attributeIcon5] setAttriID:[[attri attriId] intValue]];
}

#pragma mark - set bottom view frame
-(void)resetBottomViewFrame
{
    [self.bottomView setFrame:self.bottomViewRectView.frame];
}

-(void)scaleBottomViewFrame
{
    CGRect topViewRect = [self.topView frame];
    CGRect botViewRect = [self.bottomView frame];
    
    CGPoint origin = topViewRect.origin;
    CGSize size = CGSizeMake(botViewRect.size.width, topViewRect.size.height + botViewRect.size.height);
    
    CGRect newBotViewRect = CGRectMake(origin.x, origin.y, size.width, size.height);
    [self.bottomView setFrame:newBotViewRect];
    [self.topView setHidden:YES];
}

#pragma mark - tableView datasource && delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView tag] == 11)
    {
        return [self.tableViewDatas count];
    }
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (row < [self.tableViewCells count])
    {
        EquipChangeTableViewCell* cell = [self.tableViewCells objectAtIndex:row];
        return cell;
    }
    else
    {
        CGFloat width = self.changeTableview.frame.size.width;
        CGRect minFrame = CGRectMake(0, 0, width, 1);
        
        NSString* xibName = NSStringFromClass([EquipChangeTableViewCell class]);
        NSArray *nibs = [[NSBundle mainBundle]loadNibNamed:xibName owner:self options:nil];
        EquipChangeTableViewCell *cell = [nibs objectAtIndex:0];
        CGRect baseFrame = CGRectUnion(cell.frame, minFrame);
        [cell setNewFrame:baseFrame];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        [tempArr addObject:[self.tableViewDatas objectAtIndex:row]];
        
        [cell setDataWithObject:tempArr];
        
        [self.tableViewCells addObject:cell];
        
        return cell;
    }
}

#pragma mark - button actions handle
- (IBAction)onCloseClicked:(id)sender
{
    [self closeEquipChangeView];
}

#pragma mark - Control List to change object
//
// 消息事件来自 cell （EquipSelectTableViewCell 类）
// 选择更换的装备  
//
-(void)changEquipment:(NSDictionary*)params
{
    if ([params objectForKey:@"EquipId"])
    {
        Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[params objectForKey:@"EquipId"]];
        [[GameObject sharedInstance] setWillChangedEquipWithId:[equip equipEId] withPetId:[self petId]];
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setValue:[equip equipEId] forKey:@"EID"];
        [tempDict setValue:[equip getEquipDefSlot] forKey:@"Slot"];
        [tempDict setObject:[self petId] forKey:@"Pet"];
        
        [[PackageManager sharedInstance] changeEquipRequest:tempDict];
    }
}

#pragma mark - close function
-(void)closeEquipChangeView
{
    [self allClear];
    [self dismissViewControllerAnimated:NO completion:^{}];
}
-(void)allClear
{
    if (self.topView.isHidden)
    {
        [self resetBottomViewFrame];
    }
    self.tableViewDatas = nil;
    [self.tableViewCells removeAllObjects];
}
@end