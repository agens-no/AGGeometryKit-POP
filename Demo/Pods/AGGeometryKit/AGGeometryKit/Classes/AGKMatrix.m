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

@interface AGKMatrix ()
@property (nonatomic, assign) NSUInteger columnCount;
@property (nonatomic, assign) NSUInteger rowCount;

@property (nonatomic, strong) NSMutableArray *members;
@end

typedef NS_ENUM(NSUInteger, AGKMatrixDimension) {
    AGKMatrixDimensionColumn = 0,
    AGKMatrixDimensionRow,
};

@implementation AGKMatrix
#pragma mark - Creating and Initializing a Matrix

+ (instancetype)matrix {
	return [(AGKMatrix *)[self alloc] initWithColumns:0 rows:0 members:nil];
}

+ (instancetype)matrixWithColumns:(NSUInteger)columnCount rows:(NSUInteger)rowCount {
	return [(AGKMatrix *)[self alloc] initWithColumns:columnCount rows:rowCount members:nil];
}

+ (instancetype)matrixWithColumns:(NSArray *)columns {
    NSMutableArray *members = [NSMutableArray array];
    NSUInteger rowCount = 0;
    for (NSArray *column in columns) {
        rowCount = MAX(rowCount, column.count);
        [members addObjectsFromArray:column];
    }
    return [(AGKMatrix *)[self alloc] initWithColumns:columns.count rows:rowCount members:members];
}

+ (instancetype)matrixWithRows:(NSArray *)rows {
    NSUInteger columnCount = 0;
    for (NSArray *row in rows) {
        columnCount = MAX(columnCount, row.count);
    }
    
    NSMutableArray *members = [NSMutableArray array];
    for (NSUInteger columnIndex = 0; columnIndex < columnCount ; columnIndex++) {
        for (NSArray *row in rows) {
            [members addObject:row[columnIndex]];
        }
    }
    
    return [(AGKMatrix *)[self alloc] initWithColumns:columnCount rows:rows.count members:members];
}

+ (instancetype)matrixWithMatrix:(AGKMatrix *)otherMatrix {
	return [(AGKMatrix *)[self alloc] initWithColumns:otherMatrix.columnCount rows:otherMatrix.rowCount members:otherMatrix.members];
}

- (instancetype)initWithColumns:(NSUInteger)columnCount rows:(NSUInteger)rowCount members:(NSArray *)members {
	self = [super init];
	if (self) {
		_columnCount = columnCount;
		_rowCount = rowCount;
		if (members) {
			_members = [NSMutableArray arrayWithArray:members];
		}
	}
	
	return self;
}

- (instancetype)init
{
    return [self initWithColumns:0 rows:0 members:nil];
}

#pragma mark - Comparing Matrices

- (BOOL)isEqualToMatrix:(AGKMatrix *)otherMatrix {
    BOOL result = NO;
    
    if ([otherMatrix isKindOfClass:[AGKMatrix class]]) {
        result = YES;
        
        if (otherMatrix.columnCount != self.columnCount) {
            result = NO;
        }
        
        if (otherMatrix.rowCount != self.rowCount) {
            result = NO;
        }
        
        if (![[otherMatrix allMembers] isEqualToArray:[self allMembers]]) {
            result = NO;
        }
    }
    
    return result;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else {
        return [self isEqualToMatrix:other];
    }
}

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

- (NSUInteger)hash {
    return NSUINTROTATE(self.columnCount, NSUINT_BIT / 2) ^ self.rowCount ^ [[self allMembers] hash];
}


#pragma mark - Describing the Matrix
- (NSString *)description {
    NSMutableString *result = [NSMutableString stringWithFormat:@"<%@ %lux%lu>[\n", NSStringFromClass([self class]), (unsigned long)self.columnCount, (unsigned long)self.rowCount];
    
    for (int rowIndex = 0; rowIndex < self.rowCount; rowIndex++) {
        NSArray *row = [self rowAtIndex:rowIndex];
        [result appendFormat:@"%@\n", [row componentsJoinedByString:@", "]];
    }
    [result appendString:@"]"];
    
    return result;
}

#pragma mark - Counting Entries

- (NSUInteger)count {
	return self.columnCount * self.rowCount;
}

