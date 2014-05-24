//
//  BNRItemsViewController.h
//  Homepwner
//
//  Created by WaterWood on 14-5-13.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItemsViewController : UITableViewController<UIPopoverControllerDelegate, UIViewControllerRestoration, UIDataSourceModelAssociation>

@property (nonatomic, strong) UIPopoverController *imagePopover;

@end
