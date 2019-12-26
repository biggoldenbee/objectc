//
//  QQActorViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-12-17.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQActorViewController : UIViewController

@property (nonatomic, assign) float progressValue;

@property (strong, nonatomic) IBOutlet UIImageView *actorIcon;
@property (strong, nonatomic) IBOutlet UIImageView *progressImage;
@property (strong, nonatomic) IBOutlet UIImageView *trackImage;

- (void)setProgress:(float)progress animated:(BOOL)animated;
-(void)reset;
-(void)shake;
@end
