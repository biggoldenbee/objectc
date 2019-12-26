//
//  QQProgressView.m
//  Miner
//
//  Created by zhihua.qian on 14-12-17.
//  Copyright (c) 2014年 jim kaden. All rights reserved.
//

#import "QQProgressView.h"

@interface QQProgressView ()
@end

@implementation QQProgressView
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [[NSBundle mainBundle] loadNibNamed:@"QQProgressView" owner:self options:nil];
        [self addSubview:self.view];
    }
    return self;
}

- (void)setProgress0:(float)progress animated:(BOOL)animated
{
    self.progressValue0 = progress;
    if (animated)
    {
        [self setProgress0Animated];
    }
    else
    {
        [self setProgress0NoAnimated];
    }
}

-(void)setProgress0Animated
{
    
}

-(void)setProgress0NoAnimated
{
    CGRect backgroundRect = self.backgroundImage.frame;
    CGFloat backgroundWidth = backgroundRect.size.width;
    CGFloat backgroundHeight = backgroundRect.size.height;
    
    CGFloat trackWidth = backgroundWidth * self.progressValue0;
    CGRect trackRect = self.trackImage0.frame;
    trackRect.size.width = trackWidth;
    trackRect.size.height = backgroundHeight;
    [self.trackImage0 setFrame:trackRect];
}

- (void)setProgress1:(float)progress animated:(BOOL)animated
{
    self.progressValue1 = progress;
    if (animated)
    {
        [self setProgress1Animated];
    }
    else
    {
        [self setProgress1NoAnimated];
    }
}

-(void)setProgress1Animated
{
    
}

-(void)setProgress1NoAnimated
{
    CGRect backgroundRect = self.backgroundImage.frame;
    CGFloat backgroundWidth = backgroundRect.size.width;
    CGFloat backgroundHeight = backgroundRect.size.height;
    
    CGFloat trackWidth = backgroundWidth * self.progressValue1;
    CGFloat trackHeight = backgroundHeight;
    
    CGRect trackRect = self.trackImage1.frame;
    trackRect.size.width = trackWidth;
    trackRect.size.height = trackHeight;
    [self.trackImage1 setFrame:trackRect];
}

-(void)setInitState
{
    [self setProgress0:0 animated:NO];
    [self setProgress1:0 animated:NO];
}
@end
