//
//  Helper.m
//  RRNavigationBar
//
//  Created by Shaw on 3/27/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "Helper.h"

UIImage *_Nullable RRUIImageMakeWithSize(UIColor * _Nonnull color, CGSize size) {
    UIGraphicsBeginImageContextWithOptions(size, false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (!context) {
        UIGraphicsEndImageContext();
        return nil;
    }
    CGContextRetain(context);
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, (CGRect){.origin = CGPointZero, .size = size});
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGContextRelease(context);
    
    return output;
}

UIImage *_Nullable RRUIImageMake(UIColor * _Nonnull color) {
    return RRUIImageMakeWithSize(color, CGSizeMake(1, 1));
}
