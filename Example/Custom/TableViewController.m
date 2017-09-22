//
//  TableViewController.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/17/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "TableViewController.h"
#import "UIColor+EKExtension.h"
#import "OptionsTableViewController.h"
#import "ConfigItem.h"
#import "RRUtils.h"
#import "RRNavigationBar.h"
#import "Helper.h"


#pragma mark -

@interface TableViewController ()
@property (nonatomic, copy) NSArray<ConfigItem *> *nextVCData;
@property (nonatomic, copy) NSArray<ConfigItem *> *currentData;
@end

@implementation TableViewController

- (void)dealloc {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (instancetype)initWithData:(NSArray *)data {
    self = [super init];
    if (self) {
        self.nextVCData = data;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!self.nextVCData.count) {
        ConfigItem *tintColor = [[ConfigItem alloc] initWithType:ConfigTypeTintColor value:ConfigValueColorNone];
        ConfigItem *barTintColor = [[ConfigItem alloc] initWithType:ConfigTypeBarTintColor value:ConfigValueColorNone];
        ConfigItem *backgroundImageColor = [[ConfigItem alloc] initWithType:ConfigTypeBackgroundImageColor value:ConfigValueColorNone];
        ConfigItem *shadowImage = [[ConfigItem alloc] initWithType:ConfigTypeShadowImage value:ConfigValueTrue];
        ConfigItem *translucent = [[ConfigItem alloc] initWithType:ConfigTypeTranslucent value:ConfigValueTrue];
        ConfigItem *barStyle = [[ConfigItem alloc] initWithType:ConfigTypeBarStyle value:ConfigValueTrue];
        _nextVCData = [@[tintColor, barTintColor, backgroundImageColor, shadowImage, translucent, barStyle] mutableCopy];
    }
    
    NSMutableArray *arr = [@[] mutableCopy];
    for (ConfigItem *item in _nextVCData) {
        [arr addObject:item.mutableCopy];
    }
    _currentData = arr;    
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView = tableView;
    self.navigationItem.title = [@(self.navigationController.viewControllers.count) stringValue];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(handleClickNext:)];
//    self.tableView.backgroundColor = [UIColor ek_random];
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
        
    for (ConfigItem *item in self.currentData) {
        id value = RRConfigureValueWrap(item.value);
        switch (item.type) {
            case ConfigTypeTintColor:
                self.rr_navigationBar.tintColor = value;
                break;
            case ConfigTypeBarTintColor:
                self.rr_navigationBar.barTintColor = value;
                break;
            case ConfigTypeBackgroundImageColor:
                if ([[UIColor clearColor] isEqual:value]) {
                    [self.rr_navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
                } else {
                    [self.rr_navigationBar setBackgroundImage:value ? RRUIImageMake(value) : nil forBarMetrics:UIBarMetricsDefault];
                }
                break;
            case ConfigTypeShadowImage:
                self.rr_navigationBar.shadowImage = [value boolValue] ? nil : [UIImage new];
                break;
            case ConfigTypeTranslucent:
                self.rr_navigationBar.translucent = [value boolValue];
                break;
            case ConfigTypeBarStyle:
                self.rr_navigationBar.barStyle = [value boolValue] ? UIBarStyleDefault : UIBarStyleBlack;
                break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)handleClickNext:(UIBarButtonItem *)sender {
    TableViewController *controller = [[TableViewController alloc] initWithData:[self.nextVCData mutableCopy]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)handleClickShadowImageSwitch:(UISwitch *)sender {
    sender.on = !sender.isOn;
    _nextVCData[3].value = sender.isOn ? ConfigValueTrue : ConfigValueFalse;
}

- (void)handleClickTranslucentSwitch:(UISwitch *)sender {
    sender.on = !sender.isOn;
    _nextVCData[4].value = sender.isOn ? ConfigValueTrue : ConfigValueFalse;
}

- (void)handleClickBarStyleSwitch:(UISwitch *)sender {
    sender.on = !sender.isOn;
    _nextVCData[5].value = sender.isOn ? ConfigValueTrue : ConfigValueFalse;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"Next ViewController's NavigationBar configure";
    }
    return @"Current ViewController's NavigationBar configure";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _nextVCData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewController.reuseIdentifier"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewController.reuseIdentifier"];
    }
    ConfigItem *item;
    if (0 == indexPath.section) {
        item = _nextVCData[indexPath.row];
    } else {
        item = _currentData[indexPath.row];
    }
    cell.textLabel.text = _RRConfigTypeDescription(item.type);
    id value = RRConfigureValueWrap(item.value);
    if (!value || [value isKindOfClass:UIColor.class]) {
        cell.detailTextLabel.text = _RRConfigValueDescription(item.value);
    } else {
        UISwitch *st = [UISwitch new];
        st.on = [value boolValue];
        st.enabled = 0 == indexPath.section;
        cell.accessoryView = st;
        if (item.type == ConfigTypeShadowImage) {
            [st addTarget:self action:@selector(handleClickShadowImageSwitch:) forControlEvents:UIControlEventValueChanged];
        } else if (item.type == ConfigTypeTranslucent) {
            [st addTarget:self action:@selector(handleClickTranslucentSwitch:) forControlEvents:UIControlEventValueChanged];
        } else if (item.type == ConfigTypeBarStyle) {
            [st addTarget:self action:@selector(handleClickBarStyleSwitch:) forControlEvents:UIControlEventValueChanged];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        ConfigItem *item = _nextVCData[indexPath.row];
        OptionsTableViewController *controller = [[OptionsTableViewController alloc] initWithConfigItem:item didSelectHandler:^(ConfigValue value) {
            item.value = value;
            [tableView reloadData];
        }];
        [self.navigationController pushViewController:controller animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end



