//
//  _RRUtils.h
//  RRNavigationBar
//
//  Created by Shaw on 3/25/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

extern void RRSwizzleInstanceMethod(Class _Nonnull clazz,  SEL _Nonnull originalSelector, SEL _Nonnull overrideSelector);
extern BOOL RRIsUINavigationBarEqual(UINavigationBar *_Nonnull one, UINavigationBar *_Nonnull other);
extern UINavigationBar *_Nonnull RRUINavigationBarDuplicate(UINavigationBar *_Nonnull one);

#pragma mark - Debug

#ifndef RRLog
#    if INRR
#       define RRLog(FORMAT, ...)    \
            do {    \
                fprintf(stderr,"<%s> %s %s [%d] %s\n",    \
                (NSThread.isMainThread ? "UI" : "BG"),    \
                (sel_getName(_cmd)),\
                [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],    \
                __LINE__,    \
                [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);    \
            } while(0)
#else
#        define RRLog(FORMAT, ...)
#   endif
#endif

#ifndef RRTRY
#   define RRTRY(...) \
        @try { \
            __VA_ARGS__; \
        } @catch (NSException *exception) { \
            NSLog(@"NSException happend: %@", exception); \
        }
#endif
