//
//  LoginViewController.h
//  vkTestClient
//
//  Created by Nikita on 24.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKManager.h"
#import <VKSdk.h>

@interface LoginViewController : UIViewController <VKSdkDelegate>

- (IBAction)logInBtnAction:(id)sender;

@end
