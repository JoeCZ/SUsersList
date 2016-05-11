//
//  CoreDataTableViewController.h
//  SUsersList
//
//  Created by Chuou Zhang on 5/8/16.
//  Copyright © 2016 Chuou Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

// Make the fetchedResultsController to refetch the data
- (void)performFetch;

@end