- (void)setColumnCount:(NSUInteger)columnCount {
    if (_columnCount != columnCount) {
        [self willChangeValueForKey:@"columnCount"];
        
		if (columnCount > _columnCount) {
			for (; _columnCount < columnCount; _columnCount++) {
				for (NSUInteger rowIndex = 0; rowIndex < self.rowCount; rowIndex++) {
					NSUInteger absoluteIndex = ((_columnCount * self.rowCount) + rowIndex);
					if (absoluteIndex < self.members.count) {
						[self.members insertObject:[NSNull null] atIndex:absoluteIndex];
					} else {
						for (NSUInteger newIndex = self.members.count; newIndex <= absoluteIndex; newIndex++) {
							[self.members addObject:[NSNull null]];
						}
					}
				}
			}
		}
		
        _columnCount = columnCount;
        
        [self didChangeValueForKey:@"columnCount"];
    }
}

- (void)setRowCount:(NSUInteger)rowCount {
    if (_rowCount != rowCount) {
        [self willChangeValueForKey:@"rowCount"];
        
		if (rowCount > _rowCount) {
			for (; _rowCount < rowCount; _rowCount++) {
				for (NSUInteger columnIndex = 0; columnIndex < self.columnCount; columnIndex++) {
					NSUInteger absoluteIndex = ((columnIndex * _rowCount) + (_rowCount + columnIndex));
					if (absoluteIndex < self.members.count) {
						[self.members insertObject:[NSNull null] atIndex:absoluteIndex];
					} else {
						for (NSUInteger newIndex = self.members.count; newIndex <= absoluteIndex; newIndex++) {
							[self.members addObject:[NSNull null]];
						}
					}
				}
			}
		}
		
        _rowCount = rowCount;
        
        [self didChangeValueForKey:@"rowCount"];
    }
}

#pragma mark - Member Management

- (NSNumber *)defaultMember {
	if (_defaultMember == nil) {
		_defaultMember = @0;
	}
	
	return [_defaultMember copy];
}

- (void)resetMatrixToDefault:(NSNumber *)defaultValue {
    if (defaultValue != nil) {
        self.defaultMember = defaultValue;
    }
	self.members = nil;
}

#pragma mark - Accessing Members, Columns and Rows

- (NSArray *)columns {
	return [self getDimension:AGKMatrixDimensionColumn];
}

- (NSArray *)rows {
	return [self getDimension:AGKMatrixDimensionRow];
}

- (NSNumber *)objectAtColumnIndex:(NSUInteger)column rowIndex:(NSUInteger)row {
	return [self objectAtColumnIndex:column rowIndex:row withDefaults:YES];
}

- (NSArray *)columnAtIndex:(NSUInteger)columnIndex {
	NSArray *resultColumn = nil;
	
	NSArray *columns = [self getDimension:AGKMatrixDimensionColumn withRange:NSMakeRange(columnIndex, 1)];
	if (columns && columns.count > 0) {
		resultColumn = [columns firstObject];
	}
	
	return resultColumn;
}

- (NSArray *)rowAtIndex:(NSUInteger)rowIndex {
	NSArray *resultRow = nil;
	
	NSArray *rows = [self getDimension:AGKMatrixDimensionRow withRange:NSMakeRange(rowIndex, 1)];
	if (rows && rows.count > 0) {
		resultRow = [rows firstObject];
	}
	
	return resultRow;
}

- (NSNumber *)objectAtIndexedSubscript:(NSUInteger)index {
	return [self objectAtColumnIndex:(index / self.rowCount) rowIndex:(index % self.rowCount)];
}

- (void)enumerateMembersUsingBlock:(void (^)(NSNumber *member, NSUInteger index, NSUInteger columnIndex, NSUInteger rowIndex, BOOL *stop))block {
	BOOL stop = NO;
	
	for (NSUInteger rowIndex = 0; rowIndex < self.rowCount; rowIndex++) {
		if (stop == YES) {
			break;
		} else {
			for (NSUInteger columnIndex = 0; columnIndex < self.columnCount; columnIndex++) {
				if (stop == YES) {
					break;
				} else {
					NSUInteger absoluteIndex = ((columnIndex * self.rowCount) + rowIndex);
					block([self objectAtColumnIndex:columnIndex rowIndex:rowIndex], absoluteIndex, columnIndex, rowIndex, &stop);
				}
			}
		}
	}
}

