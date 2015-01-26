//
//  DetailTableViewCell.h
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#define IMAGE_H 135.f;
#define IMAGE_OFFSET 5.f;

#import <UIKit/UIKit.h>
#import "Item.h"
#import "Profile.h"
#import "Group.h"
#import "Photo.h"

@interface DetailTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *textLbl;
@property (weak, nonatomic) IBOutlet UIView *imagesContainerView;


- (void)fillCell:(Item*)item;

@end
