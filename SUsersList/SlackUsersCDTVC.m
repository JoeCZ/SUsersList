//
//  SlackUsersCDTVC.m
//  SUsersList
//
//  Created by Chuou Zhang on 5/10/16.
//  Copyright © 2016 Chuou Zhang. All rights reserved.
//

#import "SlackUsersCDTVC.h"
#import "SlackConstants.h"
#import "User.h"
#import "SlackFetcher.h"
#import "User+Slack.h"
#import "ProfileViewController.h"

@interface SlackUsersCDTVC () <NSURLSessionDelegate, ProfileViewControllerDelegate>

@property (nonatomic, strong) NSURLSession *slackDownloadSession;

@end

@implementation SlackUsersCDTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self startSlackFetch];
}

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    _managedObjectContext = managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    request.predicate = nil;
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES
                                                               selector:@selector(localizedStandardCompare:)]];
    
    
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"User Cell"];
    
    User *user = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = user.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Slack Fetching

- (void)startSlackFetch {
    [self.slackDownloadSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        // let's see if we're already working on a fetch ...
        if (![downloadTasks count]) {
            // ... not working on a fetch, let's start one up
            NSURLSessionDownloadTask *task = [self.slackDownloadSession downloadTaskWithURL:[SlackFetcher URLForUsersList]];
            task.taskDescription = SlackFetch;
            [task resume];
        } else {
            // ... we are working on a fetch (let's make sure it (they) is (are) running while we're here)
            for (NSURLSessionDownloadTask *task in downloadTasks) [task resume];
        }
    }];
}

// the getter for the slackDownloadSession @property
- (NSURLSession *)slackDownloadSession {
    if (!_slackDownloadSession) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSURLSessionConfiguration *urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
            _slackDownloadSession = [NSURLSession sessionWithConfiguration:urlSessionConfig
                                                                   delegate:self 
                                                              delegateQueue:nil];
        });
    }
    return _slackDownloadSession;
}


- (NSArray *)slackUsersAtURL:(NSURL *)url {
    NSDictionary *slackPropertyList;
    NSData *slackJSONData = [NSData dataWithContentsOfURL:url];
    if (slackJSONData) {
        slackPropertyList = [NSJSONSerialization JSONObjectWithData:slackJSONData
                                                             options:0
                                                               error:NULL];
    }
    return [slackPropertyList valueForKeyPath:SlackResultsMembers];
}

- (void)loadSlackUsersFromLocalURL:(NSURL *)localFile
                         intoContext:(NSManagedObjectContext *)context
                 andThenExecuteBlock:(void(^)())whenDone {
    if (context) {
        NSArray *users = [self slackUsersAtURL:localFile];
        [context performBlock:^{
            [User loadUsersFromArray:users intoManagedObjectContext:context];
            [context save:NULL];
            if (whenDone) whenDone();
        }];
    } else {
        if (whenDone) whenDone();
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)localFile {
    if ([downloadTask.taskDescription isEqualToString:SlackFetch]) {
        // If this is the slack fetching, then process the returned data
        [self loadSlackUsersFromLocalURL:localFile
                               intoContext:self.managedObjectContext
                       andThenExecuteBlock:^{
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [self.tableView reloadData];
                           });
                       }
         ];
    }
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error && (session == self.slackDownloadSession)) {
        NSLog(@"slack download session failed: %@", error.localizedDescription);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:SlackUserProfileIdentifier]) {
        ProfileViewController *profileViewController = [segue destinationViewController];
        profileViewController.delegate = self;
        
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        profileViewController.user = (User *)[self.fetchedResultsController objectAtIndexPath:indexPath];
    }
}

#pragma mark - ProfileViewControllerDelegate

- (void)updateInfoForUser:(User *)user {
    if (self.managedObjectContext) {
        [self.managedObjectContext performBlock:^{
            [User updateUserInfoWithUser:user inManagedObjectContext:self.managedObjectContext];
            [self.managedObjectContext save:NULL];
        }];
    }
}

@end
