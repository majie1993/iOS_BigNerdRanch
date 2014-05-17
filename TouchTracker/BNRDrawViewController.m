//
//  BNRDrawViewController.m
//  TouchTracker
//
//  Created by WaterWood on 14-5-15.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRDrawViewController.h"
#import "BNRDrawView.h"

@implementation BNRDrawViewController

- (void)loadView
{
    self.view = [[BNRDrawView alloc] initWithFrame:CGRectZero];
}

@end
