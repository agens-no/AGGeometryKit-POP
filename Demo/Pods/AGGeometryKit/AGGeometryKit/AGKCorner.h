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
#import <UIKit/UIKit.h>

#import "AGKBaseDefines.h"

AGK_EXTERN_C_BEGIN

typedef enum AGKSide {
    AGKSideTop = 1 << 0,
    AGKSideBottom = 1 << 1,
    AGKSideLeft = 1 << 2,
    AGKSideRight = 1 << 3,
} AGKSide;

typedef enum {
    AGKCornerTopLeft = AGKSideTop | AGKSideLeft,
    AGKCornerTopRight = AGKSideTop | AGKSideRight,
    AGKCornerBottomLeft = AGKSideBottom | AGKSideLeft,
    AGKCornerBottomRight = AGKSideBottom | AGKSideRight,
} AGKCorner;

BOOL AGKCornerIsOnSide(AGKCorner corner, AGKSide side);
CGPoint AGKCornerConvertToAnchorPoint(AGKCorner corner);
CGPoint AGKCornerConvertToPointForRect(AGKCorner corner, CGRect rect);

AGK_EXTERN_C_END