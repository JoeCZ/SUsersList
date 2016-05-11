//
//  User+Slack.h
//  SUsersList
//
//  Created by Chuou Zhang on 5/10/16.
//  Copyright © 2016 Chuou Zhang. All rights reserved.
//

#import "User.h"

@interface User (Slack)

+ (User *)userWithInfo:(NSDictionary *)userDictionary inManagedObjectContext:(NSManagedObjectContext *)context;

// Load array of users (fetched via URL) into MOC
+ (void)loadUsersFromArray:(NSArray *)users intoManagedObjectContext:(NSManagedObjectContext *)context;

// Update existing User object
+ (void)updateUserInfoWithUser:(User *)user inManagedObjectContext:(NSManagedObjectContext *)context;

@end
