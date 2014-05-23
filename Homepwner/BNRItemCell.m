//
//  BNRItemCell.m
//  Homepwner
//
//  Created by WaterWood on 14-5-21.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

- (IBAction)showImage:(id)sender
{
    if (self.actionBlcok) {
        self.actionBlcok();
    }
}

@end
