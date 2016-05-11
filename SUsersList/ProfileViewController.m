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

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userTitle;
@property (weak, nonatomic) IBOutlet UILabel *userRealName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;

@end

@implementation ProfileViewController

- (void)configureLabels {
    self.username.text = [NSString stringWithFormat:@"@%@", self.user.name];
    self.userTitle.text = self.user.title;
    self.userRealName.text = self.user.realName;
    if (self.user.phone) {
        self.userPhone.text = [NSString stringWithFormat:@"Phone: %@", self.user.phone];
    } else {
        self.userPhone.hidden = YES;
    }
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
    self.userImageView.image = [UIImage imageNamed:@"DefaultUserImage"];
    if (self.user.imageData) {
        self.userImageView.image = [UIImage imageWithData:self.user.imageData];
    } else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.user.imageURL]];
            if (!data) {
                return;
            }
            
            self.user.imageData = data;
            if ([self.delegate respondsToSelector:@selector(updateInfoForUser:)]) {
                [self.delegate updateInfoForUser:self.user];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.userImageView.image = [UIImage imageWithData:data];
            });
        });
    }
}

@end
