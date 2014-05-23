//
//  BNRImageViewController.m
//  Homepwner
//
//  Created by WaterWood on 14-5-23.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRImageViewController.h"

@interface BNRImageViewController ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BNRImageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    float w = self.view.frame.size.width;
    float h = self.view.frame.size.height;
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    //self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.image = self.image;
    
    UIScrollView *scrollView = (UIScrollView *)self.view;
    
    scrollView.contentSize = CGSizeMake(w, h);
    
    scrollView.pagingEnabled = NO;
    scrollView.maximumZoomScale = 2.0;
    scrollView.delegate = self;
    
    [scrollView addSubview:self.imageView];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    //scrollView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = scrollView;
}

@end
