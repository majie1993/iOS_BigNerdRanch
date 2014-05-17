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

@interface BNRItemsViewController()

@property (nonatomic, strong) NSMutableArray *moreThenFiftyItems;
@property (nonatomic, strong) NSMutableArray *lessThenFiftyItems;

@end

@implementation BNRItemsViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        for (int i=0; i<5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
        
        _moreThenFiftyItems = [[NSMutableArray alloc] init];
        _lessThenFiftyItems = [[NSMutableArray alloc] init];
        // deal with 50 dollar
        for (BNRItem *item in [[BNRItemStore sharedStore] allItems]) {
            if (item.valueInDollars > 50) {
                [_moreThenFiftyItems addObject:item];
            } else {
                [_lessThenFiftyItems addObject:item];
            }
        }
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.tableView.backgroundView = imageView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.lessThenFiftyItems.count;
    } else {
        return self.moreThenFiftyItems.count + 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    if (section == 0) {
        label.text = @"小于50";
    } else {
        label.text = @"大于50";
    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1 && indexPath.row==self.moreThenFiftyItems.count) {
        return 44;
    }
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        NSString *str = [self.lessThenFiftyItems[indexPath.row] description];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]}];
        cell.textLabel.attributedText = attrStr;
    } else {
        if (indexPath.row == self.moreThenFiftyItems.count) {
            cell.textLabel.text = @"No more Items";
        } else {
            NSString *str = [self.moreThenFiftyItems[indexPath.row] description];
            NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:20]}];
            cell.textLabel.attributedText = attrStr;
            
        }
    }
    
    return cell;
}

@end
