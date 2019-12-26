//
//  BagCollectionViewCell02.m
//  Miner
//
//  Created by zhihua.qian on 14-12-26.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BagCollectionViewCell02.h"

@implementation BagCollectionViewCell02

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSArray *arrayOfView = [[NSBundle mainBundle] loadNibNamed:@"BagCollectionViewCell02" owner:self options:nil];
        
        if (arrayOfView.count < 1)
        {
            return nil;
        }
        
        if (![[arrayOfView objectAtIndex:0] isKindOfClass:[BagCollectionViewCell02 class]])
        {
            return nil;
        }
        
        self = [arrayOfView objectAtIndex:0];
    }
    return self;
}

-(void)setBagStateWithString:(NSString*)state
{
    self.bagStateLabel.text = state;
}
@end
