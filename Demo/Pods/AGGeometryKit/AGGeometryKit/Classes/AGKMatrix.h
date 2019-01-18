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

#import <Foundation/Foundation.h>
//#import "AGKVector3D.h"

@interface AGKMatrix : NSObject

#pragma mark Creating and Initializing a Matrix
///-----------------------------------------------------------------------------
/// @name Creating and Initializing a Matrix
///-----------------------------------------------------------------------------

/**
*  Creates and returns an empty matrix.
*
*  @return A new empty matrix.
*/
+ (instancetype)matrix;

/**
 *  Creates and returns a matrix sized for the given column and row dimensions.
 *
 *  @param columnCount Number of columns in desired matrix.
 *  @param rowCount    Number of rows in desired matrix.
 *
 *  @return A new matrix initialized with the specified dimensions.
 */
+ (instancetype)matrixWithColumns:(NSUInteger)columnCount rows:(NSUInteger)rowCount;

/**
 *  Creates and returns a matrix from the given array of columns.
 *
 *  @param columns An array of column member arrays with which to initialize the
 *  matrix.
 *
 *  @return A new matrix initialized with the specified columns.
 */
+ (instancetype)matrixWithColumns:(NSArray *)columns;

/**
 *  Creates and returns a matrix from the given array of rows.
 *
 *  @param rows An array of row member arrays with which to initialize the 
 *  matrix.
 *
 *  @return A new matrix initialized with the specified rows.
 */
+ (instancetype)matrixWithRows:(NSArray *)rows;

/**
 *  Creates and returns a matrix containing the members and dimensions from 
 *  another given matrix.
 *
 *  @param otherMatrix A matrix containing the members and dimensions with which
 *  to initialize the new matrix.
 *
 *  @return A new matrix containing the members found in `otherMatrix`, and 
 *  sized to match `otherMatrix`.
 */
+ (instancetype)matrixWithMatrix:(AGKMatrix *)otherMatrix;

/**
 *  Initialized a newly allocated matrix with the given column and row 
 *  dimensions, and filled with the given members.
 *  
 *  This method is the designated initializer of AGKMatrix.
 *  
 *  The `members` parameter should be ordered as if to fill columns first.
 *  So if you were to want to create the following 3x4 (column x row) matrix:
 *
 *  |   |   |   |
 *  |:-:|:-:|:-:|
 *  | 0 | 1 | 2 |
 *  | 0 | 1 | 3 |
 *  | 0 | 1 | 4 |
 *  | 0 | 1 | 5 |
 *
 *  You would pass the following `members` array:
 *  `@[@0, @0, @0, @0, @1, @1, @1, @1, @2, @3, @4, @5]`
 *  
 *  Or in the other direction (4x3):
 *
 *  |   |   |   |   |
 *  |:-:|:-:|:-:|:-:|
 *  | 2 | 3 | 4 | 5 |
 *  | 1 | 1 | 1 | 1 |
 *  | 0 | 0 | 0 | 0 |
 *
 *  The `members` array would look like:
 *  `@[@2, @1, @0, @3, @1, @0, @4, @1, @0, @5, @1, @0]`
 *
 *  @param columnCount Number of columns in desired matrix.
 *  @param rowCount    Number of rows in desired matrix.
 *  @param members     An array containing the members for the new matrix, 
 *  sorted as a column first list.
 *
 *  @return An initialized matrix containing the specified members in the 
 *  specified dimensions.
 */
- (instancetype)initWithColumns:(NSUInteger)columnCount rows:(NSUInteger)rowCount members:(NSArray *)members; // Designated Initializer

#pragma mark - Comparing Matrices
///-----------------------------------------------------------------------------
/// @name Comparing Matrices
///-----------------------------------------------------------------------------

/**
 *  Compares the receiving matrix to another matrix.
 *
 *  @param otherMatrix The matrix to compare against.
 *
 *  @return `YES` if the contents of `otherMatrix` are equal to the contents of 
 *  the receiving matrix, otherwise `NO`.
 */
- (BOOL)isEqualToMatrix:(AGKMatrix *)otherMatrix;

#pragma mark Counting Entries
///-----------------------------------------------------------------------------
/// @name Counting Entries
///-----------------------------------------------------------------------------

/**
 *  The total number of members in the matrix.
 *
 * @see columnCount
 * @see rowCount
 */
@property (nonatomic, assign, readonly) NSUInteger count;

