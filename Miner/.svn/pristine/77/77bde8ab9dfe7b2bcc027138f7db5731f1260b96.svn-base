//
//  PropViewController.m
//  Miner
//
//  Created by zhihua.qian on 15-1-5.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "PropViewController.h"
#import "GameObject.h"
#import "GameUtility.h"
#import "StringConfig.h"
#import "Item.h"
#import "DropConfig.h"
#import "StageCollectionViewCell.h"
#import "PackageManager.h"

#define Bag_Collection_Cell_00      @"bagCollectionViewCell"

#define TYPE_ITEM_DEFAULT   0
#define TYPE_ITEM_USE       1
#define TYPE_ITEM_FRAGMENT  2
#define TYPE_ITEM_CHEST     3

@interface PropViewController ()

@property (nonatomic, strong) Item* usingItem;
@property (nonatomic, strong) NSMutableArray* chestItems;
@property (nonatomic, assign) int propType;
@end

@implementation PropViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.chestCollectionView registerClass:[StageCollectionViewCell class] forCellWithReuseIdentifier:@"PropsChip"];
    [self setPropType:TYPE_ITEM_DEFAULT];
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
-(void)closePropView
{
    [self.view removeFromSuperview];
}

-(void)setDataInfoForViewControllers:(NSDictionary*)data
{
    if ([data objectForKey:@"ItemId"])
    {
        NSNumber* itemId = [data objectForKey:@"ItemId"];
        self.usingItem = [[[GameObject sharedInstance] bag] getItemWithTId:itemId];
        
        if (![[self usingItem] useable])
        {
            [self setItemWithDefaultType];
        }
        else
        {
            if ([[[self usingItem] itemType] intValue] != 4)
            {
                [self setItemWithUseType];
            }
            
            if ([[[self usingItem] itemType] intValue] == 4)
            {
                [self setItemWithChestType];
            }
        }
        
    }
    else
    {
        NSLog(@"传输途中，数据丢失。");
    }
}

-(void)setItemCommonInfo
{
    [[self propNameLabel] setText:[[StringConfig share] getLocalLanguage:[[self usingItem] itemName]]];
    [[self propTypeLabel] setText:[[[self usingItem] itemType] stringValue]];
    [[self propUsedLvLabel] setText:[[[self usingItem] itemUseLv] stringValue]];
    [[self propDescTextView] setText:[[StringConfig share] getLocalLanguage:[[self usingItem] itemDesc]]];
    
    [[self propCountLabel] setText:[NSString stringWithFormat:@"x%d", [[[self usingItem] itemCount] intValue]]];
    [[self propPriceLabel] setText:[[[self usingItem] sellMoney] stringValue]];
}

-(void)setItemWithDefaultType
{
    [self setPropType:TYPE_ITEM_DEFAULT];
    [self setItemCommonInfo];
    
    [[self chestView] setHidden:YES];
    [[self functionBtn] setHidden:YES];
    
    [[self propFragmentStateLabel] setHidden:YES];
    
    [[self propIconImage] setImage:[GameUtility imageNamed:[[self usingItem] itemIcon]]];
}

-(void)setItemWithUseType
{
    [self setPropType:TYPE_ITEM_USE];
    [self setItemCommonInfo];
    
    [[self chestView] setHidden:YES];
    [[self functionBtn] setHidden:NO];
    [[self functionBtn] setTitle:@"Use" forState:UIControlStateNormal];
    [[self functionBtn] setTitle:@"Use" forState:UIControlStateHighlighted];
    
    [[self propFragmentStateLabel] setHidden:YES];
    
    [[self propIconImage] setImage:[GameUtility imageNamed:[[self usingItem] itemIcon]]];
}

-(void)setItemWithFragmentType
{
    [self setPropType:TYPE_ITEM_FRAGMENT];
    [self setItemCommonInfo];
    
    [[self chestView] setHidden:YES];
    [[self functionBtn] setHidden:NO];
    [[self functionBtn] setTitle:@"Admix" forState:UIControlStateNormal];
    [[self functionBtn] setTitle:@"Admix" forState:UIControlStateHighlighted];
    
    [[self propFragmentStateLabel] setHidden:NO];
    
    [[self propIconImage] setImage:[GameUtility imageNamed:[[self usingItem] itemIcon]]];
}

-(void)setItemWithChestType
{
    [self setPropType:TYPE_ITEM_CHEST];
    [self setItemCommonInfo];
    
    [[self chestView] setHidden:NO];
    
    [[self functionBtn] setHidden:NO];
    [[self functionBtn] setTitle:@"Open" forState:UIControlStateNormal];
    [[self functionBtn] setTitle:@"Open" forState:UIControlStateHighlighted];
    
    [[self propFragmentStateLabel] setHidden:YES];
    
    [[self propIconImage] setImage:[GameUtility imageNamed:[[self usingItem] itemIcon]]];
    
    [self setChestItems:[[NSMutableArray alloc] init]];
    NSInteger tcid = [[[self usingItem] typeNum1] integerValue];
    TcDef* tcdef = [[TcConfig share] getTcDefWithId:tcid];
    for (TcBase* tcbase in [[tcdef tcDatas] allValues])
    {
        NSInteger dropid = [tcbase dropID];
        DropDef* dropdef = [[DropConfig share] getDropDefWithId:dropid];
        [[self chestItems] addObject:dropdef];
    }
    NSSortDescriptor* idDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dropId" ascending:YES];
    NSArray* descriptors = [NSArray arrayWithObjects:idDescriptor, nil];
    NSArray* tempArr = [[self chestItems] sortedArrayUsingDescriptors:descriptors];
    [self setChestItems:[NSMutableArray arrayWithArray:tempArr]];
    
    [[self chestCollectionView] reloadData];
}

#pragma mark - collection view 
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[self chestItems] count];
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    StageCollectionViewCell *cell = (StageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PropsChip" forIndexPath:indexPath];
    
    NSInteger row = [indexPath row];
    [cell setupDataWithDropDef:[[self chestItems] objectAtIndex:row]];
    
    return cell;
}

#pragma mark - buttons events
- (IBAction)onCloseClicked:(id)sender
{
    [self closePropView];
}
- (IBAction)onOkClicked:(id)sender
{
    switch (self.propType)
    {
        case TYPE_ITEM_USE:
        {
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
            [tempDict setObject:[[self usingItem] itemIId] forKey:@"ID"];
            [tempDict setObject:[NSNumber numberWithInt:1] forKey:@"Num"];
            [[PackageManager sharedInstance] usedItemOrOpenChestRequest:tempDict];
        }
            break;
        case TYPE_ITEM_FRAGMENT:
        {
            
        }
            break;
        case TYPE_ITEM_CHEST:
        {
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
            [tempDict setObject:[[self usingItem] itemIId] forKey:@"ID"];
            [tempDict setObject:[NSNumber numberWithInt:1] forKey:@"Num"];
            [[PackageManager sharedInstance] usedItemOrOpenChestRequest:tempDict];
        }
            break;
        default:
            break;
    }
    
}
- (IBAction)onSellClicked:(id)sender
{
}
@end
