//
//  AppDelegate.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "PhotoViewController.h"
#import "CalendarViewController.h"
#import "CommentsViewController.h"
#import "ProfileViewController.h"

#import "SettingsViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                    fallbackHandler:^(FBAppCall *call) {
                        ////NSLog(@"In fallback handler");
                    }];
}

-(void)logged:(id)sender{
    
    for (UIView *v in [self.window subviews]) {
        [v removeFromSuperview];
    }
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"HelveticaNeue-Thin" size:19], NSFontAttributeName,nil];
        
    
    HomeViewController *home = [[HomeViewController alloc]init];
    home.title = @"Home";
    UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:home];
    
    CalendarViewController *calendar = [[CalendarViewController alloc]init];
    calendar.title = @" My Calendar";
    UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:calendar];
    
    PhotoViewController *photo = [[PhotoViewController alloc]init];
    photo.title = @"Upload";
    UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:photo];
    
    
    CommentsViewController *comments = [[CommentsViewController alloc]init];
    comments.title = @"Comments";
    UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:comments];

    
    SettingsViewController *settings = [[SettingsViewController alloc]init];
    settings.title = @"Settings";
    UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:settings];
    
    
    
    [nav1.tabBarItem setImage:[UIImage imageNamed:@"home.png"]];
    [nav2.tabBarItem setImage:[UIImage imageNamed:@"calender.png"]];
    [nav3.tabBarItem setImage:[UIImage imageNamed:@"photo.png"]];
    [nav4.tabBarItem setImage:[UIImage imageNamed:@"msg.png"]];
    [nav5.tabBarItem setImage:[UIImage imageNamed:@"settings.png"]];
    
    nav1.navigationBar.titleTextAttributes = textAttributes;
    nav2.navigationBar.titleTextAttributes = textAttributes;
    nav3.navigationBar.titleTextAttributes = textAttributes;
    nav4.navigationBar.titleTextAttributes = textAttributes;
    nav5.navigationBar.titleTextAttributes = textAttributes;
    
    self.tabBarController = [[UITabBarController alloc]init];
    self.tabBarController.delegate = self;

    [[UITabBar appearance] setBarTintColor: [UIColor colorWithRed:89/255.0 green:101/255.0 blue:115/255.0 alpha:1.0]];
    self.tabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"selectedTab.png"];
    
    
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    self.tabBarController.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
    self.tabBarController.delegate = self;
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    
    
}

