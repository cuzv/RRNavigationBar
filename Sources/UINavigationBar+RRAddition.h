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

@end
