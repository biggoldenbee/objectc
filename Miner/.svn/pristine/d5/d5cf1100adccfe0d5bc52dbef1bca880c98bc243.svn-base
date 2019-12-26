//
//  BagViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-11-4.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Bag.h"

typedef enum
{
    Show_Equips = 0,
    Show_Items = 1,
    Show_Fragment = 3,
}
BagShowType;

@interface PackViewController : BaseViewController<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *equipTabBtn;
@property (weak, nonatomic) IBOutlet UIButton *propsTabBtn;
@property (weak, nonatomic) IBOutlet UIButton *fragTabBtn;

@property (weak, nonatomic) IBOutlet UIButton *filterBtn;
@property (weak, nonatomic) IBOutlet UIButton *blukSaleBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *bagCollectionView;

@property (nonatomic, assign) BagShowType flagChoose;   // 见枚举
@property (nonatomic, weak) Bag *bag;
@property (nonatomic, strong) NSString* bagState;

@property (nonatomic, strong) NSArray* equipsArray;
@property (nonatomic, strong) NSArray* itemsArray;
@property (nonatomic, strong) NSArray* fragmentsArray;

-(void)updateBagInfo;
@end
