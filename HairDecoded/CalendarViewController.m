//
//  CalendarViewController.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "CalendarViewController.h"
#import "CKCalendarView.h"
#import "ContentPictureViewController.h"
#import "Custom.h"
#import "FollowersViewController.h"
#import "ProfileViewController.h"


@interface CalendarViewController () <CKCalendarDelegate>

@property(nonatomic, strong) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSMutableArray *disabledDates;

@end


@implementation CalendarViewController

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
    self.navigationItem.title = @"Back";
    if (self.isMovingFromParentViewController || self.isBeingDismissed) {
        // Do your stuff here
        _comesFromFollwers = 1;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    

    [super viewWillAppear:animated];
    

    dt = [NSDate date];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    NSLog(@"owwwwww %@",delegate.user_id);
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getCalendarRequest:) withObject:nil];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM d"];
    self.navigationItem.title = [format stringFromDate:dt];
    
}

#pragma Get Calendar

-(void)getCalendarRequest:(id)sender{
    @autoreleasepool {
        NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
        [formatDate setDateFormat:@"yyyy-MM-dd"];
        
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&userdate=%@&id=%@",GetCalendar,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],[formatDate stringFromDate:dt],delegate.user_id];
        
        //NSLog(@"%@",url);
        
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [returnString JSONValue];
        NSLog(@"%@",dict);
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            self.content = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            self.info = [dict objectForKey:@"response"];
            
            [self performSelectorOnMainThread:@selector(getCalendarSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getCalendarError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getCalendarSuccess:(id)sender{
    
    NSLog(@"456 %d",self.content.count);
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"MM"];
    


    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM d"];
    self.navigationItem.title = [format stringFromDate:dt];
    
    NSString *pathToDefaultPlist = [docs stringByAppendingPathComponent:@"user.plist"];
    NSURL *urlxx =[NSURL fileURLWithPath:pathToDefaultPlist];
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]initWithContentsOfURL:urlxx];
    NSLog(@"%@",dictionary);
    NSDictionary *dd = [self.info objectForKey:@"user_profile"];
    
    if ([ownID() isEqualToString:[dd objectForKey:@"id"] ]){
        NSLog(@"intra aici");
        [self.imgProfile loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[dictionary objectForKey:@"profile_img"]]]];
        
        self.username.text = [NSString stringWithFormat:@"%@ | %@",[dictionary objectForKey:@"username"],[dictionary objectForKey:@"hair_type"]];
        self.aboutMe.text = [dictionary objectForKey:@"describe"];
        self.aboutMe.frame = CGRectMake(78, 24, 237, 62);
        [self.aboutMe sizeToFit];
     //   self.navigationItem.leftBarButtonItem = nil;
       
        [self.follow setTitle:@"Edit" forState:UIControlStateNormal];
        [self.follow setTitleColor:commonColor forState:UIControlStateNormal];
        self.follow.backgroundColor = UIColor.whiteColor;
    }
    else {
        NSLog(@"not own id");
        
        [self.imgProfile loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[dd objectForKey:@"profile_img"]]]];
        
        self.username.text = [NSString stringWithFormat:@"%@ | %@",[dd objectForKey:@"username"],[dd objectForKey:@"hair_type"]];
        self.aboutMe.text = [dd objectForKey:@"describe"];
        self.aboutMe.frame = CGRectMake(78, 24, 237, 62);
        [self.aboutMe sizeToFit];
        self.follow.hidden = NO;
        if ([[self.info objectForKey:@"isfollow"] intValue] == 0){
            [self.follow setTitle:@"Follow" forState:UIControlStateNormal];
            [self.follow setTitleColor:commonColor forState:UIControlStateNormal];
            self.follow.backgroundColor = UIColor.whiteColor;
        }
        else {
            [self.follow setTitle:@"Following" forState:UIControlStateNormal];
            [self.follow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.follow.backgroundColor = commonColor;
        }
        
    }
    

    
    [self setRightButtonWithIntValue:[[[self.info objectForKey:@"nrFollowers"] stringValue] intValue]];
    
    
    //NSLog(@"4566 %@",self.info);
    
    if (self.content.count)[self.calendar reloadData];
    [pService OnEndRequest];
}


-(void)getCalendarError:(id)sender{
    [pService OnEndRequest];
    
    NSDictionary *dd = [self.info objectForKey:@"user_profile"];
    [self.imgProfile loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[dd objectForKey:@"profile_img"]]]];
    
    self.username.text = [NSString stringWithFormat:@"%@ | %@",[dd objectForKey:@"username"],[dd objectForKey:@"hair_type"]];
    self.aboutMe.text = [dd objectForKey:@"describe"];
    [self.aboutMe sizeToFit];
    
 //   ShowMessageBox(@"No images on selected month", @"", -1, nil);
}

