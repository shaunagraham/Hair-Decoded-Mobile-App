//
//  ReportProblemViewController.m
//  HairDecoded
//
//  Created by George on 28/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "ReportProblemViewController.h"

@interface ReportProblemViewController ()

@end

@implementation ReportProblemViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        pService = [WebServiceWrapper sharedWebServiceWrapper];
    }
    return self;
}


- (IBAction)sendReport:(id)sender {
    if ([self.content.text isEqualToString:@""]){
        ShowMessageBox(@"", @"Please report the problem.", -1, nil);
        return;
    }
    self.contentText = self.content.text;
    
    [pService OnStartRequest];
    [self performSelectorInBackground:@selector(sendReportRequest:) withObject:nil];
}

-(void)sendReportRequest:(id)sender{
    
    @autoreleasepool {
        NSString *url = [NSString stringWithFormat:@"%@&token=%@&problem=%@",ProblemReport,[[NSUserDefaults standardUserDefaults] objectForKey:@"hairdecoded_token"],encodeString(self.contentText)];
        
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
    ShowMessageBox(@"Report sent.", @"", 1 , self);
    
}

-(void)reportError:(id)sender{
    [pService OnEndRequest];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1)[self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.tintColor = commonColor;
    self.navigationItem.title = @"Send Report";
    
    [self.buttonAction.layer setMasksToBounds:YES];
	[self.buttonAction.layer setCornerRadius:5.0];
    self.buttonAction.backgroundColor = commonColor;

    [self.content.layer setMasksToBounds:YES];
	[self.content.layer setCornerRadius:5.0];
    [self.content.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.content.layer setBorderWidth:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
