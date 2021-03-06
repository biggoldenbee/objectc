//
//  StoreViewController.m
//  Miner
//
//  Created by biggoldenbee on 15/1/19.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "StoreViewController.h"
#import "GameUI.h"
#import "GameUtility.h"
#import "StoreCollectionViewCell.h"
#import "PackageManager.h"
#import "StringConfig.h"

#define STORE_TYPE_0    0 // 普通
#define STORE_TYPE_1    1 // 黑市
#define STORE_TYPE_2    2 // 赌市

#define STORE_TIMER_INTERVAL    1.0

@implementation Store

-(NSArray *)setGoodsWithArray:(NSArray *)data
{
    if (data == nil || [data count] == 0)
        return nil;
    
    NSMutableArray *tempArr = [[NSMutableArray alloc]init];
    for (NSDictionary *tempDict in data)
    {
        Goods *goods = [[Goods alloc]init];
        [goods setDataWithDictionary:tempDict];
        [tempArr addObject:goods];
    }
    
    return tempArr;
}


-(void)setDataWithDictionary:(NSDictionary *)data{
    self.Luck = [[data objectForKey:@"Luck"] integerValue];
    self.Type = [[data objectForKey:@"Type"] integerValue];
    self.Secs = [[data objectForKey:@"Secs"] integerValue];
    NSArray *goodsData = [data objectForKey:@"Goods"];
    self.Goods = [self setGoodsWithArray:goodsData];
}

@end


@interface StoreViewController ()
@property (nonatomic,assign) NSInteger theStoreType;
@property (nonatomic,strong) NSMutableArray *theStores;
@property (strong, nonatomic) NSTimer* storeTimer;
@property (nonatomic,assign) BOOL storeTimerFlag;
@property (strong, nonatomic) UIAlertView *theAlertView;
@end

