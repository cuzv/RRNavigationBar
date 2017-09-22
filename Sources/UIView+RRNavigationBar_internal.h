//
//  UIView+RRNavigationBar_internal.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 9/17/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifdef __IPHONE_11_0

/// Following methods used in library, you should not use any directly.
@interface UIView (RRNavigationBar_internal)

/// Tell ObjC ignore `setHidden:` invoke.
/// iOS 11+ use.
@property (nonatomic, assign) BOOL _rr_ignoreSetHiddenMessage NS_AVAILABLE_IOS(11_0);

@end

@interface UIScrollView (RRNavigationBar_internal)

/// Tell ObjC ignore `setHidden:` invoke.
/// iOS 11+ use.
@property (nonatomic, assign) UIScrollViewContentInsetAdjustmentBehavior _rr_contentInsetAdjustmentBehavior NS_AVAILABLE_IOS(11_0);

@end

#endif
