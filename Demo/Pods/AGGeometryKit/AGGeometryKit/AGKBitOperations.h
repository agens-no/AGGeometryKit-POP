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

// For general purpose

#ifndef AGK_BIT_ENABLE
# define AGK_BIT_ENABLE(x, b)   ((x) |= (b))
#endif

#ifndef AGK_BIT_CLEAR
# define AGK_BIT_CLEAR(x, b) ((x) &= ~(b))
#endif

#ifndef AGK_BIT_TEST_ENABLED
# define AGK_BIT_TEST_ENABLED(x, b)  (((x) & (b)) != 0)
#endif

#ifndef AGK_BIT_TEST_DISABLED
# define AGK_BIT_TEST_DISABLED(x, b)  (((x) & (b)) == 0)
#endif

#ifndef AGK_BIT_TEST_ALL_ENABLED
# define AGK_BIT_TEST_ALL_ENABLED(x, b)  ({\
     __typeof__(b) __b = (b);\
     ((x) & __b) == __b;\
  })
#endif

// For NS_OPTION

#ifndef NS_OPTION_ENABLE
# define NS_OPTION_ENABLE(x, b)   ((x) |= (b))
#endif

#ifndef NS_OPTION_CLEAR
# define NS_OPTION_CLEAR(x, b) ((x) &= ~(b))
#endif

#ifndef NS_OPTION_ENABLED
# define NS_OPTION_ENABLED(x, b)  (((x) & (b)) != 0)
#endif

#ifndef NS_OPTION_DISABLED
# define NS_OPTION_DISABLED(x, b)  (((x) & (b)) == 0)
#endif

#ifndef NS_OPTION_ALL_ENABLED
# define NS_OPTION_ALL_ENABLED(x, b)  ({\
     __typeof__(b) __b = (b);\
     ((x) & __b) == __b;\
  })
#endif

