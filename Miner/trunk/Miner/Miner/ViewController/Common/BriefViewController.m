//
//  BriefViewController.m
//  Miner
//
//  Created by zhihua.qian on 15-1-5.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "BriefViewController.h"
//#import "GameObject.h"
#import "GameUtility.h"
#import "BattleData.h"
#import "BriefTitleTableViewCell.h"
#import "BriefPropsTableViewCell.h"
#import "BriefTextTableViewCell.h"
#import "BriefCircleLabel.h"


#import "Item.h"
#import "Equipment.h"

#define Show_Time   3

@interface BriefViewController ()
@property (strong, nonatomic) IBOutlet UIView *parentView;
@property (strong, nonatomic) BriefCircleLabel *theBriefCircleLabel;//弯曲文字 "MINING RESULT"
@property (nonatomic, strong) NSMutableArray* briefDataQueue;//战报队列，先进先出

@property (nonatomic, strong) NSMutableArray* theAllIconItems;
@property (nonatomic, assign) NSInteger theTableViewRows;

@property (nonatomic, strong) BriefTitleTableViewCell *theBriefTitleTableViewCell;
@property (nonatomic, strong) BriefPropsTableViewCell *theBriefPropsTableViewCell;
@property (nonatomic, strong) BriefTextTableViewCell *theBriefTextTableViewCell;

@property (nonatomic, assign) CGFloat theCurentHeight;

// 测试数据,正式发布将移除 +
@property (nonatomic, strong) NSMutableArray* theItems;
@property (nonatomic, strong) NSMutableArray* theEquips;
@property (nonatomic, strong) NSMutableArray* theBoxs;
@property (nonatomic, strong) NSMutableArray* theAutoSells;
@property (strong, nonatomic) NSTimer* showTimer;
// 测试数据,正式发布将移除 -

@end

@implementation BriefViewController


#define Collection_Section_Num      2

-(void)setTransParentImage; {
    // 根据parentView获取当前底图，模态对话框需要透明边框部分
    if (nil!=self.parentView) {
        UIGraphicsBeginImageContext(self.parentView.bounds.size);
        [self.parentView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:viewImage]] ;
    }
}

-(id)init; {
    if (self=[super init]) {
//        if (nil==self.theBriefCircleLabel) {
//            self.theBriefCircleLabel = [[BriefCircleLabel alloc] init];
//            self.theBriefCircleLabel.frame = CGRectMake(23,35,272,41);
//            [self.theBriefCircleLabel setBackgroundColor:[UIColor clearColor]];
//            [self.theBriefCircleLabel setAutoresizingMask:0x3F];
//            [self.view addSubview:self.theBriefCircleLabel];
//        }
        
        // 设置模态对话框透明属性
        // 此属性目前只支持到iOS8.0 为了保持兼容iOS 6.0 采用如下算法 请参考方法 setTransParentImage
        
        // 此处先屏蔽
        //        self.modalPresentationStyle = UIModalPresentationOverFullScreen ;
        //        self.parentView = nil;
        
        self.briefDataQueue = [[NSMutableArray alloc] init];
        // 初始化加载XIB
        
        // 载入简报 title 部分
        self.theBriefTitleTableViewCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BriefTitleTableViewCell class]) owner:self options:nil] objectAtIndex:0];
        
        // 载入简报 icon 部分
        self.theBriefPropsTableViewCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BriefPropsTableViewCell class]) owner:self options:nil] objectAtIndex:0]; ;
        
        // 载入简报 text 部分
        self.theBriefTextTableViewCell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BriefTextTableViewCell class]) owner:self options:nil] objectAtIndex:0]; ;
        
        // 初始化战斗简报内容为零
        self.seconds        = 0;
        self.battleCount    = 0;
        self.battleWins     = 0;
        self.battleLost     = 0;
        self.battleMine     = 0;
        self.exp            = 0;
        self.money          = 0;
        self.items          = nil;
        self.equips         = nil;
        self.boxs           = nil;
        self.autoSells      = nil;
        
        // 初始化测试数据 +
        [self prepareTestPackage];
        // 初始化测试数据 -
        self.theAllIconItems = [[NSMutableArray alloc] init];
        
        self.theCurentHeight = 0.0;
    }
    return self ;
}

