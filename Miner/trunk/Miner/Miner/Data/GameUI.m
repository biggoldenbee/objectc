//
//  GameUI.m
//  Miner
//
//  Created by jim kaden on 14/10/28.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "GameUI.h"
#import "CommonDef.h"
#import "ErrorCode.h"

#import "LoginViewController.h"
#import "HallViewController.h"
#import "PortViewController.h"
#import "MineViewController.h"
#import "StoreViewController.h"
#import "NewsViewController.h"
#import "PackViewController.h"
//#import "SetViewController.h"
//#import "MessageBoxViewController.h"
#import "StageViewController.h"
#import "EquipViewController.h"
#import "SkillViewController.h"
#import "PetViewController.h"

#import "StageInfoViewController.h"

#import "EquipInfoViewController.h"
#import "UpMainAttriViewController.h"
#import "UpSubAttriViewController.h"
#import "UpGodAttriViewController.h"
#import "EquipChangeViewController.h"
#import "EquipSelectViewController.h"

#import "BlukSellViewController.h"
#import "FilterViewController.h"
#import "PropViewController.h"
// test for jim
#import "RelationViewController.h"

#import "BriefViewController.h"

static LoginViewController      *theLoginViewController = nil;      // 登陆视图
static HallViewController       *theHallViewController = nil;       // 大厅视图
static PortViewController     *thePortViewController = nil;       // 港口视图
static MineViewController       *theMineViewController = nil;       // 挖矿视图
static StoreViewController       *theStoreViewController = nil;       // 商店视图
static NewsViewController       *theNewsViewController = nil;       // 新闻视图
static PackViewController       *thePackViewController = nil;       // 包裹视图
//static SetViewController       *theSetViewController = nil;       // 设置视图
//static MessageBoxViewController *theMessageBoxViewController = nil; // 消息视图

static StageViewController      *theStageViewController = nil;
static EquipViewController      *theEquipViewController = nil;      // 装备视图
static SkillViewController      *theSkillViewController = nil;      // 技能视图
static PetViewController        *thePetViewController = nil;        // 宠物视图

static StageInfoViewController      *theStageInfoViewController = nil;

static EquipInfoViewController      *theEquipInfoViewController = nil;      // 装备信息视图
static UpMainAttriViewController    *theMainAttriViewController = nil;      // 装备升级主属性视图
static UpSubAttriViewController     *theSubAttriViewController = nil;       // 装备升级副属性视图
static UpGodAttriViewController     *theGodAttriViewController = nil;       // 装备升级神属性视图
static EquipChangeViewController    *theEquipChangeViewController = nil;    // 选择装备视图
static EquipSelectViewController    *theEquipSelectViewController = nil;    // 选择装备视图

static BlukSellViewController   *theBlukSellViewController = nil;   // 批量出售视图
static FilterViewController     *theFilterViewController = nil;     // 过滤视图
static PropViewController       *thePropViewController = nil;
// test for Jim
static RelationViewController   *theRelationViewController = nil;
// brief
static BriefViewController      *theBriefViewController = nil;

@implementation GameUI

static GameUI* theGlobalGameUI = nil;

+(GameUI*)sharedInstance
{
    if ( theGlobalGameUI == nil )
    {
        static dispatch_once_t onceGameUI = 0;
        dispatch_once(&onceGameUI, ^(void){theGlobalGameUI = [[GameUI alloc]initInstance];
        });
    }
    return theGlobalGameUI;
}
+(void)setLoginViewController:(LoginViewController *)viewController;
{
    theLoginViewController = viewController;
}

//-(id)init
//{
//    SafeAssert(false, @"GameUI 不能调用init");
//    return nil;
//}

-(id)initInstance
{
    self = [super init];
    _waitingCount = 0;
    [self initAllViewControllers];
    return self;
}

