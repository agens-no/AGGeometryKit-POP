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

#import "CGGeometry+AGGeometryKit.h"
#import <QuartzCore/QuartzCore.h>
#import "GLKit/GLKMatrix3.h"
#import "GLKit/GLKVector3.h"
#import "AGKMath.h"
#import "pthread.h"

// Usefull resources for further development:
// http://processingjs.nihongoresources.com/bezierinfo/

#pragma mark - CGFloat

CGFloat CGFloatRound_AGK(CGFloat v)
{
    #if CGFLOAT_IS_DOUBLE
        return round(v);
    #else
        return roundf(v);
    #endif
}

CGFloat CGFloatCeil_AGK(CGFloat v)
{
    #if CGFLOAT_IS_DOUBLE
        return ceil(v);
    #else
        return ceilf(v);
    #endif
}

CGFloat CGFloatFloor_AGK(CGFloat v)
{
    #if CGFLOAT_IS_DOUBLE
        return floor(v);
    #else
        return floorf(v);
    #endif
}



#pragma mark - CGPoint

BOOL CGPointGotAnyNanValues_AGK(CGPoint origin)
{
    // which is better 'a == NAN' or 'a != a'?
    return origin.x == NAN || origin.y == NAN;
}

CGPoint CGPointModified_AGK(CGPoint point, CGPoint (^block)(CGPoint point))
{
    return block(point);
}

CGPoint CGPointAdd_AGK(CGPoint p1, CGPoint p2)
{
    return (CGPoint){p1.x + p2.x, p1.y + p2.y};
}

CGPoint CGPointAddSize_AGK(CGPoint p, CGSize s)
{
    return CGPointMake(p.x + s.width, p.y + s.height);
}

CGPoint CGPointSubtract_AGK(CGPoint p1, CGPoint p2)
{
    return (CGPoint){p1.x - p2.x, p1.y - p2.y};
}

CGPoint CGPointMultiply_AGK(CGPoint p1, CGFloat factor)
{
    return (CGPoint){p1.x * factor, p1.y * factor};
}

CGPoint CGPointDivide_AGK(CGPoint p1, CGFloat factor)
{
    return (CGPoint){p1.x / factor, p1.y / factor};
}

CGPoint CGPointNormalize_AGK(CGPoint v)
{
    CGFloat length = CGPointLength_AGK(v);
    if(length != 0.0)
    {
        v.x /= length;
        v.y /= length;
    }
    return v;
}

CGFloat CGPointDotProduct_AGK(CGPoint p1, CGPoint p2)
{
    return (p1.x * p2.x) + (p1.y * p2.y);
}

CGFloat CGPointCrossProductZComponent_AGK(CGPoint v1, CGPoint v2)
{
    return v1.x * v2.y - v1.y * v2.x;
}

CGFloat CGPointLength_AGK(CGPoint v)
{
    return sqrtf(v.x * v.x + v.y * v.y);
}

CGFloat CGPointLengthBetween_AGK(CGPoint p1, CGPoint p2)
{
    CGPoint p = CGPointMake(p2.x - p1.x, p2.y - p1.y);
    return sqrtf(powf(p.x, 2.0f) + powf(p.y, 2.0f));
}

CGPoint CGPointApplyCATransform3D_AGK(CGPoint point,
                                     CATransform3D transform,
                                     CGPoint anchorPoint,
                                     CATransform3D parentSublayerTransform)
{
    // http://stackoverflow.com/a/15328910/202451

    static pthread_mutex_t mtx = PTHREAD_MUTEX_INITIALIZER;
    static CALayer *sublayer, *layer;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sublayer = [CALayer layer];
        layer = [CALayer layer];
        [layer addSublayer:sublayer];
    });

    if(pthread_mutex_lock(&mtx))
    {
        [NSException raise:NSInternalInconsistencyException format:@"pthread_mutex_lock failed"];
    }

    layer.sublayerTransform = parentSublayerTransform;
    sublayer.transform = transform;
    sublayer.anchorPoint = anchorPoint;
    CGPoint retval = [sublayer convertPoint:point toLayer:layer];

    if(pthread_mutex_unlock(&mtx) != 0)
    {
        [NSException raise:NSInternalInconsistencyException format:@"pthread_mutex_unlock failed"];
    }
    
    return retval;
}

