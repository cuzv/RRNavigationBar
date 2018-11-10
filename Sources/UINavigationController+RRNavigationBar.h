//
//  UINavigationController+RRNavigationBar.h
//  RRNavigationBar
//
//  Created by Shaw on 3/25/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (RRNavigationBar)

/// Acquire the `UINavigationControllerDelegate` you set before.
@property(nullable, nonatomic, weak, readonly) id<UINavigationControllerDelegate> rr_originalDelegate;

@end
