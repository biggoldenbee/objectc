//
//  HpImageView.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/31.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpImageView.h"
#import "HpSpriteFrame.h"
#import "HpBaseMacros.h"

@implementation HpImageView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (_spriteFrame == nil) {
        return;
    }

    [super drawRect:CGRectMake(0, 0, 180, 180)];


    // Drawing code
//    CGContextRef context=UIGraphicsGetCurrentContext();
    //设置倒立
//    CGContextRotateCTM(context,M_PI);
    //重新设置坐标  self.bounds获取整个屏幕的区域。
//    CGContextTranslateCTM(context, -self.bounds.size.width,-self.bounds.size.height);
    //CGContextScaleCTM(context, 1.0, -1.0);
//    CGRect imageRect=_spriteFrame.rect;
    //画底图
//    CGContextDrawImage(context, imageRect, [_image CGImage]);
    //填充颜色
//    CGContextSetRGBFillColor(context,0.0,0.0,0.0,1.0);
//    CGContextFillRect(context,self.bounds);
//    CGRect ret=CGRectMake(0.0, 0.0, 180, 180);
    //裁剪
//    CGContextClipToRect(context, ret);
//
//    //获取裁剪区域
//    CGRect boudsc=CGContextGetClipBoundingBox(context);
//
//    //画出裁剪区域
//    CGContextDrawImage(context, self.bounds, [_image CGImage]);

//    [_image drawInRect:_spriteFrame.rect];
}

- (void)setSpriteFrame:(HpSpriteFrame *)spriteFrame
{
    if (_spriteFrame != spriteFrame) {
        release(_spriteFrame);
        _spriteFrame = retain(spriteFrame);
        CGImageRef cgImage = CGImageCreateWithImageInRect([[UIImage imageNamed:_spriteFrame.textureFilename] CGImage], spriteFrame.rect);
        self.image = [UIImage imageWithCGImage:cgImage];
        UIImageView* iv = [[UIImageView alloc] initWithImage:self.image];
        [self addSubview:iv];
        iv.frame = CGRectMake(0, 180, iv.frame.size.width, iv.frame.size.height);
        [self setNeedsDisplay];
        
        CFRelease(cgImage);
    }
}


@end
