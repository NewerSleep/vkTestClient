//
//  DetailController.h
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"
#import "VKManager.h"

@interface DetailController : UITableViewController

- (IBAction)goBackAction:(id)sender;

@property (nonatomic, strong) Item* item;

@end
