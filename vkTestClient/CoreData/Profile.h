//
//  Profile.h
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"

@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * photo_50;
@property (nonatomic, retain) NSString * screen_name;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSString * photo_100;

+ (instancetype)profileWithID:(int)ID;
- (void)setProfile:(NSDictionary*)dict;

@end
