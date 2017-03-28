//
//  _RRWeakAssociatedObjectWrapper.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/28/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface _RRWeakAssociatedObjectWrapper : NSObject

@property (nonatomic, weak, nullable) id object;
- (nonnull instancetype)initWithObject:(nullable id)object;
- (nonnull instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (nonnull instancetype)new UNAVAILABLE_ATTRIBUTE;

@end