/**
 *  The number of columns in the matrix.
 *
 *  @warning Be very careful if you need to subclass this method, it is one of the
 *  essential methods, and is used to scale the underlying data if a new column
 *  is needed. Always call super.
 *
 * @see count
 * @see rowCount
 */
@property (nonatomic, assign, readonly) NSUInteger columnCount;

/**
 *  The number of rows in the matrix.
 *
 *  @warning Be very careful if you need to subclass this method, it is one of the
 *  essential methods, and is used to scale the underlying data if a new row
 *  is needed. Always call super.
 *
 * @see count
 * @see columnCount
 */
@property (nonatomic, assign, readonly) NSUInteger rowCount;

#pragma mark Member Management
///-----------------------------------------------------------------------------
/// @name Member Management
///-----------------------------------------------------------------------------

/**
 *  The number returned if no other member has been specified at a column/row
 *  coordinate.
 *
 *  Defaults to `@0`.
 *
 *  When the matrix is expanded, the new column or row is automatically set to
 *  return whatever number is in this property at the time the member is
 *  requested.
 *
 *  @see objectAtColumnIndex:rowIndex
 */
@property (nonatomic, copy) NSNumber *defaultMember;

/**
 *  Restores all members to their default placeholder value, keeping the matrix 
 *  at the same dimensions.
 *
 *  @param defaultValue The number object that all members should return. If 
 *  `nil` the existing `defaultMember` will be used.
 *
 *  @see defaultMember
 */
- (void)resetMatrixToDefault:(NSNumber *)defaultValue;

#pragma mark Accessing Members, Columns and Rows
///-----------------------------------------------------------------------------
/// @name Accessing Members, Columns and Rows
///-----------------------------------------------------------------------------

/**
 *  Returns a new array containing all columns as arrays of numbers.
 *
 * @see rows
 */
@property (nonatomic, strong, readonly) NSArray *columns;

/**
 *  Returns a new array containing all rows as arrays of numbers.
 *
 * @see columns
 */
@property (nonatomic, strong, readonly) NSArray *rows;

/**
 *  Returns the member associated with a given column and row.
 *
 *  This is an essential method. Most other member access methods pipe through
 *  this one in order to take advantage of column/row translation and default
 *  member substitution.
 *
 *  @param column The column index number at which the member is stored.
 *  @param row    The row index number at which the member is stored.
 *
 *  @return The number object associated with the specified column and row. Or
 *  `defaultMember` if no other number has been provided. Returns nil if `row`
 *  or `column` are beyond the matrix's bounds.
 *
 *  @see setObject:atColumnIndex:rowIndex:
 *  @see objectAtIndexedSubscript:
 *  @see defaultMember
 */
- (NSNumber *)objectAtColumnIndex:(NSUInteger)column rowIndex:(NSUInteger)row;

/**
 *  Returns an array of the members associated with the given column.
 *
 *  @param columnIndex The column index at which the members are stored.
 *
 *  @return An array of the number objects associated with the specified column.
 *
 *  @see rowAtIndex:
 */
- (NSArray *)columnAtIndex:(NSUInteger)columnIndex;

/**
 *  Returns an array of the members associated with the given row.
 *
 *  @param rowIndex The row index at which the members are stored.
 *
 *  @return An array of the number objects associated with the specified row.
 *
 *  @see columnAtIndex:
 */
- (NSArray *)rowAtIndex:(NSUInteger)rowIndex;

/**
 *  Returns the member at a given absolute index, as if the matrix was a flat
 *  list ordered in column priority.
 *
 *  The way the matrix members are accessed in this method is similar to how
 *  they are passed in the `members` parameter in
 *  `initWithColumns:rows:members:`.
 *
 *  This method is primarily used for enumeration, and is included to provide
 *  subscripting support.
 *
 *  @param index The absolute index of the desired member.
 *
 *  @return The number object associated with the specified index.
 *
 *  @see objectAtColumnIndex:rowIndex:
 *  @see initWithColumns:rows:members:
 */
- (NSNumber *)objectAtIndexedSubscript:(NSUInteger)index;

/**
 *  Executes a given block using each member in the matrix, sorted by column 
 *  priority and continuing through to matrix to the last member.
 *
 *  @param block The block to apply to members in the matrix.
 *
 *  The block takes five arguments:
 *
 *      *member*
 *      > The member in the matrix.
 *
 *      *index*
 *      > The absolute index where the member is located.
 *
 *      *columnIndex*
 *      > The column index where the member is located.
 *
 *      *rowIndex*
 *      > The row index where the member is located.
 *
 *      *stop*
 *      > A reference to a Boolean value. The block can set the value to
 *  YES to stop further processing of the matrix. The stop argument is an
 *  out-only argument. You should only ever set this Boolean to YES within the 
 *  Block.
 *
 *  @see enumerateColumnsUsingBlock:
 *  @see enumerateRowsUsingBlock:
 */
