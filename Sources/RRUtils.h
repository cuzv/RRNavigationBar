//
//  RRUtils.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/25/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern void RRSwizzleInstanceMethod(Class _Nonnull clazz,  SEL _Nonnull originalSelector, SEL _Nonnull overrideSelector);
extern BOOL RRIsUINavigationBarEqual(UINavigationBar *_Nonnull one, UINavigationBar *_Nonnull other);
extern UINavigationBar *_Nonnull RRUINavigationBarDuplicate(UINavigationBar *_Nonnull one);
