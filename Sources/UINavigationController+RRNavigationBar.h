//
//  UINavigationController+RRNavigationBar.h
//  RRNavigationBar
//
//  Created by Roy Shaw on 3/25/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RRNavigationControllerDelegate;

@interface UINavigationController (RRNavigationBar)

@property(nullable, nonatomic, weak) id<RRNavigationControllerDelegate> rr_delegate;

@end
