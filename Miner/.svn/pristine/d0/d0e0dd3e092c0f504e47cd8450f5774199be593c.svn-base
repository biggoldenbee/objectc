//
//  HpSpriteFrame.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpSpriteFrame.h"
#import "HpBaseMacros.h"

@implementation HpSpriteFrame
@synthesize offsetInPixels = offsetInPixels_, offset = offset_;
@synthesize originalSize = originalSize_, originalSizeInPixels = originalSizeInPixels_;
@synthesize textureFilename = textureFilename_;
@synthesize rotated = rotated_;


+(id) frameWithTextureFilename:(NSString*)filename rect:(CGRect)rect
{
    return autorelease([[self alloc] initWithTextureFilename:filename rect:rect]);
}


+(id) frameWithTextureFilename:(NSString*)filename rectInPixels:(CGRect)rect rotated:(BOOL)rotated offset:(CGPoint)offset originalSize:(CGSize)originalSize
{
    return autorelease([[self alloc] initWithTextureFilename:filename rectInPixels:rect rotated:rotated offset:offset originalSize:originalSize]);
}

-(id) initWithTextureFilename:(NSString*)filename rect:(CGRect)rect
{
    CGRect rectInPixels = rect; //CC_RECT_POINTS_TO_PIXELS( rect );
    return [self initWithTextureFilename:filename rectInPixels:rectInPixels rotated:NO offset:CGPointZero originalSize:rectInPixels.size];
}

-(id) initWithTextureFilename:(NSString *)filename rectInPixels:(CGRect)rect rotated:(BOOL)rotated offset:(CGPoint)offset originalSize:(CGSize)originalSize
{
    if( (self=[super init]) )
    {
        textureFilename_ = [filename copy];
        rectInPixels_ = rect;
        rect_ = rect; //CC_RECT_PIXELS_TO_POINTS( rect );
        offsetInPixels_ = offset;
        offset_ = offsetInPixels_; //CC_POINT_PIXELS_TO_POINTS( offsetInPixels_ );
        originalSizeInPixels_ = originalSize;
        originalSize_ = originalSizeInPixels_; //CC_SIZE_PIXELS_TO_POINTS( originalSizeInPixels_ );
        rotated_ = rotated;
    }
    return self;
}

- (NSString*) description
{
    return [NSString stringWithFormat:@"<%@ = %p | Texture=%@, Rect = (%.2f,%.2f,%.2f,%.2f)> rotated:%d offset=(%.2f,%.2f)", [self class], self,
            textureFilename_,
            rect_.origin.x,
            rect_.origin.y,
            rect_.size.width,
            rect_.size.height,
            rotated_,
            offsetInPixels_.x,
            offsetInPixels_.y
            ];
}

- (void) dealloc
{
    release(textureFilename_);
    super_dealloc();
}

-(id) copyWithZone: (NSZone*) zone
{
    HpSpriteFrame *copy = [[[self class] allocWithZone: zone] initWithTextureFilename:textureFilename_ rectInPixels:rectInPixels_ rotated:rotated_ offset:offsetInPixels_ originalSize:originalSizeInPixels_];
    return copy;
}

-(CGRect) rect
{
    return rect_;
}

-(CGRect) rectInPixels
{
    return rectInPixels_;
}

-(void) setRect:(CGRect)rect
{
    rect_ = rect;
    rectInPixels_ = rect_; //CC_RECT_POINTS_TO_PIXELS( rect_ );
}

-(void) setRectInPixels:(CGRect)rectInPixels
{
    rectInPixels_ = rectInPixels;
    rect_ = rectInPixels_; //C_RECT_PIXELS_TO_POINTS( rectInPixels_ );
}

-(void) setOffset:(CGPoint)offsets
{
    offset_ = offsets;
    offsetInPixels_ = offset_; //CC_POINT_POINTS_TO_PIXELS( offset_ );
}

-(void) setOffsetInPixels:(CGPoint)offsetInPixels
{
    offsetInPixels_ = offsetInPixels;
    offset_ = offsetInPixels_; //CC_POINT_PIXELS_TO_POINTS( offsetInPixels_ );
}

-(CGPoint)anchorPointWithCenter:(CGPoint)center
{
    CGPoint centerInPixels = center; //CC_POINT_POINTS_TO_PIXELS(center);
    int offx = 0.5*(originalSizeInPixels_.width - rectInPixels_.size.width)+offsetInPixels_.x;  //计算两个左顶点的偏移量
    int offy = 0.5*(originalSizeInPixels_.height - rectInPixels_.size.height)-offsetInPixels_.y;
    return CGPointMake((centerInPixels.x-offx)/rectInPixels_.size.width, (originalSizeInPixels_.height-offy-centerInPixels.y)/rectInPixels_.size.height);
}

-(CGRect)rectInPercentWithSize:(CGSize)size
{
    CGRect imagerect = !self.rotated

    ? CGRectMake(self.rect.origin.x/size.width,
                 self.rect.origin.y/size.height,
                 self.rect.size.width/size.width,
                 self.rect.size.height/size.height)

    : CGRectMake(self.rect.origin.x/size.width,
                 self.rect.origin.y/size.height,
                 self.rect.size.height/size.width,
                 self.rect.size.width/size.height);

    return imagerect;
}

@end
