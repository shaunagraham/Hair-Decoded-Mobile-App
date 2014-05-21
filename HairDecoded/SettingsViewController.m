//
//  SettingsViewController.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "SettingsViewController.h"
#import "AddFriendsViewController.h"
#import "ReportProblemViewController.h"
#import "PrivacyPolicyViewController.h"
#import "DeleteAccountViewController.h"
#import "ProfileViewController.h"
#import "AboutViewController.h"
#import "FAQViewController.h"
#import "ContactViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"Settings";
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationItem.title = @"Back";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    [[UIBarButtonItem appearance] setTintColor:commonColor];
    self.navigationItem.title = @"Settings";
   
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17.0];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    
//    if (indexPath.row == 0)cell.textLabel.text = @"Add Friends";
    if (indexPath.row == 0)cell.textLabel.text = @"Profile";
    if (indexPath.row == 1)cell.textLabel.text = @"About";
    if (indexPath.row == 2)cell.textLabel.text = @"F.A.Q.";
//    if (indexPath.row == 3){
//        cell.textLabel.text = @"Keep Private";
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        
//        if (self.keepPrivate == nil){
//            self.keepPrivate = [[UISwitch alloc]initWithFrame:CGRectMake(258, 10, 51, 31)];
//            [self.keepPrivate addTarget:self action:@selector(keepPrivate:) forControlEvents:UIControlEventValueChanged];
//            [cell.contentView addSubview:self.keepPrivate];
//        }
//        
//        [self.keepPrivate setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"keepPrivate"] boolValue]];
//    }
//    if (indexPath.row == 4){
//        cell.textLabel.text = @"Save Photos";
//        cell.accessoryType = UITableViewCellAccessoryNone;
//        
//        if (self.savePhotos == nil){
//            self.savePhotos = [[UISwitch alloc]initWithFrame:CGRectMake(258, 7, 51, 31)];
//            [self.savePhotos addTarget:self action:@selector(savePhotos:) forControlEvents:UIControlEventValueChanged];
//            [cell.contentView addSubview:self.savePhotos];
//        }
//        
//        [self.savePhotos setOn:[[[NSUserDefaults standardUserDefaults] objectForKey:@"savePhotos"] boolValue]];
//        
//        
//        
//    }
    if (indexPath.row == 3)cell.textLabel.text = @"Report A Problem";
    if (indexPath.row == 4)cell.textLabel.text = @"Privacy Policy";
    if (indexPath.row == 5)cell.textLabel.text = @"Contact";
    if (indexPath.row == 6){
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.text = @"Log Out";
    }
    if (indexPath.row == 7)cell.textLabel.text = @"Delete Account";
    
    
    
    return cell;
}

-(NSIndexPath*)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0){
        ProfileViewController *add = [[ProfileViewController alloc]init];
        add.isInitial = 0;
        [self.navigationController pushViewController:add animated:YES];
    }
    
    if (indexPath.row == 1){
        AboutViewController *add = [[AboutViewController alloc]init];
        [self.navigationController pushViewController:add animated:YES];
    }
    
    if (indexPath.row == 2){
        FAQViewController *add = [[FAQViewController alloc]init];
        [self.navigationController pushViewController:add animated:YES];
    }
    
    
    if (indexPath.row == 3){
        ReportProblemViewController *report = [[ReportProblemViewController alloc]init];
        [self.navigationController pushViewController:report animated:YES];
    }
    if (indexPath.row == 4){
        PrivacyPolicyViewController *policy = [[PrivacyPolicyViewController alloc]init];
        [self.navigationController pushViewController:policy animated:YES];
    }
    if (indexPath.row == 5){
        ContactViewController *policy = [[ContactViewController alloc]init];
        [self.navigationController pushViewController:policy animated:YES];
    }
    if (indexPath.row == 6){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cancel",@"Yes", nil];
        alert.tag = 1;
        [alert show];
    }
    if (indexPath.row == 7){
        DeleteAccountViewController *deleteAccount = [[DeleteAccountViewController alloc]init];
        [self.navigationController pushViewController:deleteAccount animated:YES];
    }
    
    
    
    
    return indexPath;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
        if (buttonIndex == 1){
            
            NSHTTPCookie *cookie;
            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
            for (cookie in [storage cookies])
            {
                NSString* domainName = [cookie domain];
                NSRange domainRange = [domainName rangeOfString:@"facebook"];
                if(domainRange.length > 0)
                {
                    [storage deleteCookie:cookie];
                }
            }
            [FBSession.activeSession closeAndClearTokenInformation];
            [[FBSession activeSession] close];
            [[FBSession activeSession] closeAndClearTokenInformation];
            [FBSession setActiveSession:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedout" object:nil];
        }
    }
}

-(void)savePhotos:(id)sender{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",self.savePhotos.isOn ? @"YES":@"NO"] forKey:@"savePhotos"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}
-(void)keepPrivate:(id)sender{
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",self.keepPrivate.isOn ? @"YES":@"NO"] forKey:@"keepPrivate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma UpdateProfile
//
//-(void)updateProfileRequest:(id)sender{
//    @autoreleasepool {
//        NSString *url = [NSString stringWithFormat:@"%@",UpdateProfile];
//        
//        
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10];
//        [request setHTTPMethod:@"POST"];
//        
//        
//        NSString *mpfBoundry = @"-----------------------------7d91191f100ca";
//        [request setValue:[NSString stringWithFormat:@"multipart/form-data, boundary=%@",mpfBoundry] forHTTPHeaderField:@"Content-Type"];
//        NSMutableData *postbody = [NSMutableData data];
//        
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"token\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"]] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"username\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithString:self.username.text] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        NSString *gender = @"";
//        if ([self.genderImage.image isEqual:[UIImage imageNamed:@"M_F1.png"]])gender = @"male";
//        else gender = @"female";
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"gender\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithString:gender] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"hair_type\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithString:[self.hairType.text lowercaseString]] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"describe\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithString:self.aboutMe.text] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        
//        
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"private\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithString:self.isPrivate] dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        [postbody appendData:[@"Content-Disposition: form-data; name=\"image\"; filename=\"profileimage.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
//        [postbody appendData:[NSData dataWithData:UIImageJPEGRepresentation(self.selectedImage.image, 1.0)]];
//        [postbody appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",mpfBoundry] dataUsingEncoding:NSUTF8StringEncoding]];
//        
//        
//        
//        [request setHTTPBody:postbody];
//        
//        NSString *strData = [[NSString alloc]initWithData:postbody encoding:NSUTF8StringEncoding];
//        ////NSLog(@"str %@",strData);
//        
//        NSHTTPURLResponse *response = nil;
//        NSError *error = nil;
//        
//        
//        
//        
//        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        
//        ////NSLog(@"%@",returnString);
//        
//        NSDictionary *dict = [returnString JSONValue];
//        
//        if ([[dict objectForKey:@"success"] boolValue] == TRUE){
//            
//            
//            
//            [self performSelectorOnMainThread:@selector(updateSuccess:) withObject:nil waitUntilDone:YES];
//        }
//        else {
//            [self performSelectorOnMainThread:@selector(updateError:) withObject:nil waitUntilDone:YES];
//            
//        }
//        
//        
//    }
//}
//
//-(void)updateSuccess:(id)sender{
//    
//}
//
//-(void)updateError:(id)sender{
//    [pService OnEndRequest];
//    ShowMessageBox(@"Error", @"Something went wrong. Please try again", -1, nil);
//}
//


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
