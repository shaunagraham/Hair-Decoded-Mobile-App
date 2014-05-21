//
//  DeleteAccountViewController.m
//  HairDecoded
//
//  Created by George on 28/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "DeleteAccountViewController.h"

@interface DeleteAccountViewController ()

@end

@implementation DeleteAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}
- (IBAction)deleteAccount:(id)sender {
    if ([self.contentText.text isEqualToString:@""]){
        ShowMessageBox(@"", @"Please add why you want to delete your account.", -1, nil);
        return;
    }
    self.content = self.contentText.text;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Are you sure?" message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes", nil];
    alert.tag = 11;
    [alert show];
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1){
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
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedout" object:nil];
    }
    else if (alertView.tag == 11){
        if (buttonIndex == 0){
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            [pService OnStartRequest];
            [self performSelectorInBackground:@selector(sendReportRequest:) withObject:nil];
        }
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    
    
    return YES;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = commonColor;
    self.navigationItem.title = @"Delete";
    
    [self.buttonAction.layer setMasksToBounds:YES];
	[self.buttonAction.layer setCornerRadius:5.0];
    self.buttonAction.backgroundColor = commonColor;
    
    [self.contentText.layer setMasksToBounds:YES];
	[self.contentText.layer setCornerRadius:5.0];
    [self.contentText.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.contentText.layer setBorderWidth:1.0];
}

-(void)sendReportRequest:(id)sender{
    
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&id=%@&reason=%@",DeleteAccount,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],ownID(),encodeString(self.content)];
        
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
            [self performSelectorOnMainThread:@selector(reportSuccess:) withObject:nil waitUntilDone:YES];
        }
        else {
            [self performSelectorOnMainThread:@selector(reportError:) withObject:nil waitUntilDone:YES];
        }
        
        
    }
    
    
}

-(void)reportSuccess:(id)sender{
    [pService OnEndRequest];
    ShowMessageBox(@"Your account has been deleted", @"", 1 , self);
    
}

-(void)reportError:(id)sender{
    [pService OnEndRequest];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
