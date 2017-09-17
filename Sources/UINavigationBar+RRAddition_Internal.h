//
//  UINavigationBar+RRAddition_Internal.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/27/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

@interface UINavigationBar (RRAddition_Internal)

/// Following methods used in library, you should not use any directly.
/// If this bar equal to other bar in transiting, inner used.
@property (nonatomic, assign) BOOL _rr_equalOtherNavigationBarInTransiting;
/// Record if this bar is in transiting, inner used.
@property (nonatomic, assign) BOOL _rr_transiting;
/// The bar's holder, inner used.
@property (nonatomic, weak, nullable) UIViewController *_holder;
/// Apply this bar's appearance to system's navigationBar, inner used.
- (void)_apply;
/// Record the bar's information used lately, inner used.
@property (nonatomic, retain, nullable) NSMutableDictionary<NSString *, id> *_tmpInfo;
/// Tell system if navigationBar should be invisible, inner used.
- (void)_rr_setAsInvisible:(BOOL)invisible;

/// Try not use following methods if it's unnecessary.
/// UINavigationBar's ivars
/// |- _backgroundView [ _UIBarBackground ]
///     |- _backgroundImageView [ UIImageView ]
///     |- _shadowView [ UIImageView ]
/// The view maintains navigationBar's backgroundImage & shadowImage.
@property (nonatomic, weak, readonly, nullable) UIView *_rr_backgroundView;
/// The view for represent this image when you set in `setBackgroundImage:forBarMetrics:`.
@property (nonatomic, weak, readonly, nullable) UIView *_rr_backgroundImageView;
/// The view for represent this image when you set in `setShadowImage:`.
@property (nonatomic, weak, readonly, nullable) UIView *_rr_shadowView;

@end
