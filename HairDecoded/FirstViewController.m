//
//  FirstViewController.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "FirstViewController.h"
#import "HairTypeViewController.h"
#import <Social/Social.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}
- (IBAction)signInFacebook:(id)sender {
    for (id obj in loginview.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]])
        {
            UIButton * loginButton =  obj;
            [loginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        if ([obj isKindOfClass:[UILabel class]])
        {
        }
    }
    
}

- (IBAction)SignInGoogle:(id)sender {
}

- (IBAction)SignInTwitter:(id)sender {
    [pService OnStartRequest];
    self.userInfo = [[NSMutableDictionary alloc]init];
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil
                                  completion:^(BOOL granted, NSError *error)
    {
        if (granted == YES)
        {
            NSArray *arrayOfAccounts = [account
                                        accountsWithAccountType:accountType];
            
            if ([arrayOfAccounts count] > 0)
            {
                ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
                NSDictionary *params = @{@"screen_name" : twitterAccount.username  };
                                         
                
                SLRequest *request =
                [SLRequest requestForServiceType:SLServiceTypeTwitter
                                   requestMethod:SLRequestMethodGET
                                             URL:url
                                      parameters:params];
                
                //  Attach an account to the request
                [request setAccount:[arrayOfAccounts lastObject]];
                
                //  Step 3:  Execute the request
                [request performRequestWithHandler:^(NSData *responseData,
                                                     NSHTTPURLResponse *urlResponse,
                                                     NSError *error) {
                    if (responseData) {
                        
                        if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                            [self performSelectorOnMainThread:@selector(twitterdetails:)
                                                   withObject:responseData waitUntilDone:YES];
                        }
                        else {
                            
                            NSLog(@"The response status code is %d", urlResponse.statusCode);
                        }
                    }
                }];
                
            }
            else {
                [self performSelectorOnMainThread:@selector(errorGive1:)
                                       withObject:nil waitUntilDone:YES];
            }
            
            
        }
        else {
            [self performSelectorOnMainThread:@selector(errorGive:)
        withObject:nil waitUntilDone:YES];

        }
        
    }];
    
    

}

-(void)errorGive:(id)sender{
    [pService OnEndRequest];
    ShowMessageBox(@"Please grant access from your device Settings", @"You need to give access to Twitter accounts or add accounts in order to login to the app.", -1, nil);
}

-(void)errorGive1:(id)sender{
    [pService OnEndRequest];
    ShowMessageBox(@"No Twitter Account found. Please set up in Settings.", @"", -1, nil);
}

-(void)twitterdetails:(NSData *)responseData{
    NSError* error = nil;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          options:NSJSONReadingAllowFragments
                          error:&error];
    
    NSString *scrnm = [json objectForKey:@"screen_name"];
    NSString *twitterid = [json objectForKey:@"id"];
    NSString *prof_img = [json objectForKey:@"profile_image_url"];
    
    [self.userInfo setValue:[NSString stringWithFormat:@"%@",twitterid] forKey:@"id"];
    [self.userInfo setValue:@"" forKey:@"gender"];
    [self.userInfo setValue:prof_img forKey:@"urlImage"];
    [self.userInfo setValue:scrnm forKey:@"username"];
    [self.userInfo setValue:[NSString stringWithFormat:@"%@@twitter.com",scrnm] forKey:@"email"];
    [self performSelectorOnMainThread:@selector(pushtoHair:) withObject:nil waitUntilDone:NO];

}

