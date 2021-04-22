//
//  _RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Shaw on 3/27/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "_RRNavigationBar.h"
#import "UINavigationBar+RRNavigationBar_Internal.h"

#ifndef RRSetNumber
#   define RRSetNumber(value) \
        if (self.value != value && \
            self._rr_holder.isViewLoaded && \
            self._rr_holder.view.window) { \
                self._rr_holder.navigationController.navigationBar.value = value; \
        } \
        super.value = value;
#endif

#ifndef RRSetObject
#   define RRSetObject(obj) \
        if (![self.obj isEqual:obj] && \
            self._rr_holder.isViewLoaded && \
            self._rr_holder.view.window) { \
            self._rr_holder.navigationController.navigationBar.obj = obj; \
        } \
        super.obj = obj;
#endif

#ifndef RRSetImage
#   define RRSetImage(image) \
        if (!_RRObjectIsEqual(self.image, image) && \
            self._rr_holder.isViewLoaded && \
            self._rr_holder.view.window) { \
            self._rr_holder.navigationController.navigationBar.image = image; \
        } \
        super.image = image;
#endif

#ifndef RRAssignObject
#   define RRAssignObject(obj) \
        if (self._rr_tmpInfo) { \
            self._rr_tmpInfo[@#obj] = obj; \
        }
#endif

#ifndef RRAssignNumber
#   define RRAssignNumber(value) \
        if (self._rr_tmpInfo) { \
            self._rr_tmpInfo[@#value] = @(value); \
        }
#endif

extern BOOL _RRObjectIsEqual(NSObject *_Nullable one, NSObject *_Nullable other);

@implementation _RRNavigationBar

- (void)setBarStyle:(UIBarStyle)barStyle {
    RRSetNumber(barStyle);
    RRAssignNumber(barStyle);
}

- (void)setTranslucent:(BOOL)translucent {
    RRSetNumber(translucent);
    RRAssignNumber(translucent);
}

- (void)setAlpha:(CGFloat)alpha {
    RRSetNumber(alpha);
    RRAssignNumber(alpha);
}

- (void)setTintColor:(UIColor *)tintColor {
    RRSetObject(tintColor);
    RRAssignObject(tintColor);
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    RRSetObject(barTintColor);
    RRAssignObject(barTintColor);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    RRSetObject(backgroundColor);
    RRAssignObject(backgroundColor);
}

- (void)setShadowImage:(UIImage *)shadowImage {
    RRSetImage(shadowImage);
    RRAssignObject(shadowImage);
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics {
    if (!_RRObjectIsEqual([self backgroundImageForBarMetrics:barMetrics], backgroundImage) &&
        self._rr_holder.isViewLoaded &&
        self._rr_holder.view.window) {
        [self._rr_holder.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    }
    [super setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    RRAssignObject(backgroundImage);
}

- (void)setBackIndicatorImage:(UIImage *)backIndicatorImage {
    RRSetImage(backIndicatorImage);
    RRAssignObject(backIndicatorImage);
}

- (void)setBackIndicatorTransitionMaskImage:(UIImage *)backIndicatorTransitionMaskImage {
    RRSetImage(backIndicatorTransitionMaskImage);
    RRAssignObject(backIndicatorTransitionMaskImage);
}

- (void)setTitleTextAttributes:(NSDictionary<NSAttributedStringKey,id> *)titleTextAttributes {
    RRSetObject(titleTextAttributes);
    RRAssignObject(titleTextAttributes);
}

#ifdef __IPHONE_11_0
- (void)layoutSubviews {
    [super layoutSubviews];
    // force navigation bar's background image container view's height equal to navigation bar.
    // iOS 11 will needs this hack.
    if (@available(iOS 11.0, *)) {
        self._rr_backgroundView.frame = self.bounds;
    }
}
#endif

@end
