//
//  BNRWebViewController.m
//  Nerdfeed
//
//  Created by WaterWood on 14-5-24.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRWebViewController.h"

@interface BNRWebViewController() <UIWebViewDelegate, UISplitViewControllerDelegate>

@property (nonatomic, strong) UIBarButtonItem *goItem;
@property (nonatomic, strong) UIBarButtonItem *backItem;

@end

@implementation BNRWebViewController

- (void)loadView
{
    UIWebView *webView = [[UIWebView alloc] init];
    webView.scalesPageToFit = YES;
    self.view = webView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    toolbar.frame = CGRectMake(0, self.view.frame.size.height - 44, self.view.frame.size.width, 44);
    self.goItem = [[UIBarButtonItem alloc] initWithTitle:@"Go" style:UIBarButtonItemStylePlain target:self action:@selector(go)];
    self.backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [toolbar setItems:@[self.goItem, self.backItem] animated:YES];
    
    
    [self.view addSubview:toolbar];
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL) {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
    }
}

- (void)go
{
    [(UIWebView *)self.view goForward];
}

- (void)back
{
    [(UIWebView *)self.view goBack];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.canGoBack) {
        self.goItem.enabled = YES;
    }
    
    if (webView.canGoForward) {
        self.goItem.enabled = YES;
    }

}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = @"Courses";
    
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // remove bar button
    if (barButtonItem == self.navigationItem.leftBarButtonItem) {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

@end
