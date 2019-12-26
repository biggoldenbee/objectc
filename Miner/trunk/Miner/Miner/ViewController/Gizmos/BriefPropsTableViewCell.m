//
//  BriefPropsTableViewCell.m
//  Miner
//
//  Created by biggoldenbee on 15/1/7.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BriefPropsTableViewCell.h"

#import "GameUtility.h"
#import "BattleData.h"

#import "Item.h"
#include "Equipment.h"

#define Brief_Max_Row_Icons     4

#define Brief_Component_Y       5.0f
#define Brief_Item_Icon_W       80.0f
#define Brief_Item_Icon_H       63.0f


@interface BriefItemIcon : NSObject
@property (strong, nonatomic) UIImageView *itemPropsBar;
@property (strong, nonatomic) UIImageView *itemIcon;
@property (strong, nonatomic) UIImageView *itemShawdow;
@property (strong, nonatomic) UILabel *itemCount;

-(void)setPosition : (CGPoint)origin;
-(void)setHidden : (BOOL)hidden;
-(void)addToSuperView : (UIView*)view;
@end

@implementation BriefItemIcon
-(id)init{
    if (self=[super init]) {
        self.itemPropsBar = [[UIImageView alloc] init];
        [self.itemPropsBar setImage:[GameUtility imageNamed:@"base_propsbar2_1.png"]];
        [self.itemPropsBar setFrame:CGRectMake(13, 1, 53, 63)];

        self.itemIcon = [[UIImageView alloc] init];
        [self.itemIcon setImage:[GameUtility imageNamed:@"icon_item101.png"]];
        [self.itemIcon setFrame:CGRectMake(17, 3, 45, 45)];

        self.itemShawdow = [[UIImageView alloc] init];
        [self.itemShawdow setImage:[GameUtility imageNamed:@"base_shadow2.png"]];
        [self.itemShawdow setFrame:CGRectMake(0, 63, 80, 3)];

        self.itemCount = [[UILabel alloc] init];
        [self.itemCount setFrame:CGRectMake(0, 52, 80, 10)];
        [self.itemCount setFont:[UIFont systemFontOfSize:10]];
        [self.itemCount setText:@"x11"];
        [self.itemCount setTextAlignment:NSTextAlignmentCenter];
    }
    return self;
}

-(void)setPosition : (CGPoint)origin; {
    [self.itemPropsBar  setFrame:CGRectMake(origin.x+13, origin.y+1, 53, 63)];
    [self.itemIcon      setFrame:CGRectMake(origin.x+17, origin.y+3, 45, 45)];
    [self.itemShawdow   setFrame:CGRectMake(origin.x+0, origin.y+63, 80, 3)];
    [self.itemCount     setFrame:CGRectMake(origin.x+0, origin.y+52, 80, 10)];
}

-(void)setHidden : (BOOL)hidden; {
    [self.itemPropsBar  setHidden:hidden];
    [self.itemIcon      setHidden:hidden];
    [self.itemShawdow   setHidden:hidden];
    [self.itemCount     setHidden:hidden];
}

-(void)addToSuperView : (UIView*)view; {
    [view addSubview:self.itemPropsBar];
    [view addSubview:self.itemIcon];
    [view addSubview:self.itemShawdow];
    [view addSubview:self.itemCount];
}

@end


@implementation BriefIconItem
@end

@interface BriefPropsTableViewCell()

@property (nonatomic, strong) NSMutableArray* theItemIcons;

@end

@implementation BriefPropsTableViewCell

-(void)initilizingComponents {
    // Initialization code
    CGFloat spaceSize = ([UIScreen mainScreen].bounds.size.width-20)/Brief_Max_Row_Icons;
    CGFloat offsetX = (spaceSize-Brief_Item_Icon_W)/2;
    if (offsetX<0) offsetX = 0.0;

    self.theItemIcons = [[NSMutableArray alloc] init];
    
    for (int i=0; i<Brief_Max_Row_Icons; i++) {
        BriefItemIcon *aItemIcon = [[BriefItemIcon alloc] init];
        [aItemIcon setPosition:CGPointMake(offsetX+i*spaceSize, Brief_Component_Y)];
        [aItemIcon addToSuperView:[self contentView]];
        [aItemIcon setHidden:TRUE];
        [self.theItemIcons addObject:aItemIcon];
    }
}

- (void)awakeFromNib {
    // Initialization code
    [self initilizingComponents];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataWithItems:(NSArray*)items row:(NSInteger)row {
    CGFloat spaceSize = ([UIScreen mainScreen].bounds.size.width-20)/Brief_Max_Row_Icons;
    CGFloat offsetX = (spaceSize-Brief_Item_Icon_W)/2;
    if (offsetX<0) offsetX = 0.0;

    for (int i=0; i<Brief_Max_Row_Icons; i++) {
        BriefItemIcon* aItemIcon = [self.theItemIcons objectAtIndex:i];
        [aItemIcon setHidden:TRUE];
        [aItemIcon setPosition:CGPointMake(offsetX+i*spaceSize, Brief_Component_Y)];
        if ((row*Brief_Max_Row_Icons+i)<[items count]) {
            BriefIconItem* aItem = [items objectAtIndex:(row*Brief_Max_Row_Icons+i)];
            if (nil!=aItem) {
                [[aItemIcon itemPropsBar] setImage:[GameUtility imageNamed:[aItem itemPropbarName]]];
                [[aItemIcon itemIcon] setImage:[GameUtility imageNamed:[aItem itemIconName]]];
                [[aItemIcon itemCount] setText:[NSString stringWithFormat:@"x%d", [[aItem itemCount] intValue]]];
                [aItemIcon setHidden:FALSE];
            }
        }
    }
}


@end
