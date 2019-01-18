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

#import "AGKVector3D.h"
#import <QuartzCore/QuartzCore.h>

const AGKVector3D AGKVector3DZero = { 0, 0, 0 };

AGKVector3D AGKVector3DMake(CGFloat x, CGFloat y, CGFloat z)
{
    AGKVector3D vector;
    vector.x = x;
    vector.y = y;
    vector.z = z;
    return vector;
}

CGFloat AGKVector3DGetLength(AGKVector3D v)
{
    return sqrtf(v.x * v.x + v.y * v.y + v.z * v.z);
}

AGKVector3D AGKVector3DAdd(AGKVector3D v1, AGKVector3D v2)
{
    return AGKVector3DMake(v1.x + v2.x, v1.y + v2.y, v1.z + v2.z);
}

AGKVector3D AGKVector3DSubtract(AGKVector3D v1, AGKVector3D v2)
{
    return AGKVector3DMake(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z);
}

AGKVector3D AGKVector3DNegate(AGKVector3D v)
{
    return AGKVector3DMake(-v.x, -v.y, -v.z);
}

AGKVector3D AGKVector3DNormalize(AGKVector3D v)
{
    CGFloat length = AGKVector3DGetLength(v);
    if(length != 0.0)
    {
        v.x /= length;
        v.y /= length;
        v.z /= length;
    }
    return v;
}

CGFloat AGKVector3DDotProduct(AGKVector3D v1, AGKVector3D v2)
{
    return (v1.x * v2.x + v1.y * v2.y + v1.z * v2.z);
}

AGKVector3D AGKVector3DCrossProduct(AGKVector3D v1, AGKVector3D v2)
{
    return AGKVector3DMake(v1.y * v2.z - v1.z * v2.y,
                          v1.z * v2.x - v1.x * v2.z,
                          v1.x * v2.y - v1.y * v2.x);
}

AGKVector3D AGKVector3DForGLKVector3(GLKVector3 vec)
{
#if defined(__STRICT_ANSI__)
    return AGKVector3DMake(vec.v[0], vec.v[1], vec.v[2]);
#else
    return AGKVector3DMake(vec.x, vec.y, vec.z);
#endif
}

AGKVector3D AGKVector3DGetTriangleNormal(AGKVector3D v1, AGKVector3D v2, AGKVector3D v3)
{
    AGKVector3D edge1 = AGKVector3DSubtract(v1, v2);
    AGKVector3D edge2 = AGKVector3DSubtract(v1, v3);
    AGKVector3D surfaceNormal = AGKVector3DCrossProduct(edge1, edge2);    
    return surfaceNormal;
}

AGKVector3D AGKVector3DPositionFromTransform(CATransform3D m)
{
    return AGKVector3DMake(m.m41, m.m42, m.m43);
}

AGKVector3D AGKVector3DApplyTransform(AGKVector3D vector, CATransform3D m)
{
    AGKVector3D p;

    p.x = (m.m11 * vector.x + m.m21 * vector.y + m.m31 * vector.z + m.m41);
    p.y = (m.m12 * vector.x + m.m22 * vector.y + m.m32 * vector.z + m.m42);
    p.z = (m.m13 * vector.x + m.m23 * vector.y + m.m33 * vector.z + m.m43);

    return p;
}

AGKVector3D AGKVector3DApplyTransformWithNoTranslate(AGKVector3D vector, CATransform3D m)
{
    AGKVector3D p;

    p.x = (m.m11 * vector.x + m.m21 * vector.y + m.m31 * vector.z);
    p.y = (m.m12 * vector.x + m.m22 * vector.y + m.m32 * vector.z);
    p.z = (m.m13 * vector.x + m.m23 * vector.y + m.m33 * vector.z);

    return p;
}
