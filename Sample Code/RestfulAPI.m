//
//  RestfulAPI.m
//  StudyBuzz
//
//  Created by Baihu Jin on 15/11/15.
//  Copyright © 2015 Baihu. All rights reserved.
//

#import "RestfulAPI.h"

@implementation RestfulAPI

@synthesize sharedUserClient = _sharedUserClient;

+ (RestfulAPI *)sharedAPI
{
    static RestfulAPI *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_sharedClient == nil)
            _sharedClient = [[RestfulAPI alloc] init];
    });
    return _sharedClient;
}

- (id) init
{
    self = [super init];
    
    if (self) {
        self.sharedUserClient = [[UserClient alloc] init];
    }
    
    return self;
}

@end
