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

+ (void)loadUsersFromArray:(NSArray *)users intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
