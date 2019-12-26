//
//  HpExtensionMacros.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/23.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpExtensionMacros.h"

@implementation UIColor (RGBA)

- (CGFloat)R { return CGColorGetComponents(self.CGColor)[0]; }
- (CGFloat)G { return CGColorGetComponents(self.CGColor)[1]; }
- (CGFloat)B { return CGColorGetComponents(self.CGColor)[2]; }
- (CGFloat)A { return CGColorGetComponents(self.CGColor)[3]; }

@end

CGFloat CGFloatLerp(CGFloat a, CGFloat b, float alpha)
{
    return  a * (1.f - alpha) + b * alpha;
}

CGPoint CGPointLerp(CGPoint a, CGPoint b, float alpha)
{
    return CGPointMake(CGFloatLerp(a.x, b.x, alpha), CGFloatLerp(a.y, b.y, alpha));
}

UIColor* UIColorLerp(UIColor* a, UIColor* b, float alpha)
{
    return [UIColor colorWithRed:CGFloatLerp(a.R, b.R, alpha)
                           green:CGFloatLerp(a.G, b.G, alpha)
                            blue:CGFloatLerp(a.B, b.B, alpha)
                           alpha:CGFloatLerp(a.A, b.A, alpha)];
}


@implementation HpHelper

+ (NSString*)fullPathFromRelativePath:(NSString*)relPath
{
    NSString *fullpath = nil;

    // only if it is not an absolute path
    if( ! [relPath isAbsolutePath] ) {

        // pathForResource also searches in .lproj directories. issue #1230
        NSString *file = [relPath lastPathComponent];
        NSString *imageDirectory = [relPath stringByDeletingLastPathComponent];

        fullpath = [[NSBundle mainBundle] pathForResource:file
                                                   ofType:nil
                                              inDirectory:imageDirectory];

    }

    return fullpath;
}

@end

