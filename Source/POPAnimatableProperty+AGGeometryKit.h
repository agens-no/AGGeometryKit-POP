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

#import <POP/POP.h>

extern NSString * const kPOPLayerAGKQuadTopLeft;
extern NSString * const kPOPLayerAGKQuadTopLeftX;
extern NSString * const kPOPLayerAGKQuadTopLeftY;

extern NSString * const kPOPLayerAGKQuadTopRight;
extern NSString * const kPOPLayerAGKQuadTopRightX;
extern NSString * const kPOPLayerAGKQuadTopRightY;

extern NSString * const kPOPLayerAGKQuadBottomLeft;
extern NSString * const kPOPLayerAGKQuadBottomLeftX;
extern NSString * const kPOPLayerAGKQuadBottomLeftY;

extern NSString * const kPOPLayerAGKQuadBottomRight;
extern NSString * const kPOPLayerAGKQuadBottomRightX;
extern NSString * const kPOPLayerAGKQuadBottomRightY;

@interface POPAnimatableProperty (AGK_POP)

+ (instancetype)AGKPropertyWithName:(NSString *)aName;

@end
