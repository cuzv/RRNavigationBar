//
//  UINavigationController+RRNavigationBar_Internal.h
//  RRNavigationBar
//
//  Created by Shaw on 1/5/18.
//  Copyright © 2018 Shaw. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (RRNavigationBar_Internal)

- (void)_handleWillShowViewController:(UIViewController *)viewController;
- (void)_handleDidShowViewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
