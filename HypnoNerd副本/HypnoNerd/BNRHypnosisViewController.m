//
//  BNRHypnosisViewController.m
//  HypnoNerd
//
//  Created by WaterWood on 14-5-11.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRHypnosisViewController.h"

@implementation BNRHypnosisViewController

- (void)loadView
{
    BNRHypnosisView *backgroundView = [[BNRHypnosisView alloc] init];
    self.view = backgroundView;
    
    NSArray *arrayItems = @[@"red", @"green", @"blue"];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:arrayItems];
    seg.frame = CGRectMake(100, 20, 100, 20);
    [seg addTarget:self action:@selector(changeColor:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:seg];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"Hypnotize";
        UIImage *image = [UIImage imageNamed:@"Hypno.png"];
        self.tabBarItem.image = image;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"BNRHypnosisViewController loaded its view");
}

- (void)changeColor: (UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        ((BNRHypnosisView *)self.view).circleColor = [UIColor redColor];
    } else if (sender.selectedSegmentIndex == 1) {
        ((BNRHypnosisView *)self.view).circleColor = [UIColor greenColor];
    } else {
        ((BNRHypnosisView *)self.view).circleColor = [UIColor blueColor];
    }
    
}

@end
