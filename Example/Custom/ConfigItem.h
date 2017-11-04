//
//  ConfigItem.h
//  RRNavigationBar
//
//  Created by Roy Shaw on 3/22/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 

typedef NS_ENUM(NSInteger, ConfigType) {
    ConfigTypeTintColor,
    ConfigTypeBarTintColor,
    ConfigTypeBackgroundImageColor,
    
    ConfigTypeShadowImage,
    ConfigTypeTranslucent,
    ConfigTypeBarStyle,
};

extern NSString *_RRConfigTypeDescription(ConfigType type);

typedef NS_ENUM(NSInteger, ConfigValue) {
    // Color
    ConfigValueColorNone,
    ConfigValueColorRed,
    ConfigValueColorGreen,
    ConfigValueColorBlue,
    ConfigValueColorCyan,
    ConfigValueColorOrange,
    
    ConfigValueColorInvisible,
    
    ConfigValueTrue,
    ConfigValueFalse
};

extern NSString *_RRConfigTypeDescription(ConfigType type);
extern NSString *_RRConfigValueDescription(ConfigValue value);
extern id RRConfigureValueWrap(ConfigValue value);

#pragma mark -

@interface ConfigItem : NSObject <NSMutableCopying>

@property (nonatomic, assign) ConfigType type;
@property (nonatomic, assign) ConfigValue value;
- (instancetype)initWithType:(ConfigType)type value:(ConfigValue)value;

@end