-(IBAction)follow_unfollow:(id)sender{
    UIButton *item = (UIButton*)sender;
    
    if ([[item titleForState:UIControlStateNormal] isEqualToString:@"Follow"]){
        followInt = 1;
        [pService OnStartRequest];
        [self performSelectorInBackground:@selector(follow_unfollowRequest:) withObject:nil];

    }
    else if ([[item titleForState:UIControlStateNormal] isEqualToString:@"Following"]){
        followInt = -1;
        [pService OnStartRequest];
        [self performSelectorInBackground:@selector(follow_unfollowRequest:) withObject:nil];

    }
    else {
        ProfileViewController *add = [[ProfileViewController alloc]init];
        add.isInitial = 0;
        [self.navigationController pushViewController:add animated:YES];
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self.follow.layer setBorderWidth:1.2];
    [self.follow.layer setBorderColor:commonColor.CGColor];
    [self.follow setTitleColor:commonColor forState:UIControlStateNormal];
    self.follow.titleLabel.font =[UIFont fontWithName:@"HelveticaNeue" size:11.0];
    
    
    self.navigationController.navigationBar.tintColor = commonColor;
    [[UIBarButtonItem appearance] setTintColor:commonColor];
    
    
    CALayer* layer = [self.followers layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = [UIColor lightGrayColor].CGColor;
    bottomBorder.borderWidth = 1;
    bottomBorder.frame = CGRectMake(0, 0, 0.5, layer.frame.size.height);
    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    [layer addSublayer:bottomBorder];
    
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startSunday];
    self.calendar = calendar;
    calendar.delegate = self;
    [calendar setDateFont:[UIFont fontWithName:@"HelveticaNeue-Thin" size:14.0]];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(0, 110, 320, 420);
    [self.view addSubview:calendar];
    [self.view bringSubviewToFront:self.topView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    [format setDateFormat:@"MMMM d"];
    self.navigationItem.title = [format stringFromDate:[NSDate date]];
    
    
}

-(void)previousMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:-1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    dt = [calendar dateByAddingComponents:dateComponents toDate:dt options:0];

    
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getCalendarRequest:) withObject:nil];
}

-(void)nextMonth{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:1];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    dt = [calendar dateByAddingComponents:dateComponents toDate:dt options:0];
    
    
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(getCalendarRequest:) withObject:nil];
}


- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (NSString*)imageForDate:(NSDate *)date {
    for (NSDictionary *withDate in self.content) {
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        int day = (int)[components day];
        NSArray *sep = [[withDate objectForKey:@"day"] componentsSeparatedByString:@"-"];
        if (day == [[sep lastObject] intValue])return [withDate objectForKey:@"img"];
        
    }
    return @"";
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(DateButton *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    
    ////NSLog(@"called");
    
    [dateItem.img setImage:[UIImage imageNamed:@"img.png"]];
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"yyyy-MM-dd"];
    
    NSString *str = [f2 stringFromDate:[NSDate date]];
    
    NSDate *date2 = [f2 dateFromString:str];
    
     if (![[self imageForDate:date] isEqualToString:@""]) {
         ////NSLog(@"%@",[NSString stringWithFormat:@"%@%@",ImageURL,[self imageForDate:date]]);
         dateItem.img.backgroundColor = [UIColor clearColor];

        [dateItem.img loadFromURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,[self imageForDate:date]]]];
    }
     else {
         dateItem.img.backgroundColor = [UIColor whiteColor];

         if ([date2 compare:date] == NSOrderedSame)dateItem.img.image = [UIImage imageNamed:@"addPlus.png"];
         else dateItem.img.image = [UIImage imageNamed:@"img.png"];
         
     }
    
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    
    return YES;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
    
    if (date == nil)return;
    
    NSDateFormatter *f2 = [[NSDateFormatter alloc] init];
    [f2 setDateFormat:@"yyyy-MM-dd"];
    
    AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    NSString *str = [f2 stringFromDate:[NSDate date]];
    
    NSDate *date2 = [f2 dateFromString:str];
    
    ////NSLog(@"%@",[f2 stringFromDate:date]);
    
    
    
    if ([date compare:date2] == NSOrderedSame){
        ////NSLog(@"e azi");
        if ([delegate.user_id isEqualToString:ownID()]){
            if (![[self imageForDate:date] isEqualToString:@""]){
                self.selectedDate = date;
                
                [pService OnStartRequest];
                [self performSelectorInBackground:@selector(getImagesRequest:) withObject:nil];
            }
            else {
                ////NSLog(@"de ce intra aici");
                [self.tabBarController setSelectedIndex:2];
            }
        }
        else{
            if (![[self imageForDate:date] isEqualToString:@""]){
                self.selectedDate = date;
                
                [pService OnStartRequest];
                [self performSelectorInBackground:@selector(getImagesRequest:) withObject:nil];
            }
        }

    }
    else {
        
        if (![[self imageForDate:date] isEqualToString:@""]){
            self.selectedDate = date;
            
            [pService OnStartRequest];
            [self performSelectorInBackground:@selector(getImagesRequest:) withObject:nil];
        }
        
        
    }
    
    

}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        //        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        //        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    ////NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


