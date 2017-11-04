//
//  UINavigationBar+RRNavigationBar.h
//  RRNavigationBar
//
//  Created by Roy Shaw on 3/26/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (RRAddition)

/// Normally, set `shadowImage` to `nil` only effect when `backgroundImage` is transparent.
/// This property will ignore that policy, make shim shadow image hidden/show by force.
@property (nonatomic, assign) BOOL rr_forceShadowImageHidden NS_AVAILABLE_IOS(7_0);

@end

/// If you don't want to be impacted for specific UINavigationController, use this method execude it.
extern void RRNavigationBarExcludeImpactBehaviorForClass(Class _Nonnull nvcClass) NS_AVAILABLE_IOS(7_0);
/// If you don't want to be impacted for specific UINavigationController, use this method execude it.
extern void RRNavigationBarExcludeImpactBehaviorForInstance(__kindof UINavigationController *_Nonnull nvc) NS_AVAILABLE_IOS(7_0);
