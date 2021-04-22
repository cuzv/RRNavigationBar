//
//  UIView+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Shaw on 9/17/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "UIView+RRNavigationBar_Internal.h"
#import "_RRUtils.h"
#import <objc/runtime.h>

@implementation UIView (RRNavigationBar_Internal)

#ifdef __IPHONE_11_0

+ (void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            RRSwizzleInstanceMethod(self.class, @selector(setHidden:), @selector(_rr_setHidden:));
        });
    }
}

- (void)_rr_setHidden:(BOOL)hidden {
    if (@available(iOS 11.0, *)) {
        id clazz = NSClassFromString(@"_UIBarBackground");
        if (clazz && [self isKindOfClass:clazz] && self._rr_ignoreSetHiddenMessage) {
            return;
        }
    }
    [self _rr_setHidden:hidden];
}

- (BOOL)_rr_ignoreSetHiddenMessage {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_rr_ignoreSetHiddenMessage:(BOOL)_rr_ignoreSetHiddenMessage {
    objc_setAssociatedObject(self, @selector(_rr_ignoreSetHiddenMessage), @(_rr_ignoreSetHiddenMessage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#endif

- (BOOL)_rr_clipsToBounds {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_rr_clipsToBounds:(BOOL)_rr_clipsToBounds {
    objc_setAssociatedObject(self, @selector(_rr_clipsToBounds), @(_rr_clipsToBounds), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end


#ifdef __IPHONE_11_0

@implementation UIScrollView (RRNavigationBar_Internal)

- (UIScrollViewContentInsetAdjustmentBehavior)_rr_contentInsetAdjustmentBehavior {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)set_rr_contentInsetAdjustmentBehavior:(UIScrollViewContentInsetAdjustmentBehavior)_rr_contentInsetAdjustmentBehavior {
    objc_setAssociatedObject(self, @selector(_rr_contentInsetAdjustmentBehavior), @(_rr_contentInsetAdjustmentBehavior), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

#endif