-(void)initAllViewControllers
{
//    _waitingVC = [[WaitingViewController alloc]init];

    theHallViewController   = [[HallViewController alloc]init];
    thePortViewController   = [[PortViewController alloc]init];
    theMineViewController   = [[MineViewController alloc]init];
    theStoreViewController  = [[StoreViewController alloc] init];
    theNewsViewController   = [[NewsViewController alloc] init];
//        theHarbourViewController   = [[HarbourViewController alloc]init];
//        theGameViewController   = [[GameViewController alloc]init];
//        theMessageBoxViewController   = [[MessageBoxViewController alloc]init];
    
    theStageViewController  = [[StageViewController alloc] init];
    theEquipViewController  = [[EquipViewController alloc]init];
    thePackViewController   = [[PackViewController alloc]init];
    theSkillViewController  = [[SkillViewController alloc]init];
    thePetViewController    = [[PetViewController alloc]init];
    
    theStageInfoViewController = [[StageInfoViewController alloc] init];
    
    theEquipInfoViewController  = [[EquipInfoViewController alloc]init];
    theMainAttriViewController  = [[UpMainAttriViewController alloc]init];
    theSubAttriViewController   = [[UpSubAttriViewController alloc]init];
    theGodAttriViewController   = [[UpGodAttriViewController alloc]init];
    theEquipChangeViewController = [[EquipChangeViewController alloc]init];
    theEquipSelectViewController = [[EquipSelectViewController alloc]init];
    
    theBlukSellViewController = [[BlukSellViewController alloc]init];
    theFilterViewController = [[FilterViewController alloc]init];
    thePropViewController = [[PropViewController alloc] init];
    // test for Jim
//    theRelationViewController = [[RelationViewController alloc]init];
    // brief
    theBriefViewController = [[BriefViewController alloc] init];
    
}

-(void)allLoadViews
{
    // port
    [theHallViewController.contentView addSubview:thePortViewController.view];
    // mine
    [theHallViewController.contentView addSubview:theMineViewController.view];
    // store
    [theHallViewController.contentView addSubview:theStoreViewController.view];
    // pack
    [theHallViewController.contentView addSubview:thePackViewController.view];
    
    [self clearContentView];
}

// 清理
-(void)clearContentView
{
    NSArray* views = [theHallViewController.contentView subviews];
    for (int i=0; i<[views count]; i++)
    {
        [[views objectAtIndex:i] removeFromSuperview];
    }
}

//-(void)showWaiting:(NSString*)progress
//{
//    if ( [[NSThread currentThread] isMainThread] == NO )
//    {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            _waitingCount ++;
//        });
//    }
//    else
//        _waitingCount ++;
//    
//    if ( _waitingCount == 1 )
//    {
//        // show up the waiting window
//        [_waitingVC show:progress];
//        
//        // debug 版下显示所有的title
//    }
//}
//
//-(void)hideWaiting
//{
//    if ( [[NSThread currentThread] isMainThread] == NO )
//    {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            _waitingCount --;
//        });
//    }
//    else
//        _waitingCount --;
//    
//    if ( _waitingCount == 0 )
//    {
//        // close the waiting window
//        [_waitingVC hide];
//    }
//}

#pragma mark - Show Error
-(void)showError:(NSString*)error title:(NSString*)title
{
    // error window 临时用AlertView代替
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title
                                                   message:error
                                                  delegate:nil
                                         cancelButtonTitle:@"Close"
                                         otherButtonTitles:nil];
    [alert show];
}

-(void)showError:(int)errorCode extraInfo:(NSString *)extraInfo
{
    // error window
    if ( errorCode == 10002 )
        return;
    NSString* errorMsg = [NSString stringWithFormat:@"err_%d", errorCode];
    if ( extraInfo && [extraInfo length] > 0 )
        [self showError:extraInfo title:@"Error"];
    else
        [self showError:errorMsg title:@"Error"];
}

#pragma mark - 大厅有关的操作
-(void)showHallView
{
    [self allLoadViews];
    if ( theLoginViewController.presentedViewController == theHallViewController )
        [theHallViewController showHallView];
    else
    {
        [theLoginViewController presentViewController:theHallViewController
                                         animated:NO
                                       completion:^{
                                           [theHallViewController showHallView];
                                       }];
    }
}
-(void)updateHallView
{
    [theHallViewController updateHallView];
}

