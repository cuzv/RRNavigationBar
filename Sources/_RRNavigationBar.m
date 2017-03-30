//
//  _RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/27/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "_RRNavigationBar.h"
#import "UINavigationBar+RRAddition.h"
#import "UINavigationBar+RRAddition_Internal.h"

#ifndef RRSetterNumber
#   define RRSetterNumber(value) \
        if (self.value != value && \
            self._holder.isViewLoaded && \
            self._holder.view.window) { \
                self._holder.navigationController.navigationBar.value = value; \
        } \
        super.value = value;
#endif

#ifndef RRSetterObject
#   define RRSetterObject(obj) \
        if (![self.obj isEqual:obj] && \
            self._holder.isViewLoaded && \
            self._holder.view.window) { \
            self._holder.navigationController.navigationBar.obj = obj; \
        } \
        super.obj = obj;
#endif

#ifndef RRSetterImage
#   define RRSetterImage(image) \
        if (!_RRObjectIsEqual(self.image, image) && \
            self._holder.isViewLoaded && \
            self._holder.view.window) { \
            self._holder.navigationController.navigationBar.image = image; \
        } \
        super.image = image;
#endif

#ifndef RRAssignObject
#   define RRAssignObject(obj) \
        if (self._tmpInfo) { \
            self._tmpInfo[@#obj] = obj; \
        }
#endif

#ifndef RRAssignNumber
#   define RRAssignNumber(value) \
        if (self._tmpInfo) { \
            self._tmpInfo[@#value] = @(value); \
        }
#endif

extern BOOL _RRObjectIsEqual(NSObject *_Nullable one, NSObject *_Nullable other);

@implementation _RRNavigationBar

- (void)setBarStyle:(UIBarStyle)barStyle {
    RRSetterNumber(barStyle);
    RRAssignNumber(barStyle);
}

- (void)setTranslucent:(BOOL)translucent {
    RRSetterNumber(translucent);
    RRAssignNumber(translucent);
}

- (void)setAlpha:(CGFloat)alpha {
    RRSetterNumber(alpha);
    RRAssignNumber(alpha);
}

- (void)setTintColor:(UIColor *)tintColor {
    RRSetterObject(tintColor);
    RRAssignObject(tintColor);
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    RRSetterObject(barTintColor);
    RRAssignObject(barTintColor);
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    RRSetterObject(backgroundColor);
    RRAssignObject(backgroundColor);
}

- (void)setShadowImage:(UIImage *)shadowImage {
    RRSetterImage(shadowImage);
    RRAssignObject(shadowImage);
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics {
    if (!_RRObjectIsEqual([self backgroundImageForBarMetrics:barMetrics], backgroundImage) &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        [self._holder.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    }
    [super setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    RRAssignObject(backgroundImage);
}

- (void)setBackIndicatorImage:(UIImage *)backIndicatorImage {
    RRSetterImage(backIndicatorImage);
    RRAssignObject(backIndicatorImage);
}

- (void)setBackIndicatorTransitionMaskImage:(UIImage *)backIndicatorTransitionMaskImage {
    RRSetterImage(backIndicatorTransitionMaskImage);
    RRAssignObject(backIndicatorTransitionMaskImage);
}

@end
