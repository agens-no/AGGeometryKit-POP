//
// Authors:
// Logan Holmes @snown
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

#import "AGKMatrix+CATransform3D.h"

@interface NSNumber (AGKCGFloat)
- (CGFloat)CGFloatValue;
@end

@implementation NSNumber (AGKCGFloat)

- (CGFloat)CGFloatValue
{
    if (CGFLOAT_IS_DOUBLE)
    {
        return (CGFloat)[self doubleValue];
    }
    else
    {
        return (CGFloat)[self floatValue];
    }
}

@end

@implementation AGKMatrix (CATransform3D)

+ (instancetype)matrixWithCATransform3D:(CATransform3D)transform
{
    AGKMatrix *myself = [(AGKMatrix *)[self alloc] initWithColumns:4 rows:4 members:nil];
    myself[0] = @(transform.m11);
    myself[1] = @(transform.m12);
    myself[2] = @(transform.m13);
    myself[3] = @(transform.m14);
    myself[4] = @(transform.m21);
    myself[5] = @(transform.m22);
    myself[6] = @(transform.m23);
    myself[7] = @(transform.m24);
    myself[8] = @(transform.m31);
    myself[9] = @(transform.m32);
    myself[10] = @(transform.m33);
    myself[11] = @(transform.m34);
    myself[12] = @(transform.m41);
    myself[13] = @(transform.m42);
    myself[14] = @(transform.m43);
    myself[15] = @(transform.m44);
    
    return myself;
}

- (CATransform3D)caTransform3DValue
{
    CATransform3D transform = CATransform3DIdentity;
    if (self.columnCount > 2 && self.rowCount > 2)
    {
        AGKMatrix *internalMatrix;
        if (self.columnCount == 3 || self.rowCount == 3)
        {
            NSUInteger columnCount = self.columnCount;
            NSUInteger rowCount = self.rowCount;
            
            internalMatrix = [AGKMatrix matrixWithMatrix:self];
            internalMatrix.defaultMember = @0;
            if (columnCount == 3)
            {
                [internalMatrix insertColumnAtIndex:2 withArray:nil];
            }
            if (rowCount == 3)
            {
                [internalMatrix insertRowAtIndex:2 withArray:nil];
            }
            
            [internalMatrix setObject:@1 atColumnIndex:2 rowIndex:2];
        }
        else
        {
            internalMatrix = self;
        }
        
        transform.m11 = [internalMatrix[0] CGFloatValue];
        transform.m12 = [internalMatrix[1] CGFloatValue];
        transform.m13 = [internalMatrix[2] CGFloatValue];
        transform.m14 = [internalMatrix[3] CGFloatValue];
        transform.m21 = [internalMatrix[4] CGFloatValue];
        transform.m22 = [internalMatrix[5] CGFloatValue];
        transform.m23 = [internalMatrix[6] CGFloatValue];
        transform.m24 = [internalMatrix[7] CGFloatValue];
        transform.m31 = [internalMatrix[8] CGFloatValue];
        transform.m32 = [internalMatrix[9] CGFloatValue];
        transform.m33 = [internalMatrix[10] CGFloatValue];
        transform.m34 = [internalMatrix[11] CGFloatValue];
        transform.m41 = [internalMatrix[12] CGFloatValue];
        transform.m42 = [internalMatrix[13] CGFloatValue];
        transform.m43 = [internalMatrix[14] CGFloatValue];
        transform.m44 = [internalMatrix[15] CGFloatValue];
    }
    
    return transform;
}

@end
