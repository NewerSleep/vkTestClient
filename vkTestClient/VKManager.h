//
//  VKManager.h
//  vkTestClient
//
//  Created by Nikita on 24.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreData+MagicalRecord.h"
#import <VKSdk.h>

#import "Item.h"
#import "Profile.h"
#import "Group.h"
#import "Photo.h"

typedef void (^complete)(BOOL);
typedef void (^VKManagerHandler)(BOOL);

@interface VKManager : NSObject <VKSdkDelegate>

+ (id)sharedInstance;

- (void)vkLogin:(VKManagerHandler)handler;
- (void)vkExit;

- (void)loadNews :(BOOL)needOldNews :(complete)complete;
- (void)loadPhotosInNewsByItem:(Item*)item :(complete)complete;

@end
