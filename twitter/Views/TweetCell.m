//
//  TweetCell.m
//  twitter
//
//  Created by selinons on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didTapFavorite:(id)sender
{
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    NSLog(@"%d", self.tweet.favoriteCount);
    [self refreshData];
}
- (void)refreshData
{
    self.favoritedCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    
    self.favoriteButton.imageView.image = [UIImage imageNamed:@"favor-icon-red"];
}

@end