CGPoint CGPointRotate_AGK(CGPoint point, CGFloat angle)
{
    return CGPointRotateAroundOrigin_AGK(point, angle, CGPointZero);
}

CGPoint CGPointRotateAroundOrigin_AGK(CGPoint point, CGFloat angle, CGPoint origin)
{
    point = CGPointSubtract_AGK(point, origin);

    CGFloat cosa = cosf(angle);
    CGFloat sina = sinf(angle);

    CGPoint r;
	r.x = point.x*cosa - point.y*sina;
	r.y = point.x*sina + point.y*cosa;

    return CGPointAdd_AGK(r, origin);
}

CGPoint CGPointRotate90DegreesCW_AGK(CGPoint point)
{
    return CGPointRotate90DegreesCWAroundPoint_AGK(point, CGPointZero);
}

CGPoint CGPointRotate90DegreesCWAroundPoint_AGK(CGPoint point, CGPoint origin)
{
    point = CGPointSubtract_AGK(point, origin);
    point = CGPointMake(point.y, -point.x);
    return CGPointAdd_AGK(point, origin);
}

CGPoint CGPointRotate90DegreesCC_AGK(CGPoint point)
{
    return CGPointRotate90DegreesCCAroundPoint_AGK(point, CGPointZero);
}

CGPoint CGPointRotate90DegreesCCAroundPoint_AGK(CGPoint point, CGPoint origin)
{
    point = CGPointSubtract_AGK(point, origin);
    point = CGPointMake(-point.y, point.x);
    return CGPointAdd_AGK(point, origin);
}

CGPoint CGPointConvertFromAnchorPoint_AGK(CGPoint anchor, CGRect rect)
{
    CGPoint point;
    point.x = (anchor.x * rect.size.width) + rect.origin.x;
    point.y = (anchor.y * rect.size.height) + rect.origin.y;
    return point;
}

CGPoint CGPointConvertToAnchorPoint_AGK(CGPoint point, CGRect rect)
{
    CGPoint anchor = CGPointZero;
    CGPoint minPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    anchor.x = ((point.x - minPoint.x) / rect.size.width);
    anchor.y = ((point.y - minPoint.y) / rect.size.height);
    return anchor;
}

CGPoint CGPointInterpolate_AGK(CGPoint point1, CGPoint point2, CGFloat progress)
{
    CGPoint result;
    result.x = AGKInterpolate(point1.x, point2.x, progress);
    result.y = AGKInterpolate(point1.y, point2.y, progress);
    return result;
}

CGPoint CGPointClamp_AGK(CGPoint p, CGFloat minX, CGFloat maxX, CGFloat minY, CGFloat maxY)
{
    CGPoint result;
    result.x = AGKClamp(p.x, minX, maxX);
    result.y = AGKClamp(p.y, minY, maxY);
    return result;
}





#pragma mark - 
#pragma mark CGSize

BOOL CGSizeGotAnyNanValues_AGK(CGSize size)
{
    // which is better 'a == NAN' or 'a != a'?
    return size.width == NAN || size.height == NAN;
}

CGSize CGSizeModified_AGK(CGSize size, CGSize (^block)(CGSize size))
{
    return block(size);
}

CGSize CGSizeHalf_AGK(CGSize size)
{
    return CGSizeMake(size.width / 2.0, size.height / 2.0);
}

CGSize CGSizeSwitchAxis_AGK(CGSize size)
{
    return CGSizeMake(size.height, size.width);
}

double CGSizeAspectRatio_AGK(CGSize size)
{
    return size.width / size.height;
}

