//
//  RelationViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-11.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "RelationViewController.h"
#import "GameObject.h"

#import "CommonDef.h"
//#import "GameNotification.h"
#import "PackageManager.h"

@interface RelationViewController ()

@property (strong, nonatomic) IBOutlet UITextField *preName;
@property (strong, nonatomic) IBOutlet UITextField *preServer;
@property (strong, nonatomic) IBOutlet UILabel *preHomeName;
@property (strong, nonatomic) IBOutlet UILabel *preHomeServer;
@property (strong, nonatomic) IBOutlet UITableView *nextHomeTableView;
@end

@implementation RelationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.nextHomeArray = [[GameObject sharedInstance] nextHomes];
//    [self.nextHomeTableView reloadData];
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

#pragma mark - Table View DataSource && Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.nextHomeArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [self.nextHomeArray objectAtIndex:[indexPath row]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Friend* delChild = [self.nextHomeArray objectAtIndex:indexPath.row];
        
        NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
        [tempDict setObject:delChild.friendId forKey:@"CID"];
        
        [[PackageManager sharedInstance] delNextHomeRequest];
//        [[[GameNotification sharedInstance]netNotificationCenter]postNotificationName:kNotif_Request_Del_NextHome object:nil];
        
        [self.nextHomeArray removeObjectAtIndex:indexPath.row];
        [[GameObject sharedInstance] removeNextHomeByIndex:indexPath.row];
        // Delete the row from the data source.
        [self.nextHomeTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

#pragma mark - Button Action On View
- (IBAction)onSetPreHomeClicked:(id)sender
{
    NSString* name = self.preName.text;
    name = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString* poertId = self.preServer.text;
    poertId = [poertId stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([name length] == 0 || [poertId length] == 0 )
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Error"
                                                       message:@"请正确输入用户名称"
                                                      delegate:nil
                                             cancelButtonTitle:@"Close"
                                             otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSMutableDictionary* tempDict = [[NSMutableDictionary alloc]init];
    [tempDict setObject:name forKey:@"Name"];
    [tempDict setObject:poertId forKey:@"HSID"];
//    [tempDict setObject:@"" forKey:@"Code"];
    
    [[PackageManager sharedInstance] addPreHomeRequest:tempDict];
//    [[[GameNotification sharedInstance] netNotificationCenter] postNotificationName:kNotif_Request_Add_PreHome object:tempDict];
    
    self.preHomeName.text = name;
    self.preHomeServer.text = poertId;
    
    self.preName.text = @"";
    self.preServer.text = @"";
}
@end
