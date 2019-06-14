//
//  _RRNavigationControllerDelegateInterceptor.m
//  RRNavigationBar
//
//  Created by Shaw on 1/5/18.
//  Copyright © 2018 Shaw. All rights reserved.
//

#import "_RRNavigationControllerDelegateInterceptor.h"
#import "UINavigationController+RRNavigationBar_Internal.h"

@interface _RRNavigationControllerDelegateInterceptor ()
@property (nonatomic, assign) BOOL delegateImplementsWillShowViewControllerAnimated;
@property (nonatomic, assign) BOOL delegateImplementsDidShowViewControllerAnimated;
@end

@implementation _RRNavigationControllerDelegateInterceptor

#pragma mark -

- (void)setDelegate:(id<UINavigationControllerDelegate>)delegate {
    if (_delegate != delegate) {
        _delegate = delegate;
        
        _delegateImplementsWillShowViewControllerAnimated = [_delegate respondsToSelector:@selector(navigationController:willShowViewController:animated:)];
        _delegateImplementsDidShowViewControllerAnimated = [_delegate respondsToSelector:@selector(navigationController:didShowViewController:animated:)];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.delegateImplementsWillShowViewControllerAnimated) {
        [self.delegate navigationController:navigationController willShowViewController:viewController animated:animated];
    }
    [navigationController _handleWillShowViewController:viewController];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.delegateImplementsDidShowViewControllerAnimated) {
        [self.delegate navigationController:navigationController didShowViewController:viewController animated:animated];
    }
    [navigationController _handleDidShowViewController:viewController];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [_delegate respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return _delegate;
}

@end
