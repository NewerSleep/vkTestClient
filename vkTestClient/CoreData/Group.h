//
//  Group.h
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "CoreData+MagicalRecord.h"

@interface Group : NSManagedObject

@property (nonatomic, retain) NSNumber * group_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * photo_50;
@property (nonatomic, retain) NSString * photo_100;
@property (nonatomic, retain) NSString * photo_200;

+ (instancetype)groupWithID:(int)ID;
- (void)setGroup:(NSDictionary*)dict;

@end
