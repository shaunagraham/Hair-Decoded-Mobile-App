//
//  AboutViewController.m
//  HairDecoded
//
//  Created by George on 01/04/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.tintColor = commonColor;
    self.navigationItem.title = @"About";
    
    NSMutableString * allHTMLContent = [[NSMutableString alloc]init];
    [allHTMLContent appendString:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
     "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" /><title>Presentation</title>"
     "<style type=\"text/css\"><!--body {margin:0;background-color:transparent;}#content { margin:0 auto;width:320px;min-height: 40px;height: auto !important;height: 100%;}"
     ".title-text {	font-family:HelveticaNeue;font-size:15px;text-align:center;font-weight:bold;margin-top:20px;margin-bottom:10px;}.sig-text{ text-align:right;}.main-text {	font-family:HelveticaNeue-Light;font-size:14px;"
     "color:black;margin-bottom:10px;margin-left:5px;margin-right:5px;}--></style></head><body style='background-color: transparent'><div id=\"content\"><div class=\"main-text\">"];
    
    [allHTMLContent appendString:@"<p>Hair Decoded Calendar is a mobile app for tracking and sharing hairstyles. Users can upload photos every day to their calendar and share, connect, and comment on all hairstyles.&nbsp;</p>&nbsp;&nbsp; &nbsp;You can use Hair Decoded Calendar to:<ul><li>Create and track hair regimens</li><li>Search and discover new hairstyles</li><li>Upload photos</li><li>Comment and share hair ideas and products</li></ul>"];
    [allHTMLContent appendString:@"<br><br></div></body></html>"];
    
    [allHTMLContent replaceOccurrencesOfString:@"&gt;" withString:@">" options:NSLiteralSearch range:NSMakeRange(0, [allHTMLContent length])];
    [allHTMLContent replaceOccurrencesOfString:@"&lt;" withString:@"<" options:NSLiteralSearch range:NSMakeRange(0, [allHTMLContent length])];
    
    [_webView loadHTMLString:allHTMLContent baseURL:nil];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
