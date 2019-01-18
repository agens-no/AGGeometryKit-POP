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

#import "AGKMatrix+GLKit.h"

@implementation AGKMatrix (GLKit)

+ (instancetype)matrixWithGLKMatrix2:(GLKMatrix2)glkMatrix
{
	AGKMatrix *myself = [(AGKMatrix *)[self alloc] initWithColumns:2 rows:2 members:nil];
	for (NSUInteger memberIndex = 0; memberIndex < (2 * 2); memberIndex++)
    {
		myself[memberIndex] = @(glkMatrix.m[memberIndex]);
	}
	
	return myself;
}

+ (instancetype)matrixWithGLKMatrix3:(GLKMatrix3)glkMatrix
{
	AGKMatrix *myself = [(AGKMatrix *)[self alloc] initWithColumns:3 rows:3 members:nil];
	for (NSUInteger memberIndex = 0; memberIndex < (3 * 3); memberIndex++)
    {
		myself[memberIndex] = @(glkMatrix.m[memberIndex]);
	}
	
	return myself;
}

+ (instancetype)matrixWithGLKMatrix4:(GLKMatrix4)glkMatrix
{
	AGKMatrix *myself = [(AGKMatrix *)[self alloc] initWithColumns:4 rows:4 members:nil];
	for (NSUInteger memberIndex = 0; memberIndex < (4 * 4); memberIndex++)
    {
		myself[memberIndex] = @(glkMatrix.m[memberIndex]);
	}
	
	return myself;
}

- (GLKMatrix2)glkMatrix2Value
{
    GLKMatrix2 glkMatrix = { 0, 0,  0, 0 };
	
	for (NSUInteger absoluteIndex = 0; absoluteIndex < (2 * 2); absoluteIndex++)
    {
		double mValue;
		if (absoluteIndex < self.count)
        {
			mValue = [self[absoluteIndex] floatValue];
		}
        else
        {
			mValue = [self.defaultMember floatValue];
		}
		
		glkMatrix.m[absoluteIndex] = mValue;
	}
	
	return glkMatrix;
}

- (GLKMatrix3)glkMatrix3Value
{
    GLKMatrix3 glkMatrix = { 0, 0, 0,  0, 0, 0,  0, 0, 0 };
	
	for (NSUInteger absoluteIndex = 0; absoluteIndex < (3 * 3); absoluteIndex++)
    {
		double mValue;
		if (absoluteIndex < self.count)
        {
			mValue = [self[absoluteIndex] floatValue];
		}
        else
        {
			mValue = [self.defaultMember floatValue];
		}
		
		glkMatrix.m[absoluteIndex] = mValue;
	}
	
	return glkMatrix;
}

- (GLKMatrix4)glkMatrix4Value
{
    GLKMatrix4 glkMatrix = { 0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0,  0, 0, 0, 0 };
	
	for (NSUInteger absoluteIndex = 0; absoluteIndex < (4 * 4); absoluteIndex++)
    {
		double mValue;
		if (absoluteIndex < self.count)
        {
			mValue = [self[absoluteIndex] floatValue];
		}
        else
        {
			mValue = [self.defaultMember floatValue];
		}
		
		glkMatrix.m[absoluteIndex] = mValue;
	}
	
	return glkMatrix;
}

@end
