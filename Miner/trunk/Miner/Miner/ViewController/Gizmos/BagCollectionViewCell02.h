//
//  BagCollectionViewCell02.h
//  Miner
//
//  Created by zhihua.qian on 14-12-26.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagCollectionViewCell02 : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *bagStateLabel;

-(void)setBagStateWithString:(NSString*)state;
@end
