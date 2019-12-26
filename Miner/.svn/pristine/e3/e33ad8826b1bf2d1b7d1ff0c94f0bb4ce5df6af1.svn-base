//
//  UIToolTipImageView.m
//  Miner
//
//  Created by jim kaden on 15/1/15.
//  Copyright (c) 2015年 jim kaden. All rights reserved.
//

#import "UIToolTipImageView.h"
#import "GameUtility.h"
#import "AttriConfig.h"
#import "AttributeString.h"
#import "StringConfig.h"
@interface UIToolTipImageView()

@property (strong) UIButton* actionButton;
@property (strong) UIView* viewTT;
@property (strong) UILabel* labelTT;
@property (strong) UIImageView* imageViewTTBK;
@property (strong) UIImageView* imageView;

@end

@implementation UIToolTipImageView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initUI];
    return self;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self initUI];
    return self;
}

-(void)initUI
{
    CGRect frame = self.frame;
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:frame];
    self.imageView = imageView;
    imageView.userInteractionEnabled = NO;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:imageView];
    
    UIButton* button = [[UIButton alloc]initWithFrame:frame];
    self.actionButton = button;
    [self addSubview:button];
    
    [button addTarget:self action:@selector(onEndShowTT:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(onEndShowTT:) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:@selector(onEndShowTT:) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:self action:@selector(onBeginShowTT:) forControlEvents:UIControlEventTouchDown];
    
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
}

-(void)setImage:(UIImage *)image
{
    CGRect rect = self.frame;
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0,0,rect.size.width, rect.size.height);
    self.actionButton.frame = self.imageView.frame;
}

-(void)layoutSubviews
{
    CGRect rect = self.frame;
    self.imageView.frame = CGRectMake(0,0,rect.size.width, rect.size.height);
    self.actionButton.frame = self.imageView.frame;

}

-(void)onBeginShowTT:(id)sender
{
    if ( self.string == nil && self.attributedString == nil )
        return;
    
    CGRect rect = self.frame;
    CGRect rectForTT = rect;
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    CGRect rectForWindow = [window bounds];
    
    int margin = 3;
    
    self.viewTT = [[UIView alloc]init];
    [window addSubview:self.viewTT];
    
    self.labelTT = [[UILabel alloc]init];
    [self.viewTT addSubview:self.labelTT];
    self.viewTT.backgroundColor = [UIColor lightGrayColor];
//    self.imageViewTTBK = [[UIImageView alloc]init];
//    self.imageViewTTBK.image = [GameUtility imageNamed:@"base_smartmask2"];
//    [self.viewTT addSubview:self.imageViewTTBK];
    
    CGRect rectText;
    CGSize sizeText = CGSizeMake(120, 20000);
    if ( self.attributedString != nil )
    {
        self.labelTT.attributedText = self.attributedString;
        rectText = [self.attributedString boundingRectWithSize:sizeText options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    }
    else
    {
        self.labelTT.font = [GameUtility getNormalFont:12];
        self.labelTT.numberOfLines = 0;
        self.labelTT.text = self.string;
        rectText = [self.string boundingRectWithSize:sizeText options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil];
    }

    rectForTT.size.width = margin * 2 + rectText.size.width;
    rectForTT.size.height = margin * 2 + rectText.size.height;
    
    if ( rect.origin.x > rectForWindow.size.width/2 )
    {
        rectForTT.origin.x = rect.origin.x - rectText.size.width;
    }
    else
    {
        rectForTT.origin.x = rect.origin.x;
    }
    
    rectForTT.origin.y = rect.origin.y - rectForTT.size.height;
    rectForTT = [window convertRect:rectForTT fromView:self.superview];
    self.viewTT.frame = rectForTT;
    self.labelTT.frame = CGRectMake(margin, margin, rectText.size.width, rectText.size.height);
    self.imageViewTTBK.frame = CGRectMake(0, 0, rectForTT.size.width, rectForTT.size.height);
}

-(void)onEndShowTT:(id)sender
{
    if ( self.viewTT != nil)
        [self.viewTT removeFromSuperview];
    self.viewTT = nil;
}

@end

@implementation UIAttributeIcon

-(void)setAttriID:(int)aid
{
    AttriDef* ad = [[AttriConfig share] getAttriDefById:[NSNumber numberWithInt:aid]];
    self.image = [GameUtility imageNamed:ad.attriIcon];
    self.string = [NSString stringWithFormat:@"%@\n%@", [[StringConfig share] getLocalLanguage:ad.attriName], [[StringConfig share] getLocalLanguage:ad.attriDesc]];
}

@end