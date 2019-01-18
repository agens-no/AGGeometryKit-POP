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
#import <GLKit/GLKit.h>
#import "GLKit/GLKVector3.h"
#import "AGKBaseDefines.h"

AGK_EXTERN_C_BEGIN

struct AGKVector3D {
    CGFloat x;
    CGFloat y;
    CGFloat z;
};
typedef struct AGKVector3D AGKVector3D;

extern const AGKVector3D AGKVector3DZero;

AGKVector3D AGKVector3DMake(CGFloat x, CGFloat y, CGFloat z);
AGKVector3D AGKVector3DWithGLKVector3(GLKVector3);
CGFloat AGKVector3DGetLength(AGKVector3D v);
AGKVector3D AGKVector3DAdd(AGKVector3D v1, AGKVector3D v2);
AGKVector3D AGKVector3DSubtract(AGKVector3D v1, AGKVector3D v2);
AGKVector3D AGKVector3DNegate(AGKVector3D v);
AGKVector3D AGKVector3DNormalize(AGKVector3D v);
CGFloat AGKVector3DDotProduct(AGKVector3D v1, AGKVector3D v2);
AGKVector3D AGKVector3DCrossProduct(AGKVector3D v1, AGKVector3D v2);
AGKVector3D AGKVector3DGetTriangleNormal(AGKVector3D v1, AGKVector3D v2, AGKVector3D v3);
AGKVector3D AGKVector3DPositionFromTransform(CATransform3D m);
AGKVector3D AGKVector3DApplyTransform(AGKVector3D vector, CATransform3D m);
AGKVector3D AGKVector3DApplyTransformWithNoTranslate(AGKVector3D vector, CATransform3D m);

AGK_EXTERN_C_END

