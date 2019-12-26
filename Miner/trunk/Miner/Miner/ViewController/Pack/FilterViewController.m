//
//  FilterViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-26.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "FilterViewController.h"
#import "GameObject.h"
#import "Equipment.h"

@interface FilterViewController ()

@property (nonatomic, weak) NSArray* bagEquipsArray;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    allCount = 0;
    weaponCount = 0;
    headCount = 0;
    chestCount = 0;
    cloakCount = 0;
    handCount = 0;
    footCount = 0;
    pickaxeCount = 0;
    probeCount = 0;
    whiteCount = 0;
    greenCount = 0;
    blueCount = 0;
    purpleCount = 0;
    orangeCount = 0;
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
    self.bagEquipsArray = [[[GameObject sharedInstance] bag] bagEquips];
    allCount = [[self bagEquipsArray] count];
    for (Equipment* equip in self.bagEquipsArray)
    {
        [self parsePart:equip];
        [self parseStar:equip];
    }
    
    [self setAllLabelStrings];
}

-(void)parsePart:(Equipment*)equip
{
    NSInteger slot = [[equip getEquipDefSlot] integerValue];
    switch (slot)
    {
        case 1:
            weaponCount++;
            break;
        case 2:
            headCount++;
            break;
        case 3:
            chestCount++;
            break;
        case 4:
            cloakCount++;
            break;
        case 5:
            handCount++;
            break;
        case 6:
            footCount++;
            break;
        case 7:
            probeCount++;
            break;
        case 8:
            pickaxeCount++;
            break;
        default:
            break;
    }
}
-(void)parseStar:(Equipment*)equip
{
    NSInteger star = [[equip equipStar] integerValue];
    switch (star)
    {
        case 1:
            whiteCount++;
            break;
        case 2:
            greenCount++;
            break;
        case 3:
            blueCount++;
            break;
        case 4:
            purpleCount++;
            break;
        case 5:
            orangeCount++;
            break;
        default:
            break;
    }
}
-(void)setAllLabelStrings
{
    self.allEquipsLabel.text    = [NSString stringWithFormat:@"x%lu",allCount];
    
    self.weaponEquipsLabel.text = [NSString stringWithFormat:@"x%lu",weaponCount];
    self.headEquipLabel.text    = [NSString stringWithFormat:@"x%lu",headCount];
    self.chestEquipLabel.text   = [NSString stringWithFormat:@"x%lu",chestCount];
    self.cloakEquipLabel.text   = [NSString stringWithFormat:@"x%lu",cloakCount];
    self.handEquipLabel.text    = [NSString stringWithFormat:@"x%lu",handCount];
    self.footEquipLabel.text    = [NSString stringWithFormat:@"x%lu",footCount];
    self.pickaxeEquipLabel.text = [NSString stringWithFormat:@"x%lu",pickaxeCount];
    self.probeEquipLabel.text   = [NSString stringWithFormat:@"x%lu",probeCount];
    
    self.whiteEquipLabel.text   = [NSString stringWithFormat:@"x%lu",whiteCount];
    self.greenEquipLabel.text   = [NSString stringWithFormat:@"x%lu",greenCount];
    self.blueEquipLabel.text    = [NSString stringWithFormat:@"x%lu",blueCount];
    self.purpleEquipLabel.text  = [NSString stringWithFormat:@"x%lu",purpleCount];
    self.orangeEquipLabel.text  = [NSString stringWithFormat:@"x%lu",orangeCount];
}

#pragma mark - buttons events
- (IBAction)onCloseClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:^{}];
}

- (IBAction)onAllClicked:(id)sender
{
    
}
- (IBAction)onWeaponClicked:(id)sender {
}
- (IBAction)onHeadClicked:(id)sender {
}
- (IBAction)onChestClicked:(id)sender {
}
- (IBAction)onCloakClicked:(id)sender {
}
- (IBAction)onHandClicked:(id)sender {
}
- (IBAction)onFootClicked:(id)sender {
}
- (IBAction)onPickaxeClicked:(id)sender {
}
- (IBAction)onProbeClicked:(id)sender {
}
- (IBAction)onWhiteClicked:(id)sender {
}
- (IBAction)onGreenClicked:(id)sender {
}
- (IBAction)onBlueClicked:(id)sender {
}
- (IBAction)onPurpleClicked:(id)sender {
}
- (IBAction)onOrangeClicked:(id)sender {
}
@end