-(void)composeAllIconItems {
    // 清除所有的itemIcon纪录
    [self.theAllIconItems removeAllObjects];
    // 遍历items
    for(NSInteger i=0; i<[self.items count]; i++) {
        Item *item = [self.items objectAtIndex:i];
        if (nil!=item) {
//            ItemDef* itemDef = [[ItemConfig share] getItemDefWithKey:[item itemIType]];
//            briefIconItem.itemIconName = [GameUtility imageNamed:[itemDef itemIcon]];
            BriefIconItem *briefIconItem = [[BriefIconItem alloc] init];
            briefIconItem.itemIconName = [item itemIcon];
            briefIconItem.itemPropbarName = @"base_propsbar_b.png"; //底图
            briefIconItem.itemCount = [item itemCount];
            [self.theAllIconItems addObject:briefIconItem];
        }
    }
    
    // 遍历equips
    for(NSInteger i=0; i<[self.equips count]; i++) {
        Equipment *equip = [self.equips objectAtIndex:i];
        if (nil!=equip) {
            BriefIconItem *briefIconItem = [[BriefIconItem alloc] init];
            briefIconItem.itemIconName = [equip getEquipIcon];
            briefIconItem.itemPropbarName = [GameUtility getImageNameForBagOrSelectViewWithStar:[[equip equipStar] intValue]]; //底图
            briefIconItem.itemCount = [NSNumber numberWithInt:1]; //装备数量为1
            [self.theAllIconItems addObject:briefIconItem];
        }
    }
    // 遍历boxs
    
    NSLog(@"self.theAllIconItems count=%lu\n", (unsigned long)[self.theAllIconItems count]);
}

-(void)prepareTestPackage; {
    self.theItems = [[NSMutableArray alloc] init] ;
    for(int i=1; i<=23; i++) {
        Item* aItem=[[Item alloc] init];
        aItem.itemIId = [NSNumber numberWithInt:(i-1)%5];
        aItem.itemName = [NSString stringWithFormat:@"key_itemname%03d", 100+i%5];
        aItem.itemIcon = [NSString stringWithFormat:@"icon_item%03d", 100+i%5];
        aItem.itemDesc = [NSString stringWithFormat:@"key_itemname%03d", 100+i%5];
        aItem.itemType = [NSNumber numberWithInt:3];
        aItem.itemCount= [NSNumber numberWithInt:i];
        
        [self.theItems addObject:aItem];
    }
    
    self.theEquips = [[NSMutableArray alloc] init] ;
    for(int i=1; i<=7; i++) {
        Equipment* aEquipment=[[Equipment alloc] init];

        aEquipment.equipEId = [NSNumber numberWithInt:i-1];
        aEquipment.equipSlot = [NSNumber numberWithInt:3];
        aEquipment.equipStar = [NSNumber numberWithInt:i%6];
        
        [self.theEquips addObject:aEquipment];
    }

    self.theBoxs = [[NSMutableArray alloc] init] ;
    for(int i=0; i<=2; i++) {
        [self.theBoxs addObject:[NSString stringWithFormat:@"BOX%d", i]];
    }
    
    self.theAutoSells = [[NSMutableArray alloc] init];
    [self.theAutoSells addObject:[NSNumber numberWithInt:1]]; // 白
    [self.theAutoSells addObject:[NSNumber numberWithInt:2]]; // 绿
    [self.theAutoSells addObject:[NSNumber numberWithInt:0]]; // 蓝
    [self.theAutoSells addObject:[NSNumber numberWithInt:4]]; // 紫
    [self.theAutoSells addObject:[NSNumber numberWithInt:5]]; // 橙
    
}

-(BOOL)isPresented; {
    return (nil==[self.view window])?FALSE:TRUE ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.contentView.dataSource = self;
    self.contentView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void)parseBriedData:(BattleBrief*)inBrief; {
    if (nil!=inBrief) {
        // 解析数据从inBrief包内
        self.seconds        = [[NSNumber numberWithInteger:[inBrief time]] unsignedIntValue];
        self.battleCount    = [[NSNumber numberWithInteger:[inBrief cnt]] unsignedIntValue];
        self.battleWins     = [[NSNumber numberWithInteger:[inBrief win]] unsignedIntValue];
        self.battleLost     = [[NSNumber numberWithInteger:[inBrief lost]] unsignedIntValue];
        self.battleMine     = [[NSNumber numberWithInteger:[inBrief mine]] unsignedIntValue];
        self.exp            = [[NSNumber numberWithInteger:[inBrief exp]] unsignedIntValue];
        self.money          = [[NSNumber numberWithInteger:[inBrief money]] unsignedIntValue];
        self.boxW           = (int)[[inBrief boxWon] count];        // 金勇说 先显示count
        self.boxF           = (int)[[inBrief boxFailed] count];     // 金勇说 先显示count
        self.items          = [inBrief items];
        self.equips         = [inBrief equips];
        self.boxs           = [inBrief boxs];
        self.autoSells      = [inBrief autoSells];
    } else {
        // 填充测试数据,测试用
        self.seconds        = 3601;
        self.battleCount    = 20;
        self.battleWins     = 16;
        self.battleLost     = 4;
        self.battleMine     = 3;
        self.exp            = 2060;
        self.money          = 14000;
        self.boxW           = 1;
        self.boxF           = 2;
        self.items          = self.theItems;
        self.equips         = self.theEquips;
        self.boxs           = self.theBoxs;
        self.autoSells      = self.theAutoSells;
    }
    
    // 遍历self.items self.equips self.boxs，组合成self.theAllIconItems，目前只需要iconName propbarName count
    [self composeAllIconItems];
    
    // 更新简报标题,此处可能还需要细调
    [self.theBriefCircleLabel drawText:@"MINING RESULT"];
    
    //此处需要触briefViewController刷新
    [self.contentView reloadData];
    //清除当面view高度
    self.theCurentHeight = 0.0;
}


