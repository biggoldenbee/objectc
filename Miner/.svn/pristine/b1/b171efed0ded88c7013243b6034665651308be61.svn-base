
//  BriefCircleLabel.m
//  toDoList
//
//  Created by biggoldenbee on 15/1/14.
//  Copyright (c) 2015年 biggoldenbee. All rights reserved.
//

#import "BriefCircleLabel.h"

#define VISUAL_DEBUGGING NO

@interface BriefCircleLabel ()
@end


@implementation BriefCircleLabel

-(void)drawRect:(CGRect)rect
{
    NSString *textBak = self.text;
//    UIGraphicsBeginImageContext(rect.size);
    
    //Get the string size.
    CGSize stringSize = [self.text sizeWithAttributes:self.textAttributes];
    
    //If the radius not set, calculate the maximum radius.
    float radius = (self.radius <=0) ? (self.bounds.size.width <= self.bounds.size.height) ? self.bounds.size.width / 2 - stringSize.height: self.bounds.size.height / 2 - stringSize.height : self.radius;
    
    //Calculate the angle per charater.
    self.characterSpacing = (self.characterSpacing > 0) ? self.characterSpacing : 1;
    float circumference = 2 * radius * M_PI;
    float anglePerPixel = M_PI * 2 / circumference * self.characterSpacing;
    
    //Set initial angle.
    float startAngle;
    if (self.textAlignment == NSTextAlignmentRight) {
        startAngle = self.baseAngle - (stringSize.width * anglePerPixel);
    } else if(self.textAlignment == NSTextAlignmentLeft) {
        startAngle = self.baseAngle;
    } else {
        startAngle = self.baseAngle - (stringSize.width * anglePerPixel/2);
    }
    
    //Set drawing context.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //Set helper vars.
    float characterPosition = 0;
    NSString *lastCharacter;
    
    
    //Loop thru characters of string.
    if (-1==self.direction) {
        NSMutableString *outputString = [[NSMutableString alloc] init];
        [self.text enumerateSubstringsInRange:NSMakeRange(0, self.text.length) options:NSStringEnumerationReverse | NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [outputString appendString:substring];
        }];
        self.text = outputString;
    }
    
    
    for (NSInteger charIdx=0; charIdx<self.text.length; charIdx++) {
        
        //Set current character.
        //        NSString *currentCharacter = [NSString stringWithFormat:@"%c", [self.text characterAtIndex:charIdx]];
        NSString * currentCharacter = [self.text substringWithRange:NSMakeRange(charIdx, 1)];
        
        //Set currenct character size & kerning.
        CGSize stringSize = [currentCharacter sizeWithAttributes:self.textAttributes];
        float kerning = (lastCharacter) ? [self kerningForCharacter:currentCharacter afterCharacter:lastCharacter] : 0;
        
        //Add half of character width to characterPosition, substract kerning.
        characterPosition += (stringSize.width / 2) - kerning;
        
        //Calculate character Angle
        float angle = characterPosition * anglePerPixel + startAngle;
        
        //Calculate character drawing point.
        CGPoint characterPoint = CGPointMake(radius * cos(angle) + self.circleCenterPoint.x, radius * sin(angle) + self.circleCenterPoint.y);
        
        NSLog(@"%f %f\n", characterPoint.x, characterPoint.y) ;
        
        //Strings are always drawn from top left. Calculate the right pos to draw it on bottom center.
        CGPoint stringPoint = CGPointMake(characterPoint.x -stringSize.width/2 , characterPoint.y - stringSize.height);
        
        //Save the current context and do the character rotation magic.
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, characterPoint.x, characterPoint.y);
        CGAffineTransform textTransform = CGAffineTransformMakeRotation(angle + self.direction*M_PI_2);
        CGContextConcatCTM(context, textTransform);
        CGContextTranslateCTM(context, -characterPoint.x, -characterPoint.y);
        
        //Draw the character
        [currentCharacter drawAtPoint:stringPoint withAttributes:self.textAttributes];
        
        //If we need some visual debugging, draw the visuals.
        if (VISUAL_DEBUGGING) {
            //Show Character BoundingBox
            [[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5] setStroke];
            [[UIBezierPath bezierPathWithRect:CGRectMake(stringPoint.x, stringPoint.y, stringSize.width, stringSize.height)] stroke];
            
            //Show character point
            [[UIColor blueColor] setStroke];
            [[UIBezierPath bezierPathWithArcCenter:characterPoint radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES] stroke];
        }
        
        //Restore context to make sure the rotation is only applied to this character.
        CGContextRestoreGState(context);
        
        //Add the other half of the character size to the character position.
        characterPosition += stringSize.width / 2;
        
        //Stop if we've reached one full circle.
        if (characterPosition * anglePerPixel >= M_PI*2) break;
        
        //store the currentCharacter to use in the next run for kerning calculation.
        lastCharacter = currentCharacter;
    }
    
    //If we need some visual debugging, draw the circle.
    if (VISUAL_DEBUGGING) {
        //Show Circle
        [[UIColor greenColor] setStroke];
        [[UIBezierPath bezierPathWithArcCenter:self.circleCenterPoint radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES] stroke];
        
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:CGPointMake(self.circleCenterPoint.x, self.circleCenterPoint.y - radius)];
        [line addLineToPoint:CGPointMake(self.circleCenterPoint.x, self.circleCenterPoint.y + radius)];
        [line moveToPoint:CGPointMake(self.circleCenterPoint.x-radius, self.circleCenterPoint.y)];
        [line addLineToPoint:CGPointMake(self.circleCenterPoint.x+radius, self.circleCenterPoint.y)];
        [line stroke];
    }

