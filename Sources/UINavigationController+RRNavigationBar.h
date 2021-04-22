//
//  UINavigationController+RRNavigationBar.h
//  RRNavigationBar
//
//  Created by Shaw on 3/25/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

/// If you don't want to be impacted for specific UINavigationController, use this method execude it.
extern void RRNavigationBarExcludeImpactBehaviorForClass(Class _Nonnull nvcClass) NS_AVAILABLE_IOS(7_0);
/// If you don't want to be impacted for specific UINavigationController, use this method execude it.
extern void RRNavigationBarExcludeImpactBehaviorForInstance(__kindof UINavigationController *_Nonnull nvc) NS_AVAILABLE_IOS(7_0);

@interface UINavigationController (RRNavigationBar)

/// Acquire the `UINavigationControllerDelegate` you set before.
@property(nullable, nonatomic, weak, readonly) id<UINavigationControllerDelegate> rr_originalDelegate;

@end