- (void)enumerateColumnsUsingBlock:(void (^)(NSArray *column, NSUInteger columnIndex, BOOL *stop))block {
	BOOL stop = NO;
	
	NSArray *allColumns = self.columns;
	for (NSUInteger columnIndex = 0; columnIndex < allColumns.count; columnIndex++) {
		if (stop == YES) {
			break;
		} else {
			block(allColumns[columnIndex], columnIndex, &stop);
		}
	}
}

- (void)enumerateRowsUsingBlock:(void (^)(NSArray *row, NSUInteger rowIndex, BOOL *stop))block {
	BOOL stop = NO;
	
	NSArray *allRows = self.rows;
	for (NSUInteger rowIndex = 0; rowIndex < allRows.count; rowIndex++) {
		if (stop == YES) {
			break;
		} else {
			block(allRows[rowIndex], rowIndex, &stop);
		}
	}
}


#pragma mark Private
- (NSNumber *)objectAtColumnIndex:(NSUInteger)column rowIndex:(NSUInteger)row withDefaults:(BOOL)giveDefaults {
	id result = nil;
	
	NSUInteger memberIndex = (column * self.rowCount) + row;
	if (memberIndex < self.members.count) {
		result = [self.members objectAtIndex:memberIndex];
	} else if (memberIndex < (self.columnCount * self.rowCount)) {
		// If the matrix is big enough to hold the specified value, but that
		// value has not been set, setup to return default member value.
		result = [NSNull null];
	}
	
	if (giveDefaults && result == [NSNull null]) {
		result = [self.defaultMember copyWithZone:NULL];
	}
	
	
	return result;
}

- (NSArray *)allMembers {
    NSMutableArray *allMembers = [NSMutableArray arrayWithCapacity:self.count];
    for (NSUInteger index = 0; index < self.count; index++) {
        NSNumber *number = self[index];
        NSAssert(number != nil, @"Found unexpected nil");
        [allMembers addObject:number];
    }
    
    return allMembers;
}

- (NSArray *)getDimension:(AGKMatrixDimension)dimension {
	NSUInteger majorCount = (dimension == AGKMatrixDimensionColumn) ? self.columnCount : self.rowCount;
	
	return [self getDimension:dimension withRange:NSMakeRange(0, majorCount) andDefaults:YES];
}

- (NSArray *)getDimension:(AGKMatrixDimension)dimension withRange:(NSRange)dimensionRange {
	return [self getDimension:dimension withRange:dimensionRange andDefaults:YES];
}

- (NSArray *)getDimension:(AGKMatrixDimension)dimension withRange:(NSRange)dimensionRange andDefaults:(BOOL)giveDefaults {
	NSArray *result = nil;
	
	NSUInteger majorCount = (dimension == AGKMatrixDimensionColumn) ? self.columnCount : self.rowCount;
	majorCount = MIN(majorCount, (dimensionRange.location + dimensionRange.length));
	
	NSUInteger minorCount = (dimension == AGKMatrixDimensionColumn) ? self.rowCount : self.columnCount;
	
	if (majorCount > 0 && minorCount > 0) {
		NSMutableArray *majorCollection = [NSMutableArray arrayWithCapacity:majorCount];
		
		for (NSUInteger majorIndex = dimensionRange.location; majorIndex < majorCount; majorIndex++) {
			NSMutableArray *minorCollection = [NSMutableArray arrayWithCapacity:minorCount];
			for (NSUInteger minorIndex = 0; minorIndex < minorCount; minorIndex++) {
				[minorCollection addObject:[self objectAtColumnIndex:((dimension == AGKMatrixDimensionColumn) ? majorIndex : minorIndex)
															rowIndex:((dimension == AGKMatrixDimensionColumn) ? minorIndex : majorIndex) withDefaults:giveDefaults]];
			}
			[majorCollection addObject:[NSArray arrayWithArray:minorCollection]];
		}
		
		if (majorCollection && majorCollection.count > 0) {
			result = [NSArray arrayWithArray:majorCollection];
		}
	}
	
	return result;
}

#pragma mark - Adding Members, Columns and Rows

- (void)setObject:(NSNumber *)object atColumnIndex:(NSUInteger)column rowIndex:(NSUInteger)row {
	self.columnCount = MAX(self.columnCount, column + 1);
	self.rowCount = MAX(self.rowCount, row + 1);
	
	NSUInteger memberIndex = (column * self.rowCount) + row;
	if (memberIndex >= self.members.count) {
		for (NSUInteger memberCount = self.members.count; memberCount <= memberIndex; memberCount++) {
			[self.members addObject:[NSNull null]]; // Used as "unfilled" space holders
		}
	}
	
	[self.members replaceObjectAtIndex:memberIndex withObject:object];
}

