//
//  UINavigationController+RRNavigationBar.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/25/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "UINavigationController+RRNavigationBar.h"
#import "UIViewController+RRNavigationBar_Internal.h"
#import "UIViewController+RRNavigationBar.h"
#import "RRUtils.h"
#import <objc/runtime.h>
#import "UINavigationBar+RRAddition.h"
#import "UINavigationBar+RRAddition_Internal.h"

#ifndef NSLog
    #if DEBUG
        #define NSLog(FORMAT, ...)    \
        do {    \
            fprintf(stderr,"<%s> %s %s [%d] %s\n",    \
            (NSThread.isMainThread ? "UI" : "BG"),    \
            (sel_getName(_cmd)),\
            [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],    \
            __LINE__,    \
            [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);    \
        } while(0)
#else
        #define NSLog(FORMAT, ...)
    #endif
#endif

@interface UINavigationController ()<UINavigationControllerDelegate, UINavigationBarDelegate>
@property (nonatomic, weak, nullable) UIViewController *_visibleTopViewController;
@end

@implementation UINavigationController (RRNavigationBar)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.class == UINavigationController.class) {
            RRSwizzleInstanceMethod(self.class, @selector(viewDidLoad), @selector(_rr_viewDidLoad));
        }
    });
}

#pragma mark - Private

- (nullable UIViewController *)_visibleTopViewController {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)set_visibleTopViewController:(nullable UIViewController *)_visibleTopViewController {
    objc_setAssociatedObject(self, @selector(_visibleTopViewController), _visibleTopViewController, OBJC_ASSOCIATION_ASSIGN);
}

- (void)_makeNavigationBarVisible:(BOOL)visible {
    [[self.navigationBar valueForKey:@"_backgroundView"] setHidden:!visible];
}

#pragma mark - Swizzle

- (void)_rr_viewDidLoad {
    [self _rr_viewDidLoad];
    self.delegate = self;
    self.rr_navigationBar = RRUINavigationBarDuplicate(self.navigationBar);
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"WILL to VC %@", viewController.title);

    if (RRIsUINavigationBarEqual(viewController.rr_navigationBar, self._visibleTopViewController.rr_navigationBar)) {
        // cancel pop, needs recover.
        viewController._rr_equalNavigationBarInTransition = YES;
        self._visibleTopViewController._rr_equalNavigationBarInTransition = YES;
        if (!viewController.view.backgroundColor) {
            viewController.view.backgroundColor = self._visibleTopViewController.view.backgroundColor;
        }
        return;
    }
    
    // Recover
    __weak typeof(self) weak_self = self;
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self._visibleTopViewController.transitionCoordinator;
    [transitionCoordinator notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (context.isCancelled) {
            NSLog(@"Canceled");
            __strong typeof(weak_self) strong_self = weak_self;
            viewController._rr_equalNavigationBarInTransition = NO;
            strong_self._visibleTopViewController._rr_equalNavigationBarInTransition = NO;
            
            [strong_self _handleDidShowViewController:strong_self._visibleTopViewController];
        }
    }];

    viewController._rr_equalNavigationBarInTransition = NO;
    self._visibleTopViewController._rr_equalNavigationBarInTransition = NO;
    viewController.view.clipsToBounds = NO;
    self._visibleTopViewController.view.clipsToBounds = NO;
    
    [viewController viewWillLayoutSubviews];
    [self._visibleTopViewController viewWillLayoutSubviews];
    
    if (!viewController.view.backgroundColor) {
        viewController.view.backgroundColor = self._visibleTopViewController.view.backgroundColor;
    }

    [self _makeNavigationBarVisible:NO];
    
    NSUInteger currentIndex = [navigationController.viewControllers indexOfObject:self._visibleTopViewController];
    NSUInteger toIndex = [navigationController.viewControllers indexOfObject:viewController];
    if (currentIndex > toIndex) {
        NSLog(@"POP");
    } else {
        NSLog(@"PUSH");
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [self _handleDidShowViewController:viewController];
    self._visibleTopViewController = viewController;
    NSLog(@"DID SHOW VC %@", viewController.title);
}

- (void)_handleDidShowViewController:(UIViewController *)viewController {
    viewController.view.clipsToBounds = YES;
    self._visibleTopViewController.view.clipsToBounds = YES;
    
    [viewController.rr_navigationBar _apply];
    viewController.rr_navigationBar.hidden = YES;
    
    [self _makeNavigationBarVisible:YES];
}

@end
