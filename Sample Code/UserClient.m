//
//  UserClient.m
//
//  Created by Baihu Jin on 7/6/13.
//  Copyright (c) 2013 Baihu Jin. All rights reserved.
//

#import "UserClient.h"
#import "NetAPIClient.h"

@implementation UserClient

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

/**
 *  Login API
 *
 *  @param email                email
 *  @param password             password
 *  @param success              success block
 *  @param failure              failure block
 */
- (void)loginWithEmail:(NSString *)email
           AndPassword:(NSString *)password
               success:(void (^)(id responseObject, NSInteger status_code))success
               failure:(void (^)(NSError* error, NSInteger status_code))failure
{
    NSString *restfulAPIUrl = [NSString stringWithFormat:RESTAPI_LOGIN, WEBSITE_URL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            email, @"email",
                            password, @"password",
                            nil];

    [[NetAPIClient sharedClient] sendToServiceByPOST:restfulAPIUrl params:params success:^(id _responseObject, NSInteger status_code) {
        success(_responseObject, status_code);
    } failure:^(NSError *_error, NSInteger status_code) {
        failure(_error, status_code);
    }];
}

/**
 *  Register API
 *
 *  @param username             username
 *  @param email                email
 *  @param password             password
 *  @param cpassword            cpassword
 *  @param success              success block
 *  @param failure              failure block
 */
- (void)registerWithUsername:(NSString *)username
                       Email:(NSString *)email
                    Password:(NSString *)password
             ConfirmPassword:(NSString *)cpassword
                     success:(void (^)(id responseObject, NSInteger status_code))success
                     failure:(void (^)(NSError* error, NSInteger status_code))failure
{
    NSString *restfulAPIUrl = [NSString stringWithFormat:RESTAPI_REGISTER, WEBSITE_URL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            username, @"username",
                            email, @"email",
                            password, @"password",
                            cpassword, @"cpassword",
                            nil];
    
    [[NetAPIClient sharedClient] sendToServiceByPOST:restfulAPIUrl params:params success:^(id _responseObject, NSInteger status_code) {
        success(_responseObject, status_code);
    } failure:^(NSError *_error, NSInteger status_code) {
        failure(_error, status_code);
    }];
}


@end
