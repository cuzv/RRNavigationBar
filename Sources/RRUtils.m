//
//  RRUtils.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/25/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "RRUtils.h"
#import <objc/runtime.h>
#import "_RRNavigationBar.h"

#pragma mark - Method Swizzle

void RRSwizzleInstanceMethod(Class _Nonnull clazz,  SEL _Nonnull originalSelector, SEL _Nonnull overrideSelector) {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method overrideMethod = class_getInstanceMethod(clazz, overrideSelector);
    
    if (class_addMethod(clazz, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        class_replaceMethod(clazz, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, overrideMethod);
    }
}

#pragma mark - Get Color

// See http://stackoverflow.com/questions/448125/how-to-get-pixel-data-from-a-uiimage-cocoa-touch-or-cgimage-core-graphics
UIColor *_Nullable _RRImageColorAtPoint(UIImage *image, CGPoint point) {
    // First get the image into your data buffer
    CGImageRef imageRef = image.CGImage;
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char *)calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData,
                                                 width,
                                                 height,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    NSUInteger byteIndex = (bytesPerRow * (int)point.y) + (int)point.x * bytesPerPixel;
    CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
    CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / alpha;
    CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / alpha;
    CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / alpha;
    
    free(rawData);
    
    return [UIColor colorWithRed:red / 255.f green:green / 255.f blue:blue / 255.f alpha:alpha];
}

UIColor *_Nullable _RRImageColor(UIImage *image) {
    return _RRImageColorAtPoint(image, CGPointMake(image.size.width * 0.5, image.size.height * 0.5));
}

#pragma mark - Compare Object

BOOL _RRObjectIsEqual(NSObject *_Nullable one, NSObject *_Nullable other) {
    if (one == other) {
        return YES;
    }
    if (one && !other) {
        return NO;
    }
    if (!one && other) {
        return NO;
    }
    if (one && other) {
        if ([one isKindOfClass:UIImage.class] && [other isKindOfClass:UIImage.class]) {
            UIColor *onColor = _RRImageColor((UIImage *)one);
            UIColor *otherColor = _RRImageColor((UIImage *)other);
            return _RRObjectIsEqual(onColor, otherColor);
        }
        if (![one isEqual:other]) {
            return NO;
        }
    }
    return YES;
}

// Do not Take `tintColor` & `shadowImage` into account.
BOOL RRIsUINavigationBarEqual(UINavigationBar *one, UINavigationBar *other) {
    if (one.barStyle != other.barStyle) {
        return NO;
    }
    
    if (one.translucent != other.translucent) {
        return NO;
    }
    
    if (!_RRObjectIsEqual(one.barTintColor, other.barTintColor)) {
        return NO;
    }
    
    UIImage *oneBackgroundImage = [one backgroundImageForBarMetrics:UIBarMetricsDefault];
    UIImage *otherBackgroundImage = [other backgroundImageForBarMetrics:UIBarMetricsDefault];
    if (!_RRObjectIsEqual(oneBackgroundImage, otherBackgroundImage)) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Duplicate UINavigationBar

UINavigationBar *_Nonnull RRUINavigationBarDuplicate(UINavigationBar *_Nonnull one) {
    UINavigationBar *bar = [_RRNavigationBar new];
    bar.barStyle = one.barStyle;
    bar.translucent = one.translucent;
    bar.tintColor = one.tintColor;
    bar.barTintColor = one.barTintColor;
    bar.backgroundColor = one.backgroundColor;
    bar.shadowImage =  one.shadowImage;
    [bar setBackgroundImage:[one backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    bar.alpha = one.alpha;
    bar.backIndicatorImage = one.backIndicatorImage;
    bar.backIndicatorTransitionMaskImage = one.backIndicatorTransitionMaskImage;
    return bar;
}
