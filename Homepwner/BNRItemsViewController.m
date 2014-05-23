//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by WaterWood on 14-5-13.
//  Copyright (c) 2014年 1010.am. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRDetaiViewController.h"
#import "BNRItemCell.h"
#import "BNRImageViewController.h"
#import "BNRImageStore.h"

@interface BNRItemsViewController()


@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        navItem.leftBarButtonItem = self.editButtonItem;
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self selector:@selector(updateTableViewForDynamicTypeSize) name:UIContentSizeCategoryDidChangeNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateTableViewForDynamicTypeSize];
}

- (void)updateTableViewForDynamicTypeSize
{
    static NSDictionary *cellHeightDictionary;
    
    if (!cellHeightDictionary) {
        cellHeightDictionary = @{UIContentSizeCategoryExtraSmall: @44,
                                 UIContentSizeCategorySmall: @44,
                                 UIContentSizeCategoryMedium: @44,
                                 UIContentSizeCategoryLarge: @44,
                                 UIContentSizeCategoryExtraLarge:@55,
                                 UIContentSizeCategoryExtraExtraLarge: @65,
                                 UIContentSizeCategoryExtraExtraExtraLarge: @75};
    }
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    
    NSNumber *cellHeight = cellHeightDictionary[userSize];
    [self.tableView setRowHeight:cellHeight.floatValue];
    NSLog(@"%f", cellHeight.floatValue);
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    
    BNRItem *item = items[indexPath.row];
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    if (item.valueInDollars < 50) {
        cell.valueLabel.backgroundColor = [UIColor greenColor];
    } else {
        cell.valueLabel.backgroundColor = [UIColor redColor];
    }
    cell.thumbnailView.image = item.thumbnail;
    
    __weak BNRItemCell *weakCell = cell;
    cell.actionBlcok = ^{
        NSLog(@"Going to show image for %@", item);
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString *itemKey = item.imageKey;
            UIImage *img = [[BNRImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return;
            }
            BNRItemCell *strongCell = weakCell;
            
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds
                                          fromView:strongCell.thumbnailView];
            BNRImageViewController *ivc = [[BNRImageViewController alloc] init];
            ivc.image = img;
            
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect
                                               inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny
                                             animated:YES];
        }
    };
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    BNRDetaiViewController *detailViewController = [[BNRDetaiViewController alloc] initForNewItem:YES];
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{
        [self.tableView reloadData];
    };
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRItem *item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[BNRItemStore sharedStore] allItems].count) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
}

- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if (proposedDestinationIndexPath.row == [[BNRItemStore sharedStore] allItems].count) {
        return sourceIndexPath;
    }
    return proposedDestinationIndexPath;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[BNRItemStore sharedStore] allItems].count) {
        return NO;
    }
    return YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectItem = items[indexPath.row];
    
    BNRDetaiViewController *detailViewController = [[BNRDetaiViewController alloc] initForNewItem:NO];
    detailViewController.item = selectItem;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}


@end












