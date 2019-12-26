//
//  HpRenderVisitorStack.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HpAffineTransformStack : NSObject
{
    CGAffineTransform* _array;
    int _capacity;
    int _top;
}

-(id)initWithCapacity:(int)capacity;
-(void)resize:(int)capacity;

-(CGAffineTransform*)pop;
-(CGAffineTransform*)peek;
-(void)push:(CGAffineTransform*)transfrom;

@end

@interface HpColorStack : NSObject
{
    NSMutableArray* _array;
    int _capacity;
    int _top;
}

-(id)initWithCapacity:(int)capacity;
-(void)resize:(int)capacity;

-(UIColor*)pop;
-(UIColor*)peek;
-(void)push:(UIColor*)color;

@end
