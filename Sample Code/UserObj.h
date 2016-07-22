//
//  UserObj.h
//  StudyBuzz
//
//  Created by Baihu Jin on 8/10/15.
//  Copyright © 2015 Baihu. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserObj : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString * user_id;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * facebook_id;
@property (nonatomic, strong) NSString * googleplus_id;
@property (nonatomic, strong) NSString * instagram_id;

@property (nonatomic, strong) NSString * first_name;
@property (nonatomic, strong) NSString * last_name;
@property (nonatomic, strong) NSString * about_me;

@property (nonatomic, strong) NSString * avatar_url;

@property (nonatomic, strong) NSNumber * age;
@property (nonatomic, strong) NSDate * birthday;
@property (nonatomic, strong) NSString * gender;

@property (nonatomic, strong) NSNumber * lat;
@property (nonatomic, strong) NSNumber * lng;

@property (nonatomic, strong) NSNumber * enabled;
@property (nonatomic, strong) NSNumber * is_vip;

@property (nonatomic, strong) NSDate * created_at;
@property (nonatomic, strong) NSDate * updated_at;

@end
