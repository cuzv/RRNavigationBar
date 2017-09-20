//
//  UINavigationBar+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/26/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UINavigationBar+RRNavigationBar.h"
#import <objc/runtime.h>
#import "_RRWeakAssociatedObjectWrapper.h"
#import "RRUtils.h"
#import "UIView+RRNavigationBar_internal.h"

@implementation UINavigationBar (RRNavigationBar)

- (BOOL)_rr_equalOtherNavigationBarInTransiting {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_rr_equalOtherNavigationBarInTransiting:(BOOL)_rr_equalOtherNavigationBarInTransiting {
    objc_setAssociatedObject(self, @selector(_rr_equalOtherNavigationBarInTransiting), @(_rr_equalOtherNavigationBarInTransiting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)_rr_transiting {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)set_rr_transiting:(BOOL)_rr_transiting {
    objc_setAssociatedObject(self, @selector(_rr_transiting), @(_rr_transiting), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (nullable UIViewController *)_holder {
    return ((_RRWeakAssociatedObjectWrapper *)objc_getAssociatedObject(self, _cmd)).object;
}

- (void)set_holder:(nullable UIViewController *)_holder {
    _RRWeakAssociatedObjectWrapper *wrapper = [[_RRWeakAssociatedObjectWrapper alloc] initWithObject:_holder];
    objc_setAssociatedObject(self, @selector(_holder), wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_apply {
    UINavigationBar *navigationBar = self._holder.navigationController.navigationBar;
    if (!navigationBar) {
        return;
    }
    navigationBar.barStyle = self.barStyle;
    navigationBar.translucent = self.translucent;
    navigationBar.alpha = self.alpha;
    navigationBar.tintColor = self.tintColor;
    navigationBar.barTintColor = self.barTintColor;
    navigationBar.backgroundColor = self.backgroundColor;
    navigationBar.shadowImage = self.shadowImage;
    [navigationBar setBackgroundImage:[self backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    navigationBar.backIndicatorImage = self.backIndicatorImage;
    navigationBar.backIndicatorTransitionMaskImage = self.backIndicatorTransitionMaskImage;
    navigationBar.rr_forceShadowImageHidden = self.rr_forceShadowImageHidden;
}

- (BOOL)rr_forceShadowImageHidden {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setRr_forceShadowImageHidden:(BOOL)rr_forceShadowImageHidden {
    if (self.rr_forceShadowImageHidden == rr_forceShadowImageHidden) {
        return;
    }
    objc_setAssociatedObject(self, @selector(rr_forceShadowImageHidden), @(rr_forceShadowImageHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    self._rr_shadowView.hidden = rr_forceShadowImageHidden;
    
    if (self._holder.isViewLoaded &&
        self._holder.view.window) {
        self._holder.navigationController.navigationBar.rr_forceShadowImageHidden = rr_forceShadowImageHidden;
    }
    if (self._tmpInfo) {
        self._tmpInfo[@"rr_forceShadowImageHidden"] = @(rr_forceShadowImageHidden);
    }
}

- (nullable NSMutableDictionary<NSString *, id> *)_tmpInfo {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)set_tmpInfo:(nullable NSMutableDictionary<NSString *, id> *)_tmpInfo {
    objc_setAssociatedObject(self, @selector(_tmpInfo), _tmpInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_rr_setAsInvisible:(BOOL)invisible {
    // iOS 11, system will change _backgroundView's hidden property several times. (iOS11- will not)
    // But we do not want its changed during animating, while animation ended, system will change back to not hidden,
    // before that, we will set back this policy make system call valid.
    UIView *_backgroundView = self._rr_backgroundView;
    if (invisible) {
        _backgroundView.hidden = invisible;
        _backgroundView._rr_ignoreSetHiddenMessage = invisible;
    } else {
        _backgroundView._rr_ignoreSetHiddenMessage = invisible;
        _backgroundView.hidden = invisible;
    }
}

- (UIView *)_rr_backgroundView {
    UIView *_backgroundView;
    RRTRY(_backgroundView = [self valueForKey:@"_backgroundView"])
    return _backgroundView;
}

- (UIView *)_rr_backgroundImageView {
    UIView *_backgroundView = self._rr_backgroundView;
    if (_backgroundView) {
        UIView *_backgroundImageView;
        RRTRY(_backgroundImageView = [self._rr_backgroundView valueForKey:@"_backgroundImageView"])
        return _backgroundImageView;
    }
    return nil;
}

- (UIView *)_rr_shadowView {
    UIView *_backgroundView = self._rr_backgroundView;
    if (_backgroundView) {
        UIView *_rr_shadowView;
        RRTRY(_rr_shadowView = [self._rr_backgroundView valueForKey:@"_shadowView"])
        return _rr_shadowView;
    }
    return nil;
}

@end
