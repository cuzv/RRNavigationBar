//
//  UIView+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 9/17/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UIView+RRNavigationBar_internal.h"
#import "RRUtils.h"
#import <objc/runtime.h>

@implementation UIView (RRNavigationBar)

#ifdef __IPHONE_11_0
+ (void)load {
    if (@available(iOS 11.0, *)) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            RRSwizzleInstanceMethod(self.class, @selector(setHidden:), @selector(_rr_setHidden:));
        });
    }
}
#endif

- (void)_rr_setHidden:(BOOL)hidden {
    id clazz = NSClassFromString(@"_UIBarBackground");
    if (clazz && [self isKindOfClass:clazz] && self._rr_ignoreSetHiddenMessage) {
        return;
    }
    [self _rr_setHidden:hidden];
}

- (BOOL)_rr_ignoreSetHiddenMessage {
    return [objc_getAssociatedObject(self, @selector(_rr_ignoreSetHiddenMessage)) boolValue];
}

- (void)set_rr_ignoreSetHiddenMessage:(BOOL)_rr_ignoreSetHiddenMessage {
    objc_setAssociatedObject(self, @selector(_rr_ignoreSetHiddenMessage), @(_rr_ignoreSetHiddenMessage), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
