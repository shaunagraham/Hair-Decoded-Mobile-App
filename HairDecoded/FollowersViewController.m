//
//  FollowersViewController.m
//  HairDecoded
//
//  Created by George on 25/04/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "FollowersViewController.h"
#import "Cell.h"
#import "CalendarViewController.h"

@interface FollowersViewController ()

@end

@implementation FollowersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        // Do your stuff here
        //NSLog(@"sdfdsdfsdfsdfsdfs");
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.user_id = self.calendarID;
    }
}

-(void)perform:(id)sender{

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"Cell"];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    self.calendarID = delegate.user_id;

    [self.navigationItem.backBarButtonItem setAction:@selector(perform:)];

    if (!IS_IPHONE_5){
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height-88);
    }
    
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getImagesRequest:) withObject:nil];
    
    _statFilter = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Followers", @"Following", nil]];
//    [_statFilter setse];
    [_statFilter addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _statFilter;
}

-(void)changeView:(id)sender{

    if ([_statFilter selectedSegmentIndex] == 0){
        [self.content removeAllObjects];
        [self.content addObjectsFromArray:self.followers];
        if (self.content.count == 0){
            self.nothing.text = @"No followers.";
            self.nothing.hidden = NO;
        }
        else{
            self.nothing.hidden = YES;
        }
    }
    else {
        [self.content removeAllObjects];
        [self.content addObjectsFromArray:self.following];
        if (self.content.count == 0){
            self.nothing.text = @"Not following anyone.";
            self.nothing.hidden = NO;
        }
        else{
            self.nothing.hidden = YES;
        }

    }
    [self.collectionView reloadData];
}

-(void)getImagesRequest:(id)sender{
    @autoreleasepool {
        
        
        
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&id=%@",GetIdFollowers,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],self.followerID];
        
        //NSLog(@"%@",url);
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            NSLog(@"%@",dict);
            
            self.following = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"following"]];
             self.followers = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"followers"]];
            [self performSelectorOnMainThread:@selector(getImagesSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getImagesError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}



-(void)getImagesSuccess:(id)sender{
    self.nothing.hidden = YES;
    
    if (self.followers.count > 0){
        [_statFilter setSelectedSegmentIndex:0];
        self.content = [[NSMutableArray alloc]initWithArray:self.followers];
    }
    else {
        if (self.following.count > 0){
            [_statFilter setSelectedSegmentIndex:1];
            self.content = [[NSMutableArray alloc]initWithArray:self.following];
        }
        else {
            self.nothing.text = @"Nothing to show";
            self.nothing.hidden = NO;
            self.content = [[NSMutableArray alloc]init];
            
        }
    }
    
    [_statFilter setTitle:[NSString stringWithFormat:@"%d Followers",self.followers.count] forSegmentAtIndex:0];
    [_statFilter setTitle:[NSString stringWithFormat:@"%d Following",self.following.count] forSegmentAtIndex:1];
    
    
    [self.collectionView reloadData];
    [pService OnEndRequest];
}

-(void)getImagesError:(id)sender{
    [pService OnEndRequest];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.content.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = (Cell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.photo.image = [UIImage imageNamed:@"img.png"];
    
    [cell.photo loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[self.content objectAtIndex:indexPath.row] objectForKey:@"profile_img"]]]];
    
    
    
    
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100,100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    delegate.user_id = [[self.content objectAtIndex:indexPath.row] objectForKey:@"id"];

    
    CalendarViewController *calendar = [[CalendarViewController alloc]init];
    calendar.comesFromFollwers = 1;
    [self.navigationController pushViewController:calendar animated:YES];
    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
