//
//  ConfigItem.m
//  RRNavigationBar
//
//  Created by Shaw on 3/22/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "ConfigItem.h"
#import <UIKit/UIKit.h>

#pragma mark -

NSString *_RRConfigTypeDescription(ConfigType type) {
    switch (type) {
        case ConfigTypeTintColor:
            return @"tintColor";
        case ConfigTypeBarTintColor:
            return @"barTintColor";
        case ConfigTypeBackgroundImageColor:
            return @"Background Image with Color";
        case ConfigTypeShadowImage:
            return @"Show Shadow Image";
        case ConfigTypeTranslucent:
            return @"Bar Translucent";
        case ConfigTypeBarStyle:
            return @"Default Style";
    }
}

NSString *_RRConfigValueDescription(ConfigValue value) {
    switch (value) {
        case ConfigValueColorNone:
            return @"None";
        case ConfigValueColorRed:
            return @"Red";
        case ConfigValueColorGreen:
            return @"Green";
        case ConfigValueColorBlue:
            return @"Blue";
        case ConfigValueColorCyan:
            return @"Cyan";
        case ConfigValueColorOrange:
            return @"Orange";
        case ConfigValueColorInvisible:
            return @"Invisible";
        case ConfigValueTrue:
            return @"YES";
        case ConfigValueFalse:
            return @"NO";
    }
}

id RRConfigureValueWrap(ConfigValue value) {
    switch (value) {
        case ConfigValueColorNone:
            return nil;
        case ConfigValueColorRed:
            return [UIColor redColor];
        case ConfigValueColorGreen:
            return [UIColor greenColor];
        case ConfigValueColorBlue:
            return [UIColor blueColor];
        case ConfigValueColorCyan:
            return [UIColor cyanColor];
        case ConfigValueColorOrange:
            return [UIColor orangeColor];
        case ConfigValueColorInvisible:
            return [UIColor clearColor];
        case ConfigValueTrue:
            return @(YES);
        case ConfigValueFalse:
            return @(NO);
    }
}

#pragma mark -

@implementation ConfigItem

- (instancetype)initWithType:(ConfigType)type value:(ConfigValue)value {
    self = [super init];
    if (self) {
        self.value = value;
        self.type = type;
    }
    
    return self;
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    ConfigItem *copy = [self.class new];
    copy->_type = _type;
    copy->_value = _value;
    return copy;
}

@end
