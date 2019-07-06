//
//  TweetCell.h
//  twitter
//
//  Created by selinons on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN
@protocol TweetCellDelegate;

@interface TweetCell : UITableViewCell
@property (nonatomic, weak) id<TweetCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *profileView;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;

@property (weak, nonatomic) IBOutlet UILabel *createdAtLabel;
@property (weak, nonatomic) IBOutlet UILabel *favoritedCount;
@property (weak, nonatomic) IBOutlet UILabel *retweetedCount;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (strong, nonatomic) Tweet *tweet;
- (IBAction)didTapFavorite:(id)sender;
- (IBAction)didTapRetweet:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeAgoLabel;
@end

@protocol TweetCellDelegate
- (void)tweetCell:(TweetCell *) tweetCell didTap: (User *)user;
@end

NS_ASSUME_NONNULL_END
