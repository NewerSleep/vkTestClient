//
//  NewsTableViewCell.m
//  vkTestClient
//
//  Created by Nikita on 24.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "NewsTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation NewsTableViewCell

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setContent:(Item *)item
{
    [_newsTextLbl setText:[item text]];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[item.date integerValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    [_dateLbl setText:[formatter stringFromDate:date]];
    
    int sourceID = (int)[item.source_id integerValue];
    BOOL isUserNews = sourceID > 0;
    
    _avatarImgView.image = nil;
    _newsImgView1.image = nil;
    _newsImgView2.image = nil;
    
    if( isUserNews )
    {
        Profile* profile = [Profile profileWithID:sourceID];
        
        if (profile)
        {
            [_lblAuthorName setText:[NSString stringWithFormat:@"%@ %@", profile.first_name, profile.last_name]];
            [self setImageToImageView:_avatarImgView withURL:profile.photo_100];
        }
    }
    else
    {
        Group* group = [Group groupWithID:-sourceID];
        
        if (group)
        {
            [_lblAuthorName setText:[group name]];
            [self setImageToImageView:_avatarImgView withURL:group.photo_100];
        }
    }
    
    NSArray* photosArray = [[item photos] allObjects];
    
    if( [[item photos] count] == 1 )
    {
        Photo* photo = photosArray[0];
        [self setImageToImageView:_newsImgView1 withURL:[photo photo_130]];

    }
    else if( [[item photos] count] == 2 )
    {
        Photo* photo2 = photosArray[0];
        [self setImageToImageView:_newsImgView1 withURL:[photo2 photo_130]];
        Photo* photo3 = photosArray[1];
        [self setImageToImageView:_newsImgView2 withURL:[photo3 photo_130]];
    }
}

- (void)setImageToImageView:(UIImageView*)imgView withURL:(NSString*)URL
{
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [imgView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    UIImage* img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@",URL]];
    
    
    
    if( img )
    {
        [activityIndicator stopAnimating];
        [activityIndicator removeFromSuperview];
        
        [imgView setImage:img];
    }
    else
    {
        [imgView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             [activityIndicator stopAnimating];
             [activityIndicator removeFromSuperview];
             
             [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"%@",URL] toDisk:YES];
         }];
    }
}

@end
