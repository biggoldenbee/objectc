//
//  HpAnimRenderVisitor.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/25.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpAnimRenderVisitor.h"
#import "HpCharaInst.h"
#import "HpStack.h"
#import "HpBaseMacros.h"
#import "HpAnimaStatus.h"
#import "HpAnimation.h"
#import "HpLayer.h"
#import "HpKeyframe.h"
#import "HpSpriteFrame.h"
#import "HpExtensionMacros.h"
#import "HpAnimaKeyframe.h"
#import "HpImageKeyframe.h"
#import "HpCharactorCache.h"

@implementation HpAnimRenderVisitor
{
    HpCharaInst* _currInst;
    HpStack* _viewCreateCache;
    HpStack* _viewRenderStack;
    HpStack* _statusRenderStack;
    CGAffineTransform _layerTransform;
    CGFloat _globalScale;
}

- (id)init
{
    if (self = [super init]) {
        _viewCreateCache = [[HpStack alloc] init];
        _viewRenderStack = [[HpStack alloc] init];
        _statusRenderStack = [[HpStack alloc] init];
        _globalScale = 0.5;
    }
    return self;
}

- (void)dealloc
{
    release(_viewCreateCache);
    release(_viewRenderStack);
    release(_statusRenderStack);
    super_dealloc();
}

- (void)begin:(id)target
{
    NSAssert([target isKindOfClass:[HpCharaInst class]], @"Invalid target-HpAnimRenderVisitor:Begin");

    [CATransaction begin];
    [CATransaction setDisableActions:YES];

    _currInst = target;
    CALayer* rootlayer = [_currInst.view.subviews[0] layer];
    [self retrieveRecursively:rootlayer isRoot:YES];

    //坐标系转变，转为左下角为（0，0）
    CGAffineTransform pin = CGAffineTransformMake(_globalScale * _currInst.scale ,
                                                  0, 0,
                                                  _globalScale * _currInst.scale * (-1),
                                                  _currInst.position.x,
                                                  _currInst.position.y);
    [rootlayer setAffineTransform:pin];

    [_viewRenderStack push:rootlayer];
    [_statusRenderStack push:_currInst.status];

}

-(void)end
{
    [_viewRenderStack pop];
    [_statusRenderStack pop];
    _currInst = nil;

    [CATransaction commit];
}

-(void)visitAnima:(HpAnimation*)ani firstly:(BOOL)first at:(float)time autoloop:(BOOL)autoloop
{
    if (autoloop) {
        HpAnimaStatus* status = [_statusRenderStack peek];

        if (first)
        {
            status.elapsed = time / _currInst.FPS;
        }

        double currtime = status.elapsed * _currInst.FPS;

        for(status.layerIndex = 0; status.layerIndex < ani.layers.count; status.layerIndex++){
            [self visitLayer:ani.layers[status.layerIndex] firstly:first at:currtime];
        }

        double duration = status.elapsed + _currInst.deltaTime;

        if (currtime >= ani.length) {
            duration = 0;
        }

        status.elapsed = duration;

    }else{
        [self visitAnima:ani firstly:first at:time];
    }
}

-(void)visitAnima:(HpAnimation*)ani firstly:(BOOL)first at:(float)time
{
    HpAnimaStatus* status = _statusRenderStack.peek;
    for(status.layerIndex = 0; status.layerIndex < ani.layers.count; status.layerIndex++){
        [self visitLayer:ani.layers[status.layerIndex] firstly:first at:time];
    }
}

-(void)visitLayer:(HpLayer*)layer firstly:(BOOL)first at:(float)time
{
    HpAnimaStatus* status = _statusRenderStack.peek;
    HpKeyframe* gfrm =  [layer getKeyframeAt:time];
    HpContentKeyframe* cfrm = [layer getContentKeyframeAt:time];
    if(cfrm){
        cfrm.firstVisitFlag = (first || cfrm != status.getLastCKey);
        if(gfrm){
            if(_currInst.firstAnimationFrame){
                if(gfrm.event && gfrm.time == time){
                    [_currInst onCustomEvent:gfrm.event];
                }
            } else if (first){
                [self fireEventsPassed:layer from:nil til:gfrm];

            } else {
                [self fireEventsPassed:layer from:[status getLastGKey] til:gfrm];
            }
        }
    }

    [status setLastGKey:gfrm lastCKey:cfrm];;
    if(gfrm && cfrm){
        [cfrm visitBy:self with:gfrm at:time];
        if (gfrm.contentType != HpContentType_Null) {
            CGAffineTransform t = _layerTransform;
            t.tx = _globalScale * t.tx + _currInst.position.x;
            t.ty = -_globalScale * t.ty + _currInst.position.y;
            layer.transform = t;
        }
    }
}

-(void)visitNullKey:(HpNullKeyFrame*)nkf with:(HpKeyframe*)frm at:(float)time
{

}

