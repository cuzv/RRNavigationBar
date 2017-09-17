//
//  UIColor+EKExtension.m
//  Copyright (c) 2014-2016 Moch Xiao (http://mochxiao.com).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "UIColor+EKExtension.h"

typedef struct _EKRange {
    NSUInteger start;
    NSUInteger end;
} EKRange;

EKRange EKRangeMake(NSUInteger start, NSUInteger end) {
    return (EKRange){start, end};
}

NSInteger EKRandomIn(EKRange range) {
    assert(range.start < range.end);
    return arc4random_uniform((u_int32_t)(range.end - range.start)) + range.start;
}

@implementation UIColor (EKExtension)

+ (nullable instancetype)ek_random {
    return [UIColor colorWithRed:EKRandomIn(EKRangeMake(0, 255)) / 255.0f green:EKRandomIn(EKRangeMake(0, 255)) / 255.0f blue:EKRandomIn(EKRangeMake(0, 255)) / 255.0f alpha:1];
}

@end
