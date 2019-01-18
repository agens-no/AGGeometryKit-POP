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

#import "UIView+AGK+Properties.h"

@implementation UIView (AGGeometryKit)

- (CGSize)frameSize
{
    return self.frame.size;
}

- (void)setFrameSize:(CGSize)value
{
    CGRect rect = self.frame;
    rect.size = value;
    self.frame = rect;
}

- (CGFloat)frameWidth
{
    return self.frame.size.width;
}

- (void)setFrameWidth:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.size.width = value;
    self.frame = rect;
}

- (CGFloat)frameHeight
{
    return self.frame.size.height;
}

- (void)setFrameHeight:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.size.height = value;
    self.frame = rect;
}

- (CGSize)frameSizeHalf
{
    return CGSizeMake(self.frameWidthHalf, self.frameHeightHalf);
}

- (CGFloat)frameHeightHalf
{
    return self.frameHeight / 2.0;
}

- (CGFloat)frameWidthHalf
{
    return self.frameWidth / 2.0;
}

- (CGPoint)frameOrigin
{
    return self.frame.origin;
}

- (void)setFrameOrigin:(CGPoint)value
{
    CGRect rect = self.frame;
    rect.origin = value;
    self.frame = rect;
}

- (CGFloat)frameMinX
{
    return CGRectGetMinX(self.frame);
}

- (void)setFrameMinX:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value;
    self.frame = rect;
}

- (CGFloat)frameMinY
{
    return CGRectGetMinY(self.frame);
}

- (void)setFrameMinY:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value;
    self.frame = rect;
}

- (CGFloat)frameMidX
{
    return CGRectGetMidX(self.frame);
}

- (void)setFrameMidX:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value - (rect.size.width / 2.0);
    self.frame = rect;
}

- (CGFloat)frameMidY
{
    return CGRectGetMidY(self.frame);
}

- (void)setFrameMidY:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value - (rect.size.height / 2.0);
    self.frame = rect;
}

- (CGFloat)frameMaxX
{
    return CGRectGetMaxX(self.frame);
}

- (void)setFrameMaxX:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.x = value - rect.size.width;
    self.frame = rect;
}

- (CGFloat)frameMaxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setFrameMaxY:(CGFloat)value
{
    CGRect rect = self.frame;
    rect.origin.y = value - rect.size.height;
    self.frame = rect;
}

- (CGRect)frameAsIfNoTransformIsApplied
{
    return CGRectMake(self.layer.position.x - (self.bounds.size.width * self.layer.anchorPoint.x),
                      self.layer.position.y - (self.bounds.size.height * self.layer.anchorPoint.y),
                      self.bounds.size.width,
                      self.bounds.size.height);
}

- (CGPoint)boundsOrigin
{
    return self.bounds.origin;
}

- (void)setBoundsOrigin:(CGPoint)value
{
    CGRect rect = self.bounds;
    rect.origin = value;
    self.bounds = rect;
}

- (CGSize)boundsSize
{
    return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)value
{
    CGRect rect = self.bounds;
    rect.size = value;
    self.bounds = rect;
}

- (CGFloat)boundsWidth
{
    return self.bounds.size.width;
}

- (void)setBoundsWidth:(CGFloat)value
{
    CGRect rect = self.bounds;
    rect.size.width = value;
    self.bounds = rect;
}

- (CGFloat)boundsHeight
{
    return self.bounds.size.height;
}

- (void)setBoundsHeight:(CGFloat)value
{
    CGRect rect = self.bounds;
    rect.size.height = value;
    self.bounds = rect;
}

- (CGFloat)boundsHeightHalf
{
    return self.boundsHeight / 2.0;
}

- (CGFloat)boundsWidthHalf
{
    return self.boundsWidth / 2.0;
}

- (CGSize)boundsSizeHalf
{
    return CGSizeMake(self.boundsWidthHalf, self.boundsHeightHalf);
}

- (CGPoint)boundsCenter
{
    return CGPointMake(self.boundsWidthHalf, self.boundsHeightHalf);
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)value
{
    self.center = CGPointMake(value, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)value
{
    self.center = CGPointMake(self.center.x, value);
}

@end
