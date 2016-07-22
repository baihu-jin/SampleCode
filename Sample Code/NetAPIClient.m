//
//  NetAPIClient.m
//
//  Created by Baihu on 7/6/13.
//  Copyright (c) 2013 Baihu. All rights reserved.
//

#import "NetAPIClient.h"

@implementation NetAPIClient

static NetAPIClient *_sharedClient = nil;

/**
 *  Singleton
 *
 *  @return Singleton Instance of the NetAPIClient Class
 */
+ (NetAPIClient *)sharedClient {
    
    if ( _sharedClient == nil ) {
        _sharedClient = [[NetAPIClient alloc] init];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    }
    
    return _sharedClient;
}

/**
 *  Initializer of Class Instance
 *
 *  @return Class Instance
 */
- (id)init {
    
    self = [super init];
    if (self) {
    }
    
    return self;
}

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
                    failure:(void (^)(NSError *_error, NSInteger status_code))_failure
{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
    
    // Validates and decodes JSON responses
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"text/javascript", @"text/plain", nil];
    
    // Encodes parameters as JSON
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:serviceAPIURL parameters:_params success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        [Logger log:@"Response : %@", responseObject];
        if (_success) {
            _success(responseObject, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        [Logger log:@"Error : %@", error.description];
        if (_failure) {
            _failure(error, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
    }];
    
//    [manager POST:serviceAPIURL parameters:_params success:^(NSURLSessionTask *operation, id responseObject) {
//        [Logger log:@"Response : %@", responseObject];
//        if (_success) {
//            _success(responseObject, [((NSHTTPURLResponse *)operation.response) statusCode]);
//        }
//        
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        [Logger log:@"Error : %@", error.description];
//        if (_failure) {
//            _failure(error, [((NSHTTPURLResponse *)operation.response) statusCode]);
//        }
//    }];
}

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
                    failure:(void (^)(NSError *_error, NSInteger status_code))_failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // Validates and decodes JSON responses
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"text/javascript", @"text/plain", nil];
    
    // Encodes parameters as JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:serviceAPIURL parameters:_params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (_media) {
            NSString *filename = [_params objectForKey:@"filename"];
            
            if (_mediaType == MediaTypePhoto) {
                [formData appendPartWithFileData:_media
                                            name:@"image"
                                        fileName:@"image.jpg"
                                        mimeType:@"image/jpeg" ] ;
            } else {
                [formData appendPartWithFileData:_media
                                            name:@"videofile"
                                        fileName:filename
                                        mimeType:@"video/quicktime"];
            }
        }
        
    } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        // NSString* string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [Logger log:@"Response : %@", responseObject];
        if (_success) {
            _success(responseObject, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }

        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        [Logger log:@"Error : %@", error.description];
        if (_failure) {
            _failure(error, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }

    }];
}

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
                   failure:(void (^)(NSError *_error, NSInteger status_code))_failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // Validates and decodes JSON responses
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"text/javascript", @"text/plain", nil];
    
    // Encodes parameters as JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager PUT:serviceAPIURL parameters:_params success:^(NSURLSessionTask *operation, id responseObject) {
        [Logger log:@"Response : %@", responseObject];
        if (_success) {
            _success(responseObject, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Logger log:@"Error : %@", error.description];
        if (_failure) {
            _failure(error, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
    }];
}

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
                   failure:(void (^)(NSError *_error, NSInteger status_code))_failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // Validates and decodes JSON responses
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"text/javascript", @"text/plain", nil];
    
    // Encodes parameters as JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:serviceAPIURL parameters:_params success:^(NSURLSessionTask *operation, id responseObject) {
        [Logger log:@"Response : %@", responseObject];
        if (_success) {
            _success(responseObject, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [Logger log:@"Error : %@", error.description];
        if (_failure) {
            _failure(error, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
    }];
}



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
                               failure:(void (^)(NSError *_error, NSInteger status_code))_failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // Validates and decodes JSON responses
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"text/javascript", @"text/plain", nil];
    
    // Encodes parameters as JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:serviceAPIURL parameters:_params success:^(NSURLSessionTask *operation, id responseObject) {
        [Logger log:@"Response : %@", responseObject];
        if (_success) {
            _success(responseObject, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        [Logger log:@"Error : %@", error.description];
        if (_failure) {
            _failure(error, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
    }];
}

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
                   failure:(void (^)(NSError *_error, NSInteger status_code))_failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    // Validates and decodes JSON responses
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"text/javascript", @"text/plain", nil];
    
    NSURLCredential *myCredential = [NSURLCredential credentialWithUser:strCredentialKey
                                                               password:strCredentialPassword
                                                            persistence:NSURLCredentialPersistenceNone];
    
    // Encodes parameters as JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.credential = myCredential;
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [securityPolicy setValidatesDomainName:NO];
    [securityPolicy setAllowInvalidCertificates:YES];
    manager.securityPolicy = securityPolicy;
    
    // Set Credential to the Manager
    [manager GET:serviceAPIURL parameters:_params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [Logger log:@"Response : %@", responseObject];
        if (_success) {
            _success(responseObject, [operation.response statusCode]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        [Logger log:@"Error : %@", error.description];
        if (_failure) {
            _failure(error, [operation.response statusCode]);
        }
    }];
    //
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //    // Validates and decodes JSON responses
    //    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"text/javascript", @"text/plain", nil];
    //
    //    // Encodes parameters as JSON
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //
    //    // Set Credential to the Manager
    //    if (![[Utilities sharedInstance] isEmpty:strCredentialKey]) {
    //        NSURLCredential *myCredential = [NSURLCredential credentialWithUser:strCredentialKey
    //                                                                   password:strCredentialPassword
    //                                                                persistence:NSURLCredentialPersistenceNone];
    //        [manager setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession * _Nonnull session, NSURLSessionTask * _Nonnull task, NSURLAuthenticationChallenge * _Nonnull challenge, NSURLCredential *__autoreleasing  _Nullable * _Nullable credential) {
    //            if (challenge.previousFailureCount == 0) {
    //                *credential = myCredential;
    //                return NSURLSessionAuthChallengeUseCredential;
    //            } else {
    //                return NSURLSessionAuthChallengePerformDefaultHandling;
    //            }
    //        }];
    //    }
    //
    //    [manager GET:serviceAPIURL parameters:_params progress:^(NSProgress * _Nonnull downloadProgress) {
    //
    //    } success:^(NSURLSessionTask *operation, id responseObject) {
    //
    //        [Logger log:@"Response : %@", responseObject];
    //        if (_success) {
    //            _success(responseObject, [((NSHTTPURLResponse *)operation.response) statusCode]);
    //        }
    //    } failure:^(NSURLSessionTask *operation, NSError *error) {
    //
    //        [Logger log:@"Error : %@", error.description];
    //        if (_failure) {
    //            _failure(error, [((NSHTTPURLResponse *)operation.response) statusCode]);
    //        }
    //    }];
}

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
                      failure:(void (^)(NSError *_error, NSInteger status_code))_failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // Validates and decodes JSON responses
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/json", @"application/json", @"text/javascript", @"text/plain", nil];
    
    // Encodes parameters as JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager DELETE:serviceAPIURL parameters:_params success:^(NSURLSessionTask *operation, id responseObject) {
        
        [Logger log:@"Response : %@", responseObject];
        if (_success) {
            _success(responseObject, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        [Logger log:@"Error : %@", error.description];
        if (_failure) {
            _failure(error, [((NSHTTPURLResponse *)operation.response) statusCode]);
        }
    }];
}

@end
