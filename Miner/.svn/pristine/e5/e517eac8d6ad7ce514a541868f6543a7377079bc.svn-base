//
//  LoginAccountViewController.m
//  testMiner
//
//  Created by zhihua.qian on 14-11-21.
//  Copyright (c) 2014年 tonyguan. All rights reserved.
//

#import "LoginAccountViewController.h"
#import "NetManager.h"

@interface LoginAccountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textAccount;
@property (weak, nonatomic) IBOutlet UITextField *textPassword;
@end

@implementation LoginAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(IBAction)onLoginClicked:(id)sender
{
    [[NetManager sharedInstance] login:self.isFake
                                  name:self.textAccount.text
                              password:self.textPassword.text
                            completion:^(NSDictionary *result)
                            {
                                [self dismissViewControllerAnimated:YES
                                                         completion:^{
                                                             dispatch_after
                                                             (
                                                                dispatch_time(DISPATCH_TIME_NOW,(int64_t)(0.1 * NSEC_PER_SEC)),
                                                                dispatch_get_main_queue(),
                                                                ^{[self.delegate handleResult:result isFake:self.isFake];}
                                                              );}];
                            }];
}

-(IBAction)onCancelClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
@end
