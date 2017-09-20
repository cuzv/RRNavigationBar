//
//  UIView+RRNavigationBar_internal.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 9/17/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Following methods used in library, you should not use any directly.
@interface UIView (RRNavigationBar_internal)

/// Tell ObjC ignore `setHidden:` invoke.
/// iOS 11+ use.
@property (nonatomic, assign) BOOL _rr_ignoreSetHiddenMessage;

@end
