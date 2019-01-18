//
// Author: Håvard Fossli <hfossli@agens.no>
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
#import <QuartzCore/QuartzCore.h>
#import "AGKBaseDefines.h"

AGK_EXTERN_C_BEGIN

// CGFloat

CGFloat CGFloatRound_AGK(CGFloat v);
CGFloat CGFloatCeil_AGK(CGFloat v);
CGFloat CGFloatFloor_AGK(CGFloat v);


// CGPoint

BOOL    CGPointGotAnyNanValues_AGK(CGPoint origin);
CGPoint CGPointModified_AGK(CGPoint point, CGPoint (^block)(CGPoint point));

CGPoint CGPointAdd_AGK(CGPoint p1, CGPoint p2);
CGPoint CGPointAddSize_AGK(CGPoint p, CGSize s);
CGPoint CGPointSubtract_AGK(CGPoint p1, CGPoint p2);
CGPoint CGPointMultiply_AGK(CGPoint p1, CGFloat factor);
CGPoint CGPointDivide_AGK(CGPoint p1, CGFloat factor);
CGPoint CGPointNormalize_AGK(CGPoint v);
CGFloat CGPointDotProduct_AGK(CGPoint p1, CGPoint p2);
CGFloat CGPointCrossProductZComponent_AGK(CGPoint v1, CGPoint v2);
CGFloat CGPointLength_AGK(CGPoint v);
CGFloat CGPointLengthBetween_AGK(CGPoint p1, CGPoint p2);

CGPoint CGPointApplyCATransform3D_AGK(CGPoint point,
                                     CATransform3D transform,
                                     CGPoint anchorPoint,
                                     CATransform3D parentSublayerTransform);

CGPoint CGPointRotate_AGK(CGPoint point, CGFloat angle);
CGPoint CGPointRotateAroundOrigin_AGK(CGPoint point, CGFloat angle, CGPoint origin);
CGPoint CGPointRotate90DegreesCW_AGK(CGPoint point);
CGPoint CGPointRotate90DegreesCWAroundPoint_AGK(CGPoint point, CGPoint origin);
CGPoint CGPointRotate90DegreesCC_AGK(CGPoint point);
CGPoint CGPointRotate90DegreesCCAroundPoint_AGK(CGPoint point, CGPoint origin);

CGPoint CGPointConvertFromAnchorPoint_AGK(CGPoint anchor, CGRect rect);
CGPoint CGPointConvertToAnchorPoint_AGK(CGPoint point, CGRect rect);

CGPoint CGPointInterpolate_AGK(CGPoint point1, CGPoint point2, CGFloat progress);
CGPoint CGPointClamp_AGK(CGPoint p, CGFloat minX, CGFloat maxX, CGFloat minY, CGFloat maxY);


// CGSize

BOOL    CGSizeGotAnyNanValues_AGK(CGSize size);
CGSize  CGSizeModified_AGK(CGSize size, CGSize (^block)(CGSize size));

CGSize  CGSizeHalf_AGK(CGSize size);
CGSize  CGSizeSwitchAxis_AGK(CGSize size);
double  CGSizeAspectRatio_AGK(CGSize size);
CGSize  CGSizeAdjustOuterSizeToFitInnerSize_AGK(CGSize outer, CGSize inner);
BOOL    CGSizeAspectIsWiderThanCGSize_AGK(CGSize size1, CGSize size2);
CGFloat CGSizeScalarToAspectFit_AGK(CGSize sizeToFit, CGSize container);
CGFloat CGSizeScalarToAspectFill_AGK(CGSize sizeToFill, CGSize container);

CGSize  CGSizeInterpolate_AGK(CGSize size1, CGSize size2, CGFloat progress);
CGSize  CGSizeClamp_AGK(CGSize s, CGFloat minWidth, CGFloat maxWidth, CGFloat minHeight, CGFloat maxHeight);


// CGRect

BOOL    CGRectGotAnyNanValues_AGK(CGRect rect);
CGRect  CGRectModified_AGK(CGRect rect, CGRect (^block)(CGRect rect));
CGSize  CGRectGapBetween_AGK(CGRect rect1, CGRect rect2);
CGPoint CGRectGetMid_AGK(CGRect rect);

CGRect  CGRectSmallestWithCGPoints_AGK(CGPoint pointsArray[], int numberOfPoints);
CGRect  CGRectMakeWithSize_AGK(CGSize size);
CGRect  CGRectWithSize_AGK(CGRect rect, CGSize newSize);
CGRect  CGRectWithWidth_AGK(CGRect rect, CGFloat newWidth);
CGRect  CGRectWithHeight_AGK(CGRect rect, CGFloat newHeight);
CGRect  CGRectWithOrigin_AGK(CGRect rect, CGPoint origin);
CGRect  CGRectWithOriginMinX_AGK(CGRect rect, CGFloat value);
CGRect  CGRectWithOriginMinY_AGK(CGRect rect, CGFloat value);
CGRect  CGRectWithOriginMaxY_AGK(CGRect rect, CGFloat value);
CGRect  CGRectWithOriginMaxX_AGK(CGRect rect, CGFloat value);
CGRect  CGRectWithOriginMidX_AGK(CGRect rect, CGFloat value);
CGRect  CGRectWithOriginMidY_AGK(CGRect rect, CGFloat value);
CGRect  CGRectWithOriginMid_AGK(CGRect rect, CGPoint origin);

CGRect CGRectFloor_AGK(CGRect rect);
CGRect CGRectCeil_AGK(CGRect rect);
CGRect CGRectRound_AGK(CGRect rect);

CGRect  CGRectInterpolate_AGK(CGRect rect1, CGRect rect2, CGFloat progress);

AGK_EXTERN_C_END
