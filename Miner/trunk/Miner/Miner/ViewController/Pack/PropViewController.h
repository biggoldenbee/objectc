//
//  PropViewController.h
//  Miner
//
//  Created by zhihua.qian on 15-1-5.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"

@interface PropViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *chestView;
@property (strong, nonatomic) IBOutlet UICollectionView *chestCollectionView;

@property (strong, nonatomic) IBOutlet UIButton *functionBtn;

@property (strong, nonatomic) IBOutlet UILabel *propNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *propTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *propUsedLvLabel;
@property (strong, nonatomic) IBOutlet UITextView *propDescTextView;
@property (strong, nonatomic) IBOutlet UILabel *propCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *propPriceLabel;
@property (strong, nonatomic) IBOutlet UILabel *propFragmentStateLabel;

@property (strong, nonatomic) IBOutlet UIImageView *propStarImage;
@property (strong, nonatomic) IBOutlet UIImageView *propIconImage;

-(void)setDataInfoForViewControllers:(NSDictionary*)data;
-(void)closePropView;
@end
