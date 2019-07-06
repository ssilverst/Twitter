//
//  MyProfileViewController.m
//  twitter
//
//  Created by selinons on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "MyProfileViewController.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"

@interface MyProfileViewController ()
@property (strong, nonatomic) NSDictionary *userDictionary;
@property (strong, nonatomic) NSString *screenName;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *tweetCount;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchUser];
    [self fetchTweetsFromUser];
    //self.userLabel.text = self.userDictionary[@"name"];
    //self.handleLabel.text = self.user.screenName;
    NSLog(@"Help");
    //self.descriptionLabel.text = self.userDictionary[@""];
    
}
- (void)fetchUser {
    [[APIManager shared] getUser:^(NSDictionary *userDeets, NSError *error) {
        if (userDeets) {
            self.screenName = userDeets[@"screen_name"];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}
- (void)fetchTweetsFromUser {
    [[APIManager shared] getTweetsFromUser:self.user.screenName completion:^(NSArray *userDeets, NSError *error){
        if (userDeets) {
            self.userDictionary = (NSDictionary *) userDeets;
            //NSLog(@"%@", userDeets);
            for (NSDictionary *tweet in self.userDictionary){
                NSDictionary *userStuff = tweet[@"user"];
                
                if (self.screenName == userStuff[@"screen_name"])
                {
                    
                    self.userLabel.text = userStuff[@"name"];
                    self.descriptionLabel.text = userStuff[@"description"];
                    self.followersCount.text = [NSString stringWithFormat:@"%@",userStuff[@"followers_count"]];
                    self.followingCount.text = [NSString stringWithFormat:@"%@",userStuff[@"friends_count"]];
                    self.tweetCount.text = [NSString stringWithFormat:@"%@",userStuff[@"statuses_count"]];
                    NSURL *profileURL = [NSURL URLWithString:userStuff[@"profile_image_url_https"]];
                    [self.profileImage setImageWithURL:profileURL];
                    
                    NSURL *bannerURL = [NSURL URLWithString:userStuff[@"profile_banner_url"]];
                    [self.bannerImage setImageWithURL:bannerURL];
                }
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];

}


@end
