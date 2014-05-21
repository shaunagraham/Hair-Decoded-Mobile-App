//
//  HomeViewController.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "HomeViewController.h"
#import "Cell.h"
#import "ContentPictureViewController.h"
#import "CalendarViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}
- (IBAction)selectHairType:(id)sender {
    NSString *hair_type = @"";
    
    self.likePhotosLabel.hidden = YES;
    self.nothingFound.hidden = YES;
    self.noFollow.hidden = YES;
    
    [self.content removeAllObjects];
    
    if ([self.hairSegment selectedSegmentIndex] == 4){
        self.search.text = @"";
        [pService OnStartRequest];
        [self performSelectorInBackground:@selector(getLikedImages:) withObject:nil];
    }
    else {

        if (![self.search.text isEqualToString:@""]){
            [self refresh:nil];
        }

        if ([self.hairSegment selectedSegmentIndex] == 0)hair_type = @"straight";
        if ([self.hairSegment selectedSegmentIndex] == 1)hair_type = @"wavy";
        if ([self.hairSegment selectedSegmentIndex] == 2)hair_type = @"curly";
        if ([self.hairSegment selectedSegmentIndex] == 3)hair_type = @"kinky";
        
        for (NSDictionary *value in self.allContent) {
            if ([[value objectForKey:@"hair_type"] isEqualToString:hair_type])[self.content addObject:value];
        }
    }
    

    
    [self.collectionView reloadData];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    ////NSLog(@"didbegin editing");
    self.likePhotosLabel.hidden = YES;
    _viewHidden.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.search.frame = CGRectMake(self.search.frame.origin.x, self.search.frame.origin.y-201, self.search.frame.size.width, self.search.frame.size.height);
    [UIView commitAnimations];

}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
  
    [textField resignFirstResponder];
    return YES;
}

-(void)profilePage:(id)sender{
    CalendarViewController *calendar = [[CalendarViewController alloc]init];
    calendar.comesFromFollwers = 1;
    [self.navigationController pushViewController:calendar animated:YES];
}

-(void)dismissAlertView{
    [alert dismissWithClickedButtonIndex:-1 animated:YES];
}

-(void)done{
    _viewHidden.hidden = YES;
    self.noFollow.hidden = YES;
    self.nothingFound.hidden = YES;
    self.likePhotosLabel.hidden = YES;
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(searchInfo:) withObject:nil];
    [self.search resignFirstResponder];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.search.frame = CGRectMake(self.search.frame.origin.x, self.search.frame.origin.y+201, self.search.frame.size.width, self.search.frame.size.height);
    [UIView commitAnimations];
    
}

-(void)cancelButton{
    _viewHidden.hidden = YES;
    [self.search resignFirstResponder];
    self.search.text = @"";
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.search.frame = CGRectMake(self.search.frame.origin.x, self.search.frame.origin.y+201, self.search.frame.size.width, self.search.frame.size.height);
    [UIView commitAnimations];
    self.nothingFound.hidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _viewHidden = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
    _viewHidden.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_viewHidden];
    [self.view bringSubviewToFront:self.search];
    [_viewHidden setHidden:YES];
    
    if (!IS_IPHONE_5){
        self.hairSegment.frame = CGRectMake(self.hairSegment.frame.origin.x, self.hairSegment.frame.origin.y-88, self.hairSegment.frame.size.width, self.hairSegment.frame.size.height);
        self.search.frame = CGRectMake(self.search.frame.origin.x, self.search.frame.origin.y-88, self.search.frame.size.width, self.search.frame.size.height);
        self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.size.width, self.collectionView.frame.size.height-88);
    }
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh:) name:@"refresh" object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"favorites-full.png"] style:UIBarButtonItemStylePlain target:self action:@selector(getImageFollowers:)];
    
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"rate"] boolValue]){
        alert = [[UIAlertView alloc]initWithTitle:@"Discover hairstyles daily!"  message:nil delegate:nil cancelButtonTitle:nil  otherButtonTitles:@"Ok",nil];
        [alert show];
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"rate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      //  [self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:2];
    }
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM d"];
    self.navigationItem.title = [format stringFromDate:[NSDate date]];
    
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle = UIBarStyleBlackTranslucent;
    UIBarButtonItem *privacy = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButton)];
    UIBarButtonItem *barFlexible = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:cancel,barFlexible,privacy, nil]];
    self.search.inputAccessoryView = toolbar;


    [[UIBarButtonItem appearance] setTintColor:commonColor];
    
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"Cell"];
    


    
    [[UIBarButtonItem appearance] setTintColor:commonColor];
    formatDate = [[NSDateFormatter alloc]init];
    [formatDate setDateFormat:@"yyyy-MM-dd"];
    [self.hairSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    NSString *today = [formatDate stringFromDate:[NSDate date]];
    
    selectedDate = [formatDate dateFromString:today];
    
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getImagesRequest:) withObject:nil];
    
    

}

