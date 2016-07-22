//
//  RestfulAPI.h
//  StudyBuzz
//
//  Created by Baihu Jin on 15/11/15.
//  Copyright © 2015 Baihu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserClient.h"

@interface RestfulAPI : NSObject

#pragma mark - Singleton Instance
+ (RestfulAPI *)sharedAPI;

#pragma mark - Instances Of API Client Classes
@property (nonatomic,strong) UserClient  *sharedUserClient;

@end
