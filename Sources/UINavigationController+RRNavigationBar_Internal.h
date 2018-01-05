//
//  UINavigationController+RRNavigationBar_Internal.h
//  RRNavigationBar
//
//  Created by Roy Shaw on 1/5/18.
//  Copyright © 2018 RedRain. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

static NSMutableSet *_excludeNVCClassess;
static NSMutableSet *_excludeNVCInstance;

#ifndef RRExcludeImpactBehaviorFor
#   define RRExcludeImpactBehaviorFor(instance) \
        for (Class clazz in _excludeNVCClassess) { \
            if ([instance isKindOfClass:clazz]) { return; } \
        } \
        for (UINavigationController *nvc in _excludeNVCInstance) { \
            if ([instance isEqual:nvc]) { return; } \
        }
#endif

@interface UINavigationController (RRNavigationBar_Internal)

- (void)_handleWillShowViewController:(UIViewController *)viewController;
- (void)_handleDidShowViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
