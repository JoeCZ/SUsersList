//
//  User+Slack.m
//  SUsersList
//
//  Created by Chuou Zhang on 5/10/16.
//  Copyright © 2016 Chuou Zhang. All rights reserved.
//

#import "User+Slack.h"
#import "SlackConstants.h"

@implementation User (Slack)

+ (User *)userWithInfo:(NSDictionary *)userDictionary inManagedObjectContext:(NSManagedObjectContext *)context {
    User *user = nil;
    
    NSString *userId = userDictionary[SlackUserID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches || error || ([matches count] > 1)) {
        // handle error
    } else if ([matches count]) {
        user = [matches firstObject];
    } else {
        user = [NSEntityDescription insertNewObjectForEntityForName:@"User"
                                              inManagedObjectContext:context];
        user.userId = userId;
        user.name = [userDictionary valueForKeyPath:SlackUserName];
        user.color = [userDictionary valueForKeyPath:SlackUserColor];
        user.firstName = [userDictionary valueForKeyPath:SlackUserFirstName];
        user.lastName = [userDictionary valueForKeyPath:SlackUserLastName];
        user.realName = [userDictionary valueForKeyPath:SlackUserRealName];
        user.title = [userDictionary valueForKeyPath:SlackUserTitle];
        user.imageURL = [userDictionary valueForKeyPath:SlackUserImageURL];
        user.phone = [userDictionary valueForKeyPath:SlackUserPhone];
    }
    
    return user;
}

+ (void)loadUsersFromArray:(NSArray *)users intoManagedObjectContext:(NSManagedObjectContext *)context {
    for (NSDictionary *user in users) {
        [self userWithInfo:user inManagedObjectContext:context];
    }
}

+ (void)updateUserInfoWithUser:(User *)user inManagedObjectContext:(NSManagedObjectContext *)context {
    NSString *userId = user.userId;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = [NSPredicate predicateWithFormat:@"userId = %@", userId];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if ([matches count]) {
        User *oldUser = [matches firstObject];
        [oldUser setValue:user.imageData forKey:@"imageData"];
    }
}

@end
