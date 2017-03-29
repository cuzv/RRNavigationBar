//
//  UIViewController+RRNavigationBar.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/17/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (RRNavigationBar)

/// Define a different look like UINavigationBar for specific ViewController, assigin to this property.
/// Try not change `translucent` property, which is may cause navigationBar flash when animation complete with extends container ViewController's view backgroundColor.
/// `hidden`property will have no effect, try use `setBackgroundImage:forBarMetrics:` & `shadowImage` make navigationBar invisible.
/// If current ViewController isn't in `UINvaigationController`'s `viewControllers` stack, will return nil.
@property (nonatomic, strong, nonnull) UINavigationBar *rr_navigationBar;

/// Disable pop interactive animation, default value is `NO`.
@property (nonatomic, assign) BOOL rr_interactivePopGestureRecognizerDisabled;

@end
