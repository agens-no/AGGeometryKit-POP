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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "AGKBaseDefines.h"

AGK_EXTERN_C_BEGIN

#define AGK_CLAMP(x, low, high) ({\
  __typeof__(x) __x = (x); \
  __typeof__(low) __low = (low);\
  __typeof__(high) __high = (high);\
  __x > __high ? __high : (__x < __low ? __low : __x);\
  })

#define AGK_IS_WITHIN(x, low, high) ({\
  __typeof__(x) __x = (x); \
  __typeof__(low) __low = (low);\
  __typeof__(high) __high = (high);\
  __x <= __high && __x >= __low;\
  })

CGFloat AGKInterpolate(CGFloat startValue, CGFloat endValue, CGFloat progress);
CGFloat AGKRemapToZeroOne(CGFloat value, CGFloat startValue, CGFloat endValue);
CGFloat AGKRemap(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue, CGFloat newStartValue, CGFloat newEndValue);
CGFloat AGKRemapAndClamp(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue, CGFloat newStartValue, CGFloat newEndValue);
CGFloat AGKRemapToZeroOneAndClamp(CGFloat value, CGFloat oldStartValue, CGFloat oldEndValue);
CGFloat AGKClamp(CGFloat value, CGFloat min, CGFloat max);

BOOL AGKIsWithin(CGFloat value, CGFloat min, CGFloat max);

CGFloat AGKRadiansToDegrees(CGFloat radians);
CGFloat AGKDegreesToRadians(CGFloat degrees);

CGFloat AGKMakeProgressPingPong(CGFloat progress);
CGFloat AGKMakeProgressPingPongSin(CGFloat progress);
CGFloat AGKBezierYForX(CGFloat x, CGPoint p0, CGPoint p1, CGPoint p2, CGPoint p3);
CGFloat AGKBezierZeroOneYForX(CGFloat x, CGPoint p1, CGPoint p2);
CGFloat AGKEaseInWithBezier(CGFloat progress);
CGFloat AGKEaseOutWithBezier(CGFloat progress);
CGFloat AGKEaseInOutWithBezier(CGFloat progress, CGFloat force);
CGFloat AGKEaseOutWithOverShoot(CGFloat progress, CGFloat overshoot);
CGFloat AGKEaseOutWithPower(CGFloat progress, CGFloat power);

CGFloat AGKDelayedProgressForItems(NSUInteger index,
                                   NSUInteger itemCount,
                                   CGFloat overlap,
                                   CGFloat overallProgress);

CGFloat AGKEaseWithTwoBeziers(CGPoint tangent1,
                              CGPoint tangent2,
                              CGPoint pointOfConnection,
                              CGFloat x,
                              CGPoint tangent4,
                              CGFloat time,
                              CGFloat progress);

CGFloat AGKMinInArray(CGFloat values[], NSUInteger numberOfValues, NSUInteger *out_index);
CGFloat AGKMaxInArray(CGFloat values[], NSUInteger numberOfValues, NSUInteger *out_index);

double AGKFloatToDoubleZeroFill(float value);

AGK_EXTERN_C_END
