//
//  _RRNavigationControllerDelegateInterceptor.h
//  RRNavigationBar
//
//  Created by Shaw on 1/5/18.
//  Copyright © 2018 Shaw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface _RRNavigationControllerDelegateInterceptor : NSObject <UINavigationControllerDelegate>

@property(nullable, nonatomic, weak) id<UINavigationControllerDelegate> delegate;

@end
