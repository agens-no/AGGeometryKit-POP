//
// Author: Odd Magne Hågensen <oddmagne@agens.no>
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

#import "UIView+AGK+AngleConverter.h"
#import "CGGeometry+AGGeometryKit.h"

@implementation UIView (AngleConverter)

- (CGFloat)convertAngle:(CGFloat)angle toView:(UIView *)view
{
    CGPoint p1n = CGPointMake(0, 0);
    CGPoint p2n = CGPointMake(0, 1000);
    
    CGPoint p1r = [self convertPoint:p1n toView:view];
    CGPoint p2r = [self convertPoint:p2n toView:view];
    
    CGPoint v1 = CGPointMake(p2n.x - p1n.x, p2n.y - p1n.y);
    CGPoint v2 = CGPointMake(p2r.x - p1r.x, p2r.y - p1r.y);
    
    CGPoint v1Normalized = CGPointNormalize_AGK(v1);
    CGPoint v2Normalized = CGPointNormalize_AGK(v2);
    
    CGFloat crossZ = CGPointCrossProductZComponent_AGK(v1Normalized, v2Normalized);
    CGFloat cosAngleInRelation = CGPointDotProduct_AGK(v1Normalized, v2Normalized);
    CGFloat angleInRelation = acosf(cosAngleInRelation) + angle;
    
    if (crossZ > 0.0f)
    {
        angleInRelation = -angleInRelation;
    }
    
    return angleInRelation;
}

- (CGFloat)convertAngleOfViewInRelationToView:(UIView *)view
{
    return [self convertAngle:0.0 toView:view];
}

@end
