//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"NMzSrwlvrCqvUfWTtLsD0uRPC";
static NSString * const consumerSecret = @"3uJOkMfTdC76Sq0JG7hS47g3a5GpwzuOkhSEwwxrVTe2txottO";

@interface APIManager()

@end

@implementation APIManager

// singleton generates a single instance and initiates itself
+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

// completion handler called passing back data

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       
       //Manually cache the tweets. If the request fails, restore from cache if possible.
       NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tweetDictionaries];
       [[NSUserDefaults standardUserDefaults] setValue:data forKey:@"hometimeline_tweets"];
       // Success
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       NSArray *tweetDictionaries = nil;

//       // Fetch tweets from cache if possible
       NSData *data = [[NSUserDefaults standardUserDefaults] valueForKey:@"hometimeline_tweets"];
       if (data != nil) {
           tweetDictionaries = [NSKeyedUnarchiver unarchiveObjectWithData:data];
       }

       completion(tweetDictionaries, error);
   }];
}

// get user info through api call
- (void)getUser:(void(^)(NSDictionary *userDeets, NSError *error))completion {
    
    [self GET:@"1.1/account/settings.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable userDeetsDictionary) {
       
       completion(userDeetsDictionary, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       completion(nil, error);
   }];
}

// get tweets from user
- (void)getTweetsFromUser:(NSString *)screen_name completion:(void (^)(NSArray *, NSError *))completion
{
    NSString *parameter = screen_name;
    [self GET:@"1.1/statuses/user_timeline.json"
   parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionary) {
       
       completion(tweetDictionary, nil);
       
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       completion(nil, error);
   }];
}

// api call to post the new tweet
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
// four methods to favorite, unfavorite, retweet and unretweet: IMPORTANT --
// should figure out how to refactor because there are very small differences between
// methods. way to send in function pointer?

- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json", tweet.idStr];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json", tweet.idStr];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}


@end