-(void)visitImageKey:(HpImageKeyframe*)ikf with:(HpKeyframe*)frm at:(float)time
{
    [[_statusRenderStack peek] clearSubAS];

    CALayer* imageView = [self createLayer];
    HpSpriteFrame* sprite = ikf.spriteframe;

    UIImage* image = [_currInst.cache imageBySpriteFrame:sprite];
    CGRect imagerect = [sprite rectInPercentWithSize:image.size];

    imageView.frame = CGRectMake(0, 0, sprite.rect.size.width, sprite.rect.size.height);
    [imageView setAnchorPoint:[sprite anchorPointWithCenter:[frm getCenterAt:time]]];
    [imageView setPosition:CGPointZero];

    if (!sprite.rotated) {
        imageView.contents = (id)image.CGImage;
        imageView.contentsRect = imagerect;
    }
    else {

        [_viewRenderStack push:imageView];

        CALayer* subView = [self createLayer];
        subView.contents = (id)image.CGImage;
        subView.contentsRect = imagerect;
        subView.frame = CGRectMake(0, 0, sprite.rect.size.width, sprite.rect.size.height);
        [subView setAnchorPoint:CGPointMake(0, 0)];
        [subView setAffineTransform:CGAffineTransformMakeRotation(-M_PI_2)];

        [_viewRenderStack pop];
    }

    UIColor* color = [frm getColorAt:time];
//    [imageView setFilters:[NSArray arrayWithObjects:[self createFilterByColor:color], nil]];

    CGAffineTransform matrix;
    [self buildTransform:&matrix keyFrame:frm at:time type:NO];
    _layerTransform = matrix;

    matrix = CGAffineTransformScale(matrix, 1.0, -1.0); //上下翻转
    [imageView setAffineTransform:matrix];
    [imageView setOpacity:color.A];

//    NSLog(@"%.3f: %@",time, NSStringFromCGAffineTransform(matrix));

}

-(void)visitAnimaKey:(HpAnimaKeyframe*)akf with:(HpKeyframe*)frm at:(float)time
{
    CALayer* view = [self createLayer];
    UIColor* color = [frm getColorAt:time];
    CGAffineTransform matrix;
    [self buildTransform:&matrix keyFrame:frm at:time type:YES];

    [view setAffineTransform:matrix];
    [view setOpacity:color.A];
//    [view setFilters:[NSArray arrayWithObjects:[self createFilterByColor:color], nil]];

    HpAnimaStatus* _as = _statusRenderStack.peek;
    [_statusRenderStack push:[_as getSubAS]];
    [_viewRenderStack push:view];

    HpAnimation* anima = akf.anima;
    [self visitAnima:anima firstly:akf.firstVisitFlag at:time-akf.time autoloop:!frm.isTimeInherited];

    [_viewRenderStack pop];
    [_statusRenderStack pop];

    _layerTransform = matrix;

}


///*---------------------------------------------------------------------

#define HDEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) * 0.01745329252f) // PI / 180

-(CGAffineTransform*)buildTransform:(CGAffineTransform*)pin  keyFrame:(HpKeyframe*)frm at:(float)time type:(BOOL)isAnima
{
    CGPoint center = [frm getCenterAt:time];
    CGPoint trans = [frm getTransAt:time];
    float rot = [frm getRotAt:time];
    CGPoint skew = [frm getSkewAt:time];
    CGPoint scale = [frm getScaleAt:time];

    if (CGPointEqualToPoint(scale, CGPointZero)) {
        scale = CGPointMake(0.000001f, 0.000001f);
    }

    *pin = CGAffineTransformIdentity;
    *pin = CGAffineTransformTranslate(*pin, trans.x + center.x, trans.y + center.y);
    *pin = CGAffineTransformRotate(*pin, HDEGREES_TO_RADIANS(rot));

    struct CGAffineTransform skew_tf = CGAffineTransformIdentity;
    skew_tf.b = tanf(HDEGREES_TO_RADIANS(skew.y));
    skew_tf.c = tanf(HDEGREES_TO_RADIANS(skew.x));
    *pin = CGAffineTransformConcat(skew_tf, *pin);
    *pin = CGAffineTransformScale(*pin, scale.x, scale.y);

    if (isAnima) {
        *pin = CGAffineTransformTranslate(*pin, -center.x, -center.y);
    }

    return pin;
}

