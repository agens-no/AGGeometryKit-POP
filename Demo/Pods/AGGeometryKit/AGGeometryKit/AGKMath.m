//
// Authors:
// Håvard Fossli <hfossli@agens.no>
// Marcus Eckert <marcuseckert@gmail.com>
//
// Copyright (c) 2013 Agens AS (http://agens.no/)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AGKMath.h"

CGFloat AGKInterpolate(CGFloat startValue, CGFloat endValue, CGFloat progress)
{
    return startValue + ((endValue - startValue) * progress);
}

CGFloat AGKRemapToZeroOne(CGFloat value, CGFloat startValue, CGFloat endValue)
{
    CGFloat diff = endValue - startValue;
    
    if(diff != 0.0)
    {
        return (value - startValue) / diff;
    }
    else
    {
        return 0.0;
    }
}

CGFloat AGKRemap(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue, CGFloat newStartValue, CGFloat newEndValue)
{
    CGFloat p = AGKRemapToZeroOne(value, oldStartValue, oldEndValue);
    return AGKInterpolate(newStartValue, newEndValue, p);
}

CGFloat AGKRemapAndClamp(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue, CGFloat newStartValue, CGFloat newEndValue)
{
    CGFloat p = AGKRemapToZeroOne(value, oldStartValue, oldEndValue);
    CGFloat remapped = AGKInterpolate(newStartValue, newEndValue, p);
    return AGKClamp(remapped, newStartValue, newEndValue);
}

CGFloat AGKRemapToZeroOneAndClamp(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue)
{
    CGFloat remapped = AGKRemapToZeroOne(value, oldStartValue, oldEndValue);
    return AGKClamp(remapped, 0.0, 1.0);
}

CGFloat AGKClamp(CGFloat value, CGFloat min, CGFloat max)
{
    if(value > max)
        return max;
    if(value < min)
        return min;
    return value;
}

BOOL AGKIsWithin(CGFloat value, CGFloat min, CGFloat max)
{
    if(value >= max)
        return NO;
    if(value <= min)
        return NO;
    return YES;
}

CGFloat AGKRadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
}

CGFloat AGKDegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}

CGFloat AGKMakeProgressPingPong(CGFloat progress)
{
    CGFloat fac1 = AGKRemapToZeroOneAndClamp(progress, 0.0, 0.5);
    CGFloat fac2 = 1.0 - AGKRemapToZeroOneAndClamp(progress, 0.5, 1.0);

    return fac2 != 1.0f ? fac2 : fac1;
}

CGFloat AGKMakeProgressPingPongSin(CGFloat progress)
{
    // http://www.wolframalpha.com/input/?i=sin%28x*PI*2.0-PI*0.5%29*0.5%2B0.5
    return sinf(progress*M_PI*2.0-M_PI*0.5)*0.5+0.5;
}

CGFloat AGKDelayedProgressForItems(NSUInteger index,
                                   NSUInteger itemCount,
                                   CGFloat overlap,
                                   CGFloat overallProgress)
{
    CGFloat multi = (1.0f-overlap) * (itemCount-1.0f);
    multi +=1.0f;
    overallProgress *= multi;

    CGFloat min = (CGFloat)index*(1.0f-overlap);
    CGFloat sFac = overallProgress-min;

    sFac = MIN(MAX(sFac, 0.0f), 1.0f);

    return sFac;
}

static CGFloat AGKBezierSlope(CGFloat t, CGFloat A, CGFloat B, CGFloat C)
{
    CGFloat dtdx = 1.0/(3.0*A*t*t + 2.0*B*t + C);
    return dtdx;
}

static CGFloat AGKBezierXFromT(CGFloat t, CGFloat A, CGFloat B, CGFloat C, CGFloat D)
{
    CGFloat x = A*(t*t*t) + B*(t*t) + C*t + D;
    return x;
}

static CGFloat AGKBezierYFromT(CGFloat t, CGFloat E, CGFloat F, CGFloat G, CGFloat H)
{
    CGFloat y = E*(t*t*t) + F*(t*t) + G*t + H;
    return y;
}

