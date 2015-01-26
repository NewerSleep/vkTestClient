//
//  Profile.m
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "Profile.h"


@implementation Profile

@dynamic first_name;
@dynamic last_name;
@dynamic photo_50;
@dynamic screen_name;
@dynamic user_id;
@dynamic photo_100;

-(void)setProfile:(NSDictionary *)dict
{
    self.user_id = dict[@"id"];
    self.first_name = dict[@"first_name"];
    self.last_name = dict[@"last_name"];
    self.photo_50 = dict[@"photo_50"];
    self.photo_100 = dict[@"photo_100"];
    self.screen_name = dict[@"screen_name"];
}

+(instancetype)profileWithID:(int)ID
{
    NSNumber* number = [NSNumber numberWithInt:ID];
    Profile* profile = [Profile MR_findFirstByAttribute:@"user_id" withValue:number];
    return profile;
}

@end
