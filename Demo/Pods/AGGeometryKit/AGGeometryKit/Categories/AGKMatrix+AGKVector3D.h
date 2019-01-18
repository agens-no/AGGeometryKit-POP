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

#import "AGKMatrix.h"
#import "AGKVector3D.h"

@interface AGKMatrix (AGKVector3D)

/**
 *  Creates and returns a 1x3 matrix containing the members and from the given 
 *  vector.
 *
 *  @param vector The vector with which to initialize the matrix's members.
 *
 *  @return A new matrix containing the values found in `vector`
 */
+ (instancetype)matrixWithVector3D:(AGKVector3D)vector;

/**
 *  Returns a matrix multiplied by the given 3D vector.
 *
 *  @param vector The vector to multiply against.
 *
 *  @return A 1x3 matrix resulting from multiplying the receiver with the
 *  specified vector.
 */
- (AGKMatrix *)matrixByMultiplyingWithVector3D:(AGKVector3D)vector;

- (AGKVector3D)agkVector3DValue;

@end
