//
//  BNRItemStore.m
//  Homepwner
//
//  Created by WaterWood on 14-5-13.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@import CoreData;

@interface BNRItemStore()

@property (nonatomic, strong) NSMutableArray *privateItems;

@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
   
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use +[BNRItemStore sharedStore" userInfo:nil];
}

- (instancetype)initPrivate
{
    self = [super init];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self) {
            
            // read in Homepwner.xcdatamodeld
            _model = [NSManagedObjectModel mergedModelFromBundles:nil];
            NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
            
            // where does the SQLite file go
            NSString *path = [self itemArchivePath];
            NSURL *storeURL = [NSURL fileURLWithPath:path];
            
            NSError *error = nil;
            if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                                   configuration:nil
                                             URL:storeURL
                                         options:nil
                                           error:&error]) {
                @throw [NSException exceptionWithName:@"OpenFailure"
                                               reason:[error localizedDescription]
                                             userInfo:nil];
            }
            _context = [[NSManagedObjectContext alloc] init];
            _context.persistentStoreCoordinator = psc;
            
            [self loadAllItems];
        }
    });
    
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (BNRItem *)createItem
{
    //BNRItem *item = [BNRItem randomItem];
    
    double order;
    if (self.allItems.count == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    
    NSLog(@"Adding after %ld items, order = %.2f", [self.privateItems count], order);
    
    BNRItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                                  inManagedObjectContext:self.context];
    
    item.orderingValue = order;
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(BNRItem *)item
{
    NSString *key = item.imageKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
    
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    
    BNRItem *item = self.privateItems[fromIndex];
    [self.privateItems removeObjectAtIndex:fromIndex];
    [self.privateItems insertObject:item atIndex:toIndex];
    
    double lowerBound = 0.0;
    // is there an object before it in the array
    if (toIndex > 0) {
        lowerBound = [self.privateItems[toIndex - 1] orderingValue];
    } else {
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    // is there an object after it in the array
    if (toIndex < [self.privateItems count] - 1) {
        upperBound = [self.privateItems[toIndex + 1] orderingValue];
    } else {
        upperBound = [self.privateItems[toIndex - 1] orderingValue] + 2.0;
    }
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

- (NSString *)itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges
{
    NSError *error;
    
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRItem"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}


- (NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [NSEntityDescription entityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError *error = nil;
        NSArray *result = [self.context executeFetchRequest:request
                                                      error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        _allAssetTypes = [result mutableCopy];
    }
    
    // first time program run
    if ([_allAssetTypes count] == 0) {
        NSManagedObject *type;
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Jewerlry" forKey:@"label"];
        [_allAssetTypes addObject:type];

        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Electronic" forKey:@"label"];
        [_allAssetTypes addObject:type];
    }
    
    return _allAssetTypes;
}


@end












