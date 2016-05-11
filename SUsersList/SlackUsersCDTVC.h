//
//  SlackUsersCDTVC.h
//  SUsersList
//
//  Created by Chuou Zhang on 5/10/16.
//  Copyright © 2016 Chuou Zhang. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "AppDelegate.h"

@interface SlackUsersCDTVC : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
