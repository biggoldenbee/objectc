//
//  BagViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "PackViewController.h"
#import "GameUI.h"
#import "CommonDef.h"
#import "PackageManager.h"
#import "BagCollectionViewCell.h"
#import "BagCollectionViewCell01.h"
#import "BagCollectionViewCell02.h"
#import "GameObject.h"
#import "Equipment.h"
#import "Item.h"
#import "GameUtility.h"
#import "UtilityDef.h"

#define Bag_Collection_Cell_00      @"bagCollectionViewCell"
#define Bag_Collection_Cell_01      @"bagCollectionViewCell01"
#define Bag_Collection_Cell_02      @"bagCollectionViewCell02"

#define Collection_Section_Num      2

@interface PackViewController ()

@end

@implementation PackViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.bagCollectionView registerClass:[BagCollectionViewCell class] forCellWithReuseIdentifier:Bag_Collection_Cell_00];
    [self.bagCollectionView registerClass:[BagCollectionViewCell01 class] forCellWithReuseIdentifier:Bag_Collection_Cell_01];
    [self.bagCollectionView registerClass:[BagCollectionViewCell02 class] forCellWithReuseIdentifier:Bag_Collection_Cell_02];
    
    [self setAllViewControllers];
    
    [self.bagCollectionView setBackgroundColor:[UIColor clearColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self setAllViewControllers];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)setAllViewControllers
{
    self.bag = [[GameObject sharedInstance] bag];
    self.equipsArray = self.bag.bagEquips;
    self.itemsArray = self.bag.bagItems;
    
    self.bagState = [NSString stringWithFormat:@"%lu/%@", [self.equipsArray count], [self.bag bagMaxNum]];
    
    switch (self.flagChoose)
    {
        case Show_Equips:
            [self setEquipViewData];
            break;
        case Show_Items:
            [self setItemViewData];
            break;
        case Show_Fragment:
            [self setFragmentViewData];
            break;
        default:
            break;
    }
}

-(void)setEquipViewData
{
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

    self.equipsArray = [GameUtility array:[self equipsArray] sortArrayWithParams:tempDict];
    
    [self.bagCollectionView reloadData];
    
    [self.filterBtn setHidden:NO];
    [self.blukSaleBtn setHidden:NO];
}

-(void)setItemViewData
{
    [self.bagCollectionView reloadData];
    
    [self.filterBtn setHidden:YES];
    [self.blukSaleBtn setHidden:YES];
//    [self.view bringSubviewToFront:self.bagCollectionView];
}

-(void)setFragmentViewData
{
}

#pragma mark - Collection view datasource && delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    // 设置section数量
    switch (self.flagChoose)
    {
        case Show_Equips:
            return Collection_Section_Num;
        break;
        case Show_Items:
            return Collection_Section_Num-1;
        break;
        case Show_Fragment:
            return Collection_Section_Num-1;
        break;
    default:
        break;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.flagChoose == Show_Equips)
    {
        if (section == 0)
        {
            return [self.equipsArray count];
        }
        else
        {
            return 2;
        }
    }
    else if (self.flagChoose == Show_Items)
    {
        return [self.itemsArray count];
    }
    else
    {
        return [self.fragmentsArray count];
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0)
    {
        BagCollectionViewCell *cell = (BagCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:Bag_Collection_Cell_00 forIndexPath:indexPath];
        
        NSInteger row = [indexPath row];
        if (self.flagChoose == Show_Equips)
        {
            Equipment *equip = [self.equipsArray objectAtIndex:row];
            if ( [indexPath section] == 0 )
            {
                NSNumber* subLevel = [[[equip subAttri] objectAtIndex:0] attriLevel];
                NSString* imageName = [GameUtility getImageNameForEquipStrengthenWithStar:[subLevel intValue]];
                [cell setDataWithStarIcon:[GameUtility imageNamed:imageName]
                                equipIcon:[GameUtility imageNamed:[equip getEquipIcon]]
                                  equipLv:[[equip mainAttri] attriLevel]
                                equipStar:subLevel];
            }
        }
        else if (self.flagChoose == Show_Items)
        {
            Item* item = [self.itemsArray objectAtIndex:row];
            [cell setDataWithIcon:[GameUtility imageNamed:item.itemIcon] count:item.itemCount];
        }
        else
        {
            
        }
        
        return cell;
    }
    else
    {
        if ([indexPath row] == 0)
        {
            BagCollectionViewCell01 *cell = (BagCollectionViewCell01 *)[collectionView dequeueReusableCellWithReuseIdentifier:Bag_Collection_Cell_01 forIndexPath:indexPath];
            
            return cell;
        }
        else
        {
            BagCollectionViewCell02 *cell = (BagCollectionViewCell02 *)[collectionView dequeueReusableCellWithReuseIdentifier:Bag_Collection_Cell_02 forIndexPath:indexPath];
            
            [cell setBagStateWithString:self.bagState];
            
            CGRect rect = cell.frame;
            rect.size.width = 130;
            rect.size.height = 50;
            cell.frame = rect;
            
            return cell;
        }
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.flagChoose == Show_Equips)
    {
        if ([indexPath section] == 0)
        {
            NSInteger row = [indexPath row];
            Equipment *equip = [self.equipsArray objectAtIndex:row];
            
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
            [tempDict setObject:[equip equipEId] forKey:@"EquipId"];
            [tempDict setObject:DefaultValue forKey:@"PetId"];
            [[GameUI sharedInstance] showEquipInfoView:tempDict];
        }
        else
        {
            if ([indexPath row] == 0)
            {
                [[PackageManager sharedInstance] expandBagRequest];
            }
        }
    }
    else if (self.flagChoose == Show_Items)
    {
        if ([indexPath section] == 0)
        {
            NSInteger row = [indexPath row];
            Item* item = [self.itemsArray objectAtIndex:row];
            NSNumber* itemDefId = item.itemTId;
            NSDictionary* tempdict = [NSDictionary dictionaryWithObjectsAndKeys:itemDefId,@"ItemId", nil];
            [[GameUI sharedInstance] showPropInfoView:tempdict];
        }
    }
    
}

#pragma mark - Button Events
- (IBAction)showEquipView:(id)sender
{
    [self resetTabBtnNomal];
    self.flagChoose = Show_Equips;
    [self setEquipViewData];
    self.equipTabBtn.selected = YES;
}

- (IBAction)showItemView:(id)sender
{
    [self resetTabBtnNomal];
    self.flagChoose = Show_Items;
    [self setItemViewData];
    self.propsTabBtn.selected = YES;
}
- (IBAction)showFragmentView:(id)sender
{
    [self resetTabBtnNomal];
    self.flagChoose = Show_Fragment;
    [self setItemViewData];
    self.fragTabBtn.selected = YES;
}
-(void)resetTabBtnNomal
{
    self.equipTabBtn.selected = NO;
    self.propsTabBtn.selected = NO;
    self.fragTabBtn.selected = NO;
}

- (IBAction)onFilterClicked:(id)sender
{
    [[GameUI sharedInstance] showFilterView];
}

- (IBAction)onBlukSaleClicked:(id)sender
{
    [[GameUI sharedInstance] showBlukSellView];
}

#pragma mark - Notification Event
//-(void)updateBagInfo:(NSNotification *)notify
-(void)updateBagInfo
{
    [self setAllViewControllers];
}
@end
