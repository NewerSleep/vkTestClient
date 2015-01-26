//
//  Item.h
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"

@class Photo;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSNumber * post_id;
@property (nonatomic, retain) NSNumber * source_id;
@property (nonatomic, retain) NSNumber * likes;
@property (nonatomic, retain) NSNumber * reposts;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * album_type;
@property (nonatomic, retain) NSString * user_id;
@property (nonatomic, retain) NSString * main_user_id;
@property (nonatomic, retain) NSSet *photos;

+ (instancetype)itemWithID:(NSNumber *)ID;
- (void)setItem:(NSDictionary *)dict;

@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

@end