#pragma mark - 港口有关的操作
-(void)showPortView
{
    [self clearContentView];
    thePortViewController.view.frame = theHallViewController.contentView.frame;
    [theHallViewController.contentView addSubview:thePortViewController.view];
}

#pragma mark - 挖矿挂机有关的操作
-(void)showMineView
{
    [self clearContentView];
    theMineViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theMineViewController.view];
}
-(void)updateMineView
{
    [theMineViewController updateViewControllers];
}
-(void)updateBattleMineView:(NSArray*)data
{
    [theMineViewController updateBattleLog:data];
}
-(void)nextBattleMineView:(NSArray*)params
{
    [theMineViewController updateNextBattleTime:params];
}

#pragma mark -- 战斗有关的操作
-(void)showBriefView:(NSDictionary*)params
{
    if (FALSE==[theBriefViewController isPresented]) {
        [theHallViewController presentViewController:theBriefViewController animated:NO completion:^{}];
    }
    [theBriefViewController setDataInfoInViewControllers:params inParentView:theHallViewController.view];
}

#pragma mark -- 地图有关的操作
-(void)showStageView
{
    [self clearContentView];
    theStageViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theStageViewController.view];
    [theStageViewController updateStageViewAllControllers];
}
-(void)showStageInfoView:(NSNumber*)mapId
{
    [theHallViewController presentViewController:theStageInfoViewController animated:NO completion:^{}];
    [theStageInfoViewController setDataInfoInViewControllers:mapId];
}
-(void)updateTheStageInfoView
{
    [theStageInfoViewController updateStageInfoView];
}
-(void)closeTheStageInfoView
{
    [theStageInfoViewController closeStageInfoView];
}

#pragma mark -- 装备有关的操作
-(void)showEquipView
{
    [self clearContentView];
    theEquipViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theEquipViewController.view];
    [theEquipViewController setEquipViewData];
}
-(void)updateEquipView
{
    [theEquipViewController updateEquipViewData];
}
/*
 以下的方法是接收消息处理的方法
 传递的参数  为 NSDictionary
 包括的键有 @“EquipId”, @"PetId"  根据需要选用
 */
-(void)showEquipInfoView:(NSDictionary*)params
{
    [self clearContentView];
    theEquipInfoViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theEquipInfoViewController.view];
    [theEquipInfoViewController setEquipInfoViewData:params];
}
-(void)updateEquipInfoView
{
    [theEquipInfoViewController updateEquipInfoView];
}

-(void)showEquipMainView:(NSDictionary*)params
{
    [self clearContentView];
    theMainAttriViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theMainAttriViewController.view];
    [theMainAttriViewController showMainAttriView:params];
}

-(void)showEquipSubView:(NSDictionary*)params
{
    [self clearContentView];
    theSubAttriViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theSubAttriViewController.view];
    [theSubAttriViewController setDataInfoInViewControllers:params];
}

-(void)showEquipGodView:(NSDictionary*)params
{
    [self clearContentView];
    theGodAttriViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theGodAttriViewController.view];
    [theGodAttriViewController showGodAttriView:params];
}
/*
 以下的方法是接收消息处理的方法
 传递的参数  为 NSDictionary
 包括的键有 @“EquipSlot”, @"PetId"  根据需要选用
 */
-(void)showEquipChangeView:(NSDictionary*)params
{
    [theHallViewController presentViewController:theEquipChangeViewController animated:NO completion:^{}];
    [theEquipChangeViewController setEquipChangeViewData:params];
}
-(void)showEquipSelectView:(NSDictionary*)params
{
    [theHallViewController presentViewController:theEquipSelectViewController animated:NO completion:^{[theEquipSelectViewController scrollToTopRowAtIndexPath];}];
    [theEquipSelectViewController setDataForSelectViewControllers:params];
}

