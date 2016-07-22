//
//  UserClient.h
//
//  Created by Baihu Jin on 7/6/13.
//  Copyright (c) 2013 Baihu Jin. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "UserObj.h"

@interface UserClient : NSObject

- (id)init;

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
               failure:(void (^)(NSError* error, NSInteger status_code))failure;

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
                     failure:(void (^)(NSError* error, NSInteger status_code))failure;

@end