-(void)fireEventsPassed:(HpLayer *)layer from:(HpKeyframe*)last_kf til:(HpKeyframe *)kf
{
    NSAssert(kf == [layer.keys objectAtIndex:kf.arrayIndex], @"kf is not belong to the layer - HpAnimRenderVisitor:FireEventBetweenKeyframe");

    if (last_kf == nil) {
        for (int i = 0; i <= kf.arrayIndex; ++ i) {
            HpKeyframe* key = [layer.keys objectAtIndex:i];
            if (key.event) {
                [_currInst onCustomEvent:key.event];
            }
        }
    }
    else {
        NSAssert(last_kf == [layer.keys objectAtIndex:last_kf.arrayIndex], @"last_kf is not belong to the layer - HpAnimRenderVisitor:FireEventBetweenKeyframe");

        if (kf.arrayIndex < last_kf.arrayIndex) {
            for (int i = last_kf.arrayIndex + 1; i < layer.keys.count; ++ i) {
                HpKeyframe* key = [layer.keys objectAtIndex:i];
                if (key.event) {
                    [_currInst onCustomEvent:key.event];
                }
            }
            for (int i = 0; i <= kf.arrayIndex; ++ i) {
                HpKeyframe* key = [layer.keys objectAtIndex:i];
                if (key.event) {
                    [_currInst onCustomEvent:key.event];
                }
            }
        }
        else {
            for (int i = last_kf.arrayIndex + 1; i <= kf.arrayIndex; ++ i) {
                HpKeyframe* key = [layer.keys objectAtIndex:i];
                if (key.event) {
                    [_currInst onCustomEvent:key.event];
                }
            }
        }

    }
}

-(void)retrieveRecursively:(id)view isRoot:(bool)root
{
    for (NSInteger i=[[view sublayers] count]-1; i>=0; i--) {
        [self retrieveRecursively:[[view sublayers] objectAtIndex:i] isRoot:NO];
    }

    if (!root) {
        [_viewCreateCache push:retain(view)];//让计数器加1后存起来，不然Pop时对象消亡
        [view setContents:nil];
        [view removeFromSuperlayer];
    }
}

-(CALayer*)createLayer
{
    CALayer* layer = nil;

    if (_viewCreateCache.count > 0) {
        layer = [_viewCreateCache pop]; //a retain object as pushing with retained
    }else {
        layer = [[CALayer alloc] init];
    }

    [layer setFrame:CGRectMake(0, 0, 0, 0)];
    [layer setOpacity:1.0];
    [layer setAffineTransform:CGAffineTransformIdentity];
    [layer setAnchorPoint:CGPointMake(0, 1)];
    [layer setPosition:CGPointZero];

    [layer setContents:nil];
    [layer setContentsRect:CGRectZero];

    [[_viewRenderStack peek] addSublayer:layer];

    release(layer);
    return layer;
}

/*

[Color Matrix] CIColorMatrix

inputBiasVector : {
    CIAttributeClass = CIVector;
    CIAttributeDefault = "[0 0 0 0]";
    CIAttributeIdentity = "[0 0 0 0]";
}

inputRVector : {
    CIAttributeClass = CIVector;
    CIAttributeDefault = "[1 0 0 0]";
    CIAttributeIdentity = "[1 0 0 0]";
}

inputAVector : {
    CIAttributeClass = CIVector;
    CIAttributeDefault = "[0 0 0 1]";
    CIAttributeIdentity = "[0 0 0 1]";
}

inputBVector : {
    CIAttributeClass = CIVector;
    CIAttributeDefault = "[0 0 1 0]";
    CIAttributeIdentity = "[0 0 1 0]";
}

inputImage : {
    CIAttributeClass = CIImage;
    CIAttributeType = CIAttributeTypeImage;
}

inputGVector : {
    CIAttributeClass = CIVector;
    CIAttributeDefault = "[0 1 0 0]";
    CIAttributeIdentity = "[0 1 0 0]";
}





CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"];

[filter setValue:inputImage forKey:@"inputImage"];

[filter setValue:[CIVector vectorWithX:1 Y:0 Z:0 W:0] forKey:@"inputRVector"];

[filter setValue:[CIVector vectorWithX:0 Y:0.9 Z:0.3 W:0] forKey:@"inputGVector"];

[filter setValue:[CIVector vectorWithX:0 Y:0.1 Z:0.7 W:0] forKey:@"inputBVector"];







CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"];

[filter setValue:inputImage forKey:@"inputImage"];

[filter setValue:[CIVector vectorWithX:0.8 Y:0 Z:0.3 W:0] forKey:@"inputRVector"];

[filter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputGVector"];

[filter setValue:[CIVector vectorWithX:0.2 Y:0 Z:0.8 W:0] forKey:@"inputBVector"];





色彩矩阵

CIColorMatrix 过滤器对源色彩值进行预相乘运算并对每个色彩组件加上一个偏移参数。请比较下面的图像与图 4-19 中的原始图像。

注意：三个vector的rgb值纵向相加=1时不会产生色偏
 
*/

- (CIFilter*)createFilterByColor:(UIColor*)color
{
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputRVector"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputGVector"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:0] forKey:@"inputBVector"];
    return filter;
}


@end

