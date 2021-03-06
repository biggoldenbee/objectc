//
//  StoreViewController.h
//  Miner
//
//  Created by biggoldenbee on 15/1/19.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BaseViewController.h"

@interface Store : NSObject
@property (atomic) NSArray *Goods;
@property (assign) NSInteger Luck;
@property (assign) NSInteger Type;
@property (assign) NSInteger Secs;
-(void)setDataWithDictionary:(NSDictionary *)data;
@end


@interface StoreViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UIButton *theStoreButton;
@property (strong, nonatomic) IBOutlet UIButton *theMarketButton;
@property (strong, nonatomic) IBOutlet UIButton *theGambleButton;
@property (strong, nonatomic) IBOutlet UIButton *theRefreshButton;
@property (strong, nonatomic) IBOutlet UILabel *theStoreLuck;
@property (strong, nonatomic) IBOutlet UILabel *theStoreFavorability;

@property (strong, nonatomic) IBOutlet UILabel *theNextAutoRefreshLabelTitle;
@property (strong, nonatomic) IBOutlet UILabel *theNextAutoRefreshLabelTimer;

@property (strong, nonatomic) IBOutlet UICollectionView *storeCollectionView;

-(void)setDataInfoInViewControllers:(NSDictionary *)data;

@end
