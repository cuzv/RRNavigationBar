//
//  UINavigationBar+RRAddition.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/26/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (RRAddition)

/// Normally, set `shadowImage` to `nil` only effect when `backgroundImage` is transparent.
/// This property will ignore that policy, make shim shadow image hidden/show by force.
@property (nonatomic, assign) BOOL rr_forceShadowImageHidden;

/// If your want to deploy `UINavigationBar` behavior globally, like: `UINavigationBar.appearance.xxx = newValue`
/// After assign new values, set this property to `YES` to tell this lib take your prefered behavior as default value.
/// otherwise, settings will take no effect.
/// **Notice**: set this property before `UINavigationController` invoke `viewDidLoad`, and only set once.
/// Default value is `NO`.
@property (nonatomic, assign) BOOL rr_appearanceDeployed;

@end