// TODO: Add test for nil members
- (void)setColumnAtIndex:(NSUInteger)columnIndex withArray:(NSArray *)columnMembers {
	if (!columnMembers) {
        columnMembers = @[];
    }
    
	for (NSUInteger rowIndex = 0; rowIndex < MAX(columnMembers.count, self.rowCount); rowIndex++) {
		id member = nil;
		if (rowIndex < columnMembers.count) {
			member = columnMembers[rowIndex];
		} else {
			member = [NSNull null];
		}
		
		[self setObject:member atColumnIndex:columnIndex rowIndex:rowIndex];
	}
}

// TODO: Add test for nil members
- (void)setRowAtIndex:(NSUInteger)rowIndex withArray:(NSArray *)rowMembers {
    if (!rowMembers) {
        rowMembers = @[];
    }
	
	for (NSUInteger columnIndex = 0; columnIndex < MAX(rowMembers.count, self.columnCount); columnIndex++) {
		id member = nil;
		if (columnIndex < rowMembers.count) {
			member = rowMembers[columnIndex];
		} else {
			member = [NSNull null];
		}
		
		[self setObject:member atColumnIndex:columnIndex rowIndex:rowIndex];
	}
}

- (void)insertColumnAtIndex:(NSUInteger)columnIndex withArray:(NSArray *)columnMembers {
    if (columnIndex < self.columnCount) {
        for (NSUInteger reverseColumnIndex = self.columnCount; reverseColumnIndex > columnIndex; reverseColumnIndex--) {
            NSArray *currentColumn = [[self getDimension:AGKMatrixDimensionColumn withRange:NSMakeRange(reverseColumnIndex - 1, 1) andDefaults:NO] firstObject];
            [self setColumnAtIndex:reverseColumnIndex withArray:currentColumn];
        }
    }
    
    [self setColumnAtIndex:columnIndex withArray:columnMembers];
}

- (void)insertRowAtIndex:(NSUInteger)rowIndex withArray:(NSArray *)rowMembers {
    if (rowIndex < self.rowCount) {
        for (NSUInteger reverseRowIndex = self.rowCount; reverseRowIndex > rowIndex; reverseRowIndex--) {
            NSArray *currentRow = [[self getDimension:AGKMatrixDimensionRow withRange:NSMakeRange(reverseRowIndex - 1, 1) andDefaults:NO] firstObject];
            [self setRowAtIndex:reverseRowIndex withArray:currentRow];
        }
    }
    
    [self setRowAtIndex:rowIndex withArray:rowMembers];
}

- (void)fillColumn:(NSUInteger)columnIndex withObject:(NSNumber *)initialMember {
    for (NSUInteger rowIndex = 0; rowIndex < self.rowCount; rowIndex++) {
        [self setObject:initialMember atColumnIndex:columnIndex rowIndex:rowIndex];
    }
}

- (void)fillRow:(NSUInteger)rowIndex withObject:(NSNumber *)initialMember {
	for (NSUInteger columnIndex = 0; columnIndex < self.columnCount; columnIndex++) {
		[self setObject:initialMember atColumnIndex:columnIndex rowIndex:rowIndex];
	}
}

- (void)setObject:(NSNumber *)obj atIndexedSubscript:(NSUInteger)index {
	[self setObject:obj atColumnIndex:(index / self.rowCount) rowIndex:(index % self.rowCount)];
}

#pragma mark Private

- (void)addColumnWithMembers:(NSArray *)columnMembers {
    [self setColumnAtIndex:self.columnCount withArray:columnMembers];
}

- (void)addRowWithMembers:(NSArray *)rowMembers {
    [self setRowAtIndex:self.rowCount withArray:rowMembers];
}

#pragma mark - Rearranging Members

