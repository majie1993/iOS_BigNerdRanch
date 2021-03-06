//
//  BNRItem.h
//  RandomItems
//
//  Created by WaterWood on 14-5-8.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, weak) BNRItem *container;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly) NSDate *dateCreated;

+ (instancetype)randomItem;

// Designated initializer for BNRItem
- (instancetype)initWithItemName: (NSString *)name
                  valueInDollars: (int)value
                    serialNumber: (NSString *)sNumber;

- (instancetype)initWithItemName: (NSString *)name;

- (instancetype)initWithItemName: (NSString *)name
                    serialNumber: (NSString *)sNumber;

@end