- (void)enumerateMembersUsingBlock:(void (^)(NSNumber *member, NSUInteger index, NSUInteger columnIndex, NSUInteger rowIndex, BOOL *stop))block;

/**
 *  Executes a given block using each column in the matrix. Columns are 
 *  collected into arrays of members, and provided column by column to the last 
 *  column array.
 *
 *  @param block The block to apply to the columns in the matrix.
 *
 *  The block takes three arguments:
 *
 *      *column*
 *      > The array of members in the current column of the matrix.
 *
 *      *columnIndex*
 *      > The column index number.
 *
 *      *stop*
 *      > A reference to a Boolean value. The block can set the value to
 *  YES to stop further processing of the matrix. The stop argument is an
 *  out-only argument. You should only ever set this Boolean to YES within the
 *  Block.
 *
 *  @see enumerateRowsUsingBlock:
 *  @see enumerateMembersUsingBlock:
 */
- (void)enumerateColumnsUsingBlock:(void (^)(NSArray *column, NSUInteger columnIndex, BOOL *stop))block;

/**
 *  Executes a given block using each row in the matrix. Rows are
 *  collected into arrays of members, and provided row by row to the last
 *  row array.
 *
 *  @param block The block to apply to the rows in the matrix.
 *
 *  The block takes three arguments:
 *
 *      *row*
 *      > The array of members in the current row of the matrix.
 *
 *      *rowIndex*
 *      > The row index number.
 *
 *      *stop*
 *      > A reference to a Boolean value. The block can set the value to
 *  YES to stop further processing of the matrix. The stop argument is an
 *  out-only argument. You should only ever set this Boolean to YES within the
 *  Block.
 *
 *  @see enumerateColumnsUsingBlock:
 *  @see enumerateMembersUsingBlock:
 */
- (void)enumerateRowsUsingBlock:(void (^)(NSArray *row, NSUInteger rowIndex, BOOL *stop))block;

#pragma mark Adding Members, Columns and Rows
///-----------------------------------------------------------------------------
/// @name Adding Members, Columns and Rows
///-----------------------------------------------------------------------------

/**
 *  Adds a member to the matrix at the given column, row location.
 *
 *  This is an essential method. Most other matrix modification methods pipe
 *  through this one in order to take advantage of column/row translation and
 *  matrix expansion.
 *
 *  @param object The number to add as a new member of the matrix.
 *  @param column The column index at which to insert the member.
 *  @param row    The row index at which to insert the member.
 *
 *  @see objectAtColumnIndex:rowIndex:
 */
- (void)setObject:(NSNumber *)object atColumnIndex:(NSUInteger)column rowIndex:(NSUInteger)row;

/**
 *  Adds or replaces the given column with members from the given array.
 *
 *  If the `columnMembers` array is shorter than the current `rowCount`, then
 *  the remainder positions will be filled with the default placeholder.
 *  Conversely if the `columnMembers` array is longer than the current
 *  `rowCount`, then the matrix will expand to the new column size, and all
 *  other columns will fill remaining spots with the default placeholder.
 *
 *  @param columnIndex   The column index where the new `columnMembers` should
 *  be placed.
 *  @param columnMembers The array of number object to become the specified
 *  column.
 *
 *  @see setRowAtIndex:withArray:
 *  @see fillColumn:withObject:
 *  @see setObject:atColumnIndex:rowIndex:
 */
- (void)setColumnAtIndex:(NSUInteger)columnIndex withArray:(NSArray *)columnMembers;

/**
 *  Adds or replaces the given row with members from the given array.
 *
 *  If the `rowMembers` array is shorter than the current `columnCount`, then
 *  the remainder positions will be filled with the default placeholder.
 *  Conversely if the `rowMembers` array is longer than the current
 *  `columnCount`, then the matrix will expand to the new row size, and all
 *  other rows will fill remaining spots with the default placeholder.
 *
 *  @param rowIndex   The row index where the new `columnMembers` should be
 *  placed.
 *  @param rowMembers The array of number objects to become the specified row.
 *
 *  @see setColumnAtIndex:withArray:
 *  @see fillRow:withObject:
 *  @see setObject:atColumnIndex:rowIndex:
 */
