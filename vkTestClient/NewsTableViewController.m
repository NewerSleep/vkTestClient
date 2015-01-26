//
//  NewsTableViewController.m
//  vkTestClient
//
//  Created by Nikita on 24.01.15.
//  Copyright (c) 2015 Nikita. All rights reserved.
//

#import "NewsTableViewController.h"
#import "LoginViewController.h"
#import "NewsTableViewCell.h"
#import "DetailController.h"

@interface NewsTableViewController ()
{
    NSArray* newsArray;
    BOOL isUpdating;
    
    UIActivityIndicatorView* activityIndicator;
}

@end

@implementation NewsTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];    
    isUpdating = YES;
    if( [VKSdk wakeUpSession] )
    {
        [self startActivityIndicatorAnimation];
        
        [[VKManager sharedInstance] loadNews:NO :^(BOOL completed)
        {
            [self stopActivityIndicatorAnimation];
            isUpdating = NO;
            if( completed )
            {
                newsArray = nil;
                [self.tableView reloadData];
            }
        }];
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(updateNews) forControlEvents:UIControlEventValueChanged];
}

- (void)updateNews
{
    if( [VKSdk wakeUpSession] )
    {
        isUpdating = YES;
        [[VKManager sharedInstance] loadNews:NO :^(BOOL completed)
         {
             isUpdating = NO;
             if( completed )
             {
                 newsArray = nil;
                 [self.tableView reloadData];
                 [self.refreshControl endRefreshing];
             }
         }];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    newsArray = nil;
    
    if ( ![VKSdk wakeUpSession] )
    {
        [self needLogin];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)needLogin
{
    LoginViewController * login = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:login animated:NO completion:nil];

}

#pragma mark - Table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self getNews] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Item* item = [self getNews][indexPath.row];
    
    NSString * identifire;
    
    if( [[item photos] count] > 0 && [item text] )
    {
        identifire = @"textImgNews";
    }
    else if ( [[item photos] count] > 0 && ![item text] )
    {
        identifire = @"imgNews";
    }
    else
    {
        identifire = @"textNews";
    }
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifire forIndexPath:indexPath];
    
    [cell setContent:item];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float maxTableViewOffset = 60.f;
    if ( !isUpdating && scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - maxTableViewOffset )
    {
        isUpdating = YES;
        [[VKManager sharedInstance] loadNews:YES :^(BOOL completed)
         {
             isUpdating = NO;
             if( completed )
             {
                 newsArray = nil;
                 [self.tableView reloadData];
             }
         }];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = (UITableViewCell*)sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    Item* item = [self getNews][indexPath.row];
    
    DetailController* detailController = segue.destinationViewController;
    [detailController setItem:item];
}

#pragma mark

- (NSArray*)getNews
{
    if( !newsArray )
    {
        NSString* userID = [[VKSdk getAccessToken] userId];
        newsArray = userID ? [Item MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"main_user_id == %@",userID]] : nil;
        
        if( newsArray )
        {
            newsArray = [newsArray sortedArrayUsingComparator:^NSComparisonResult(Item * item1, Item * item2)
                         {
                             return [item1.date compare:item2.date] == NSOrderedAscending;
                         }];
        }
    }
    
    return newsArray;
}

- (IBAction)exitBtnAction:(id)sender
{
    [[VKManager sharedInstance] vkExit];    
    [self needLogin];
}

- (void)startActivityIndicatorAnimation
{
    if( !activityIndicator )
    {
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityIndicator setCenter:self.view.center];
        [activityIndicator setColor:[UIColor colorWithRed:(CGFloat)91.f/255.f green:(CGFloat)125.f/255.f blue:(CGFloat)160.f/255.f alpha:1.f]];
        [activityIndicator hidesWhenStopped];
        
        [self.view addSubview:activityIndicator];
    }
    
    [activityIndicator startAnimating];
}

- (void)stopActivityIndicatorAnimation
{
    [activityIndicator stopAnimating];
}

@end
