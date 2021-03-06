//
//  EquipInfoViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "EquipInfoViewController.h"
#import "Equipment.h"

#import "GameUI.h"
#import "GameObject.h"
#import "PackageManager.h"
#import "StringConfig.h"
#import "GameUtility.h"

#import "UtilityDef.h"

@interface EquipInfoViewController ()

@property (nonatomic, strong) NSNumber* equipEid;
@property (nonatomic, strong) NSNumber* equipSlot;
@property (nonatomic, strong) NSNumber* petId;

@end

@implementation EquipInfoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.equipEid   = DefaultValue;
    self.equipSlot  = DefaultValue;
    self.petId      = DefaultValue;
    [[self attributeIcon0] setAttriID:1];
    [[self attributeIcon1] setAttriID:1];
    [[self attributeIcon2] setAttriID:1];
    [[self attributeIcon3] setAttriID:1];
    [[self attributeIcon4] setAttriID:1];
}

- (void)didReceiveMemoryWarning
{
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
// 该方法被用于外部调用 主要是 GameUI 的调用
// 用来 设置界面控件的显示及其内容
//
-(void)setEquipInfoViewData:(NSDictionary *)data
{
    if ([data objectForKey:@"EquipId"])
    {
        self.equipEid = [data objectForKey:@"EquipId"];
    }
    
    if ([data objectForKey:@"PetId"])
    {
        self.petId = [data objectForKey:@"PetId"];
    }
    
    [self updateEquipInfoView];
}

// 更新界面
-(void)updateEquipInfoView
{
    Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[self equipEid]];
    self.equipSlot = [equip equipSlot];
    
    NSString* tag = [[GameObject sharedInstance].player.heroIdentifier stringValue];
    if ( self.petId != nil )
        tag = [tag stringByAppendingFormat:@"_%@", self.petId];
    
    [[GameObject sharedInstance].bag setVisitedFlagToAll:YES slot:self.equipSlot.intValue tag:tag];

    
    // 如果 0 < equipSlot < 9 说明是从装备界面过来的
    // 否则 就是从背包界面过来的
    if ([[self equipSlot] integerValue] > 0 && [[self equipSlot] integerValue] < 9)
    {
        self.removeBtn.hidden       = NO;
        self.repalceBtn.hidden      = NO;
        self.sellEquipBtn.hidden    = YES;
    }
    else
    {
        self.removeBtn.hidden       = YES;
        self.repalceBtn.hidden      = YES;
        self.sellEquipBtn.hidden    = NO;
    }
    
    self.equipNameLabel.text    = [[StringConfig share] getLocalLanguage:[equip getEquipName]];
    self.scoreLabel.text        = [[equip equipBV] stringValue];
    
    self.mainAttriLabel.text    = [equip mainAttriInfoString];
    self.equipLevel.text        = [[[equip mainAttri] attriLevel] stringValue];
    self.mainAttriIcon.image    = [GameUtility imageNamed:[[equip mainAttri] getAttriIcon]];
    [[self attributeIcon0] setAttriID:[[[equip mainAttri] attriId] intValue]];
    
    self.sellPriceLabel.text    = [[equip getSellPrice] stringValue];
    
    self.equipDescLabel.text    = [[StringConfig share] getLocalLanguage:[equip getEquipDesc]];
    
    NSNumber* subLevel          = [[[equip subAttri] objectAtIndex:0] attriLevel];
    self.equipLevel.textColor   = [GameUtility getColorWithLv:subLevel.intValue];
    self.textLvLabel.textColor  = [GameUtility getColorWithLv:subLevel.intValue];
    
    self.equipIcon.image        = [GameUtility imageNamed:[equip getEquipIcon]];
    self.equipStarIcon.image    = [GameUtility imageNamed:[GameUtility getImageNameForEquipStrengthenWithStar:[subLevel intValue]]];
    
    // 副属性
    NSArray* imageViewOfSubs    = @[ self.sub1AttriIcon,self.sub2AttriIcon, self.sub3AttriIcon ];
    NSArray* labelOfSubs        = @[self.sub1AttriLabel, self.sub2AttriLabel, self.sub3AttriLabel];
    NSArray* attributeSubs      = @[self.attributeIcon1, self.attributeIcon2, self.attributeIcon3];
    
    int i = 0;
    for( AttributeData* subAttri in equip.subAttri)
    {
        ((UIImageView*)imageViewOfSubs[i]).image    = [GameUtility imageNamed:[subAttri getAttriIcon]];
        ((UILabel*)labelOfSubs[i]).text             = [subAttri.attriValue stringValue];
        [((UIAttributeIcon*)attributeSubs[i]) setAttriID:[subAttri.attriId intValue]];
        
        ((UIView*)imageViewOfSubs[i]).hidden        = NO;
        ((UILabel*)labelOfSubs[i]).hidden           = NO;
        ((UIAttributeIcon*)attributeSubs[i]).hidden = NO;
        i++;
    }
    
    if (i == 0)
    {
        self.builBtn.hidden = YES;
    }
    
    for(; i < imageViewOfSubs.count; i ++)
    {
        ((UIView*)imageViewOfSubs[i]).hidden        = YES;
        ((UILabel*)labelOfSubs[i]).hidden           = YES;
        ((UIAttributeIcon*)attributeSubs[i]).hidden = YES;
    }
    
    // 神器属性
    if( [equip godAttri] != nil )
    {
        self.godAttriIcon.image     = [GameUtility imageNamed:[[equip godAttri] getAttriIcon]];
        self.godAttriLabel.text     = [[[equip godAttri] attriValue] stringValue];
        self.godAttriIcon.hidden    = NO;
        self.godAttriLabel.hidden   = NO;
        self.evolutionBtn.hidden    = NO;
        self.attributeIcon4.hidden  = NO;
        [[self attributeIcon4] setAttriID:[[[equip godAttri] attriId] intValue]];
    }
    else
    {
        self.godAttriIcon.hidden    = YES;
        self.godAttriLabel.hidden   = YES;
        self.evolutionBtn.hidden    = YES;
        self.attributeIcon4.hidden  = YES;
    }
}

