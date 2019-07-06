//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "TweetDetailsViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"

@interface TimelineViewController () <TweetCellDelegate, ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //deferred execution allows you to hand piece of code to completion handler so you don't block the execution of other code
    [SVProgressHUD show];
    
    // step 3: view controller tells the tableview its going to be the datasource and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self fetchTweets];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchTweets) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];


}
-(void) fetchTweets
{
    // Get timeline
    // step 4: making a network request - included completion
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            // step 7: reload tableview data
            [self.tableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
    }];
    
}
//if func is not called you forgot to set the delegate
// step 8, 9: asks for number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}
// step 8: asks for cellForRowAt
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    cell.delegate = self;
    Tweet *tweet = self.tweets[indexPath.row];
    User *user = tweet.user;
    cell.userLabel.text = user.name;
    cell.tweetLabel.text = tweet.text;
    cell.createdAtLabel.text = tweet.createdAtString;
    cell.timeAgoLabel.text = tweet.timeAgoString;
    cell.handleLabel.text = [@"@" stringByAppendingString:user.screenName];
    cell.retweetedCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favoritedCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    cell.tweet = tweet;
    
    UIImage *favoritedIcon = [UIImage imageNamed:@"favor-icon-red"];

    UIImage *unfavoritedIcon = [UIImage imageNamed:@"favor-icon"];
    
    UIImage *retweetIcon = [UIImage imageNamed:@"retweet-icon-green"];

    UIImage *unretweetIcon = [UIImage imageNamed:@"retweet-icon"];

    UIImage *chosenImage = (cell.tweet.favorited == YES) ? favoritedIcon:unfavoritedIcon;
    [cell.favoriteButton setImage:chosenImage forState:UIControlStateNormal];
    
    chosenImage = (cell.tweet.retweeted == YES) ? retweetIcon:unretweetIcon;
    [cell.retweetButton setImage:chosenImage forState:UIControlStateNormal];

    // set the image based on poster path
    NSURL *profileURL = [NSURL URLWithString:user.profileImageURL];

    [cell.profileView setImageWithURL:profileURL];
    return cell;
    
}
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];

}
- (void)didTweet:(Tweet *)tweet
{
    NSArray* newTweets = [self.tweets arrayByAddingObject:tweet];
    self.tweets = newTweets;
    [self.tableView reloadData];
}

- (IBAction)logout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];

}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([[segue identifier] isEqualToString:@"composeSegue"]) {
         UINavigationController *navigationController = [segue destinationViewController];
         ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
         composeController.delegate = self;
     }
     else if ([[segue identifier] isEqualToString:@"detailsSegue"]){
         TweetCell *tappedCell = sender;
         NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
         Tweet *tweet = self.tweets[indexPath.row];
         UINavigationController *navigationController = [segue destinationViewController];
         TweetDetailsViewController *tweetDeetController = (TweetDetailsViewController*)navigationController.topViewController;
         tweetDeetController.tweet = tweet;
     }
     else if ([[segue identifier] isEqualToString:@"profileSegue"]){
         UINavigationController *navigationController = [segue destinationViewController];
         
         ProfileViewController *profileController = (ProfileViewController*)navigationController.topViewController;
         profileController.user = sender;
     }

 }
@end
