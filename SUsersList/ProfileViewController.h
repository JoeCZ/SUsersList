//
//  ProfileViewController.h
//  SUsersList
//
//  Created by Chuou Zhang on 5/10/16.
//  Copyright © 2016 Chuou Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class User;

@protocol ProfileViewControllerDelegate <NSObject>

- (void)updateInfoForUser:(User *)user;

@end

@interface ProfileViewController : UIViewController

@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;
@property (nonatomic, strong) User *user;

@end