-(void)setDataInfoInViewControllers:(NSDictionary*)data inParentView:(UIView*)inParentView;
{
    if (FALSE==[self isPresented]) {
        // 保存父窗口view
        self.parentView = inParentView;
        if (nil!=self.parentView) {
            [self setTransParentImage];
        }
        
        if ([data objectForKey:@"Brief"])
        {
            [self parseBriedData:[data objectForKey:@"Brief"]];
        }
        // 测试数据
        else
        {
            [self parseBriedData:nil];
        }
    } else {
        // 数据先缓存到briefDataQueue队列里
        if ([data objectForKey:@"Brief"]) {
            [self.briefDataQueue addObject:data] ;
        }
    }
    // 测试用，显示现在缓冲数量
    [self.getAllButton setTitle:([self.briefDataQueue count]>0)?
     [NSString stringWithFormat:@"Get All(%lu)",[self.briefDataQueue count]]:
     @"Get All"
                       forState:UIControlStateNormal];
}

-(void)resetViewControllerData
{
    self.seconds = 0;
    self.battleCount = 0;
    self.battleWins = 0;
    self.battleLost = 0;
    self.battleMine = 0;
    self.exp = 0;
    self.money = 0;
    self.equips  = nil;
    self.items = nil;
    self.boxs = nil;
    self.autoSells = nil;
}

-(void)handleTimer:(NSTimer*)timer
{
    [self.showTimer invalidate];
    self.showTimer = nil;
    [self onGetAllClicked:nil];
}

-(NSString*)setTimeWithInt
{
    int seconds = 0;
    int minutes = 0;
    int hours = 0;
    int days = 0;
    
    if ([self seconds] >= 60)
    {
        seconds = self.seconds % 60;
        minutes = self.seconds / 60;
        if (minutes >= 60)
        {
            hours = minutes / 60;
            minutes = minutes % 60;
            if (hours >= 24)
            {
                days = hours / 24;
                hours = hours % 24;
            }
        }
    }
    
    NSString* daysString = @"";
    if (days != 0)
    {
        daysString = [NSString stringWithFormat:@" %d days ", days];
    }
    NSString* hoursString = @"";
    if (hours != 0)
    {
        hoursString = [NSString stringWithFormat:@" %d hours ", hours];
    }
    NSString* minutesString = @"";
    if (minutes != 0)
    {
        minutesString = [NSString stringWithFormat:@" %d minutes ", minutes];
    }
    NSString* secondsString = @"";
    if (seconds != 0)
    {
        secondsString = [NSString stringWithFormat:@" %d seconds", seconds];
    }
    
    return [NSString stringWithFormat:@"In the last%@%@%@%@.\n", daysString, hoursString, minutesString,secondsString];
}
-(NSString*)setBattleResultWithInt
{
    NSString* countString = @"";
    if ([self battleCount] > 0)
    {
        countString = [NSString stringWithFormat:@"Battle Count : %d\n", self.battleCount];
    }
    NSString* winString = @"";
    if ([self battleWins] > 0)
    {
        winString = [NSString stringWithFormat:@"Win Count : %d\n", self.battleWins];
    }
    NSString* lostString = @"";
    if ([self battleLost] > 0)
    {
        lostString = [NSString stringWithFormat:@"Lost Count : %d\n", self.battleLost];
    }
    NSString* mineString = @"";
    if ([self battleMine] > 0)
    {
        mineString = [NSString stringWithFormat:@"Battle Count : %d\n", self.battleMine];
    }
    
    return [NSString stringWithFormat:@"%@%@%@%@", countString,winString,lostString,mineString];
}

-(NSString*)setRewardWithInt
{
    NSString* expString = @"";
    if ([self exp] > 0)
    {
        expString = [NSString stringWithFormat:@"Gain Experience : %d\n", self.exp];
    }
    
    NSString* moneyString = @"";
    if ([self money] > 0)
    {
        moneyString = [NSString stringWithFormat:@"Gain Money : %d\n", self.money];
    }

    NSString* boxString = @"";
    boxString = [NSString stringWithFormat:@"Successfully opened boxes : %d\nFailed to open boxes : %d\n",self.boxW,self.boxF];

    
    return [NSString stringWithFormat:@"%@%@%@",expString, moneyString,boxString];
}


