//
//  OptionsTableViewController.m
//  RRNavigationBar
//
//  Created by Shaw on 3/17/17.
//  Copyright © 2017 Shaw. All rights reserved.
//

#import "OptionsTableViewController.h"
#import "UIColor+EKExtension.h"
#import "RRNavigationBar.h"

@interface OptionsTableViewController ()
@property (nonatomic, strong) ConfigItem *item;
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, copy) DidSelectHandler didSelectHandler;
@end

@implementation OptionsTableViewController

- (instancetype)initWithConfigItem:(ConfigItem *)item didSelectHandler:(DidSelectHandler)didSelectHandler {
    self = [super init];
    if (self) {
        self.item = item;
        self.didSelectHandler = didSelectHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    self.tableView = tableView;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OptionsTableViewController.reuseIdentifier"];
//    self.tableView.backgroundColor = [UIColor ek_random];
    self.navigationItem.title = @"Options";
    
    UIBarButtonItem *root = [[UIBarButtonItem alloc] initWithTitle:@"Root" style:UIBarButtonItemStylePlain target:self action:@selector(handleClickPopToRoot:)];
    UIBarButtonItem *second = [[UIBarButtonItem alloc] initWithTitle:@"second" style:UIBarButtonItemStylePlain target:self action:@selector(handleClickPopToSecond:)];
    if (self.navigationController.viewControllers.count > 2) {
        self.navigationItem.rightBarButtonItems = @[root, second];
    } else {
        self.navigationItem.rightBarButtonItems = @[root];
    }
    
    ConfigType type = self.item.type;
    switch (type) {
        case ConfigTypeTintColor:
        case ConfigTypeBarTintColor:
        case ConfigTypeBackgroundImageColor:
            _data = @[@(ConfigValueColorNone),
                      @(ConfigValueColorRed),
                      @(ConfigValueColorGreen),
                      @(ConfigValueColorBlue),
                      @(ConfigValueColorCyan),
                      @(ConfigValueColorOrange)
                      ];
            break;
        case ConfigTypeShadowImage:
        case ConfigTypeTranslucent:
        case ConfigTypeBarStyle:
            _data = @[@(ConfigValueTrue), @(ConfigValueFalse)];
            break;
    }
    if (type == ConfigTypeBackgroundImageColor) {
        NSMutableArray *newArr = [_data mutableCopy];
        [newArr addObject:@(ConfigValueColorInvisible)];
        _data = newArr;
    }
    
    self.rr_navigationBar.translucent = self.navigationController.navigationBar.translucent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super  viewWillAppear:animated];
}

- (void)handleClickPopToRoot:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)handleClickPopToSecond:(UIBarButtonItem *)sender {
    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionsTableViewController.reuseIdentifier" forIndexPath:indexPath];
    ConfigValue value = [_data[indexPath.row] integerValue];
    cell.textLabel.text = _RRConfigValueDescription(value);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ConfigValue value = [_data[indexPath.row] integerValue];
    self.didSelectHandler(value);
    [self.navigationController popViewControllerAnimated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
