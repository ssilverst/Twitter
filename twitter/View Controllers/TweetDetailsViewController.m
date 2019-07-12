//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by selinons on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "APIManager.h"

@interface TweetDetailsViewController ()

@end

@implementation TweetDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    User *user = self.tweet.user;
    self.userLabel.text = user.name;
    self.tweetLabel.text = self.tweet.text;
    self.dateLabel.text = self.tweet.createdAtString;
    self.handleLabel.text = [@"@" stringByAppendingString:user.screenName];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    UIImage *favoritedIcon = [UIImage imageNamed:@"favor-icon-red"];
    
    UIImage *unfavoritedIcon = [UIImage imageNamed:@"favor-icon"];
    
    UIImage *retweetIcon = [UIImage imageNamed:@"retweet-icon-green"];
    
    UIImage *unretweetIcon = [UIImage imageNamed:@"retweet-icon"];
    
    UIImage *chosenImage = (self.tweet.favorited == YES) ? favoritedIcon:unfavoritedIcon;
    [self.favoriteButton setImage:chosenImage forState:UIControlStateNormal];
    
    chosenImage = (self.tweet.retweeted == YES) ? retweetIcon:unretweetIcon;
    [self.retweetButton setImage:chosenImage forState:UIControlStateNormal];
    
    // set the image based on poster path
    NSURL *profileURL = [NSURL URLWithString:user.profileImageURL];
    
    [self.profileImage setImageWithURL:profileURL];
}
- (IBAction)dismissTweetDeets:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)didTapFavorite:(id)sender
{
    // Update the local tweet model
    // setting the tweet to unfavorited
    if (self.tweet.favorited == YES)
    {
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        // Update cell UI
        [self refreshData];
        // Send a POST request to the POST favorites/create endpoint
        [self unfavoriteTweet];
    }
    // setting the tweet to favorited
    else
    {
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        // Update cell UI
        [self refreshData];
        // Send a POST request to the POST favorites/destroy endpoint
        [self favoriteTweet];
    }
}
- (IBAction)didTapRetweet:(id)sender {
    // Update the local tweet model
    // setting the tweet to unretweeted
    if (self.tweet.retweeted == YES)
    {
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        // Update cell UI
        [self refreshData];
        // Send a POST request to the POST retweet/create endpoint
        [self unretweet];
    }
    // setting the tweet to retweeted
    else
    {
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        // Update cell UI
        [self refreshData];
        // Send a POST request to the POST unretweet/destroy endpoint
        [self retweet];
    }
}

- (void)refreshData
{
    self.favoriteCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    self.retweetCountLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    
    UIImage *favoritedIcon = [UIImage imageNamed:@"favor-icon-red"];
    
    UIImage *unfavoritedIcon = [UIImage imageNamed:@"favor-icon"];
    
    UIImage *retweetIcon = [UIImage imageNamed:@"retweet-icon-green"];
    
    UIImage *unretweetIcon = [UIImage imageNamed:@"retweet-icon"];
    
    UIImage *chosenImage = (self.tweet.favorited == YES) ? favoritedIcon:unfavoritedIcon;
    [self.favoriteButton setImage:chosenImage forState:UIControlStateNormal];
    
    chosenImage = (self.tweet.retweeted == YES) ? retweetIcon:unretweetIcon;
    [self.retweetButton setImage:chosenImage forState:UIControlStateNormal];
    
}
- (void) favoriteTweet
{
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
}
- (void) unfavoriteTweet
{
    [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
        }
    }];
}
- (void) retweet
{
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
}
- (void) unretweet
{
    [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unretweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
        }
    }];
}


@end
