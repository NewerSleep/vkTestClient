//
//  Item.m
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "Item.h"
#import "Photo.h"


@implementation Item

@dynamic date;
@dynamic post_id;
@dynamic source_id;
@dynamic text;
@dynamic type;
@dynamic user_id;
@dynamic main_user_id;
@dynamic photos;
@dynamic likes;
@dynamic reposts;
@dynamic album_type;

+ (instancetype)itemWithID:(NSNumber *)ID
{
    Item* item = [Item MR_findFirstByAttribute:@"post_id" withValue:ID];
    return item;
}

- (void)setItem:(NSDictionary *)dict
{
    NSMutableSet* photos = [NSMutableSet set];
    
    self.date  = dict[@"date"];
    self.post_id = dict[@"post_id"];
    self.source_id = dict[@"source_id"];
    self.type = dict[@"type"];
    self.user_id = dict[@"user_id"];
    self.type = dict[@"type"];
    self.likes = dict[@"likes"][@"count"];
    self.reposts = dict[@"reposts"][@"count"];
    
    if( dict[@"copy_history"] )
    {
        NSMutableDictionary* copyHistory = dict[@"copy_history"][0];
        self.text = copyHistory[@"text"];
        
        if ( copyHistory[@"photos"] )
        {
            for ( NSDictionary* row in copyHistory[@"photos"][@"items"] )
            {
                Photo * photo = [Photo MR_createEntity];
                [photo setPhoto:row];
                [photos addObject:photo];
            }
        }
        if ( copyHistory[@"attachments"] )
        {
            for( NSDictionary* row in copyHistory[@"attachments"] )
            {
                Photo * photo = [Photo MR_createEntity];
                [photo setPhoto:row[@"photo"]];
                [photos addObject:photo];
            }
        }
    }
    else
    {
        self.text = dict[@"text"];
    }
    
    if ( dict[@"attachments"] )
    {
        for( NSDictionary* row in dict[@"attachments"] )
        {
            Photo * photo = [Photo MR_createEntity];
            [photo setPhoto:row[@"photo"]];
            [photos addObject:photo];
        }
    }
    
    if ( dict[@"photos"] )
    {
        for ( NSDictionary* row in dict[@"photos"][@"items"] )
        {
            Photo * photo = [Photo MR_createEntity];
            [photo setPhoto:row];
            [photos addObject:photo];
        }
    }
    
    self.photos = [photos copy];
}

@end
