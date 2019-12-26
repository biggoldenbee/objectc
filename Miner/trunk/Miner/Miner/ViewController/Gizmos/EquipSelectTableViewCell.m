//
//  EquipSelectTableViewCell.m
//  Miner
//
//  Created by zhihua.qian on 15-1-4.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "EquipSelectTableViewCell.h"
#import "GameUI.h"
#import "Equipment.h"
#import "GameUtility.h"
#import "StringConfig.h"

#define SELECT_EQUIP_COUNT_MAX  6

static int m_sSelectCount = 0;

@interface EquipSelectTableViewCell ()

@property (nonatomic, weak) Equipment* selectEquip;
@property (nonatomic, assign) BOOL isSelectState;
@end

@implementation EquipSelectTableViewCell
+(void)resetSelectCount
{
    m_sSelectCount = 0;
}

- (void)awakeFromNib {
    // Initialization code
}



-(void)setDataWithObject:(NSArray *)data
{
    self.selectEquip = [data objectAtIndex:0];
    
    NSNumber* subAttriLevel = [[[[self selectEquip] subAttri] objectAtIndex:0] attriLevel];
    NSString* starIconName = [GameUtility getImageNameForEquipStrengthenWithStar:[subAttriLevel intValue]];
    [self.equipStarImage setImage:[GameUtility imageNamed:starIconName]];
    [self.equipIconImage setImage:[GameUtility imageNamed:[[self selectEquip] getEquipIcon]]];
    
    // 还需要设置装备名字属性
    self.equipNameLabel.text = [[StringConfig share] getLocalLanguage:[[self selectEquip] getEquipName]];
    
    NSNumber* saLevel = ((AttributeData*)[[self selectEquip].subAttri objectAtIndex:0]).attriLevel;
    NSString* mainLevel = [[[[self selectEquip] mainAttri] attriLevel] stringValue];
    self.equipLevelLabel.textColor  = [GameUtility getColorWithLv:[saLevel intValue]];
    self.equipLevelLabel.text = [NSString stringWithFormat:@"Lv. %@", mainLevel];
    
    NSInteger maxExp    = [[[self selectEquip] getMainAttributeTotalExp] integerValue];
    NSInteger baseExp   = [[[self selectEquip] getMainAttributeBaseExp] integerValue];
    float ratio         = [[[self selectEquip] getMainAttributeRatio] floatValue];
    
    NSInteger addExp = maxExp * ratio + baseExp;
    self.equipGainExpLabel.text = [NSString stringWithFormat:@"%lu", addExp];
}

- (IBAction)onSelectClicked:(id)sender
{
    if (self.chooseBtn.isSelected)
    {
        [self.chooseBtn setSelected:NO];
        m_sSelectCount--;
    }
    else
    {
        if ([self canSelectEquip])
        {
            [self.chooseBtn setSelected:YES];
        }
        else
        {
            return;
        }
    }
    [[GameUI sharedInstance] changeEquipListInSelectView:[[self selectEquip] equipEId] option:self.chooseBtn.isSelected];
}

-(BOOL)canSelectEquip
{
    if (m_sSelectCount == SELECT_EQUIP_COUNT_MAX)
    {
        NSLog(@"不能再选择了");
        return NO;
    }
    else
    {
        NSLog(@"还可以再选择，现在是第%d件", m_sSelectCount);
        m_sSelectCount++;
        return YES;
    }
}
@end
