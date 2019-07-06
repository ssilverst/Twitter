//
//  MyProfileViewController.h
//  twitter
//
//  Created by selinons on 7/5/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyProfileViewController : UIViewController
@property (strong, nonatomic) User *user; // Contains name, screenname, etc. of tweet author

@end

NS_ASSUME_NONNULL_END