-(void)pushtoHair:(id)sender{
    
    self.type = @"twitter";
   // [pService OnStartRequest];
    [self performSelectorInBackground:@selector(checkAccount:) withObject:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    loginview = [[FBLoginView alloc] init];
    loginview.frame = CGRectMake(4, 95, 271, 37);
    loginview.delegate = self;
    loginview.readPermissions = @[@"email", @"user_photos",@"user_birthday"];
    [self.view addSubview:loginview];
    [self.view sendSubviewToBack:loginview];
    self.isLoggedIn = 0;
    
}

-(void)push:(id)sender{
    
}
- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView{
    //NSLog(@"xxxx");
    self.isLoggedIn = 1;
    
}

-(void)loginView:(FBLoginView *)loginView handleError:(NSError *)error{
    
    NSLog(@"%@",error);
    ShowMessageBox(@"Something went wrong with Facebook login.", @"Make sure you granted access to Facebook from device settings.", -1, nil);
    
}
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user{
     //NSLog(@"xxxx");
    self.fbID = [user objectForKey:@"id"];
    self.userInfo = [[NSMutableDictionary alloc]initWithDictionary:(NSDictionary*)user];
    
    if (self.isLoggedIn == 1){
        self.type = @"facebook";
        [pService OnStartRequest];
        [self performSelectorInBackground:@selector(checkAccount:) withObject:nil];
    }
    
    
//    // FBSample logic
//    // Check to see whether we have already opened a session.
//    if (FBSession.activeSession.isOpen) {
//        // login is integrated with the send button -- so if open, we send
//        [self sendRequests];
//    } else {
//        
//        //        NSArray *permissions = [[NSArray alloc] initWithObjects:
//        //                                @"user_photos",
//        //                                nil];
//        
//        [FBSession openActiveSessionWithReadPermissions:nil
//                                           allowLoginUI:YES
//                                      completionHandler:^(FBSession *session,
//                                                          FBSessionState status,
//                                                          NSError *error) {
//                                          // if login fails for any reason, we alert
//                                          if (error) {
//                                              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
//                                                                                              message:error.localizedDescription
//                                                                                             delegate:nil
//                                                                                    cancelButtonTitle:@"OK"
//                                                                                    otherButtonTitles:nil];
//                                              [alert show];
//                                              // if otherwise we check to see if the session is open, an alternative to
//                                              // to the FB_ISSESSIONOPENWITHSTATE helper-macro would be to check the isOpen
//                                              // property of the session object; the macros are useful, however, for more
//                                              // detailed state checking for FBSession objects
//                                          } else if (FB_ISSESSIONOPENWITHSTATE(status)) {
//                                              // send our requests if we successfully logged in
//                                              [self sendRequests];
//                                          }
//                                      }];
//    }
}



//- (void)sendRequests {
//    // extract the id's for which we will request the profile
//    
//    // create the connection object
//    FBRequestConnection *newConnection = [[FBRequestConnection alloc] init];
//    
//    // for each fbid in the array, we create a request object to fetch
//    // the profile, along with a handler to respond to the results of the request
//    
//    // create a handler block to handle the results of the request for fbid's profile
//    FBRequestHandler handler =
//    ^(FBRequestConnection *connection, id result, NSError *error) {
//        // output the results of the request
//        [self requestCompleted:connection forFbID:self.fbID result:result error:error];
//    };
//    
//    // create the request object, using the fbid as the graph path
//    // as an alternative the request* static methods of the FBRequest class could
//    // be used to fetch common requests, such as /me and /me/friends
//    FBRequest *request = [[FBRequest alloc] initWithSession:FBSession.activeSession
//                                                  graphPath:[NSString stringWithFormat:@"%@",@"me/albums?fields=id,cover_photo,name"]];
//    [newConnection addRequest:request completionHandler:handler];
//    
//    
//    // if there's an outstanding connection, just cancel
//    [self.requestConnection cancel];
//    
//    // keep track of our connection, and start it
//    self.requestConnection = newConnection;
//    [newConnection start];
//}

//- (void)requestCompleted:(FBRequestConnection *)connection
//                 forFbID:fbID
//                  result:(id)result
//                   error:(NSError *)error {
//    // not the completion we were looking for...
//    if (self.requestConnection &&
//        connection != self.requestConnection) {
//        return;
//    }
//    
//    // clean this up, for posterity
//    self.requestConnection = nil;
//    
//    
//    NSString *text;
//    if (error) {
//        // error contains details about why the request failed
//        text = error.localizedDescription;
//    } else {
//        // result is the json response from a successful request
//        NSDictionary *dictionary = (NSDictionary *)result;
//        // we pull the name property out, if there is one, and display it
//        text = (NSString *)[dictionary objectForKey:@"name"];
//        
//        self.albums = [[NSMutableArray alloc]initWithArray:(NSArray*)[dictionary objectForKey:@"data"]];
//        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
//        
//        NSDateFormatter *facebookFormat = [[NSDateFormatter alloc]init];
//        [facebookFormat setDateFormat:@"MM/dd/yyyy"];
//        
//        NSDate *date = [facebookFormat dateFromString:[self.userInfo objectForKey:@"birthday"]];
//        
//        NSDateFormatter *serverFormat = [[NSDateFormatter alloc]init];
//        [serverFormat setDateFormat:@"yyyy-MM-dd"];
//        [delegate.initialProfile setValue:[serverFormat stringFromDate:date] forKey:@"birthday"];
//        [delegate.initialProfile setValue:self.fbID forKey:@"fbid"];
//        [delegate.initialProfile setValue:delegate.device_token forKey:@"device_token"];
//        
//        [self performSelectorInBackground:@selector(createProfileRequest:) withObject:nil];
//        
//        
//        
//    }
//    
//    
//    
//    
//}

-(void)checkAccount:(id)sender{
    @autoreleasepool {
        
        
        
        NSString *url = [NSString stringWithFormat:@"%@&api_user_id=%@&app_code=%@",CheckUserAccount,[self.userInfo objectForKey:@"id"],self.type];
        
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
            
            self.check = [dict objectForKey:@"response"];
            [self performSelectorOnMainThread:@selector(checkSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(checkError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
}

-(void)checkSuccess:(id)sender{
    [pService OnEndRequest];
    if ([[self.check objectForKey:@"reason"] isKindOfClass:[NSString class]]){
        HairTypeViewController *hair = [[HairTypeViewController alloc]init];
        hair.userInfo = self.userInfo;
        hair.app_code = self.type;
        [self.navigationController pushViewController:hair animated:YES];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setValue:@"YES" forKey:@"hairdecoded_logged"];
        [[NSUserDefaults standardUserDefaults] setValue:[[self.check objectForKey:@"reason"] objectForKey:@"token"] forKey:@"hairdecoded_token"];
        [[NSUserDefaults standardUserDefaults] setValue:[[self.check objectForKey:@"reason"] objectForKey:@"id"] forKey:@"hairdecoded_id"];
        [[NSUserDefaults standardUserDefaults] setValue:[[self.check objectForKey:@"reason"] objectForKey:@"username"] forKey:@"hairdecoded_username"];
        [[NSUserDefaults standardUserDefaults] setValue:[[self.check objectForKey:@"reason"] objectForKey:@"profile_img"] forKey:@"hairdecoded_profile_img"];
         AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
        
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        delegate.user_id = ownID();
        
        NSArray * directoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * pathPlist = [NSString stringWithFormat:@"%@/user.plist",[directoryPath objectAtIndex:0]];
        NSURL * urlPlist = [NSURL fileURLWithPath:pathPlist];
        [[self.check objectForKey:@"reason"] writeToURL:urlPlist atomically:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logged" object:nil];
    }
    
    
}

-(void)checkError:(id)sender{
    [pService OnEndRequest];
    HairTypeViewController *hair = [[HairTypeViewController alloc]init];
    hair.userInfo = self.userInfo;
    hair.app_code = self.type;
    [self.navigationController pushViewController:hair animated:YES];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
