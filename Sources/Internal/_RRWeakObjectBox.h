//
//  _RRWeakObjectBox.h
//  RRNavigationBar
//
//  Created by Shaw on 3/28/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _RRWeakObjectBox : NSObject

@property (nonatomic, weak, nullable, readonly) id object;
- (nonnull instancetype)initWithObject:(nonnull id)object;
- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nonnull instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
