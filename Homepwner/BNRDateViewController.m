//
//  BNRDateViewController.m
//  Homepwner
//
//  Created by WaterWood on 14-5-14.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRDateViewController.h"
#import "BNRItem.h"

@interface BNRDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation BNRDateViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.datePicker.date = self.item.dateCreated;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    self.item.dateCreated = self.datePicker.date;
}

- (IBAction)clickOk:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