CGFloat AGKBezierYForX(CGFloat x, CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3)
{
    CGFloat y0a = p0.y; // initial y
    CGFloat x0a = p0.x; // initial x
    CGFloat y1a = p1.y; // 1st influence y
    CGFloat x1a = p1.x; // 1st influence x
    CGFloat y2a = p2.y; // 2nd influence y
    CGFloat x2a = p2.x; // 2nd influence x
    CGFloat y3a = p3.y; // final y
    CGFloat x3a = p3.x; // final x

    CGFloat A =   x3a - 3*x2a + 3*x1a - x0a;
    CGFloat B = 3*x2a - 6*x1a + 3*x0a;
    CGFloat C = 3*x1a - 3*x0a;
    CGFloat D =   x0a;

    CGFloat E =   y3a - 3*y2a + 3*y1a - y0a;
    CGFloat F = 3*y2a - 6*y1a + 3*y0a;
    CGFloat G = 3*y1a - 3*y0a;
    CGFloat H =   y0a;

    // Solve for t given x (using Newton-Raphelson), then solve for y given t.
    // Assume for the first guess that t = x.
    CGFloat currentt = x;

    for (NSUInteger i = 0; i < 5; i++)
    {
        CGFloat currentx = AGKBezierXFromT(currentt, A, B, C, D);
        CGFloat currentslope = AGKBezierSlope(currentt, A, B, C);
        currentt -= (currentx - x) * currentslope;
        currentt = MIN(MAX(currentt, 0.0f),1.0f);
    }

    return AGKBezierYFromT(currentt, E, F, G, H);
}

CGFloat AGKBezierZeroOneYForX(CGFloat x, CGPoint p1, CGPoint p2)
{
    return AGKBezierYForX(x, CGPointZero, p1, p2, CGPointMake(1, 1));
}

CGFloat AGKEaseInWithBezier(CGFloat progress)
{
    return AGKBezierZeroOneYForX(progress, CGPointMake(0.9, 0.0), CGPointMake(0.8, 0.6));
}

CGFloat AGKEaseOutWithBezier(CGFloat progress)
{
    return AGKBezierZeroOneYForX(progress, CGPointMake(0.2f, 0.4f), CGPointMake(0.1f, 1.0f));
}

CGFloat AGKEaseInOutWithBezier(CGFloat progress, CGFloat force)
{
    return AGKBezierZeroOneYForX(progress, CGPointMake(force, 0.0f), CGPointMake(1.0f-force, 1.0f));
}

CGFloat AGKEaseOutWithOverShoot(CGFloat progress, CGFloat overshoot)
{
    // overshoot is 2.0
    // http://www.wolframalpha.com/input/?i=%28%28x-1%29*%28x-1%29*%28%282%2B1%29*%28x-1%29+%2B+2%29+%2B+1%29+from+0+to+1
    return ((progress-1.0)*(progress-1.0)*((overshoot+1.0)*(progress-1.0) + overshoot) + 1.0);
}

CGFloat AGKEaseOutWithPower(CGFloat progress, CGFloat power)
{
    // power is 3.0
    // http://www.wolframalpha.com/input/?i=1.0-%281.0-x%29^3+from+0+to+1
    return 1.0f-powf(fabs(1.0f-progress), power);
}

CGFloat AGKEaseWithTwoBeziers(CGPoint tangent1,
                                    CGPoint tangent2,
                                    CGPoint pointOfConnection,
                                    CGFloat x,
                                    CGPoint tangent4,
                                    CGFloat time,
                                    CGFloat progress)
{
    CGFloat fac1 = AGKRemapToZeroOneAndClamp(progress, 0.0, time);
    CGFloat fac2 = AGKRemapToZeroOneAndClamp(progress, time, 1.0);

    CGPoint tangent3 = CGPointMake(x, pointOfConnection.y+ (pointOfConnection.y-tangent2.y));

    if (fac1 <= 1.0)
    {
        return AGKBezierYForX(fac1,
                             CGPointZero,
                             tangent1,
                             tangent2,
                             pointOfConnection);
    }
    else
    {
        return AGKBezierYForX(fac2,
                             CGPointMake(0.0, pointOfConnection.y),
                             tangent3,
                             tangent4,
                             CGPointMake(1.0, 1.0));
    }
}

CGFloat AGKMinInArray(CGFloat values[], NSUInteger numberOfValues, NSUInteger *out_index)
{
    CGFloat lowest = values[0];
    unsigned int index = 0;

    for(int i = 1; i < numberOfValues; i++)
    {
        CGFloat value = values[i];
        if(value < lowest)
        {
            lowest = value;
            index = i;
        }
    }

    if(out_index != NULL)
    {
        *out_index = index;
    }

    return lowest;
}

CGFloat AGKMaxInArray(CGFloat values[], NSUInteger numberOfValues, NSUInteger *out_index)
{
    CGFloat highest = values[0];
    unsigned int index = 0;

    for(int i = 1; i < numberOfValues; i++)
    {
        CGFloat value = values[i];
        if(value > highest)
        {
            highest = value;
            index = i;
        }
    }

    if(out_index != NULL)
    {
        *out_index = index;
    }

    return highest;
}

double AGKFloatToDoubleZeroFill(float floatValue)
{
    double doubleValue = [[NSString stringWithFormat:@"%f", floatValue] doubleValue];
    return doubleValue;
}
