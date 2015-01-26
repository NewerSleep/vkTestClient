//
//  VKManager.m
//  vkTestClient
//
//  Created by Nikita on 24.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#define url_api @"https://api.vk.com/method/"

#import "VKManager.h"

@implementation VKManager

static VKManagerHandler pendingHandler = nil;

+ (id)sharedInstance {
    static VKManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];        
    });
    return instance;
}

- (void)vkLogin:(VKManagerHandler)handler
{
    pendingHandler = handler;
    
    NSArray * scope = @[@"friends", @"wall", @"pages"];
    [VKSdk authorize:scope revokeAccess:YES forceOAuth:YES inApp:NO];
}

- (void) vkRunPendingHandler:(VKAccessToken *)token
{
    if ( pendingHandler != nil && token )
    {
        pendingHandler( YES );
        pendingHandler = nil;
    }
    else
    {
        pendingHandler( NO );
        pendingHandler = nil;
    }
}

- (void) vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    [self vkRunPendingHandler:nil];
    NSLog(@"vkSdkNeedCaptchaEnter->Captcha");
}

- (void) vkSdkTokenHasExpired:(VKAccessToken *)expiredToken
{
    [self vkRunPendingHandler:nil];
    NSLog(@"vkSdkTokenHasExpired->Expired");
}

- (void) vkSdkUserDeniedAccess:(VKError *)authorizationError
{
    [self vkRunPendingHandler:nil];
    NSLog(@"vkSdkUserDeniedAccess->Denied %ld - %@", (long)[authorizationError errorCode] , [ authorizationError errorMessage] );
}

- (void) vkSdkReceivedNewToken:(VKAccessToken *)newToken
{
    NSLog(@"vkSdkReceivedNewToken->Token");
    [self vkRunPendingHandler:newToken];
    [self checkForceTokenSave:newToken];
}

- (void)vkSdkAcceptedUserToken:(VKAccessToken *)token
{
    NSLog(@"vkSdkAcceptedUserToken->User token");
    [self vkRunPendingHandler:token];
    [self checkForceTokenSave:token];
}

- (void)vkSdkRenewedToken:(VKAccessToken *)newToken
{
    NSLog( @"vkSdkRenewedToken->Renew" );
    [self vkRunPendingHandler:newToken];
    [self checkForceTokenSave:newToken];
}

- (void)checkForceTokenSave:(VKAccessToken *)authData
{
    
}

- (void)loadNews :(BOOL)needOldNews :(complete)complete
{
    NSLog( @"Start load news" );
    
    NSDictionary* params;
    
    if( needOldNews )
    {
        params = @{ @"max_photos" : @"2", @"count" : @"15", @"start_from" : [[NSUserDefaults standardUserDefaults] objectForKey:@"next_from"] };
    }
    else
    {
        params = @{ @"max_photos" : @"2", @"count" : @"15" };
    }
    
    VKRequest* getNewsRequest = [VKRequest requestWithMethod:@"newsfeed.get" andParameters:params andHttpMethod:@"GET"];
    
    [getNewsRequest executeWithResultBlock:^(VKResponse * response)
     {
         NSLog(@"News json result: %@", response.json);
         
         NSDictionary* responseDictionary = (NSDictionary*)response.json;
         
         [self parseNewsData:responseDictionary];
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
         {
             complete(success);
         }];

     }
                                errorBlock:^(NSError * error)
     {
         if (error.code != VK_API_ERROR)
         {
             [error.vkError.request repeat];
         }
         else
         {
             NSLog(@"VK error: %@", error);
         }
     }];
}

- (void)parseNewsData:(NSDictionary*)response
{
    [[NSUserDefaults standardUserDefaults] setObject:response[@"next_from"] forKey:@"next_from"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    for (NSDictionary* row in response[@"items"])
    {
        Item* item = [Item itemWithID:row[@"post_id"]];
        if (!item)
        {
            item = [Item MR_createEntity];
            item.main_user_id = [[VKSdk getAccessToken] userId];
            [item setItem:row];
        }
    }
    
    for (NSDictionary* row in response[@"groups"])
    {
        Group * group = [Group MR_createEntity];
        [group setGroup:row];
    }
    
    for (NSDictionary * row in response[@"profiles"])
    {
        Profile* profile = [Profile MR_createEntity];
        [profile setProfile:row];
    }
}

- (void)loadPhotosInNewsByItem:(Item *)item :(complete)complete
{
    NSLog( @"Start load detail photo" );
    
    VKRequest* getPhotosRequest = [VKRequest requestWithMethod:@"photos.get" andParameters:@{
                                                                                             @"feed" : [item date],
                                                                                             @"feed_type" : @"photo",
                                                                                             @"owner_id" : [item source_id]
                                                                                             } andHttpMethod:@"GET"];
    
    NSLog( @"%@", [[getPhotosRequest getPreparedRequest] URL] );
    
    [getPhotosRequest executeWithResultBlock:^(VKResponse * response)
     {
         NSLog(@"Photos json result: %@", response.json);
         
         NSDictionary* responseDictionary = (NSDictionary*)response.json;
         
         if( [responseDictionary count] > 0 )
         {
             [self parsePhotosData:responseDictionary andAddPhotoToItem:item];
         }
         
         [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error)
          {
              complete(success);
          }];
         
     }
                                errorBlock:^(NSError * error)
     {
         if (error.code != VK_API_ERROR)
         {
             [error.vkError.request repeat];
         }
         else
         {
             NSLog(@"VK error: %@", error);
         }
     }];
}

- (void)parsePhotosData:(NSDictionary*)response andAddPhotoToItem:(Item*)item
{
    NSMutableSet* photos = (NSMutableSet*)[item photos];
    
    for ( NSDictionary* row in response[@"items"] )
    {
        Photo* photo = [Photo MR_createEntity];
        [photo setPhoto:row];
        [photos addObject:photo];
    }
    
    [item setPhotos:photos];    
}

- (void)vkExit
{
    [VKSdk forceLogout];
}

@end
