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

- (void)updateInterfaceForDynamicTypeSize
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary *imageSizeDictionary;
    
    if (!imageSizeDictionary) {
        imageSizeDictionary = @{UIContentSizeCategoryExtraSmall: @40,
                                 UIContentSizeCategorySmall: @40,
                                 UIContentSizeCategoryMedium: @40,
                                 UIContentSizeCategoryLarge: @40,
                                 UIContentSizeCategoryExtraLarge:@45,
                                 UIContentSizeCategoryExtraExtraLarge: @55,
                                 UIContentSizeCategoryExtraExtraExtraLarge: @65};
    }
    
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightContraint.constant = imageSize.floatValue;
}

- (void)awakeFromNib
{
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self selector:@selector(updateInterfaceForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeHeight
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.thumbnailView
                                                                  attribute:NSLayoutAttributeWidth
                                                                 multiplier:1
                                                                   constant:0];
    [self.thumbnailView addConstraint:constraint];
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
