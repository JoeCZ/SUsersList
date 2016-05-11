//
//  SlackFetcher.m
//  SUsersList
//
//  Created by Chuou Zhang on 5/10/16.
//  Copyright © 2016 Chuou Zhang. All rights reserved.
//

#import "SlackFetcher.h"

NSString * const kSlackAPIToken = @"xoxp-4698769766-4698769768-18910479235-8fa82d53b2";
NSString * const kSlackAPIBaseURL = @"https://slack.com/api/users.list";

@implementation SlackFetcher

+ (NSURL *)URLForUsersList {
    NSString *urlString = [NSString stringWithFormat:@"%@?token=%@", kSlackAPIBaseURL, kSlackAPIToken];
    return [NSURL URLWithString:urlString];
}

@end