- (void)exchangeMemberAtColumn:(NSUInteger)firstColumnIndex row:(NSUInteger)firstRowIndex withColumn:(NSUInteger)secondColumnIndex row:(NSUInteger)secondRowIndex {
	NSNumber *member1 = [self objectAtColumnIndex:firstColumnIndex rowIndex:firstRowIndex withDefaults:NO];
	NSNumber *member2 = [self objectAtColumnIndex:secondColumnIndex rowIndex:secondRowIndex withDefaults:NO];
	
	[self setObject:member1 atColumnIndex:secondColumnIndex rowIndex:secondRowIndex];
	[self setObject:member2 atColumnIndex:firstColumnIndex rowIndex:firstRowIndex];
}

- (AGKMatrix *)transpose {
	NSArray *allRows = [self getDimension:AGKMatrixDimensionRow withRange:NSMakeRange(0, self.count) andDefaults:NO];
	self.members = nil;
	self.rowCount = 0;
	self.columnCount = 0;
	
	for (NSUInteger columnIndex = 0; columnIndex < allRows.count; columnIndex++) {
		[self setColumnAtIndex:columnIndex withArray:allRows[columnIndex]];
	}
    
    return self;
}

#pragma mark - Deriving New Matrices

- (AGKMatrix *)matrixWithColumnSize:(NSUInteger)columns rowSize:(NSUInteger)rows {
	return [self matrixWithColumnSize:columns rowSize:rows andTranspose:NO];
}

- (AGKMatrix *)matrixWithColumnSize:(NSUInteger)columns rowSize:(NSUInteger)rows andTranspose:(BOOL)transpose {
    NSArray *rawColumns = [self getDimension:AGKMatrixDimensionColumn withRange:NSMakeRange(0, self.columnCount) andDefaults:NO];
    NSMutableArray *allMembers = [NSMutableArray arrayWithCapacity:self.count];
    for (NSArray *column in rawColumns) {
        [allMembers addObjectsFromArray:column];
    }
    
    AGKMatrix *resultMatrix = [[AGKMatrix alloc] initWithColumns:columns rows:rows members:[allMembers subarrayWithRange:NSMakeRange(0, MIN((columns * rows), self.count))]];
    
    if (transpose) {
        [resultMatrix transpose];
    }
    
    return resultMatrix;
}

- (AGKMatrix *)cofactorMatrix {
    if (self.columnCount != self.rowCount) {
        return nil;
    }
    
    AGKMatrix *cofactorMatrix = [AGKMatrix matrix];
    for (NSUInteger columnIndex = 0; columnIndex < self.columnCount; columnIndex++) {
        for (NSUInteger rowIndex = 0; rowIndex < self.rowCount; rowIndex++) {
            NSNumber *cofactor = [self cofactorAtColumn:columnIndex row:rowIndex];
            [cofactorMatrix setObject:cofactor atColumnIndex:columnIndex rowIndex:rowIndex];
        }
    }
    
    return cofactorMatrix;
}

- (AGKMatrix *)adjointMatrix {
    if (self.columnCount != self.rowCount) {
        return nil;
    }
    
    AGKMatrix *matrix = [self cofactorMatrix];
    [matrix transpose];
    
    return matrix;
}

- (AGKMatrix *)inverseMatrix {
    if (self.columnCount != self.rowCount) {
        return nil;
    }
    
    double determinant = [[self determinant] doubleValue];
    AGKMatrix *matrix = [self adjointMatrix];
    [matrix multiplyByNumber:@(1.0 / determinant)];
    
    return matrix;
}

- (AGKMatrix *)matrixByMultiplyingWithMatrix:(AGKMatrix *)otherMatrix {
    if (self.columnCount != otherMatrix.rowCount) {
        return nil;
    }
    
    AGKMatrix *matrix = [AGKMatrix matrix];
    
    for (NSUInteger rowIndex = 0; rowIndex < self.rowCount; rowIndex++) {
        for (NSUInteger otherColumnIndex = 0; otherColumnIndex < otherMatrix.columnCount; otherColumnIndex++) {
            double member = 0.0;
            for (NSUInteger memberIndex = 0; memberIndex < self.columnCount; memberIndex++) {
                    member += [[self objectAtColumnIndex:memberIndex rowIndex:rowIndex] doubleValue] * [[otherMatrix objectAtColumnIndex:otherColumnIndex rowIndex:memberIndex] doubleValue];
            }
            [matrix setObject:@(member) atColumnIndex:otherColumnIndex rowIndex:rowIndex];
        }
    }
    
    return matrix;
}

#pragma mark Private

