//
//  HpExtensionMacros.h
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/23.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HpAnimVisitor;
@protocol HpAnimParser;

@interface UIColor (GRGA)

- (CGFloat)R;
- (CGFloat)G;
- (CGFloat)B;
- (CGFloat)A;

@end


/** Linear Interpolation between two points a and b
 @returns
	alpha == 0 ? a
	alpha == 1 ? b
	otherwise a value between a..b
 @since v0.99.1
 */
extern CGFloat CGFloatLerp(CGFloat a, CGFloat b, float alpha);
extern CGPoint CGPointLerp(CGPoint a, CGPoint b, float alpha);
extern UIColor* UIColorLerp(UIColor* a, UIColor* b, float alpha);



@interface HpHelper : NSObject

+ (NSString*)fullPathFromRelativePath:(NSString*)relPath;


@end