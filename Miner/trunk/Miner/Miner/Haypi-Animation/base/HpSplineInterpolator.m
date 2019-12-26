//
//  HpSplineInterpolator.m
//  HpAnimaTestMeragerOnCocoa
//
//  Created by zhou gang on 14/12/24.
//  Copyright (c) 2014年 zhou gang. All rights reserved.
//

#import "HpSplineInterpolator.h"
#import "HpBaseMacros.h"

double sign(double x)
{
    return x > 1e-6 ? 1.0 : x < -1e-6 ? -1.0 : 0;
}

@implementation HpSplineInterp

@synthesize p1=P1, p2=P2;

- (id)init
{
    if (self=[super init]){
        P0 = CGPointMake(0, 0);
        P1 = CGPointMake(0.6, 0);
        P2 = CGPointMake(0.4, 1);
        P3 = CGPointMake(1, 1);
    }
    return self;
}

- (double)coventX2Time:(double)x
{
    double a = -P0.x + 3.0 * P1.x - 3.0 * P2.x + P3.x;
    double b = 3.0 * P0.x - 6.0 * P1.x + 3.0 * P2.x;
    double c = -3.0 * P0.x + 3.0 * P1.x;
    double d = P0.x - x;

    double A = b * b - 3.0 * a * c;
    double B = b * c - 9.0 * a * d;
    double C = c * c - 3.0 * b * d;
    double delta = B * B - 4.0 * A * C;

    // 当A=B=0时，盛金公式①：
    // X1=X2=X3=－b/(3a)=－c/b=－3d/c。
    if (fabs(A) < 1e-6 && fabs(B) < 1e-6)
    {
        return -c / b;
    }

    // 当Δ=B^2－4AC=0时，盛金公式③：
    // X1=－b/a+K；X2=X3=－K/2，
    // 其中K=B/A，(A≠0)。
    if (abs(delta) < 1e-6)
    {
        if (abs(A) > 1e-6)
        {
            double K = B / A;
            double X1 = -b / a + K;
            double X2 = -K / 2.0;

            return X1 >= 0 && X1 <= 1 ? X1 : X2;
        }
    }

    // 当Δ=B^2－4AC>0时，盛金公式②：
    // X1=(－b－(Y1)^(1/3)－(Y2)^(1/3))/(3a)；
    // X2，X3=(－2b+(Y1)^(1/3)+(Y2)^(1/3))/(6a)±3^(1/2)((Y1)^(1/3)－(Y2)^(1/3))i/(6a)，
    // 其中Y1，Y2=Ab+3a(－B±(B^2－4AC)^(1/2))/2，i^2=－1。
    if (delta > 0)
    {
        double Y1 = A * b + 3.0 * a * (-B + sqrt(delta)) / 2.0;
        double Y2 = A * b + 3.0 * a * (-B - sqrt(delta)) / 2.0;
        return (-b - sign(Y1) * pow(fabs(Y1), 1.0 / 3.0) - sign(Y2) * pow(fabs(Y2), 1.0 / 3.0)) / (3.0 * a);
    }

    // 当Δ=B^2－4AC<0时，盛金公式④：
    // X1=(－b－2A^(1/2)cos(θ/3))/(3a)；
    // X2，X3=(－b+A^(1/2)(cos(θ/3)±3^(1/2)sin(θ/3)))/(3a)，
    // 其中θ=arccosT，T= (2Ab－3aB)/(2A^(3/2))，(A>0，－1<T<1)。
    if (delta < 0)
    {
        if (A > 1e-6)
        {
            double T = (2.0 * A * b - 3.0 * a * B) / (2.0 * pow(A, 3.0 / 2.0));
            if (T > -1 && T < 1)
            {
                double theta = acos(T) / 3.0;
                double X1 = (-b - 2.0 * sqrt(A) * cos(theta / 3.0)) / (3 * a);
                double X2 = (-b + sqrt(A) * (cos(theta) + sqrt(3.0) * sin(theta))) / (3.0 * a);
                double X3 = (-b + sqrt(A) * (cos(theta) - sqrt(3.0) * sin(theta))) / (3.0 * a);

                return X1 >= 0 && X1 <= 1 ? X1 : X2 >= 0 && X2 <= 1 ? X2 : X3;
            }
        }
    }

    return x;
}


- (float)getFactorWithStart:(int)t1 end:(int)t2 at:(float)pt
{
    if (pt > t2) {
        NSLog(@"");
    }

    double x = (pt - t1) * 1.0 / (t2 - t1);
    double t = [self coventX2Time:x];

    double factor = P0.y * ((1 - t) * (1 - t) * (1 - t))
                  + P1.y * (3.0 * t * (1 - t) * (1 - t))
                  + P2.y * (3.0 * t * t * (1 - t))
                  + P3.y * (t * t * t);

    return factor;
}

static NSMutableDictionary* s_splineTires = nil;

+ (id)interp:(NSString*)ctrlpts
{
    if (s_splineTires == nil) {
        s_splineTires = [[NSMutableDictionary alloc] init];
    }

    HpSplineInterp* spline = [s_splineTires objectForKey:ctrlpts];
    if (spline == nil) {
        spline = [[HpSplineInterp alloc] init];

        NSArray* splits = [ctrlpts componentsSeparatedByString:@" "];
        if([splits count] >= 2)
        {
            spline->P0 = CGPointMake(0, 0);
            spline->P1 = CGPointFromString([splits objectAtIndex:0]);
            spline->P2 = CGPointFromString([splits objectAtIndex:1]);
            spline->P3 = CGPointMake(1, 1);
        }

        [s_splineTires setObject:spline forKey:ctrlpts];
        release(spline);
    }
    return spline;
}

+ (void)purge
{
    release(s_splineTires);
}

@end

