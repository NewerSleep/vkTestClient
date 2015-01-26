//
//  Photo.h
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Item;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSNumber * photo_id;
@property (nonatomic, retain) NSNumber * owner_id;
@property (nonatomic, retain) NSString * photo_130;
@property (nonatomic, retain) NSString * photo_807;
@property (nonatomic, retain) NSNumber * post_id;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) Item *item;

- (void)setPhoto:(NSDictionary*)dict;

@end
