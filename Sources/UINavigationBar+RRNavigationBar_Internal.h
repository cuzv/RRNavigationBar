//
//  UINavigationBar+RRNavigationBar_Internal.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/27/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

@interface UINavigationBar (RRNavigationBar_Internal)

/// Following methods used in library, you should not use any directly.
/// If this bar equal to other bar in transiting, inner used.
@property (nonatomic, assign) BOOL _rr_equalOtherNavigationBarInTransiting NS_AVAILABLE_IOS(7_0);
/// Record if this bar is in transiting, inner used.
@property (nonatomic, assign) BOOL _rr_transiting NS_AVAILABLE_IOS(7_0);
/// The bar's holder, inner used.
@property (nonatomic, weak, nullable) UIViewController *_holder NS_AVAILABLE_IOS(7_0);
/// Apply this bar's appearance to system's navigationBar, inner used.
- (void)_rr_apply NS_AVAILABLE_IOS(7_0);
/// Record the bar's information used lately, inner used.
@property (nonatomic, retain, nullable) NSMutableDictionary<NSString *, id> *_rr_tmpInfo NS_AVAILABLE_IOS(7_0);
/// Tell system if navigationBar should be invisible, inner used.
- (void)_rr_setAsInvisible:(BOOL)invisible NS_AVAILABLE_IOS(7_0);

/// Try not use following methods unless it's unavoidable.
/// UINavigationBar's ivars
/// |- _backgroundView [ _UIBarBackground ]
///     |- _backgroundImageView [ UIImageView ]
///     |- _shadowView [ UIImageView ]
/// The view maintains navigationBar's backgroundImage & shadowImage.
@property (nonatomic, weak, readonly, nullable) UIView *_rr_backgroundView NS_AVAILABLE_IOS(7_0);
/// The view for represent this image when you set in `setBackgroundImage:forBarMetrics:`.
@property (nonatomic, weak, readonly, nullable) UIView *_rr_backgroundImageView NS_AVAILABLE_IOS(7_0);
/// The view for represent this image when you set in `setShadowImage:`.
@property (nonatomic, weak, readonly, nullable) UIView *_rr_shadowView NS_AVAILABLE_IOS(7_0);

@end
