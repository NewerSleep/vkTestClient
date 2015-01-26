//
//  Group.m
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "Group.h"


@implementation Group

@dynamic group_id;
@dynamic name;
@dynamic photo_50;
@dynamic photo_100;
@dynamic photo_200;

+ (instancetype)groupWithID:(int)ID
{
    NSNumber* number = [NSNumber numberWithInt:ID];
    Group* group = [Group MR_findFirstByAttribute:@"group_id" withValue:number];
    return group;
}

- (void)setGroup:(NSDictionary *)dict
{
    self.group_id = dict[@"id"];
    self.name = dict[@"name"];
    self.photo_50 = dict[@"photo_50"];
    self.photo_100 = dict[@"photo_100"];
    self.photo_200 = dict[@"photo_200"];
}

@end