//    UIGraphicsEndImageContext();
    self.text = textBak;
}


- (float) kerningForCharacter:(NSString *)currentCharacter afterCharacter:(NSString *)previousCharacter
{
    float totalSize = [[NSString stringWithFormat:@"%@%@", previousCharacter, currentCharacter] sizeWithAttributes:self.textAttributes].width;
    float currentCharacterSize = [currentCharacter sizeWithAttributes:self.textAttributes].width;
    float previousCharacterSize = [previousCharacter sizeWithAttributes:self.textAttributes].width;
    
    return (currentCharacterSize + previousCharacterSize) - totalSize;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



-(void)drawText:(NSString*)inStr; {
    // 根据rect计算半径原点，基本算法源于公式 R2=A2+B2
    // deltaH   文字输出band高度
    // a        弦长的1/2
    // h        弦到弧顶高度 frame.size.height-deltaH
    // r2 = a2+(r-h)2

    CGFloat deltaH = 30;
    CGFloat scaleRateW = [UIScreen mainScreen].bounds.size.width/320;
    CGFloat scaleRateH = [UIScreen mainScreen].bounds.size.height/480;
    CGFloat a = scaleRateW*(self.frame.size.width/2);
    CGFloat h = scaleRateW*(self.frame.size.height-deltaH);
    CGFloat r = (a*a+h*h)/(2*h);
    
    
    NSLog(@"%f %f\n",scaleRateW,scaleRateH);
    
    self.text = inStr;
    
    self.circleCenterPoint = CGPointMake(a, self.frame.size.height*scaleRateW-r-7/scaleRateH) ;
    self.direction = -1;
    self.radius = r;
    
    self.textAttributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:(21*scaleRateW)],
                            NSStrokeColorAttributeName:[UIColor whiteColor],
                            NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    self.textAlignment = NSTextAlignmentCenter;
    self.baseAngle = 90 * M_PI / 180;
    self.characterSpacing = 1.0;
    
    [self.drawimage setAutoresizingMask:0x3F];
    
    
    UIGraphicsBeginImageContext(self.drawimage.frame.size);
    [self drawRect:self.drawimage.frame];
    self.drawimage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

}

@end
