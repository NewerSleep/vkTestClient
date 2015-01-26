//
//  DetailTableViewCell.m
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "DetailTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation DetailTableViewCell
{

}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)fillCell:(Item *)item
{
    [_textLbl setText:[item text]];
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:[item.date integerValue]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    [_dateLbl setText:[formatter stringFromDate:date]];
    
    int sourceID = (int)[item.source_id integerValue];
    BOOL isUserNews = sourceID > 0;
    
    if( isUserNews )
    {
        Profile* profile = [Profile profileWithID:sourceID];
        
        if (profile)
        {
            [_nameLbl setText:[NSString stringWithFormat:@"%@ %@", profile.first_name, profile.last_name]];
            [self setImageToImageView:_avatarImgView withURL:profile.photo_100];
        }
    }
    else
    {
        Group* group = [Group groupWithID:-sourceID];
        
        if (group)
        {
            [_nameLbl setText:[group name]];
            [self setImageToImageView:_avatarImgView withURL:group.photo_100];
        }
    }
    
    int imageNumber = 0;
    
    float imageH = IMAGE_H;
    float imageW = 200.f;
    float imageOffset = IMAGE_OFFSET;
    
    [[_imagesContainerView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for ( Photo* photo in [item photos] )
    {
        UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake( 0, imageNumber*imageH+imageOffset, imageW, imageH)];
        
        [imgView setContentMode:UIViewContentModeScaleAspectFit];
        
        [self setImageToImageView:imgView withURL:[photo photo_807]];
        
        [_imagesContainerView addSubview:imgView];
        
        ++imageNumber;
    }
    
    
}

- (void)setImageToImageView:(UIImageView*)imgView withURL:(NSString*)URL
{
    UIImage* img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@",URL]];
    imgView.image = nil;
    
    if( img )
    {
        [imgView setImage:img];
    }
    else
    {
        [imgView sd_setImageWithURL:[NSURL URLWithString:URL] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             [[SDImageCache sharedImageCache] storeImage:image forKey:[NSString stringWithFormat:@"%@",URL] toDisk:YES];
         }];
    }
}

@end
