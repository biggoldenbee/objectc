//
//  StageCollectionViewCell.m
//  Miner
//
//  Created by zhihua.qian on 15/1/7.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "StageCollectionViewCell.h"
#import "DropConfig.h"
#import "GameUtility.h"
#import "StringConfig.h"

@implementation StageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"StageCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1)
        {
            return nil;
        }
        
        if (![[arrayOfView objectAtIndex:0] isKindOfClass:[StageCollectionViewCell class]])
        {
            return nil;
        }
        
        self = [arrayOfView objectAtIndex:0];
    }
    return self;
}

-(void)setupDataWithDropDef:(DropDef*)def
{
    UIImage* itemIcon = [GameUtility imageNamed:[def dropIcon]];
    [[self propsChipIconImage] setImage:itemIcon];
    
    [[self propsNameLabel] setText:[[StringConfig share] getLocalLanguage:[def dropName]]];
}
@end
