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
    
//    self.navigationItem.title = @"Product Detail";

    [self.rr_navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.rr_navigationBar.shadowImage = [UIImage new];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"More" style:UIBarButtonItemStylePlain target:self action:@selector(handleClickMore:)];
    
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
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
    
    // Warning: CGContextDrawImage: invalid context 0x0. If you want to see the backtrace, please set CG_CONTEXT_SHOW_BACKTRACE environmental variable.
    // seemed to be a bug, see http://stackoverflow.com/questions/31872650/how-can-i-set-cg-context-show-backtrace-environmental-variable https://forums.developer.apple.com/thread/13683
    @autoreleasepool {
        if (ratio < 1) {
            [self.rr_navigationBar setBackgroundImage:RRUIImageMake([[UIColor whiteColor] colorWithAlphaComponent:ratio]) forBarMetrics:UIBarMetricsDefault];
            self.rr_navigationBar.shadowImage = [UIImage new];
            self.statusBarStyle = UIBarStyleBlack;
        } else {
            [self.rr_navigationBar setBackgroundImage:nil  forBarMetrics:UIBarMetricsDefault];
            self.rr_navigationBar.shadowImage = nil;
            self.statusBarStyle = UIBarStyleDefault;
        }
    }

    [self setNeedsStatusBarAppearanceUpdate];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UITextView *textView = [UITextView new];
        _scrollView = textView;
        textView.alwaysBounceVertical = YES;
        textView.backgroundColor = [UIColor lightGrayColor];
        textView.editable = NO;
        textView.text = NSLocalizedString(@"content", nil);
        textView.textColor = [UIColor brownColor];
        textView.font = [UIFont systemFontOfSize:17];
        _scrollView = textView;
    }
    return _scrollView;
}



@end
