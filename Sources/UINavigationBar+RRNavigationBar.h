//
//  UINavigationBar+RRNavigationBar.h
//  RRNavigationBar
//
//  Created by Shaw on 3/26/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (RRNavigationBar)

/// Normally, set `shadowImage` to `nil` only effect when `backgroundImage` is transparent.
/// This property will ignore that policy, make shim shadow image hidden/show by force.
@property (nonatomic, assign) BOOL rr_forceShadowImageHidden NS_AVAILABLE_IOS(7_0);

@end
