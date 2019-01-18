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

#import "NSValue+AGKQuad.h"

@implementation NSValue (AGKQuad)

+ (NSValue *)valueWithAGKQuad:(AGKQuad)q
{
    CGFloat values[8];
    for(int i = 0; i < 4; i++)
    {
        CGPoint p = AGKQuadGet(q, i);
        values[(i*2)] = p.x;
        values[(i*2)+1] = p.y;
    }
    NSValue *value = [NSValue value:&q withObjCType:@encode(CGFloat[8])];
    return value;
}

- (AGKQuad)AGKQuadValue
{
    CGPoint points[4];
    CGFloat values[8];
    [self getValue:values];
    for(int i = 0; i < 4; i++)
    {
        CGPoint p = CGPointMake(values[(i*2)], values[(i*2)+1]);
        points[i] = p;
    }
    return AGKQuadMakeWithPoints(points);
}

@end
