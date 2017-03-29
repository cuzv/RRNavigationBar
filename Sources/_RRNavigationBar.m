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

extern BOOL _RRObjectIsEqual(NSObject *_Nullable one, NSObject *_Nullable other);

@implementation _RRNavigationBar

- (void)setBarStyle:(UIBarStyle)barStyle {
    if (self.barStyle != barStyle &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.barStyle = barStyle;
    }
    [super setBarStyle:barStyle];
    if (self._tmpInfo) {
        self._tmpInfo[@"barStyle"] = @(barStyle);
    }
}

- (void)setTranslucent:(BOOL)translucent {
    if (self.barStyle != translucent &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.translucent = translucent;
    }
    [super setTranslucent:translucent];
    if (self._tmpInfo) {
        self._tmpInfo[@"translucent"] = @(translucent);
    }
}

- (void)setTintColor:(UIColor *)tintColor {
    if (![self.tintColor isEqual:tintColor] &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.tintColor = tintColor;
    }
    [super setTintColor:tintColor];
    if (self._tmpInfo) {
        self._tmpInfo[@"tintColor"] = tintColor;
    }
}

- (void)setBarTintColor:(UIColor *)barTintColor {
    if (![self.barTintColor isEqual:barTintColor] &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.barTintColor = barTintColor;
    }
    [super setBarTintColor:barTintColor];
    if (self._tmpInfo) {
        self._tmpInfo[@"barTintColor"] = barTintColor;
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (![self.backgroundColor isEqual:backgroundColor] &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.backgroundColor = backgroundColor;
    }
    [super setBackgroundColor:backgroundColor];
    if (self._tmpInfo) {
        self._tmpInfo[@"backgroundColor"] = backgroundColor;
    }
}

- (void)setShadowImage:(UIImage *)shadowImage {
    if (!_RRObjectIsEqual(self.shadowImage, shadowImage) &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.shadowImage = shadowImage;
    }
    [super setShadowImage:shadowImage];
    if (self._tmpInfo) {
        self._tmpInfo[@"shadowImage"] = shadowImage;
    }
}

- (void)setBackgroundImage:(UIImage *)backgroundImage forBarMetrics:(UIBarMetrics)barMetrics {
    if (!_RRObjectIsEqual([self backgroundImageForBarMetrics:barMetrics], backgroundImage) &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        [self._holder.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    }
    [super setBackgroundImage:backgroundImage forBarMetrics:barMetrics];
    if (self._tmpInfo) {
        self._tmpInfo[@"backgroundImage"] = backgroundImage;
    }
}

- (void)setAlpha:(CGFloat)alpha {
    if (self.alpha != alpha &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.alpha = alpha;
    }
    [super setAlpha:alpha];
    if (self._tmpInfo) {
        self._tmpInfo[@"alpha"] = @(alpha);
    }
}

- (void)setBackIndicatorImage:(UIImage *)backIndicatorImage {
    if (!_RRObjectIsEqual(self.backIndicatorImage, backIndicatorImage) &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.backIndicatorImage = backIndicatorImage;
    }
    [super setBackIndicatorImage:backIndicatorImage];
    if (self._tmpInfo) {
        self._tmpInfo[@"backIndicatorImage"] = backIndicatorImage;
    }
}

- (void)setBackIndicatorTransitionMaskImage:(UIImage *)backIndicatorTransitionMaskImage {
    if (!_RRObjectIsEqual(self.backIndicatorTransitionMaskImage, backIndicatorTransitionMaskImage) &&
        self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.backIndicatorTransitionMaskImage = backIndicatorTransitionMaskImage;
    }
    [super setBackIndicatorTransitionMaskImage:backIndicatorTransitionMaskImage];
    if (self._tmpInfo) {
        self._tmpInfo[@"backIndicatorTransitionMaskImage"] = backIndicatorTransitionMaskImage;
    }
}

@end