- (void)setRowAtIndex:(NSUInteger)rowIndex withArray:(NSArray *)rowMembers;

/**
 *  Inserts a column at the given index filled with the given members.
 *
 *  @param columnIndex   The column index number where the new column should be 
 *  inserted.
 *  @param columnMembers The array of number objects to be inserted as a new 
 *  column.
 */
- (void)insertColumnAtIndex:(NSUInteger)columnIndex withArray:(NSArray *)columnMembers;

/**
 *  Inserts a row at the given index filled with the given members.
 *
 *  @param rowIndex   The row index number where the new row should be inserted.
 *  @param rowMembers The array of number objects to be inserted as a new row.
 */
- (void)insertRowAtIndex:(NSUInteger)rowIndex withArray:(NSArray *)rowMembers;

/**
 *  Replaces the given column's rows with the given member.
 *
 *  If no column exists at the given index, that column will be added, and the
 *  matrix expanded.
 *
 *  @param columnIndex   The column index to be replaced by the new member.
 *  @param initialMember The number object that should fill in all rows of the
 *  specified column.
 *
 *  @see fillRow:withObject:
 *  @see setColumnAtIndex:withArray:
 *  @see setObject:atColumnIndex:rowIndex:
 */
- (void)fillColumn:(NSUInteger)columnIndex withObject:(NSNumber *)initialMember;

/**
 *  Replaces the given row's columns with the given number.
 *
 *  If no row exists at the given index, that row will be added, and the matrix
 *  expanded.
 *
 *  @param rowIndex      The row index to be replaced by the new member.
 *  @param initialMember The number object that should fill in all columns of
 *  the specified row.
 *
 *  @see fillColumn:withObject:
 *  @see setRowAtIndex:withArray:
 *  @see setObject:atColumnIndex:rowIndex:
 */
- (void)fillRow:(NSUInteger)rowIndex withObject:(NSNumber *)initialMember;

/**
 *  Adds or replaces the matrix member at the given absolute index.
 *
 *  The way the matrix members are added in this method is similar to how they
 *  are passed in the `members` parameter of `initWithColumns:rows:members:`.
 *
 *  This method is primarily used for enumeration, and is included to provide
 *  subscripting support.
 *
 *  @param object The number object to become a new matrix member.
 *  @param index  The absolute index at which the specified member should be
 *  placed.
 *
 *  @see objectAtIndexedSubscript:
 *  @see setObject:atColumnIndex:rowIndex:
 *  @see initWithColumns:rows:members:
 */
- (void)setObject:(NSNumber *)object atIndexedSubscript:(NSUInteger)index;

#pragma mark Rearranging Members
///-----------------------------------------------------------------------------
/// @name Rearranging Members
///-----------------------------------------------------------------------------

/**
 *  Exchanges the members in the matrix at the given column/row locations.
 *
 *  @param firstColumnIndex  The column index at which the first member is
 *  stored.
 *  @param firstRowIndex     The row index at which the first member is stored.
 *  @param secondColumnIndex The column index at which the second member is
 *  stored.
 *  @param secondRowIndex    The row index at which the second member is stored.
 */
- (void)exchangeMemberAtColumn:(NSUInteger)firstColumnIndex row:(NSUInteger)firstRowIndex withColumn:(NSUInteger)secondColumnIndex row:(NSUInteger)secondRowIndex;

/**
 *  Reorient the matrix so columns become rows, and rows become columns.
 *
 *  If the matrix's dimensions are not equal, the sizes are swapped. For example
 *  if your matrix is 3x4, it will become a 4x3 matrix after this method.
 *
 *  @return Returns the matrix after transposing for chaining purposes.
 */
- (AGKMatrix *)transpose;

#pragma mark Deriving New Matrices
///-----------------------------------------------------------------------------
/// @name Deriving New Matrices
///-----------------------------------------------------------------------------

/**
 *  Returns a new matrix containing the receiving matrix's members that fall
 *  within the column and row limits given.
 *
 *  The receiver's members are flattened into a single array with column
 *  priority, then passed into the new matrix.
 *
 *  If the specified columns or rows are larger than the receiver, the remaining
 *  slots will be filled with the default placeholder.
 *
 *  @param columns The number of columns in the desired matrix.
 *  @param rows    The number of rows in the desired matrix.
 *
 *  @return A new matrix with the specified columns and rows dimensions, and
 *  filled with the receiver's members as much as possible.
 *
 *  @see matrixWithColumnSize:rowSize:andTranspose:
 *  @see matrixWithColumns:rows:
 */
