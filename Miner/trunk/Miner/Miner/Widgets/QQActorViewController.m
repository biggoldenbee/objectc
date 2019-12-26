//
//  QQActorViewController.m
//  Miner
//
//  Created by zhihua.qian on 14-12-17.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "QQActorViewController.h"

@interface QQActorViewController ()

@end

@implementation QQActorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    self.progressValue = progress;
    if (animated)
    {
        [self setProgressAnimated];
    }
    else
    {
        [self setProgressNoAnimated];
    }
}

-(void)setProgressAnimated
{
    
}

-(void)setProgressNoAnimated
{
    CGRect backgroundRect = self.progressImage.frame;
    CGFloat backgroundWidth = backgroundRect.size.width;
    CGFloat trackWidth = backgroundWidth * self.progressValue;
    CGRect trackRect = self.trackImage.frame;
    trackRect.size.width = trackWidth;
    [self.trackImage setFrame:trackRect];
}

-(void)reset
{
    [self.trackImage setFrame:self.progressImage.frame];
}

-(void)shake
{
//    CAKeyframeAnimation
    
}
@end
