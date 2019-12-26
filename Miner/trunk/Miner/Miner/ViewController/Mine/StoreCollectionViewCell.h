//
//  StoreCollectionViewCell.h
//  Miner
//
//  Created by biggoldenbee on 15/1/19.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Goods : NSObject
@property (assign) NSInteger Cnt;
@property (assign) NSInteger DCnt;
@property (assign) NSInteger Hot;
@property (assign) NSInteger Luck;
@property (assign) NSInteger MCnt;
@property (assign) NSInteger MType;
@property (assign) NSInteger Sold;
@property (atomic) NSString *Token;
@property (assign) NSInteger Type;
-(void)setDataWithDictionary:(NSDictionary *)data;
@end


@interface StoreCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *itemPropsBar;
@property (strong, nonatomic) IBOutlet UIImageView *itemIcon;
@property (strong, nonatomic) IBOutlet UIImageView *itemPropsFrame;
@property (strong, nonatomic) IBOutlet UILabel *itemPropsName;
@property (strong, nonatomic) IBOutlet UIImageView *itemBaseShadow;
@property (strong, nonatomic) IBOutlet UIImageView *itemBaseIcon;
@property (strong, nonatomic) IBOutlet UIImageView *itemCurrency;
@property (strong, nonatomic) IBOutlet UILabel *itemPrice;
@property (strong, nonatomic) IBOutlet UIButton *itemBuy;
@property (strong, nonatomic) IBOutlet UIImageView *itemStar0;
@property (strong, nonatomic) IBOutlet UIImageView *itemStar1;
@property (strong, nonatomic) IBOutlet UIImageView *itemStar2;
@property (strong, nonatomic) IBOutlet UIImageView *itemStar3;
@property (strong, nonatomic) IBOutlet UIImageView *itemStar4;
@property (strong, nonatomic) IBOutlet UILabel *itemDiscount;
@property (strong, nonatomic) IBOutlet UIImageView *itemDiscountIcon;
@property (strong, nonatomic) IBOutlet UILabel *itemCount;

-(void)setDataWithObject:(Goods *)inGoods storeType:(NSInteger)storeType;

@end
