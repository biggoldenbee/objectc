//
//  BlukSellViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-26.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "BlukSellViewController.h"
#import "GameObject.h"
#import "Equipment.h"
#import "PackageManager.h"

@interface BlukSellViewController ()

@end

@implementation BlukSellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    self.bag = [[GameObject sharedInstance] bag];
    
    self.whiteEquips = [[NSMutableArray alloc]init];
    self.greenEquips = [[NSMutableArray alloc]init];
    self.blueEquips = [[NSMutableArray alloc]init];
    self.purpleEquips = [[NSMutableArray alloc]init];
    self.orangeEquips = [[NSMutableArray alloc]init];
    
    [self setAllLabelsData];
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

-(void)setAllLabelsData
{
    [self clearAllEquipArray];
    
    self.bag = [[GameObject sharedInstance] bag];
    NSArray* equips = self.bag.bagEquips;
    
    for (Equipment* equip in equips)
    {
        switch ([[equip equipStar] intValue])
        {
            case 1:
                [self.whiteEquips addObject:equip];
                break;
            case 2:
                [self.greenEquips addObject:equip];
                break;
            case 3:
                [self.blueEquips addObject:equip];
                break;
            case 4:
                [self.purpleEquips addObject:equip];
                break;
            case 5:
                [self.orangeEquips addObject:equip];
                break;
                
            default:
                break;
        }
    }
    
    self.whiteEquipLabel.text   = [NSString stringWithFormat:@"%lu", self.whiteEquips.count];
    self.greenEquipLabel.text   = [NSString stringWithFormat:@"%lu", self.greenEquips.count];
    self.blueEquipLabel.text    = [NSString stringWithFormat:@"%lu", self.blueEquips.count];
    self.purpleEquipLabel.text  = [NSString stringWithFormat:@"%lu", self.purpleEquips.count];
    self.orangeEqupLabel.text   = [NSString stringWithFormat:@"%lu", self.orangeEquips.count];
}

-(void)clearAllEquipArray
{
    [self.whiteEquips removeAllObjects];
    [self.greenEquips removeAllObjects];
    [self.blueEquips removeAllObjects];
    [self.purpleEquips removeAllObjects];
    [self.orangeEquips removeAllObjects];
}

- (IBAction)onSellWhiteEqupClicked:(id)sender
{
    for (Equipment* equip in self.whiteEquips)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:[equip equipEId] forKey:@"ID"];
        [tempDict setObject:[equip equipTId] forKey:@"TID"];
        [tempDict setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"Num"];
        
        [[PackageManager sharedInstance] sellItemOrEquipFromBagRequest:tempDict];
    }
    [self setAllLabelsData];
}
- (IBAction)onSellGreenEqupClicked:(id)sender
{
    for (Equipment* equip in self.greenEquips)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:[equip equipEId] forKey:@"ID"];
        [tempDict setObject:[equip equipTId] forKey:@"TID"];
        [tempDict setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"Num"];
        
        [[PackageManager sharedInstance] sellItemOrEquipFromBagRequest:tempDict];
    }
    [self setAllLabelsData];
}
- (IBAction)onSellBlueEqupClicked:(id)sender
{
    for (Equipment* equip in self.blueEquips)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:[equip equipEId] forKey:@"ID"];
        [tempDict setObject:[equip equipTId] forKey:@"TID"];
        [tempDict setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"Num"];
        
        [[PackageManager sharedInstance] sellItemOrEquipFromBagRequest:tempDict];
    }
}
- (IBAction)onSellPurpleEqupClicked:(id)sender
{
    for (Equipment* equip in self.purpleEquips)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:[equip equipEId] forKey:@"ID"];
        [tempDict setObject:[equip equipTId] forKey:@"TID"];
        [tempDict setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"Num"];
        
        [[PackageManager sharedInstance] sellItemOrEquipFromBagRequest:tempDict];
    }
}
- (IBAction)onSellOrangeEqupClicked:(id)sender
{
    for (Equipment* equip in self.orangeEquips)
    {
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:[equip equipEId] forKey:@"ID"];
        [tempDict setObject:[equip equipTId] forKey:@"TID"];
        [tempDict setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"Num"];
        
        [[PackageManager sharedInstance] sellItemOrEquipFromBagRequest:tempDict];
    }
}
- (IBAction)onCloseClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{}];
}

-(void)updateBlukViewData
{
    [self setAllLabelsData];
}
@end
