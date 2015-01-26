//
//  Photo.m
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "Photo.h"
#import "Item.h"


@implementation Photo

@dynamic photo_id;
@dynamic owner_id;
@dynamic photo_130;
@dynamic photo_807;
@dynamic post_id;
@dynamic user_id;
@dynamic item;

- (void)setPhoto:(NSDictionary*)dict
{
    self.photo_id = dict[@"id"];
    self.owner_id = dict[@"owner_id"];
    self.photo_130 = dict[@"photo_130"];
    self.photo_807 = dict[@"photo_807"];
    self.user_id = dict[@"user_id"];
}

@end
