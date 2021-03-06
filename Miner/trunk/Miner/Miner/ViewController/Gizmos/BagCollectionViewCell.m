//
//  BagCollectionViewCell.m
//  Miner
//
//  Created by zhihua.qian on 14-11-26.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BagCollectionViewCell.h"
#import "GameUtility.h"

@implementation BagCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"BagCollectionViewCell" owner:self options:nil];
        
        if (arrayOfView.count < 1)
        {
            return nil;
        }
        
        if (![[arrayOfView objectAtIndex:0] isKindOfClass:[BagCollectionViewCell class]])
        {
            return nil;
        }
        
        self = [arrayOfView objectAtIndex:0];
    }
    return self;
}

-(void)setDataWithStarIcon:(UIImage*)image equipIcon:(UIImage*)equipImage equipLv:(NSNumber*)level equipStar:(NSNumber*)equipStar
{
    self.starIcon.hidden = NO;
    [self.starIcon setImage:image];
    [self.equipIcon setImage:equipImage];
    
    self.levelLabel.textColor = [GameUtility getColorWithLv:[equipStar intValue]];
    NSString* levelString = [NSString stringWithFormat:@"Lv. %@", [level stringValue]];
    [self.levelLabel setText:levelString];
}


-(void)setDataWithIcon:(UIImage*)itemImage count:(NSNumber*)count
{
    self.starIcon.hidden = YES;
    [self.equipIcon setImage:itemImage];
    [self.levelLabel setText:[count stringValue]];
}
@end
