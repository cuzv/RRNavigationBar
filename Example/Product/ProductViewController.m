//
//  ProductViewController.m
//  RRNavigationBar
//
//  Created by Moch Xiao on 3/27/17.
//  Copyright © 2017 RedRain. All rights reserved.
//

#import "ProductViewController.h"
#import "RRNavigationBar.h"
#import "ProductMoreViewController.h"
#import "Helper.h"

@interface ProductViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@end

@implementation ProductViewController

- (void)dealloc {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.rr_navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.rr_navigationBar.shadowImage = [UIImage new];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStylePlain target:self action:@selector(handleClickMore:)];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.bounds), 2000);
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)handleClickMore:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:[ProductMoreViewController new] animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    if (!object) {
        return;
    }
    if (object != self.scrollView) {
        return;
    }
    
    CGFloat offsetY = self.scrollView.contentOffset.y;
    CGFloat ratio = offsetY / (CGRectGetWidth(self.view.bounds) * 0.4f);
    if (ratio > 1) {
        ratio = 1;
    }
    
    if (ratio < 1) {
        @autoreleasepool {
            [self.rr_navigationBar setBackgroundImage:RRUIImageMake([[UIColor whiteColor] colorWithAlphaComponent:ratio]) forBarMetrics:UIBarMetricsDefault];
            self.rr_navigationBar.shadowImage = [UIImage new];
            self.statusBarStyle = UIBarStyleBlack;
        }
    } else {
        [self.rr_navigationBar setBackgroundImage:nil  forBarMetrics:UIBarMetricsDefault];
        self.rr_navigationBar.shadowImage = nil;
        self.statusBarStyle = UIBarStyleDefault;
    }

    [self setNeedsStatusBarAppearanceUpdate];
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.backgroundColor = [UIColor cyanColor];
    }
    return _scrollView;
}



@end