-(void)loggedout:(id)sender{
    NSArray * directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * userPlistAtPath = [NSString stringWithFormat:@"%@/user.plist",[directoryPath objectAtIndex:0 ]];
    
        [[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]]writeToFile:userPlistAtPath atomically:NO];
    

    
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"hairdecoded_logged"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"hairdecoded_id"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"hairdecoded_token"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"hairdecoded_username"];
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"hairdecoded_profile_img"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
        
    for (UIView *v in [self.window subviews]) {
        [v removeFromSuperview];
    }
    
    NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIFont fontWithName:@"HelveticaNeue-Thin" size:19], NSFontAttributeName,nil];
    
    FirstViewController *first = [[FirstViewController alloc]init];
    
    self.navController = [[UINavigationController alloc]initWithRootViewController:first];
    self.navController.navigationBarHidden = YES;
    self.navController.navigationBar.titleTextAttributes = textAttributes;
    self.window.rootViewController = self.navController;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logged:) name:@"logged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loggedout:) name:@"loggedout" object:nil];
    
    NSArray * directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString * userPlistAtPath = [NSString stringWithFormat:@"%@/user.plist",[directoryPath objectAtIndex:0 ]];
    
    if(![[NSMutableArray alloc]initWithContentsOfFile:userPlistAtPath])
    {
        [[[NSMutableArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"user.plist" ofType:nil]]writeToFile:userPlistAtPath atomically:NO];
    }

    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_logged"] boolValue] == TRUE){
        
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"HelveticaNeue-Thin" size:19], NSFontAttributeName,nil];

        
        HomeViewController *home = [[HomeViewController alloc]init];
        home.title = @"Home";
        UINavigationController *nav1 = [[UINavigationController alloc]initWithRootViewController:home];
        
        CalendarViewController *calendar = [[CalendarViewController alloc]init];
        calendar.title = @" My Calendar";
        UINavigationController *nav2 = [[UINavigationController alloc]initWithRootViewController:calendar];
        
        PhotoViewController *photo = [[PhotoViewController alloc]init];
        photo.title = @"Upload";
        UINavigationController *nav3 = [[UINavigationController alloc]initWithRootViewController:photo];
        
        
        CommentsViewController *comments = [[CommentsViewController alloc]init];
        comments.title = @"Comments";
        UINavigationController *nav4 = [[UINavigationController alloc]initWithRootViewController:comments];
        
        
        SettingsViewController *settings = [[SettingsViewController alloc]init];
        settings.title = @"Settings";
        UINavigationController *nav5 = [[UINavigationController alloc]initWithRootViewController:settings];
        
        
        
        [nav1.tabBarItem setImage:[UIImage imageNamed:@"home.png"]];
        [nav2.tabBarItem setImage:[UIImage imageNamed:@"calender.png"]];
        [nav3.tabBarItem setImage:[UIImage imageNamed:@"photo.png"]];
        [nav4.tabBarItem setImage:[UIImage imageNamed:@"msg.png"]];
        [nav5.tabBarItem setImage:[UIImage imageNamed:@"settings.png"]];

        nav1.navigationBar.titleTextAttributes = textAttributes;
        nav2.navigationBar.titleTextAttributes = textAttributes;
        nav3.navigationBar.titleTextAttributes = textAttributes;
        nav4.navigationBar.titleTextAttributes = textAttributes;
        nav5.navigationBar.titleTextAttributes = textAttributes;

        self.tabBarController = [[UITabBarController alloc]init];
        [[UITabBar appearance] setBarTintColor: [UIColor colorWithRed:89/255.0 green:101/255.0 blue:115/255.0 alpha:1.0]];
        self.tabBarController.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"selectedTab.png"];
        
        [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
        self.tabBarController.viewControllers = @[nav1,nav2,nav3,nav4,nav5];
        self.tabBarController.delegate = self;
        self.window.rootViewController = self.tabBarController;
        [self.window makeKeyAndVisible];
        
  
        
        self.user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_id"];
        
    }
    else {
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"HelveticaNeue-Thin" size:19], NSFontAttributeName,nil];

        FirstViewController *first = [[FirstViewController alloc]init];
        
        self.navController = [[UINavigationController alloc]initWithRootViewController:first];
        self.navController.navigationBarHidden = YES;
        self.navController.navigationBar.titleTextAttributes = textAttributes;
        self.window.rootViewController = self.navController;
    }
    
    
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if (tabBarController.selectedIndex == 0 || tabBarController.selectedIndex == 3){
        NSLog(@"4444asdasd");
        UINavigationController *nav = (UINavigationController*)viewController;
        [nav popToRootViewControllerAnimated:YES];
    }
    if ([viewController isEqual:[[tabBarController viewControllers] objectAtIndex:1]]){
        NSLog(@"didselect1");
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.user_id = ownID();
    }
    
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

    if (tabBarController.selectedIndex == 1){
        NSLog(@"didselect");
        AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
        delegate.user_id = ownID();
    }
    if (tabBarController.selectedIndex == 0 || tabBarController.selectedIndex == 3){
        UINavigationController *navController = (UINavigationController *)viewController;
        [navController popToRootViewControllerAnimated:NO];
    }

}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    NSMutableArray *content = GetComm();
    
    if (content == nil){}
    else {
        int badge = 0;
        NSDateFormatter *formatDate = [[NSDateFormatter alloc]init];
        [formatDate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *datelast = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastDate"];
        
        for (NSDictionary *dictionary in content) {
            NSString *dateString = [NSString stringWithFormat:@"%@ %@",[dictionary objectForKey:@"day"],[dictionary objectForKey:@"hour"]];
            
            
            
            
            NSString *str = [formatDate stringFromDate:datelast];
            NSDate *today = [formatDate dateFromString:str];
            NSDate *day = [formatDate dateFromString:dateString];
            
            if ([day compare:today] == NSOrderedDescending)badge++;
            
            //NSLog(@"%@ %@",dateString, str);
        }
        NSString *dateString = [NSString stringWithFormat:@"%@ %@",[[content objectAtIndex:0] objectForKey:@"day"],[[content objectAtIndex:0] objectForKey:@"hour"]];

        if (datelast == nil)badge = content.count;
        
        [[NSUserDefaults standardUserDefaults] setValue:[formatDate dateFromString:dateString] forKey:@"lastDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //NSLog(@"testing %d",content.count);
        
        if (badge>0){
            UITabBarItem *tabItem = [[[self.tabBarController tabBar] items] objectAtIndex:3];
            [tabItem setBadgeValue:[NSString stringWithFormat:@"%d",badge]];

        }
        
    }
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
