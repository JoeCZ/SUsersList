//
//  ProfileViewController.m
//  SUsersList
//
//  Created by Chuou Zhang on 5/10/16.
//  Copyright © 2016 Chuou Zhang. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;
@property (weak, nonatomic) IBOutlet UILabel *userRealName;

@end

@implementation ProfileViewController

- (void)configureLabels {
    self.username.text = self.user.name;
    self.userTitle.text = self.user.title;
    self.userRealName.text = self.user.realName;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureLabels];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadImage];
}

- (void)loadImage {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.user.imageURL]];
        if (!data) {
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.userImage.image = [UIImage imageWithData: data];
        });
    });
}

@end
