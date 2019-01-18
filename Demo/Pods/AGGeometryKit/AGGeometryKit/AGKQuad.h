//
// Author: Håvard Fossli <hfossli@agens.no>
// Author: https://github.com/kennytm
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
#import "AGKCorner.h"
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AGKBaseDefines.h"

AGK_EXTERN_C_BEGIN

/*
 tl = top left
 tr = top right
 br = bottom right
 bl = bottom left
 */

typedef struct AGKQuad {
    CGPoint tl, tr, br, bl;
} AGKQuad;

extern const AGKQuad AGKQuadZero;
BOOL AGKQuadEqual(AGKQuad q1, AGKQuad q2);
BOOL AGKQuadEqualWithAccuracy(AGKQuad q1, AGKQuad q2, CGFloat accuracy);
BOOL AGKQuadIsConvex(AGKQuad q);
BOOL AGKQuadContainsValidValues(AGKQuad q);
BOOL AGKQuadIsValid(AGKQuad q);
int AGKQuadCornerIndexForCorner(AGKCorner corner);
AGKCorner AGKQuadCornerForCornerIndex(int cornerIndex);
AGKQuad AGKQuadMove(AGKQuad q, CGFloat x, CGFloat y);
AGKQuad AGKQuadInsetLeft(AGKQuad q, CGFloat inset);
AGKQuad AGKQuadInsetRight(AGKQuad q, CGFloat inset);
AGKQuad AGKQuadInsetTop(AGKQuad q, CGFloat inset);
AGKQuad AGKQuadInsetBottom(AGKQuad q, CGFloat inset);
AGKQuad AGKQuadMirror(AGKQuad q, BOOL x, BOOL y);
AGKQuad AGKQuadMake(CGPoint tl, CGPoint tr, CGPoint br, CGPoint bl);
AGKQuad AGKQuadMakeWithCGRect(CGRect rect);
AGKQuad AGKQuadMakeWithCGSize(CGSize size);
AGKQuad AGKQuadMakeWithPoints(CGPoint *values);
CGFloat AGKQuadGetSmallestX(AGKQuad q);
CGFloat AGKQuadGetBiggestX(AGKQuad q);
CGFloat AGKQuadGetSmallestY(AGKQuad q);
CGFloat AGKQuadGetBiggestY(AGKQuad q);
CGRect AGKQuadGetBoundingRect(AGKQuad q);
CGPoint AGKQuadGetCenter(AGKQuad q);
CGPoint AGKQuadGetCenterForSide(AGKQuad q, AGKSide side);
CGSize AGKQuadGetSize(AGKQuad q);
CGPoint AGKQuadGetPointForCorner(AGKQuad q, AGKCorner corner);
CGPoint AGKQuadGet(AGKQuad q, int cornerIndex);
AGKQuad AGKQuadModifyCorner(AGKQuad q, AGKCorner corner, CGPoint point);
AGKQuad AGKQuadModifyCornerAtIndex(AGKQuad q, int cornerIndex, CGPoint point);
void AGKQuadGetValues(AGKQuad q, CGPoint *out_values);
void AGKQuadGetXValues(AGKQuad q, CGFloat *out_values);
void AGKQuadGetYValues(AGKQuad q, CGFloat *out_values);
AGKQuad AGKQuadInterpolate(AGKQuad q1, AGKQuad q2, CGFloat progress);
AGKQuad AGKQuadRotate(AGKQuad q, CGFloat radians);
AGKQuad AGKQuadRotateAroundPoint(AGKQuad q, CGPoint point, CGFloat radians);
AGKQuad AGKQuadApplyCGAffineTransform(AGKQuad q, CGAffineTransform t);
AGKQuad AGKQuadApplyCATransform3D(AGKQuad q, CATransform3D t);
NSString * NSStringFromAGKQuad(AGKQuad q);

/**
 * @discussion
 *   It is only possible to make 'convex quadrilateral' with transforms.
 *   So make sure your quadrilateral is convex.
 *   http://upload.wikimedia.org/wikipedia/commons/f/f1/Quadrilateral_hierarchy.png
 */
CATransform3D CATransform3DWithAGKQuadFromBounds(AGKQuad q, CGRect rect);
CATransform3D CATransform3DWithAGKQuadFromRect(AGKQuad q, CGRect rect);

AGK_EXTERN_C_END

