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

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray *tweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];

    //self.tableView.rowHeight = 300;
    //self.tableView.rowHeight = UITableViewAutomaticDimension
    
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
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            //            for (NSDictionary *dictionary in tweets) {
            //                NSString *text = dictionary[@"text"];
            //                NSLog(@"%@", text);
            //            }
            [self.tableView reloadData];
            
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.refreshControl endRefreshing];
        [SVProgressHUD dismiss];
    }];
    
}
//if func is not called you forgot to set the delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];

    Tweet *tweet = self.tweets[indexPath.row];
    User *user = tweet.user;
    cell.userLabel.text = user.name;
    cell.tweetLabel.text = tweet.text;
    cell.createdAtLabel.text = tweet.createdAtString;
    cell.handleLabel.text = [@"@" stringByAppendingString:user.screenName];
    cell.retweetedCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favoritedCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
//    if (user.hasProfile){
    // set the image based on poster path
    NSURL *profileURL = [NSURL URLWithString:user.profileImageURL];

    [cell.profileView setImageWithURL:profileURL];
    //}
    
    return cell;
    
}
- (void)didTweet:(Tweet *)tweet
{
    NSArray* newTweets = [self.tweets arrayByAddingObject:tweet];
    self.tweets = newTweets;
    [self.tableView reloadData];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if(!self.isMoreDataLoading){
//        // Calculate the position of one screen length before the bottom of the results
//        int scrollViewContentHeight = self.tableView.contentSize.height;
//        int scrollOffsetThreshold = scrollViewContentHeight - self.tableView.bounds.size.height;
//
//        // When the user has scrolled past the threshold, start requesting
//        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tableView.isDragging) {
//            self.isMoreDataLoading = true;
//            //[self loadMoreData];
//        }
//
//    }
//}
//-(void)loadMoreData{
//    [APIManager init];
//
//    // Configure session so that completion handler is executed on main UI thread
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//
//    NSURLSession *session  = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
//
//    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *requestError) {
//        if (requestError != nil) {
//
//        }
//        else
//        {
//            // Update flag
//            self.isMoreDataLoading = false;
//
//            // ... Use the new data to update the data source ...
//
//            // Reload the tableView now that there is new data
//            [self.tableView reloadData];
//        }
//    }];
//    [task resume];
//}
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 UINavigationController *navigationController = [segue destinationViewController];
 ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
 composeController.delegate = self;
 }

@end