CGSize CGSizeAdjustOuterSizeToFitInnerSize_AGK(CGSize outer, CGSize inner)
{
    double outerAspect = outer.width / outer.height;
    double innerAspect = inner.width / inner.height;

    if(outerAspect > innerAspect) // outer is wider
    {
        return CGSizeMake(inner.height * outerAspect, inner.height);
    }
    else // outer is thinner
    {
        return CGSizeMake(inner.width, inner.width * outerAspect);
    }
}

BOOL CGSizeAspectIsWiderThanCGSize_AGK(CGSize size1, CGSize size2)
{
    double aspect1 = CGSizeAspectRatio_AGK(size1);
    double aspect2 = CGSizeAspectRatio_AGK(size2);
    return aspect1 > aspect2;
}

CGFloat CGSizeScalarToAspectFit_AGK(CGSize sizeToFit, CGSize container)
{
    CGSize sizeMultiplier = CGSizeMake(sizeToFit.width / container.width,
                                       sizeToFit.height / container.height);

    return sizeMultiplier.width < sizeMultiplier.height ? sizeMultiplier.width : sizeMultiplier.height;
}

CGFloat CGSizeScalarToAspectFill_AGK(CGSize sizeToFill, CGSize container)
{
    CGSize sizeMultiplier = CGSizeMake(sizeToFill.width / container.width,
                                       sizeToFill.height / container.height);

    return sizeMultiplier.width > sizeMultiplier.height ? sizeMultiplier.width : sizeMultiplier.height;
}

CGSize CGSizeInterpolate_AGK(CGSize size1, CGSize size2, CGFloat progress)
{
    CGSize result;
    result.width = AGKInterpolate(size1.width, size2.width, progress);
    result.height = AGKInterpolate(size1.height, size2.height, progress);
    return result;
}

CGSize CGSizeClamp_AGK(CGSize s, CGFloat minWidth, CGFloat maxWidth, CGFloat minHeight, CGFloat maxHeight)
{
    CGSize result;
    result.width = AGKClamp(s.width, minWidth, maxWidth);
    result.height = AGKClamp(s.height, minHeight, maxHeight);
    return result;
}




#pragma mark -
#pragma mark CGRect

BOOL CGRectGotAnyNanValues_AGK(CGRect rect)
{
    return CGSizeGotAnyNanValues_AGK(rect.size) || CGPointGotAnyNanValues_AGK(rect.origin);
}

CGRect CGRectModified_AGK(CGRect rect, CGRect (^block)(CGRect rect))
{
    return block(rect);
}

CGSize CGRectGapBetween_AGK(CGRect rect1, CGRect rect2)
{
    if (CGRectIntersectsRect(rect1, rect2))
    {
        return CGSizeMake(0, 0);
    }

    CGRect mostLeft = rect1.origin.x < rect2.origin.x ? rect1 : rect2;
    CGRect mostRight = rect2.origin.x < rect1.origin.x ? rect1 : rect2;

    CGFloat xDifference = mostLeft.origin.x == mostRight.origin.x ? 0 : mostRight.origin.x - (mostLeft.origin.x + mostLeft.size.width);
    xDifference = MAX(0, xDifference);

    CGRect upper = rect1.origin.y < rect2.origin.y ? rect1 : rect2;
    CGRect lower = rect2.origin.y < rect1.origin.y ? rect1 : rect2;

    CGFloat yDifference = upper.origin.y == lower.origin.y ? 0 : lower.origin.y - (upper.origin.y + upper.size.height);
    yDifference = MAX(0, yDifference);

    return CGSizeMake(xDifference, yDifference);
}