#pragma mark - button events
- (IBAction)onCloseClicked:(id)sender
{
    if ([[self petId] isEqualToNumber:DefaultValue])
    {
        if ([[self equipSlot] isEqualToNumber:DefaultValue])
        {// slot为0  未装配  在背包里的
            [[GameUI sharedInstance] showPackView];
        }
        else
        {// slot不为0  已装配  在玩家身上的
            [[GameUI sharedInstance] showEquipView];
        }
    }
    else
    {// 有宠物ID 说明是来自宠物
        [[GameUI sharedInstance] showPetView];
    }
}

- (IBAction)onLockClicked:(id)sender
{
}

- (IBAction)upgradeMainAttri:(id)sender
{
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:[self equipEid] forKey:@"EquipId"];
    [tempDict setObject:[self petId] forKey:@"PetId"];
    [[GameUI sharedInstance] showEquipMainView:tempDict];
}
- (IBAction)upgradeSubAttri:(id)sender
{
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:[self equipEid] forKey:@"EquipId"];
    [tempDict setObject:[self petId] forKey:@"PetId"];
    [[GameUI sharedInstance] showEquipSubView:tempDict];
}

- (IBAction)upgradeGodAttri:(id)sender
{
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:[self equipEid] forKey:@"EquipId"];
    [tempDict setObject:[self petId] forKey:@"PetId"];
    [[GameUI sharedInstance] showEquipGodView:tempDict];
}

- (IBAction)onRemoveClicked:(id)sender
{
    BOOL isFull = [[[GameObject sharedInstance] bag] isEquipFull];
    if (isFull)
    {
        [[GameUI sharedInstance] showError:@"背包已经满了，请先清理背包吧！！！" title:@"Error"];
        return;
    }
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:[self equipEid] forKey:@"EID"];
    [tempDict setObject:[self petId] forKey:@"Pet"];
    [[PackageManager sharedInstance] unloadEquipRequest:tempDict];
    
    [[GameObject sharedInstance] setWillChangedEquipWithId:[self equipEid]
                                                 withPetId:[self petId]];
}
- (IBAction)onReplaceClicked:(id)sender
{
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:[self equipSlot] forKey:@"EquipSlot"];
    [tempDict setObject:[self petId] forKey:@"PetId"];
    [[GameUI sharedInstance] showEquipChangeView:tempDict];
}

//
// 出售action
//
- (IBAction)onSellClicked:(id)sender
{
    if ([[self equipSlot] integerValue] > 0)
    {
        // 一般不会走这里
        [[GameUI sharedInstance] showError:@"装备在身上无法出售，请先卸载！" title:@"Error"];
        return;
    }
    Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:[self equipEid]];
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:[self equipEid] forKey:@"ID"];
    [tempDict setObject:[equip equipTId] forKey:@"TID"];
    [tempDict setObject:INT_TO_NUMBER(1) forKey:@"Num"];
    
    [[PackageManager sharedInstance] sellItemOrEquipFromBagRequest:tempDict];
}
@end
