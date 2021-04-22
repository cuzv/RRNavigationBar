//
//  _RRUtils.m
//  RRNavigationBar
//
//  Created by Shaw on 3/25/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "_RRUtils.h"
#import <objc/runtime.h>
#import "_RRNavigationBar.h"

#pragma mark - Method Swizzle

 inline void RRSwizzleInstanceMethod(Class _Nonnull clazz,  SEL _Nonnull originalSelector, SEL _Nonnull overrideSelector) {
    Method originalMethod = class_getInstanceMethod(clazz, originalSelector);
    Method overrideMethod = class_getInstanceMethod(clazz, overrideSelector);
    if (overrideMethod && overrideMethod) {
        if (class_addMethod(clazz, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
            class_replaceMethod(clazz, overrideSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, overrideMethod);
        }
    }
}

#pragma mark - Compare Object

BOOL _RRObjectIsEqual(NSObject *_Nullable one, NSObject *_Nullable other) {
    if (one == other) {
        return YES;
    }
    if ((one && !other) || (!one && other)) {
        return NO;
    }
    if (one && other) {
        if ([one isKindOfClass:UIImage.class] && [other isKindOfClass:UIImage.class]) {
            UIImage *oneImage = (UIImage *)one;
            UIImage *otherImage = (UIImage *)other;
            return [UIImagePNGRepresentation(oneImage) isEqual:UIImagePNGRepresentation(otherImage)];
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
    bar.alpha = one.alpha;
    bar.tintColor = one.tintColor;
    bar.barTintColor = one.barTintColor;
    bar.backgroundColor = one.backgroundColor;
    bar.shadowImage =  one.shadowImage;
    [@[
        @(UIBarMetricsDefault),
        @(UIBarMetricsCompact),
        @(UIBarMetricsCompactPrompt),
        @(UIBarMetricsDefaultPrompt)
    ] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [bar setBackgroundImage:[one backgroundImageForBarMetrics:[obj integerValue]] forBarMetrics:[obj integerValue]];
    }];
    bar.backIndicatorImage = one.backIndicatorImage;
    bar.backIndicatorTransitionMaskImage = one.backIndicatorTransitionMaskImage;
    bar.titleTextAttributes = one.titleTextAttributes;
    if (@available(iOS 11.0, *)) {
        bar.largeTitleTextAttributes = one.largeTitleTextAttributes;
    }
#ifdef __IPHONE_14_0
    bar.items = @[[[UINavigationItem alloc] initWithTitle:@""]];
#endif
    return bar;
}
