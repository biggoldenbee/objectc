//
//  QQEquipBtnDefault.m
//  Miner
//
//  Created by zhihua.qian on 14-12-23.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "QQEquipBtnDefault.h"
#import "GameUtility.h"
#import "GameObject.h"
#import "GameUI.h"
#import "UtilityDef.h"

#import "Equipment.h"
#import "Item.h"

#define EQUIP_MAIN_ADD_ICON             @"strengthen_add"
#define EQUIP_PART_DEFAULT_ICON         @"equ_bg"

@interface QQEquipBtnDefault ()

// btnType
// 为部件代号  装备界面 1~8
// 主属性界面 为 0 增加装备
// 副属性界面 为 10 道具
@property (nonatomic, strong) NSNumber* btnType;        // 部位代号 1~8
@property (nonatomic, strong) NSNumber* equipEId;       // 装备EId
@property (nonatomic, strong) NSNumber* itemTId;        // 道具ID
@property (nonatomic, strong) NSNumber* petId;          // 宠物ID
@property (nonatomic, assign) BOOL haveEquip;           // 是否装配了装备（慢慢绕吧）
@property (nonatomic, assign) BOOL isOKForUpgrade;      // 需求道具数量是否满足

@end

@implementation QQEquipBtnDefault
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"QQEquipBtnDefaultView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

// 初始化成默认无装备状态
-(void)initViewWithPartType:(int)type withPetId:(NSNumber*)petId
{
    self.petId  = petId;
    self.btnType = [NSNumber numberWithInt:type];
    
    [[self backGroundIcon] setImage:[GameUtility imageNamed:EQUIP_PART_DEFAULT_ICON]];
    
    if (type > 0 && type < 9)
    {
        NSString* partIconName  = [GameUtility getImageNameForEquipViewWithType:type];
        UIImage* stateImage     = [GameUtility imageNamed:partIconName];
        [[self equipPartIcon] setImage:stateImage];
    }
    if (type == 10)
    {
        [[self equipPartIcon] setHidden:YES];
    }
    if (type == 0)
    {
        UIImage* stateImage     = [GameUtility imageNamed:EQUIP_MAIN_ADD_ICON];
        [[self equipPartIcon] setImage:stateImage];
    }
    
    [[self levelLabel] setHidden:YES];
    [[self markIcon] setHidden:YES];
    [[self equipColorIcon] setHidden:YES];
    [self hiddenAllStars];
}

-(void)hiddenAllStars
{
    [[self star1Image] setHidden:YES];
    [[self star2Image] setHidden:YES];
    [[self star3Image] setHidden:YES];
    [[self star4Image] setHidden:YES];
    [[self star5Image] setHidden:YES];
    [[self star6Image] setHidden:YES];
    [[self star7Image] setHidden:YES];
    [[self star8Image] setHidden:YES];
    [[self star9Image] setHidden:YES];
}

-(void)setEquipDataWithEId:(NSNumber*)equipId
{
    Equipment* equip = [[GameObject sharedInstance] getEquipWithEId:equipId];
    if (equip)
    {
        self.haveEquip  = YES;
        self.equipEId   = equipId;
        
        [[self equipColorIcon] setHidden:NO];
        NSNumber* sublevel = [[[equip subAttri] objectAtIndex:0] attriLevel];
        NSString* imageName = [GameUtility getImageNameForEquipStrengthenWithStar:[sublevel intValue]];
        [[self equipColorIcon] setImage:[GameUtility imageNamed:imageName]];
        
        NSString* equipIcon = [equip getEquipIcon];
        [[self equipPartIcon] setImage:[GameUtility imageNamed:equipIcon]];
        
        [[self levelLabel] setHidden:NO];
        NSString* mainlevel         = [[[equip mainAttri] attriLevel] stringValue];
        NSNumber* saLevel = ((AttributeData*)[equip.subAttri objectAtIndex:0]).attriLevel;
        self.levelLabel.textColor   = [GameUtility getColorWithLv:[saLevel intValue]];
        self.levelLabel.text        = [NSString stringWithFormat:@"Lv. %@", mainlevel];
        
        [self setStarImageNum:[equip equipStar]];
    }
}

