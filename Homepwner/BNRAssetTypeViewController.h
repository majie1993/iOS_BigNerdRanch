//
//  BNRAssetTypeViewController.h
//  Homepwner
//
//  Created by WaterWood on 14-5-24.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@class  BNRItem;

@interface BNRAssetTypeViewController : UITableViewController

@property (nonatomic, strong) BNRItem *item;

@property (nonatomic, copy) void(^dismissBlock)(void);

@end