@implementation StoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.theStoreType = STORE_TYPE_0;
    [self resetAllBtns];
    // 隐藏赌场 暂时不用
    [self.theGambleButton setHidden:TRUE];

    // 注册StoreCollectionViewCell类到self.storeCollectionView
    [self.storeCollectionView registerClass:[StoreCollectionViewCell class] forCellWithReuseIdentifier:@"StoreCollectionViewCell"];

    // 初始化商店
    self.theStores = [[NSMutableArray alloc] init];
    for (int i=0; i<3; i++)
    {
        Store *aStore=[[Store alloc] init];
        aStore.Type = i;
        aStore.Secs = -1;
        [self.theStores addObject:aStore];
    }

    // 激活STORE TAB页面
    [self onStoreButtonClicked:[self theStoreButton]];
    // 获取所有数据
    [self storeQueryGoods:-1];
    // 设置refresh button
    [[self theRefreshButton] setTitle:[[StringConfig share] getLocalLanguage:@"Refresh"] forState:UIControlStateNormal];
    [[self theRefreshButton] setTitle:[[StringConfig share] getLocalLanguage:@"Refresh"] forState:UIControlStateHighlighted];
    [[self theRefreshButton] setTitle:[[StringConfig share] getLocalLanguage:@"Refresh"] forState:UIControlStateSelected];
    [[self theRefreshButton] setBackgroundImage:[GameUtility imageNamed:@"base_button1_a.png"] forState:UIControlStateNormal];
    [[self theRefreshButton] setBackgroundImage:[GameUtility imageNamed:@"base_button1_b.png"] forState:UIControlStateHighlighted];
    
    // 设置TAB文字--STROE
    [[self theStoreButton] setTitle:[[StringConfig share] getLocalLanguage:@"Store"] forState:UIControlStateNormal];
    [[self theStoreButton] setTitle:[[StringConfig share] getLocalLanguage:@"Store"] forState:UIControlStateHighlighted];
    [[self theStoreButton] setTitle:[[StringConfig share] getLocalLanguage:@"Store"] forState:UIControlStateSelected];
    // 设置TAB文字--Market
    [[self theMarketButton] setTitle:[[StringConfig share] getLocalLanguage:@"Market"] forState:UIControlStateNormal];
    [[self theMarketButton] setTitle:[[StringConfig share] getLocalLanguage:@"Market"] forState:UIControlStateHighlighted];
    [[self theMarketButton] setTitle:[[StringConfig share] getLocalLanguage:@"Market"] forState:UIControlStateSelected];
    // 设置TAB文字--PUB
    [[self theGambleButton] setTitle:[[StringConfig share] getLocalLanguage:@"Pub"] forState:UIControlStateNormal];
    [[self theGambleButton] setTitle:[[StringConfig share] getLocalLanguage:@"Pub"] forState:UIControlStateHighlighted];
    [[self theGambleButton] setTitle:[[StringConfig share] getLocalLanguage:@"Pub"] forState:UIControlStateSelected];
    // 产生对话框
    self.theAlertView = [[UIAlertView alloc] initWithTitle:[[StringConfig share] getLocalLanguage:@"Store"]
                                                   message:@"You need pay money for refreshing store, continue?"
                                                  delegate:self
                                         cancelButtonTitle:[[StringConfig share] getLocalLanguage:@"Cancel"]
                                         otherButtonTitles:[[StringConfig share] getLocalLanguage:@"Ok"],nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleStoreTimer:(NSTimer*)timer
{
    // 检查计时器是不是已经在调用
    if (TRUE==self.storeTimerFlag) return;
    // 设置标志
    self.storeTimerFlag=TRUE;
    // 检查所有商店再刷新到计时
    for (int i=0; i<[[self theStores] count]; i++) {
        Store *aStore = [[self theStores] objectAtIndex:i];
        int theRefreshCountDownSecs = (int)[aStore Secs];
        // 更新所有商店再刷新倒计时
        if (theRefreshCountDownSecs>0) {
            // 刷新商店到计时显示内容
            //NSLog(@"self.theStoreType==aStore.Type %d %d\n", (int)[self theStoreType], (int)aStore.Type);
            if (self.theStoreType==aStore.Type) {
                // 这段代码要仔细review一下
                int seconds = theRefreshCountDownSecs%60;
                int minutes = 0;
                int hours = 0;
                if (theRefreshCountDownSecs>0) {
                    if (theRefreshCountDownSecs>=60) {
                        seconds = theRefreshCountDownSecs%60;
                        minutes = theRefreshCountDownSecs/60;
                        if (minutes >= 60) {
                            hours = minutes/60;
                            minutes = minutes%60;
                            if (hours>= 24) {
                                hours = hours%24;
                            }
                        }
                    }
                    // 更新label到计时内容
                    [[self theNextAutoRefreshLabelTitle] setText:[NSString stringWithFormat:@"%@:",@"Next Auto Refresh"]];
                    [[self theNextAutoRefreshLabelTimer] setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hours,minutes,seconds]];
//                    NSLog(@"handleStoreTimer %@ %d %d\n", [self.view window], (int)[self theStoreType], theRefreshCountDownSecs);
                }
            }
            // 执行到计时
            theRefreshCountDownSecs--;
            aStore.Secs = theRefreshCountDownSecs;
        } else if (0==theRefreshCountDownSecs) { // 再刷新商店到计时为零，需要重新获取新的stroe goods
            [[self theNextAutoRefreshLabelTitle] setText:[NSString stringWithFormat:@"%@:",@"Now Refreshing...:"]];
            [[self theNextAutoRefreshLabelTimer] setText:[NSString stringWithFormat:@"--:--:--"]];
            [self storeRefreshGoods:aStore.Type];
            // 设置到计时为-1，以防止多次调用重新刷新
            aStore.Secs = -1;
        }
    }
    // 清除标志
    self.storeTimerFlag=FALSE;
}

