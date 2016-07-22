//
//  UserObj.m
//  StudyBuzz
//
//  Created by Baihu Jin on 8/10/15.
//  Copyright © 2015 Baihu. All rights reserved.
//

#import "UserObj.h"

@implementation UserObj

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    return dateFormatter;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"user_id":@"_id",
             @"email":@"email",
             @"facebook_id":@"facebook_id",
             @"googleplus_id":@"googleplus_id",
             @"instagram_id":@"instagram_id",
             @"first_name":@"first_name",
             @"last_name":@"last_name",
             @"about_me":@"about_me",
             @"avatar_url":@"avatar_url",
             @"age":@"age",
             @"birthday":@"birthday",
             @"gender":@"gender",
             @"lat":@"lat",
             @"lng":@"lng",
             @"enabled":@"enabled",
             @"is_vip":@"is_vip",
             @"created_at":@"createdAt",
             @"updated_at":@"updatedAt"
             };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError *__autoreleasing *)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    return self;
}

+ (NSValueTransformer *)created_atJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *strDate, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:strDate];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}

+ (NSValueTransformer *)updated_atJSONTransformer
{
    return [self created_atJSONTransformer];
}

+ (NSValueTransformer *)birthdayJSONTransformer
{
    return [self created_atJSONTransformer];
}

@end
