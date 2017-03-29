//
//  UINavigationBar+RRAddition_Internal.h
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/27/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

@interface UINavigationBar (RRAddition_Internal)

@property (nonatomic, assign) BOOL _rr_equalOtherNavigationBarInTransiting;
@property (nonatomic, assign) BOOL _rr_transiting;
@property (nonatomic, weak, nullable) UIViewController *_holder;
- (void)_apply;
@property (nonatomic, retain, nullable) NSMutableDictionary<NSString *, id> *_tmpInfo;

@end
