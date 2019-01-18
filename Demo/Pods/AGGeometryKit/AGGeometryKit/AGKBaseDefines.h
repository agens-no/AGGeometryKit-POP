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


#ifndef AGKBaseDefines
#define AGKBaseDefines

// The C++ compiler mangles C function names. extern "C" { /* your C functions */ } prevents this.
// You should wrap all C function prototypes declared in headers with ASDISPLAYNODE_EXTERN_C_BEGIN/END, even if
// they are included only from .m (Objective-C) files. It's common for .m files to start using C++
// features and become .mm (Objective-C++) files. Always wrapping the prototypes with
// AGK_EXTERN_C_BEGIN/END will save someone a headache once they need to do this. You do not need to
// wrap constants, only C functions. See StackOverflow for more details:
// http://stackoverflow.com/questions/1041866/in-c-source-what-is-the-effect-of-extern-c
#ifdef __cplusplus
# define AGK_EXTERN_C_BEGIN extern "C" {
# define AGK_EXTERN_C_END   }
#else
# define AGK_EXTERN_C_BEGIN
# define AGK_EXTERN_C_END
#endif

#endif
