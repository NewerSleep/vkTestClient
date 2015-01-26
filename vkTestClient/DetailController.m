//
//  DetailController.m
//  vkTestClient
//
//  Created by Nikita on 25.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "DetailController.h"
#import "DetailTableViewCell.h"

@interface DetailController ()

@end

@implementation DetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[VKManager sharedInstance] loadPhotosInNewsByItem:_item :^(BOOL completed)
    {
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (CGFloat)getTextHeight
{
    CGFloat size = 0.f;
    
    if( [[_item text] length] > 0 )
    {        
        CGSize constraint = CGSizeMake([UIScreen mainScreen].bounds.size.width-16, FLT_MAX);
        
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        CGSize boundingBox = [[_item text] boundingRectWithSize:constraint
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.f]}
                                                context:context].size;
        
        CGSize cgSize = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
        size = cgSize.height;
    }
    return size;
}

- (CGFloat)getImagesHeight
{
    float imageH = IMAGE_H;
    float imageOffset = IMAGE_OFFSET;
    return (imageH+imageOffset)*[[_item photos] count];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f + [self getTextHeight] + [self getImagesHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    [cell fillCell:_item];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBackAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
