//
//  FAQViewController.m
//  HairDecoded
//
//  Created by George on 01/04/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController ()

@end

@implementation FAQViewController

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
    self.navigationItem.title = @"F.A.Q.";
    
    NSMutableString * allHTMLContent = [[NSMutableString alloc]init];
    [allHTMLContent appendString:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
     "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" /><title>Presentation</title>"
     "<style type=\"text/css\"><!--body {margin:0;background-color:transparent;}#content { margin:0 auto;width:320px;min-height: 40px;height: auto !important;height: 100%;}"
     ".title-text {	font-family:HelveticaNeue;font-size:15px;text-align:center;font-weight:bold;margin-top:20px;margin-bottom:10px;}.sig-text{ text-align:right;}.main-text {	font-family:HelveticaNeue-Light; font-size:14px;"
     "color:black;margin-bottom:10px;margin-left:5px;margin-right:5px;}--></style></head><body style='background-color: transparent'><div id=\"content\"><div class=\"main-text\">"];
    [allHTMLContent appendString:@"<strong><br>How do I find members or hairstyles?</strong><br>Go to the Home Page and type in the member name to find people.&nbsp; You can use a #hashtag to discover hairstyles.&nbsp;&nbsp;<strong><br><br>My hair does not fit in any category, can I still post?</strong><br>Yes, just choose the category for the most natural state of your hair. For example, if you were born with curly hair, but you are now bald, pick Curly as the category.<br><br>"];
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
