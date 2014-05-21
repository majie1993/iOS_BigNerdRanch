//
//  BNRItemStore.h
//  Homepwner
//
//  Created by WaterWood on 14-5-13.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;

+ (instancetype)sharedStore;
- (BNRItem *)createItem;
- (void)removeItem: (BNRItem *)item;
- (void)moveItemAtIndex: (NSUInteger)fromIndex toIndex: (NSUInteger)toIndex;

- (BOOL)saveChanges;

@end
