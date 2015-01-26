//
//  LoginViewController.m
//  vkTestClient
//
//  Created by Nikita on 24.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)logInBtnAction:(id)sender
{
    [[VKManager sharedInstance] vkLogin:^( BOOL completion )
     {
         if( completion )
         {
             [self dismissViewControllerAnimated:YES completion:nil];
         }
     }];
}

@end
