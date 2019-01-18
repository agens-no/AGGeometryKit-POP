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

#import <UIKit/UIKit.h>

@interface UIView (AGGeometryKit)

@property (nonatomic, assign) CGSize frameSize;
@property (nonatomic, readonly) CGSize frameSizeHalf;
@property (nonatomic, readonly) CGFloat frameWidthHalf;
@property (nonatomic, readonly) CGFloat frameHeightHalf;

@property (nonatomic, assign) CGPoint frameOrigin;
@property (nonatomic, assign) CGFloat frameMinX;
@property (nonatomic, assign) CGFloat frameMinY;
@property (nonatomic, assign) CGFloat frameMidX;
@property (nonatomic, assign) CGFloat frameMidY;
@property (nonatomic, assign) CGFloat frameMaxX;
@property (nonatomic, assign) CGFloat frameMaxY;
@property (nonatomic, assign) CGFloat frameWidth;
@property (nonatomic, assign) CGFloat frameHeight;

@property (nonatomic, readonly) CGRect frameAsIfNoTransformIsApplied;

@property (nonatomic, assign) CGPoint boundsOrigin;
@property (nonatomic, assign) CGSize boundsSize;
@property (nonatomic, assign) CGFloat boundsWidth;
@property (nonatomic, assign) CGFloat boundsHeight;

@property (nonatomic, readonly) CGPoint boundsCenter;
@property (nonatomic, readonly) CGSize boundsSizeHalf;
@property (nonatomic, readonly) CGFloat boundsWidthHalf;
@property (nonatomic, readonly) CGFloat boundsHeightHalf;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