-(void)nextDay:(id)sender{
    selectedDate = [selectedDate dateByAddingTimeInterval:3600*24];
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getImagesRequest:) withObject:nil];
    
}
-(void)previousDay:(id)sender{
    selectedDate = [selectedDate dateByAddingTimeInterval:-3600*24];
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getImagesRequest:) withObject:nil];
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
    
    if ([self.search.text isEqualToString:@""]){
        
        [cell.photo loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[self.content objectAtIndex:indexPath.row] objectForKey:@"img"]]]];
    }
    else {
        if ([self.search.text rangeOfString:@"#"].location == NSNotFound) {
            ////NSLog(@"user search");
            [cell.photo loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[self.content objectAtIndex:indexPath.row] objectForKey:@"profile_img"]]]];
        } else {
            ////NSLog(@"image  search");
            [cell.photo loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[[self.content objectAtIndex:indexPath.row] objectForKey:@"img"]]]];
        }
    }

    
    

    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100,100);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([self.search.text isEqualToString:@""]){
        
        ContentPictureViewController *content = [[ContentPictureViewController alloc]init];
       // content.hidesBottomBarWhenPushed = YES;
        content.currentDay = selectedDate;
        content.currentSelection = indexPath.row;
        content.content = self.content;
        [self.navigationController pushViewController:content animated:YES];
        
        
    }
    else {
        if ([self.search.text rangeOfString:@"#"].location == NSNotFound) {
            ////NSLog(@"user search");
            AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            
            delegate.user_id = [[self.content objectAtIndex:indexPath.row] objectForKey:@"id"];
            CalendarViewController *calendar = [[CalendarViewController alloc]init];
            calendar.comesFromFollwers = 1;
            [self.navigationController pushViewController:calendar animated:YES];

        } else {
            ////NSLog(@"image  search");
            ContentPictureViewController *content = [[ContentPictureViewController alloc]init];
         //   content.hidesBottomBarWhenPushed = YES;
            content.currentDay = selectedDate;
            content.currentSelection = indexPath.row;
            content.content = self.content;
            [self.navigationController pushViewController:content animated:YES];;
        }
    }
    
    

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM d"];
    self.navigationItem.title = [format stringFromDate:[NSDate date]];

    
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"Back";
//    self.search.text = @"";
}


#pragma getImageFollowers

-(void)getImageFollowers:(id)sender{
    self.search.text = @"";
    self.noFollow.hidden = YES;
    self.nothingFound.hidden = YES;
    self.likePhotosLabel.hidden = YES;
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getImageFollowersRequest:) withObject:nil];
}