- (AGKMatrix *)matrixByDeletingColumn:(NSUInteger)columnIndex {
    AGKMatrix *resultMatrix = [[AGKMatrix alloc] initWithColumns:0 rows:0 members:nil];
    
    [self enumerateColumnsUsingBlock:^(NSArray *column, NSUInteger innerColumnIndex, BOOL *stop) {
        if (innerColumnIndex != columnIndex) {
            [resultMatrix addColumnWithMembers:column];
        }
    }];
    
    return resultMatrix;
}

- (AGKMatrix *)matrixByDeletingRow:(NSUInteger)rowIndex {
    AGKMatrix *resultMatrix = [[AGKMatrix alloc] initWithColumns:0 rows:0 members:nil];
    
    [self enumerateRowsUsingBlock:^(NSArray *row, NSUInteger innerRowIndex, BOOL *stop) {
        if (innerRowIndex != rowIndex) {
            [resultMatrix addRowWithMembers:row];
        }
    }];
    
    return resultMatrix;
}

#pragma mark - Matrix Operations

- (void)multiplyByNumber:(NSNumber *)multiplier {
    [self enumerateMembersUsingBlock:^(NSNumber *member, NSUInteger index, NSUInteger columnIndex, NSUInteger rowIndex, BOOL *stop) {
        [self setObject:@([member doubleValue] * [multiplier doubleValue]) atColumnIndex:columnIndex rowIndex:rowIndex];
    }];
}

- (NSNumber *)determinant {
    if (self.rowCount != self.columnCount) {
        return nil;
    }
    
    if (self.rowCount == 2 && self.columnCount == 2) {
        return @(([self[0] doubleValue] * [self[3] doubleValue]) - ([self[1] doubleValue] * [self[2] doubleValue]));
    } else {
        double determinant = 0.0;
        
        NSArray *row = [self rowAtIndex:0];
        AGKMatrix *matrix = [self matrixByDeletingRow:0];
        for (NSUInteger columnIndex = 0; columnIndex < self.columnCount; columnIndex++) {
            AGKMatrix *subMatrix = [matrix matrixByDeletingColumn:columnIndex];
            double subDeterminant = [[subMatrix determinant] doubleValue];
            double columnDeterminant = [[row objectAtIndex:columnIndex] doubleValue] * subDeterminant;
            if (columnIndex % 2 == 1) {
                columnDeterminant *= -1.0;
            }
            
            determinant += columnDeterminant;
        }
        
        return @(determinant);
    }
}

- (NSNumber *)cofactorAtColumn:(NSUInteger)columnIndex row:(NSUInteger)rowIndex {
    if (self.rowCount != self.columnCount) {
        return nil;
    }
    
    AGKMatrix *matrix = [[self matrixByDeletingColumn:columnIndex] matrixByDeletingRow:rowIndex];
    double cofactorSign = (columnIndex % 2) == 1 ? -1.0 : 1.0;
    cofactorSign *= (rowIndex % 2) == 1 ? -1.0 : 1.0;
    NSNumber *determinant = [matrix determinant];
    
    return @(cofactorSign * [determinant doubleValue]);
}

- (void)performGivensRotationOnRow:(NSUInteger)firstRow andRow:(NSUInteger)secondRow withCosine:(NSNumber *)cosine sine:(NSNumber *)sine {
	double dCosine = [cosine doubleValue];
	double dSine = [sine doubleValue];
	
	for (NSUInteger colIndex = 0; colIndex < self.columnCount; colIndex++) {
		double t0 = ([[self objectAtColumnIndex:colIndex rowIndex:firstRow] doubleValue] * dCosine) + ([[self objectAtColumnIndex:colIndex rowIndex:secondRow] doubleValue] * dSine);
		double t1 = ([[self objectAtColumnIndex:colIndex rowIndex:secondRow] doubleValue] * dCosine) - ([[self objectAtColumnIndex:colIndex rowIndex:firstRow] doubleValue] * dSine);
		[self setObject:@(t0) atColumnIndex:colIndex rowIndex:firstRow];
		[self setObject:@(t1) atColumnIndex:colIndex rowIndex:secondRow];
	}
}

#pragma mark - Private

- (NSMutableArray *)members {
	if (!_members) {
		[self willChangeValueForKey:@"members"];
		_members = [NSMutableArray array];
		[self didChangeValueForKey:@"members"];
	}
	
	return _members;
}

@end