CGPoint CGRectGetMid_AGK(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect CGRectSmallestWithCGPoints_AGK(CGPoint pointsArray[], int numberOfPoints)
{
    double greatestXValue = pointsArray[0].x;
    double greatestYValue = pointsArray[0].y;
    double smallestXValue = pointsArray[0].x;
    double smallestYValue = pointsArray[0].y;

    for(int i = 1; i < numberOfPoints; i++)
    {
        CGPoint point = pointsArray[i];
        greatestXValue = MAX(greatestXValue, point.x);
        greatestYValue = MAX(greatestYValue, point.y);
        smallestXValue = MIN(smallestXValue, point.x);
        smallestYValue = MIN(smallestYValue, point.y);
    }

    CGRect rect;
    rect.origin = CGPointMake(smallestXValue, smallestYValue);
    rect.size.width = greatestXValue - smallestXValue;
    rect.size.height = greatestYValue - smallestYValue;

    return rect;
}

CGRect CGRectMakeWithSize_AGK(CGSize size)
{
    return (CGRect){CGPointZero, size};
}

CGRect CGRectWithSize_AGK(CGRect rect, CGSize newSize)
{
    rect.size = newSize;
    return rect;
}

CGRect CGRectWithWidth_AGK(CGRect rect, CGFloat newWidth)
{
    rect.size.width = newWidth;
    return rect;
}

CGRect CGRectWithHeight_AGK(CGRect rect, CGFloat newHeight)
{
    rect.size.height = newHeight;
    return rect;
}

CGRect CGRectWithOrigin_AGK(CGRect rect, CGPoint origin)
{
    rect.origin = origin;
    return rect;
}

CGRect CGRectWithOriginMinX_AGK(CGRect rect, CGFloat value)
{
    rect.origin.x = value;
    return rect;
}

CGRect CGRectWithOriginMinY_AGK(CGRect rect, CGFloat value)
{
    rect.origin.y = value;
    return rect;
}

CGRect CGRectWithOriginMaxY_AGK(CGRect rect, CGFloat value)
{
    rect.origin.y = value - rect.size.height;
    return rect;
}

CGRect CGRectWithOriginMaxX_AGK(CGRect rect, CGFloat value)
{
    rect.origin.x = value - rect.size.width;
    return rect;
}

CGRect CGRectWithOriginMidX_AGK(CGRect rect, CGFloat value)
{
    rect.origin.x = value - (rect.size.width / 2.0);
    return rect;
}

CGRect CGRectWithOriginMidY_AGK(CGRect rect, CGFloat value)
{
    rect.origin.y = value - (rect.size.height / 2.0);
    return rect;
}

CGRect CGRectWithOriginMid_AGK(CGRect rect, CGPoint origin)
{
    rect.origin.x = origin.x - (rect.size.width / 2.0);
    rect.origin.y = origin.y - (rect.size.height / 2.0);
    return rect;
}

CGRect CGRectFloor_AGK(CGRect rect)
{
    return CGRectMake(CGFloatFloor_AGK(rect.origin.x),
                      CGFloatFloor_AGK(rect.origin.y),
                      CGFloatFloor_AGK(rect.size.width),
                      CGFloatFloor_AGK(rect.size.height));
}

CGRect CGRectCeil_AGK(CGRect rect)
{
    return CGRectMake(CGFloatCeil_AGK(rect.origin.x),
                      CGFloatCeil_AGK(rect.origin.y),
                      CGFloatCeil_AGK(rect.size.width),
                      CGFloatCeil_AGK(rect.size.height));
}

CGRect CGRectRound_AGK(CGRect rect)
{
    return CGRectMake(CGFloatRound_AGK(rect.origin.x),
                      CGFloatRound_AGK(rect.origin.y),
                      CGFloatRound_AGK(rect.size.width),
                      CGFloatRound_AGK(rect.size.height));
}

CGRect CGRectInterpolate_AGK(CGRect rect1, CGRect rect2, CGFloat progress)
{
    CGRect result;
    result.origin = CGPointInterpolate_AGK(rect1.origin, rect2.origin, progress);
    result.size = CGSizeInterpolate_AGK(rect1.size, rect2.size, progress);
    return result;
}

