//
//  QQProgressViewController.h
//  Miner
//
//  Created by zhihua.qian on 14-12-17.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QQProgressView : UIView

@property (nonatomic, assign) float progressValue0;
@property (nonatomic, assign) float progressValue1;

@property (weak, nonatomic) IBOutlet UIView* view;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *trackImage0;
@property (weak, nonatomic) IBOutlet UIImageView *trackImage1;

- (void)setProgress0:(float)progress animated:(BOOL)animated;
- (void)setProgress1:(float)progress animated:(BOOL)animated;

-(void)setInitState;
@end