-(void)setDataInfoInViewControllers:(NSDictionary *)data {
    // 关闭当前计时器
    if (nil!=self.storeTimer) {
        self.storeTimerFlag = FALSE;
        [self.storeTimer invalidate];
        self.storeTimer = nil;
    }
    // 此函数响应refreshClicked，获取全部的商品列表
    if ([data objectForKey:@"Shop"])
    {
        // 获取原始商店包从server数据
        NSArray *storeData = [data objectForKey:@"Shop"];
        // 解析STORE
        for (int i=0;i<[[storeData objectAtIndex:0] count]; i++)
        {
            Store *aStore = [[Store alloc] init];
            [aStore setDataWithDictionary:[[storeData objectAtIndex:0] objectAtIndex:i]];
            NSLog(@"%ld\n", aStore.Luck);
            NSLog(@"%ld\n", aStore.Type);
            NSLog(@"%ld\n", aStore.Secs);
            for (Goods *goods in aStore.Goods) {
                NSLog(@"%ld\n", [goods Type]);
                NSLog(@"%@\n", [goods Token]);
            }
            // 根据store type替换该商店数据
            if (aStore.Type<[self.theStores count]) {
                [self.theStores replaceObjectAtIndex:aStore.Type withObject:aStore];
            } else {
                NSLog(@"if (aStore.Type<[self.theStores count]) else, please check what happened\n");
            }
        }
    }

    // 此处等金勇新的定义
    if ([data objectForKey:@"Hero"])
    {
        NSLog(@"%@\n", [data objectForKey:@"Hero"]);
    }

    // 启动store timer
    self.storeTimer = [NSTimer scheduledTimerWithTimeInterval:STORE_TIMER_INTERVAL target:self selector:@selector(handleStoreTimer:) userInfo:nil repeats:YES];
    self.storeTimerFlag = FALSE;

    // 设置store luck
    [[self theStoreFavorability] setText:[NSString stringWithFormat:@"%@:",[[StringConfig share] getLocalLanguage:@"The Favorability"]]];
    [[self theStoreLuck] setText:[NSString stringWithFormat:@"%2d%%",(int)[[self.theStores objectAtIndex:self.theStoreType] Luck]/100]];
    [[self storeCollectionView] reloadData];
    
}

-(void)storeQueryGoods:(NSInteger)type{
    // type是-1将请求所有的商店物品
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:[NSNumber numberWithInt:(int)type] forKey:@"Type"];
    [[PackageManager sharedInstance] storeQueryGoods:tempDict];
}

-(void)storeRefreshGoods:(NSInteger)type{
    // Secs计时到，请求重新刷新所有的商店物品
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:[NSNumber numberWithInt:(int)type] forKey:@"Type"];
    [[PackageManager sharedInstance] storeRefreshGoods:tempDict];
}

-(void)resetAllBtns{
    [[self theStoreButton] setSelected:NO];
    [[self theMarketButton] setSelected:NO];
    [[self theGambleButton] setSelected:NO];
}

- (IBAction)onStoreButtonClicked:(id)sender {
    [self resetAllBtns];
    [[self theStoreButton] setSelected:YES];
    [[self storeCollectionView] reloadData];
    self.theStoreType = STORE_TYPE_0;
    [[self storeCollectionView] reloadData];
}

- (IBAction)onMarketButtonClicked:(id)sender {
    [self resetAllBtns];
    [[self theMarketButton] setSelected:YES];
    [[self storeCollectionView] reloadData];
    self.theStoreType = STORE_TYPE_1;
    [[self storeCollectionView] reloadData];
}

- (IBAction)onGambleClicked:(id)sender {
    [self resetAllBtns];
    [[self theGambleButton] setSelected:YES];
    [[self storeCollectionView] reloadData];
    self.theStoreType = STORE_TYPE_2;
    [[self storeCollectionView] reloadData];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"buttonIndex is : %i",(int)buttonIndex);
    switch (buttonIndex) {
        case 0:{
        }break;
        case 1:{
            [self storeRefreshGoods:self.theStoreType];            
        }break;
        default:
            break;
    }
}


- (IBAction)onRefreshClicked:(id)sender {
    [[self theAlertView] show];
// 此处测试用
//    [self storeRefreshGoods:self.theStoreType];
//    [self storeQueryGoods:-1];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - Collection view datasource && delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    switch ([self theStoreType])
    {
        case STORE_TYPE_0:
            return 1;
            break;
        case STORE_TYPE_1:
            return 1;
            break;
        case STORE_TYPE_2:
            return 1;
            break;
        default:
            return 1;
            break;
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count=0;
    if ((self.theStoreType<[self.theStores count]))
        count = [[[self.theStores objectAtIndex:self.theStoreType] Goods] count];
    return count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath section] == 0) {
        if ((self.theStoreType<[self.theStores count])) {

            StoreCollectionViewCell *cell = (StoreCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"StoreCollectionViewCell" forIndexPath:indexPath];

            NSInteger row = [indexPath row];
            [cell setDataWithObject:[[[self.theStores objectAtIndex:self.theStoreType] Goods] objectAtIndex:row] storeType:[self theStoreType]];

            return cell;
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didSelectItemAtIndexPath\n");
}

@end
