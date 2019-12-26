//
//  CommonTableViewCell.m
//  Miner
//
//  Created by zhihua.qian on 14-12-1.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "EquipChangeTableViewCell.h"
#import "Equipment.h"
#import "GameUI.h"
#import "GameUtility.h"
#import "StringConfig.h"


@implementation EquipChangeTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}
-(void)setNewFrame:(CGRect)frame
{
    self.frame = frame;
}

-(void)setDataWithObject:(NSArray *)data
{
    if ([data count] == 0)
    {
        return;
    }
    
    self.equip = [data objectAtIndex:0];
    
    // 属性战力的设置
    self.scoreLabel.text = [self.equip.equipBV stringValue];
    
    self.mainAttriLabel.text = [[StringConfig share] getLocalLanguage:[self.equip.mainAttri getAttriName]];
    self.mainAttriValueLabel.text = [[self.equip.mainAttri attriValue] stringValue];
    
    [self setSubAttributeDataWithArray:self.equip.subAttri];
    [self setGodAttributeDataWithAttribute:self.equip.godAttri];

    NSNumber* subLevel = [[[[self equip] subAttri] objectAtIndex:0] attriLevel];
    NSString* starIconName = [GameUtility getImageNameForEquipStrengthenWithStar:[subLevel intValue]];
    [self.starImage setImage:[GameUtility imageNamed:starIconName]];
    [self.iconImage setImage:[GameUtility imageNamed:[self.equip getEquipIcon]]];
    
    // 还需要设置装备名字属性
    self.nameLabel.text = [[StringConfig share] getLocalLanguage:[self.equip getEquipName]];
    
    NSString* mainLevel = [[[[self equip] mainAttri] attriLevel] stringValue];
    NSNumber* saLevel = ((AttributeData*)[self.equip.subAttri objectAtIndex:0]).attriLevel;
    self.levelLabel.textColor  = [GameUtility getColorWithLv:[saLevel intValue]];
    self.levelLabel.text = [NSString stringWithFormat:@"Lv. %@", mainLevel];
}

-(void)setSubAttributeDataWithArray:(NSArray*)data
{
    [self.sub1AttriLabel setHidden:YES];
    [self.sub1AttriValueLabel setHidden:YES];
    [self.sub2AttriLabel setHidden:YES];
    [self.sub2AttriValueLabel setHidden:YES];
    [self.sub3AttriLabel setHidden:YES];
    [self.sub3AttriValueLabel setHidden:YES];
    
    if (data == nil || [data count] == 0)
    {
        return;
    }
    
    for (int i=0; i<[data count]; i++)
    {
        AttributeData* attri = [data objectAtIndex:i];
        if (i == 0)
        {
            [self.sub1AttriLabel setHidden:NO];
            self.sub1AttriLabel.text = [[StringConfig share] getLocalLanguage:[attri getAttriName]];
            [self.sub1AttriValueLabel setHidden:NO];
            self.sub1AttriValueLabel.text = attri.attriValue.stringValue;
        }
        if (i == 1)
        {
            [self.sub2AttriLabel setHidden:NO];
            self.sub2AttriLabel.text = [[StringConfig share] getLocalLanguage:[attri getAttriName]];
            [self.sub2AttriValueLabel setHidden:NO];
            self.sub2AttriValueLabel.text = attri.attriValue.stringValue;
        }
        if (i == 2)
        {
            [self.sub3AttriLabel setHidden:NO];
            self.sub3AttriLabel.text = [[StringConfig share] getLocalLanguage:[attri getAttriName]];
            [self.sub3AttriValueLabel setHidden:NO];
            self.sub3AttriValueLabel.text = attri.attriValue.stringValue;
        }
    }
}

-(void)setGodAttributeDataWithAttribute:(AttributeData*)attri
{
    if (attri != nil)
    {
        [self.godAttriLabel setHidden:NO];
        self.godAttriLabel.text = [[StringConfig share] getLocalLanguage:[attri getAttriName]];
        [self.godAttriValueLabel setHidden:NO];
        self.godAttriValueLabel.text = attri.attriValue.stringValue;
    }
    else
    {
        [self.godAttriLabel setHidden:YES];
        [self.godAttriValueLabel setHidden:YES];
    }
}
//
// 将选中的更换装备告诉 EquipChangeViewController
//
- (IBAction)changeEquip:(id)sender
{
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc] init];
    [tempDict setObject:[[self equip] equipEId] forKey:@"EquipId"];
//    [tempDict setObject:[self petId] forKey:@"PetId"];
    [[GameUI sharedInstance] updateEquipChangeView:tempDict];
}
@end
