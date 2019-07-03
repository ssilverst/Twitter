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
//@property (strong, nonatomic) NSObject *hasProfile;
@property (strong, nonatomic) NSString *profileImageURL;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end
