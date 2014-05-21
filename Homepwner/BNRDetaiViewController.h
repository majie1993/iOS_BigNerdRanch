//
//  BNRDetaiViewController.h
//  Homepwner
//
//  Created by WaterWood on 14-5-14.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetaiViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void(^dismissBlock)(void);


- (instancetype)initForNewItem:(BOOL)isNew;

@end
