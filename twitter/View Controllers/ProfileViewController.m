//
//  ProfileViewController.m
//  twitter
//
//  Created by selinons on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followerCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // set the image based on poster path
    NSURL *profileURL = [NSURL URLWithString:self.user.profileImageURL];
    [self.profileImage setImageWithURL:profileURL];

    if (self.user.profileBannerURL != nil)
    {
        NSURL *bannerURL = [NSURL URLWithString:self.user.profileBannerURL];
        [self.bannerImage setImageWithURL:bannerURL];

    }

    self.userLabel.text = self.user.name;
    self.handleLabel.text = [@"@" stringByAppendingString:self.user.screenName];
    self.followerCount.text = self.user.followerCount;
    self.followingCount.text = self.user.followingCount;
    self.tweetCount.text = self.user.tweetCount;
    self.descriptionLabel.text = self.user.userDescription;
    
}

- (IBAction)dismissProfile:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
