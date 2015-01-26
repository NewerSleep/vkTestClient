//
//  NewsTableViewCell.h
//  vkTestClient
//
//  Created by Nikita on 24.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "News.h"
#import "Profile.h"
#import "Group.h"
#import "Item.h"
#import "Photo.h"

@interface NewsTableViewCell : UITableViewCell

//- (void)fillWithNews:(Item*)item;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthorName;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *newsTextLbl;

@property (weak, nonatomic) IBOutlet UIImageView *newsImgView1;
@property (weak, nonatomic) IBOutlet UIImageView *newsImgView2;

- (void)setContent:(Item*)item;

@end