#pragma mark - button events
- (IBAction)onGetAllClicked:(id)sender
{
    // 判断birefViewController是否在呈现中
    if (TRUE==[self isPresented]) {
        // 判读briefDataQueue是否有需要跟新的数据,若为空则需要退出briefViewController.
        if ([self.briefDataQueue count]<=0) {
            [self resetViewControllerData];
            [self dismissViewControllerAnimated:NO completion:^{}];
            if (nil!=self.parentView) {
                self.parentView = nil ;
            }
        } else {
            // briefDataQueue不为空,取索引0数据到data.
            id data = [self.briefDataQueue objectAtIndex:0] ;
            // 移除索引0数据
            [self.briefDataQueue removeObjectAtIndex:0] ;
            // 呈现给玩家新数据
            if ([data objectForKey:@"Brief"])
            {
                [self parseBriedData:[data objectForKey:@"Brief"]];
            }
        }
    }
    // 测试用，显示现在缓冲数量
    [self.getAllButton setTitle:([self.briefDataQueue count]>0)?
     [NSString stringWithFormat:@"Get All(%lu)",[self.briefDataQueue count]]:
     @"Get All"
                       forState:UIControlStateNormal];
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //此处先做简单计算处理
    NSUInteger row = [indexPath row];
    CGFloat height=90.0;
    if (0==row) {
        CGRect rect = [self.theBriefTitleTableViewCell frame] ;
        height = rect.size.height ;
    } else if ((self.theTableViewRows-1)==row) {    //输出最后行
        //此处需要计算输出文本高度，调整view大小
        CGRect rect = [self.theBriefTextTableViewCell frame] ;
        height = rect.size.height ;
    } else { //输出briefProps内容 第二行--第N行
        //此处需要动态调整props个数，调整view大小
        CGRect rect = [self.theBriefPropsTableViewCell frame] ;
        height = rect.size.height ;
    }
    
    self.theCurentHeight = self.theCurentHeight+height;
    
    return ceilf(height) ;
}


#pragma mark - table view

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    // 计算当前brif所有viewCell的高度
    CGRect rect;
    rect = [self.contentView frame];
    NSLog(@"%f %f\n", self.theCurentHeight, rect.size.height) ;
    
    // 判断是不是要设置滚动
    [self.contentView setScrollEnabled:(self.theCurentHeight<=rect.size.height)?FALSE:TRUE] ;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // briefTableView显示布局：
    /*  第一行 title
     第二行 itemIcon (如果有)
     第三行 itemIcon (如果有)
     第N行  itemIcon (如果有)
     最后行 Txt
     */
    
    // 先计算itemIcon的行数，一行显示4个icon
    NSInteger itemLines = 0 ;
    
    if ([self.theAllIconItems count]>0) {
        itemLines = ([self.theAllIconItems count]-1)/4+1;
    }
    self.theTableViewRows = (1+itemLines+1);
    return [self theTableViewRows];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    if (0==row) {   //输出briefTitle内容 第一行
        BriefTitleTableViewCell *cell = self.theBriefTitleTableViewCell;
        // 更新brieftitleTableViewCell
        {
            NSString* time = [self setTimeWithInt];
            
            NSString* layerString = [NSString stringWithFormat:@"You minging in rock layer."];
            NSString* moneyString = [NSString stringWithFormat:@"%d", self.money];
            NSString* experiencesString = [NSString stringWithFormat:@"%d", self.exp];
            
            NSArray* data = [[NSArray alloc] initWithObjects:time, layerString, moneyString, experiencesString, nil];
            
            [cell setDataWithObject:data];
        }

        return cell;
    } else if ((self.theTableViewRows-1)==row) {    //输出最后行
        BriefTextTableViewCell *cell = self.theBriefTextTableViewCell;
        // 更新briefTextTableViewCell
        {
            NSString* time = [self setTimeWithInt];
            NSString* battleResult = [self setBattleResultWithInt];
            NSString* rewards = [self setRewardWithInt];
            NSString* resultString = [NSString stringWithFormat:@"%@%@%@", time, battleResult, rewards];
            [cell setTextInfo:resultString autoSells:self.autoSells];
        }
        
        return cell;
    } else {
        BriefPropsTableViewCell *cell=[[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BriefPropsTableViewCell class]) owner:self options:nil] objectAtIndex:0];
        
        [cell setDataWithItems:self.theAllIconItems row:row-1];
        
        return cell ;
    }
    return nil;
    
}

@end
