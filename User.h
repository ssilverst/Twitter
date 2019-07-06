//
//  User.h
//  twitter
//
//  Created by selinons on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *screenName;
// Add any additional properties here
@property (strong, nonatomic) NSString *profileImageURL;
@property (strong, nonatomic) NSString *followingCount;
@property (strong, nonatomic) NSString *followerCount;
@property (strong, nonatomic) NSString *tweetCount;
@property (strong, nonatomic) NSString *userDescription;
@property (strong, nonatomic) NSString *profileBannerURL;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
