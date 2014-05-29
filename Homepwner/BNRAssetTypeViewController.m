//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by WaterWood on 14-5-24.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"

@implementation BNRAssetTypeViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Asset Type", @"BNRAssetTypeViewController title");
    }
    
    return  self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[BNRItemStore sharedStore] allAssetTypes].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    NSArray *allAsserts = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = allAsserts[indexPath.row];
    
    NSString *assetLabel = [assetType valueForKey:@"label"];
    cell.textLabel.text = assetLabel;
    
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    
    NSManagedObject *assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        self.dismissBlock();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end