-(void)setStarImageNum:(NSNumber*)stars
{
    [self hiddenAllStars];
    switch ([stars intValue])
    {
        case 1:
            [[self star3Image] setHidden:NO];
            break;
        case 2:
            [[self star7Image] setHidden:NO];
            [[self star8Image] setHidden:NO];
            break;
        case 3:
            [[self star2Image] setHidden:NO];
            [[self star3Image] setHidden:NO];
            [[self star4Image] setHidden:NO];
            break;
        case 4:
            [[self star6Image] setHidden:NO];
            [[self star7Image] setHidden:NO];
            [[self star8Image] setHidden:NO];
            [[self star9Image] setHidden:NO];
            break;
        case 5:
            [[self star1Image] setHidden:NO];
            [[self star2Image] setHidden:NO];
            [[self star3Image] setHidden:NO];
            [[self star4Image] setHidden:NO];
            [[self star5Image] setHidden:NO];
            break;
    }
}


-(void)setItemDataWithTId:(NSNumber*)itemTId countNum:(NSInteger)num
{

    self.itemTId        = itemTId;
    NSInteger needNum   = num;
    NSInteger curNum    = 0;
    
    Item* item = [[GameObject sharedInstance] getItemWithTId:itemTId];
    if (item != nil)
    {
        // 当前拥有量
        curNum = [[item itemCount] integerValue];
    }
    
    if (needNum <= curNum)
    {// 足够
        self.isOKForUpgrade = YES;
    }
    else
    {// 不够
        self.isOKForUpgrade = NO;
    }
    
    // 数量显示
    NSString* strNeedNum    = [NSString stringWithFormat:@"%lu", needNum];
    NSString* strCurNum     = [NSString stringWithFormat:@"%lu", curNum];
    
    [[self levelLabel] setHidden:NO];
    if ([self isOKForUpgrade])
    {
        self.levelLabel.textColor = [UIColor colorWithRed:0 green:184/255.0 blue:82/255.0 alpha:1.0];
    }
    else
    {
        self.levelLabel.textColor = [UIColor redColor];
    }
    self.levelLabel.text = [NSString stringWithFormat:@"%@ / %@", strCurNum, strNeedNum];
    
    [[self equipPartIcon] setHidden:NO];
    ItemDef* itemDef = [[ItemConfig share] getItemDefWithKey:itemTId];
    UIImage* itemIcon = [GameUtility imageNamed:[itemDef itemIcon]];
    [[self equipPartIcon] setImage:itemIcon];

}

-(BOOL)checkEnough
{
    return [self isOKForUpgrade];
}

- (IBAction)onSelectEquipClicked:(id)sender
{
    if ([self.btnType integerValue] >= 10)
    {
        return;
    }
    
    if ([[self btnType] integerValue] == 0)
    {
        [[self deleate] onClickedOnQQEquipDefaultView:nil];
    }
    
    if ([[self btnType] integerValue] > 0 && [[self btnType] integerValue] < 9 )
    {
        if ([self haveEquip])
        {
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
            [tempDict setObject:self.equipEId forKey:@"EquipId"];
            [tempDict setObject:self.petId forKey:@"PetId"];
            
            [[GameUI sharedInstance] showEquipInfoView:tempDict];
        }
        else
        {
            NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
            [tempDict setObject:self.btnType forKey:@"EquipSlot"];
            [tempDict setObject:self.petId forKey:@"PetId"];        // 宠物ID 默认为 0
            [[GameUI sharedInstance] showEquipChangeView:tempDict];
        }
    }
}

-(void)refreshState:(int)slot
{
    Equipment* equip = nil;
    if ( self.equipEId != nil )
        equip = [[GameObject sharedInstance] getEquipWithEId:self.equipEId];
    
    Bag* bag = [GameObject sharedInstance].bag;
    NSString* tag = [[GameObject sharedInstance].player.heroIdentifier stringValue];
    if ( self.petId != nil )
    {
        tag = [tag stringByAppendingFormat:@"_%@", self.petId];
    }
    self.markIcon.hidden = ![bag hasBetterEquip:slot current:equip tag:tag];
}
@end