- (AGKMatrix *)matrixWithColumnSize:(NSUInteger)columns rowSize:(NSUInteger)rows;

/**
 *  Returns a new matrix containing the receiving matrix's members that fall
 *  within the column and row limits given. Then transposed if desired.
 *
 *  The receiver's members are flattened into a single array with column 
 *  priority, then passed into the new matrix.
 *
 *  If `transpose` is `YES` the resulting matrix will be transposed, turning 
 *  columns into rows.
 *
 *  If the specified columns or rows are larger than the receiver, the remaining
 *  slots will be filled with the default placeholder.
 *
 *  @param columns   The number of columns in the desired matrix.
 *  @param rows      The number of rows in the desired matrix.
 *  @param transpose If `YES`, members are copied in a row first manner,
 *  otherwise they are copied as column first.
 *
 *  @return A New matrix with the specified columns and rows dimensions, and
 *  filled with the receiver's members as much as possible.
 *
 *  @see matrixWithColumnSize:rowSize:
 *  @see transpose
 */
- (AGKMatrix *)matrixWithColumnSize:(NSUInteger)columns rowSize:(NSUInteger)rows andTranspose:(BOOL)transpose;

/**
 *  Returns a matrix of the same size as the recipient, but filled with 
 *  cofactors of each of the receiver's members.
 *
 *  @return A matrix filled with cofactor members, or `nil` if matrix is not 
 *  square.
 *
 *  @see cofactorAtColumn:row:
 *  @see determinant
 *  @see adjointMatrix
 */
- (AGKMatrix *)cofactorMatrix;

/**
 *  Returns the adjoint matrix of the receiver.
 *
 *  An adjoint matrix is the same as a cofactor matrix, but transposed.
 *
 *  @return The adjoint matrix of the receiver, or `nil` if matrix is not 
 *  square.
 *
 *  @see cofactorMatrix
 *  @see transpose
 */
- (AGKMatrix *)adjointMatrix;

/**
 *  Returns the inverse matrix of the receiver.
 *
 *  An inverse matrix is defined by the fact that when multiplied by the 
 *  original matrix, you will get an identity matrix in return.
 *
 *  @return A new matrix that is the inverse of the receiver, or `nil` if the 
 *  matrix is not square.
 */
- (AGKMatrix *)inverseMatrix;

/**
 *  Returns a new matrix from multiplying the receiver by the given matrix.
 *
 *  @param otherMatrix The matrix to multiply against.
 *
 *  @return A new matrix that is the result of multiplying the two matrices.
 */
- (AGKMatrix *)matrixByMultiplyingWithMatrix:(AGKMatrix *)otherMatrix;

#pragma mark Matrix Operations
///-----------------------------------------------------------------------------
/// @name Matrix Operations
///-----------------------------------------------------------------------------

/**
 *  Multiply the matrix by a given number.
 *
 *  @param multiplier The number to multiply the matrix by.
 */
- (void)multiplyByNumber:(NSNumber *)multiplier;

/**
 *  Returns the determinant of a square matrix.
 *
 *  If the matrix is not square, method will return `nil`.
 *
 *  @return The determinant of the receiver matrix, or `nil` if no determinant 
 *  is available.
 *
 *  @see cofactorMatrix
 */
- (NSNumber *)determinant;

/**
 *  Returns the matrix cofactor at a given location.
 *
 *  @param columnIndex The column index with which to calculate the cofactor.
 *  @param rowIndex    The row index with which to calculation the cofactor
 *
 *  @return The cofactor calculated from the specified column and row location. 
 *  Or `nil` if matrix isn't square.
 *
 *  @see cofactorMatrix
 *  @see determinant
 */
- (NSNumber *)cofactorAtColumn:(NSUInteger)columnIndex row:(NSUInteger)rowIndex;

/**
 *  Executes a Givens rotation on the given rows, for the given cos*θ* and
 *  sin*θ*.
 *
 *  @param firstRow  The first row index on which to apply the givens rotation.
 *  @param secondRow The second row index on which to apply the givens rotation.
 *  @param cosine    The cos*θ* number to use during rotation.
 *  @param sine      The sin*θ* number to use during rotation.
 */
- (void)performGivensRotationOnRow:(NSUInteger)firstRow andRow:(NSUInteger)secondRow withCosine:(NSNumber *)cosine sine:(NSNumber *)sine;


@end