-(void)getImageFollowersRequest:(id)sender{
    @autoreleasepool {
        
        
        
        NSString *url = [NSString stringWithFormat:@"%@&token=%@",GetFollowImages,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"]];
        
        NSLog(@"%@",url);
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            self.content = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            [self performSelectorOnMainThread:@selector(getFollowImagesSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getFollowImagesError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getFollowImagesSuccess:(id)sender{
    
    if (self.content.count == 0)self.noFollow.hidden = NO;
    else self.noFollow.hidden = YES;
    
    [self.collectionView reloadData];
    
    [pService OnEndRequest];
}

-(void)getFollowImagesError:(id)sender{
    [pService OnEndRequest];
}


#pragma Get Images

-(void)getImagesRequest:(id)sender{
    @autoreleasepool {
        

        
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&userdate=%@",GetImages,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],[formatDate stringFromDate:selectedDate]];
        
        ////NSLog(@"%@",url);
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            self.content = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            self.allContent = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            [self performSelectorOnMainThread:@selector(getImagesSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getImagesError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getImagesSuccess:(id)sender{
    
    [self.collectionView reloadData];
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"yyyy-MM-dd"];
    
 
    self.nothingFound.hidden = YES;

    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM d"];
    self.navigationItem.title = [format stringFromDate:selectedDate];

    
    NSString *hair_type = @"";
    
    if ([self.hairSegment selectedSegmentIndex] == 0)hair_type = @"straight";
    if ([self.hairSegment selectedSegmentIndex] == 1)hair_type = @"wavy";
    if ([self.hairSegment selectedSegmentIndex] == 2)hair_type = @"curly";
    if ([self.hairSegment selectedSegmentIndex] == 3)hair_type = @"kinky";
    
    if (![hair_type isEqualToString:@""]){
        NSMutableArray *toRemove = [[NSMutableArray alloc]init];
        
        for (NSDictionary *value in self.content) {
            if (![[value objectForKey:@"hair_type"] isEqualToString:hair_type])[toRemove addObject:value];
        }
        [self.content removeObjectsInArray:toRemove];
    }
    
    
    
    [pService OnEndRequest];
}

-(void)getImagesError:(id)sender{
    [pService OnEndRequest];
}

#pragma getLikedImages

-(void)getLikedImages:(id)sender{
    @autoreleasepool {
        
        
        
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&id=%@",GetLikedImages,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],ownID()];
        
        ////NSLog(@"%@",url);
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            self.content = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            
            NSMutableArray *toRemove = [[NSMutableArray alloc]init];
            for (NSDictionary *values in self.content) {
                
                if ([[values objectForKey:@"liked"] boolValue] == false)[toRemove addObject:values];
            }
            [self.content removeObjectsInArray:toRemove];
            
            [self performSelectorOnMainThread:@selector(getLikedImagesSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getLikedImagesError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getLikedImagesSuccess:(id)sender{
    
    if (self.content.count == 0)self.likePhotosLabel.hidden = NO;
    else self.likePhotosLabel.hidden = YES;
    
    [self.collectionView reloadData];
    
    [pService OnEndRequest];
}

-(void)getLikedImagesError:(id)sender{
    [pService OnEndRequest];
}

#pragma searchInfo

-(void)searchInfo:(id)sender{
    @autoreleasepool {
        
        NSString *url = @"";
       
        
        if ([self.search.text rangeOfString:@"#"].location == NSNotFound) {
            ////NSLog(@"string does not contain bla");
            url =  [NSString stringWithFormat:@"%@&token=%@&textsearched=%@",SearchUser,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],encodeString(self.search.text)];

        } else {
            ////NSLog(@"string contains bla!");
            url = [NSString stringWithFormat:@"%@&token=%@&textsearched=%@",SearchImage,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],encodeString(self.search.text)];

        }
        
        
        ////NSLog(@"%@",url);
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        ////NSLog(@"%@",returnString);
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            self.content = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            [self performSelectorOnMainThread:@selector(searchInfoSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(searchInfoError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)searchInfoSuccess:(id)sender{

    if (self.content.count == 0)self.nothingFound.hidden = NO;
    else self.nothingFound.hidden = YES;
    
    [self.collectionView reloadData];
    
    [pService OnEndRequest];
}

-(void)refresh:(id)sender{
    self.search.text = @"";
    self.noFollow.hidden = YES;
    
    formatDate = [[NSDateFormatter alloc]init];
    [formatDate setDateFormat:@"yyyy-MM-dd"];
    [self.hairSegment setSelectedSegmentIndex:UISegmentedControlNoSegment];
    NSString *today = [formatDate stringFromDate:[NSDate date]];
    
    selectedDate = [formatDate dateFromString:today];
    
    [pService OnStartRequest];
     [self performSelectorInBackground:@selector(getImagesRequest:) withObject:nil];
}

-(void)searchInfoError:(id)sender{
    [pService OnEndRequest];
    [self.content removeAllObjects];
    if (self.content.count == 0)self.nothingFound.hidden = NO;
    else self.nothingFound.hidden = YES;
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