-(void)closeEquipInfoView
{
    [theEquipInfoViewController.view removeFromSuperview];
}
-(void)closeTheEquipChangeView
{
    [theEquipChangeViewController closeEquipChangeView];
}

-(void)EquipSelectToEquipMain:(NSArray *)data
{
    [theMainAttriViewController setOtherEquips:data];
}

-(void)updateEquipMainAttribute:(NSNumber*)equipId
{
    NSDictionary* tempDict = [[NSDictionary alloc]initWithObjectsAndKeys:equipId,@"EquipId", nil];
    [theMainAttriViewController showMainAttriView:tempDict];
}
-(void)updateEquipSubAttribute:(NSNumber*)equipId
{
    [theSubAttriViewController updateEquipInfo:equipId];
}
-(void)updateEquipGodAttribute:(NSNumber *)equipId
{
    NSDictionary* tempDict = [[NSDictionary alloc]initWithObjectsAndKeys:equipId,@"EquipId", nil];
    [theGodAttriViewController showGodAttriView:tempDict];
}
-(void)updateEquipChangeView:(NSDictionary*)data
{
    [theEquipChangeViewController changEquipment:data];
}
-(void)changeEquipListInSelectView:(NSNumber*)equipId option:(BOOL)isAdd
{
    NSDictionary* tempDict = [[NSDictionary alloc]initWithObjectsAndKeys:equipId,@"EquipId", nil];
    if (isAdd)
    {
        [theEquipSelectViewController addObjectToList:tempDict];
    }
    else
    {
        [theEquipSelectViewController substractObjectToList:tempDict];
    }
}

#pragma mark -- 技能有关的操作
-(void)showSkillView
{
    [self clearContentView];
    theSkillViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theSkillViewController.view];
    [theSkillViewController setAllViewControllers];
}
-(void)updateSkillView
{
    [theSkillViewController updateSkills];
}

#pragma mark -- 宠物有关的操作
-(void)showPetView
{
    [self clearContentView];
    thePetViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:thePetViewController.view];
    [thePetViewController updatePetViewAllControllers];
}
-(void)updatePetView
{
    [thePetViewController updatePetViewAllControllers];
}
-(void)updatePetActiveBtnController
{
    [thePetViewController updatePetActiveBtnControllers];
}

#pragma mark - 商店有关的操作
-(void)setStoreView:(NSDictionary*)data{
    [theStoreViewController setDataInfoInViewControllers:data];
}

-(void)showStoreView
{
    [self clearContentView];
    theStoreViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theStoreViewController.view];
}

#pragma mark - 新闻有关的操作
-(void)showNewsView
{
    [self clearContentView];
    theNewsViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:theNewsViewController.view];
}

#pragma mark - 背包有关的操作
-(void)showPackView
{
    [self clearContentView];
    thePackViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:thePackViewController.view];
}
-(void)showBlukSellView
{
    [theHallViewController presentViewController:theBlukSellViewController animated:NO completion:^{}];
}

-(void)showFilterView
{
    [theHallViewController presentViewController:theFilterViewController animated:NO completion:^{}];
    [theFilterViewController setAllLabelsData];
}

-(void)showPropInfoView:(NSDictionary*)params
{
    thePropViewController.view.frame = theHallViewController.contentView.bounds;
    [theHallViewController.contentView addSubview:thePropViewController.view];
    [thePropViewController setDataInfoForViewControllers:params];
}
-(void)closeThePropInfoView
{
    [thePropViewController closePropView];
}
-(void)updateBagView
{
    [thePackViewController updateBagInfo];
}
-(void)updateBlukView
{
    [theBlukSellViewController updateBlukViewData];
}

#pragma mark - 设置有关的操作
-(void)showSetView
{
//    [self clearContentView];
//    // test for Jim
//    theRelationViewController.view.frame = theHallViewController.contentView.frame;
//    [theHallViewController.contentView addSubview:theRelationViewController.view];
}
@end