#pragma Get Images

-(void)getImagesRequest:(id)sender{
    @autoreleasepool {
        
        NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
        [formatDate setDateFormat:@"yyyy-MM-dd"];
        
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&userdate=%@&id=%@",GetImages,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],[formatDate stringFromDate:self.selectedDate],[[self.info objectForKey:@"user_profile"] objectForKey:@"id"]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [returnString JSONValue];
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            self.contentPictures = [[NSMutableArray alloc]initWithArray:(NSArray*)[[dict objectForKey:@"response"] objectForKey:@"profile"]];
            
            
            
            [self performSelectorOnMainThread:@selector(getImagesSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(getImagesError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)getImagesSuccess:(id)sender{
    
    [pService OnEndRequest];

    //self.hidesBottomBarWhenPushed = NO;
    ContentPictureViewController *content = [[ContentPictureViewController alloc]init];

    content.currentDay = self.selectedDate;
    content.currentSelection = 0;
    content.content = self.contentPictures;
    [self.navigationController pushViewController:content animated:YES];
    
    
    
    
}

-(void)getImagesError:(id)sender{
    [pService OnEndRequest];
}

#pragma Follow

-(void)follow_unfollowRequest:(id)sender{
    @autoreleasepool {
        
        NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
        [formatDate setDateFormat:@"yyyy-MM-dd"];
        
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&value=%d&id=%@",FollowUser,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],followInt,[[self.info objectForKey:@"user_profile"] objectForKey:@"id"]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
        [request setHTTPMethod:@"GET"];
        
        NSHTTPURLResponse *response = nil;
        NSError *error = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSDictionary *dict = [returnString JSONValue];
        NSLog(@"123 %@",returnString);
        
        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
            
            
            [self performSelectorOnMainThread:@selector(followSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(followError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)followSuccess:(id)sender{
    
    [pService OnEndRequest];
    if (followInt == -1){
        int value = [[[self.info objectForKey:@"nrFollowers"] stringValue]intValue];
        value--;
        [self setRightButtonWithIntValue:value];
        [self.info setValue:[NSNumber numberWithInt:value] forKey:@"nrFollowers"];
        [self.follow setTitle:@"Follow" forState:UIControlStateNormal];
        [self.follow setTitleColor:commonColor forState:UIControlStateNormal];
        self.follow.backgroundColor = UIColor.whiteColor;
    }
    else {
        int value = [[[self.info objectForKey:@"nrFollowers"] stringValue]intValue];
        value++;
        [self setRightButtonWithIntValue:value];
        [self.info setValue:[NSNumber numberWithInt:value] forKey:@"nrFollowers"];
        [self.follow setTitle:@"Following" forState:UIControlStateNormal];
        [self.follow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.follow.backgroundColor = commonColor;
   
    }

}

-(void)setRightButtonWithIntValue:(int)value{
    UIImage *chatImage = [UIImage imageNamed:@"favorites_modified.png"];
    
    UIButton *chatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chatButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0];
    [chatButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    chatButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //    [chatButton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [chatButton addTarget:self action:@selector(followers:) forControlEvents:UIControlEventTouchUpInside];
    [chatButton setBackgroundImage:chatImage forState:UIControlStateNormal];
  //  [chatButton setTitle:[NSString stringWithFormat:@"      %d",value] forState:UIControlStateNormal];
    chatButton.frame = (CGRect) {
        .size.width = 30,
        .size.height = 26,
    };
    
    UIBarButtonItem *barButton= [[UIBarButtonItem alloc] initWithCustomView:chatButton];
    self.navigationItem.rightBarButtonItem = barButton;

}

-(void)backBTN:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)followError:(id)sender{
    [pService OnEndRequest];
}


-(void)followers:(id)sender{
    
    if ([[[self.info objectForKey:@"nrFollowers"] stringValue] intValue]> 0 || [[[self.info objectForKey:@"nrFollowers"] stringValue] intValue]> 0){
        FollowersViewController *follower = [[FollowersViewController alloc]init];
        follower.followerID = [[self.info objectForKey:@"user_profile"] objectForKey:@"id"];
        [self.navigationController pushViewController:follower animated:YES];
    }
    else {
        ShowMessageBox(@"No Followers", @"", -1, nil);
    }
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
