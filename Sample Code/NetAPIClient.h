//
//  NetAPIClient.h
//
//  Created by Baihu on 7/6/13.
//  Copyright (c) 2013 Baihu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

#import "CTConfig.h"

typedef enum {
    MediaTypePhoto = 0,
    MediaTypeVideo = 1
} MediaType;

@interface NetAPIClient : AFHTTPSessionManager

/**
 *  Singleton
 *
 *  @return Singleton Instance of the NetAPIClient Class
 */
+ (NetAPIClient *)sharedClient;

/**
 *  Submit textual data by POST
 *
 *  @param serviceAPIURL URL of the RESTful API
 *  @param _params       Parameters
 *  @param _success      Success Handler Block
 *  @param _failure      Failure Handler Block
 */
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                    success:(void (^)(id _responseObject, NSInteger status_code))_success
                    failure:(void (^)(NSError *_error, NSInteger status_code))_failure;

/**
 *  Submit photo/video data by POST
 *
 *  @param serviceAPIURL URL of the RESTful API
 *  @param _params       Parameters
 *  @param _media        NSData (image or video data)
 *  @param _mediaType    0:MediaTypePhoto, 1:MediaTypeVideo
 *  @param _success      Success Handler Block
 *  @param _failure      Failure Handler Block
 */
- (void)sendToServiceByPOST:(NSString *)serviceAPIURL
                     params:(NSDictionary *)_params
                      media:(NSData* )_media
                  mediaType:(MediaType)_mediaType
                    success:(void (^)(id _responseObject, NSInteger status_code))_success
                    failure:(void (^)(NSError *_error, NSInteger status_code))_failure;

/**
 *  Update Record by PUT
 *
 *  @param serviceAPIURL URL of the RESTful API
 *  @param _params       Parameters
 *  @param _success      Success Handler Block
 *  @param _failure      Failure Handler Block
 */
- (void)sendToServiceByPUT:(NSString *)serviceAPIURL
                    params:(NSDictionary *)_params
                   success:(void (^)(id _responseObject, NSInteger status_code))_success
                   failure:(void (^)(NSError *_error, NSInteger status_code))_failure;

/**
 *  Get Records by GET
 *
 *  @param serviceAPIURL URL of the RESTful API
 *  @param _params       Parameters
 *  @param _success      Success Handler Block
 *  @param _failure      Failure Handler Block
 */
- (void)sendToServiceByGET:(NSString *)serviceAPIURL
                    params:(NSDictionary *)_params
                   success:(void (^)(id _responseObject, NSInteger status_code))_success
                   failure:(void (^)(NSError *_error, NSInteger status_code))_failure;

/**
 *  Get HTTP Response by GET
 *
 *  @param serviceAPIURL URL of the RESTful API
 *  @param _params       Parameters
 *  @param _success      Success Handler Block
 *  @param _failure      Failure Handler Block
 */
- (void)sendToHTTPResponseServiceByGET:(NSString *)serviceAPIURL
                                params:(NSDictionary *)_params
                               success:(void (^)(id _responseObject, NSInteger status_code))_success
                               failure:(void (^)(NSError *_error, NSInteger status_code))_failure;

/**
 *  Retrieve Records by GET With Credentials
 *
 *  @param serviceAPIURL            URL of the RESTful API
 *  @param _params                  Parameters
 *  @param strCredentialKey         Credential Key
 *  @param strCredentialPassword    Credential Password
 *  @param _success                 Success Handler Block
 *  @param _failure                 Failure Handler Block
 */
- (void)sendToServiceByGET:(NSString *)serviceAPIURL
             CredentialKey:(NSString *)strCredentialKey
        CredentialPassword:(NSString *)strCredentialPassword
                    params:(NSDictionary *)_params
                   success:(void (^)(id _responseObject, NSInteger status_code))_success
                   failure:(void (^)(NSError *_error, NSInteger status_code))_failure;

/**
 *  Delete Record by DELETE Method
 *
 *  @param serviceAPIURL URL of the RESTful API
 *  @param _params       Parameters
 *  @param _success      Success Handler Block
 *  @param _failure      Failure Handler Block
 */
- (void)sendToServiceByDELETE:(NSString *)serviceAPIURL
                       params:(NSDictionary *)_params
                      success:(void (^)(id _responseObject, NSInteger status_code))_success
                      failure:(void (^)(NSError *_error, NSInteger status_code))_failure;

@end
