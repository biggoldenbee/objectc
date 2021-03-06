//
//  HallViewController.m
//  testMiner
//
//  Created by zhihua.qian on 14-11-27.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "HallViewController.h"
#import "GameObject.h"
#import "GameUI.h"
#import "GameUtility.h"
#import "QQProgressView.h"
#import "QQIconAndStringView.h"

#define PROGRESS_BACKGROUND_IMAGE   @"base_progressbg"
#define PROGRESS_TRACK_IMAGE        @"base_progressbar"

@interface HallViewController ()

@property (nonatomic, strong) QQIconAndStringView* money;
@property (nonatomic, strong) QQIconAndStringView* tiCoin;
@property (nonatomic, strong) QQIconAndStringView* diamond;

@property (nonatomic, weak) Hero *player;
@end

@implementation HallViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 添加所谓的贡献经验条（就是个进度条啦）
//    [self setupCLevelProgressView];
    // 获取主角对象
    
    // 这个是为了显示图标和数字的视图
//    self.money = [self createSubView];
//    self.tiCoin = [self createSubView];
//    self.diamond = [self createSubView];
    
//    [self updateForAllControllers];
//    [self onShowPortViewClicked:nil];
    
    [[self viplevelProgress] setInitState];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)setupCLevelProgressView
//{
//    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"QQProgressView" owner:self options:nil];
//    self.CLProgress = [nibs objectAtIndex:0];
//    self.CLProgress.frame = self.viplevelProgress.bounds;
//    [self.viplevelProgress addSubview:self.CLProgress];
//    [self.CLProgress.backgroundImage setImage:[GameUtility imageNamed:PROGRESS_BACKGROUND_IMAGE]];
//    [self.CLProgress.trackImage0 setImage:[GameUtility imageNamed:PROGRESS_TRACK_IMAGE]];
//    [self.CLProgress.trackImage1 setImage:[GameUtility imageNamed:PROGRESS_TRACK_IMAGE]];
//    [self.CLProgress setInitState];
//}

//-(QQIconAndStringView*)createSubView
//{
//    NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"QQIconAndStringView" owner:self options:nil];
//    return [nibs objectAtIndex:0];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showHallView
{
    self.player = [[GameObject sharedInstance] player];
    [self updateHallView];
    
//    [self.view addSubview:self.money];
//    [self.money setDataForControllers:Money_Type numData:self.player.heroMoney];
//    self.money.center = self.moneyView.center;
//    
//    [self.view addSubview:self.tiCoin];
//    [self.tiCoin setDataForControllers:Money_Type numData:self.player.heroMoney];
//    self.tiCoin.center = self.tiCoinView.center;
//    
//    [self.view addSubview:self.diamond];
//    [self.diamond setDataForControllers:Money_Type numData:self.player.heroMoney];
//    self.diamond.center = self.diamondView.center;
    
    [self onShowMineViewClicked:nil];
}

-(void)updateHallView
{    
    self.viplvLabel.text = [self convertNumberToString:self.player.heroCLevel];
    
    self.moneyLabel.text = [self convertNumberToString:self.player.heroMoney];
    self.tiCoinsLabel.text = [self convertNumberToString:self.player.heroEther];
    self.diamondLabel.text = [self convertNumberToString:self.player.heroCoin];
    [self.viplevelProgress setProgress0:[self.player getCntrbPercent] animated:NO];
}

-(NSString*)convertNumberToString:(NSNumber*)number
{
    unsigned long len = [[number stringValue] length];
    unsigned long num = [number unsignedLongValue];
    if (len <= 5)
    {
        return [number stringValue];
    }
    
    if (len > 5 && len <= 8)
    {
        return [NSString stringWithFormat:@"%luK", num/1000];
    }
    
    if (len > 8)
    {
        return [NSString stringWithFormat:@"%luM", num/1000000];
    }
    
    return [number stringValue];
}

#pragma mark - Button events
- (IBAction)onShowPortViewClicked:(id)sender
{
    [self resetAllBtnDefault];
    self.portBtn.selected = true;
    [[GameUI sharedInstance] showPortView];
}
- (IBAction)onShowMineViewClicked:(id)sender
{
    [self resetAllBtnDefault];
    self.mineBtn.selected = true;
    [[GameUI sharedInstance] showMineView];
}
- (IBAction)onShowStoreViewClicked:(id)sender
{
    [self resetAllBtnDefault];
    self.storeBtn.selected = true;
    [[GameUI sharedInstance] showStoreView];
}
- (IBAction)onShowNewsViewClicked:(id)sender
{
    [self resetAllBtnDefault];
    self.newsBtn.selected = true;
    [[GameUI sharedInstance] showNewsView];
}
- (IBAction)onShowPackViewClicked:(id)sender
{
    [self resetAllBtnDefault];
    self.packBtn.selected = true;
    [[GameUI sharedInstance] showPackView];
}
- (IBAction)onShowSetViewClicked:(id)sender
{
    [self resetAllBtnDefault];
    self.setBtn.selected = true;
    [[GameUI sharedInstance] showSetView];
}
-(void)resetAllBtnDefault
{
    self.portBtn.selected = false;
    self.mineBtn.selected = false;
    self.storeBtn.selected = false;
    self.newsBtn.selected = false;
    self.packBtn.selected = false;
    self.setBtn.selected = false;
}
@end
