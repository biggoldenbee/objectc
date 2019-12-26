//
//  BriefCircleLabel.h
//  toDoList
//
//  Created by biggoldenbee on 15/1/14.
//  Copyright (c) 2015年 biggoldenbee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BriefCircleLabel : UIView
@property (strong, nonatomic) IBOutlet UIImageView *drawimage;

@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSDictionary *textAttributes;
@property (nonatomic) NSTextAlignment textAlignment;

@property (nonatomic) float radius;
@property (nonatomic) float baseAngle;
@property (nonatomic) float characterSpacing;
@property (nonatomic) int direction;

@property (nonatomic) CGPoint circleCenterPoint;

-(void)drawText:(NSString*)inStr;

@end
