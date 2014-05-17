//
//  main.m
//  RandomItems
//
//  Created by WaterWood on 14-5-8.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [array addObject:[BNRItem randomItem]];
        [array addObject:[BNRItem randomItem]];
        [array addObject:[BNRItem randomItem]];
        
        for (BNRItem *item in array) {
            NSLog(@"%@", item);
        }
        
        
    }
    return 0;
}

