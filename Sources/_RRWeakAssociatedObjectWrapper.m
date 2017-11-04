//
//  _RRWeakAssociatedObjectWrapper.m
//  RRNavigationBar
//
//  Created by Roy Shaw on 3/28/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "_RRWeakAssociatedObjectWrapper.h"

@implementation _RRWeakAssociatedObjectWrapper

- (nonnull instancetype)initWithObject:(nullable id)object {
    self = [super init];
    if (self) {
        self.object = object;
    }
    return self;
}

@end
