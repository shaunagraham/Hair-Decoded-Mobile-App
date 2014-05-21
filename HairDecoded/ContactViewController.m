//
//  ContactViewController.m
//  HairDecoded
//
//  Created by George on 01/04/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "ContactViewController.h"

@interface ContactViewController ()

@end

@implementation ContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}
- (IBAction)sendContact:(id)sender {
    if ([self.name.text isEqualToString:@""]){
        ShowMessageBox(@"Please fill name.", @"", -1, nil);
        return;
    }
    if ([self.message.text isEqualToString:@""]){
        ShowMessageBox(@"Please add message.", @"", -1, nil);
        return;
    }
    if ([self.name.text isEqualToString:@""] || [self.username.text isEqualToString:@""] || [self.email.text isEqualToString:@""] || [self.message.text isEqualToString:@""]){
        ShowMessageBox(@"All fields are required", @"", -1, nil);
        return;
    }
    self.messageText = self.message.text;
    
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(sendReportRequest:) withObject:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return TRUE;
}

- (void)textViewDidChange:(UITextView *)txtView
{
    self.textHolder.hidden = ([txtView.text length] > 0);
}

- (void)textViewDidEndEditing:(UITextView *)txtView
{
    self.textHolder.hidden = ([txtView.text length] > 0);
    self.messageText = self.message.text;
    [UIView beginAnimations:nil context:nil];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
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
    
    if (!IS_IPHONE_5) {
        self.send.frame = CGRectMake(self.send.frame.origin.x, self.send.frame.origin.y-88, self.send.frame.size.width, self.send.frame.size.height);
    }
    
    
    self.username.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    self.email.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);
    self.name.layer.sublayerTransform = CATransform3DMakeTranslation(7, 0, 0);

    
    self.username.text = [NSString stringWithFormat:@"%@",userContent(@"username")];
    self.email.text = [NSString stringWithFormat:@"%@",userContent(@"email")];
//    self.name.text = [NSString stringWithFormat:@"  %@",userContent(@"username")];
    
    self.navigationController.navigationBar.tintColor = commonColor;
      [[UIBarButtonItem appearance] setTintColor:commonColor];
    self.navigationItem.title = @"Contact";
    
    [self.send.layer setMasksToBounds:YES];
	[self.send.layer setCornerRadius:5.0];
    self.send.backgroundColor = commonColor;
    
    [self.name.layer setMasksToBounds:YES];
	[self.name.layer setCornerRadius:5.0];
    [self.name.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.name.layer setBorderWidth:1.0];
    
    [self.username.layer setMasksToBounds:YES];
	[self.username.layer setCornerRadius:5.0];
    [self.username.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.username.layer setBorderWidth:1.0];
    
    [self.email.layer setMasksToBounds:YES];
	[self.email.layer setCornerRadius:5.0];
    [self.email.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.email.layer setBorderWidth:1.0];
    
    [self.message.layer setMasksToBounds:YES];
	[self.message.layer setCornerRadius:5.0];
    [self.message.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.message.layer setBorderWidth:1.0];
}

-(void)sendReportRequest:(id)sender{
    
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&username=%@&name=%@&email=%@&message=%@",Contact,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],encodeString(self.username.text),encodeString(self.name.text),encodeString(self.email.text),encodeString(self.messageText)];
        
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
    ShowMessageBox(@"Message sent.", @"", 1 , self);
    
}

-(void)reportError:(id)sender{
    [pService OnEndRequest];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)[self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
