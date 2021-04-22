//
//  _RRWeakObjectBox.m
//  RRNavigationBar
//
//  Created by Shaw on 3/28/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "_RRWeakObjectBox.h"

@implementation _RRWeakObjectBox

- (nonnull instancetype)initWithObject:(nonnull id)object {
    self = [super init];
    if (self) {
        _object = object;
    }
    return self;
}

@end
