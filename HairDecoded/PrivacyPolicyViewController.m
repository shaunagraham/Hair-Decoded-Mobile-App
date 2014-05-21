//
//  PrivacyPolicyViewController.m
//  HairDecoded
//
//  Created by George on 28/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "PrivacyPolicyViewController.h"

@interface PrivacyPolicyViewController ()

@end

@implementation PrivacyPolicyViewController

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
    self.navigationItem.title = @"Privacy Policy";
    
    NSMutableString * allHTMLContent = [[NSMutableString alloc]init];
    [allHTMLContent appendString:@"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
     "<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\" /><title>Presentation</title>"
     "<style type=\"text/css\"><!--body {margin:0;background-color:transparent;}#content { margin:0 auto;width:320px;min-height: 40px;height: auto !important;height: 100%;}"
     ".title-text {	font-family:HelveticaNeue;font-size:15px;text-align:center;font-weight:bold;margin-top:20px;margin-bottom:10px;}.sig-text{ text-align:right;}.main-text {	font-family:HelveticaNeue-Light;font-size:14px;"
     "color:black;margin-bottom:10px;margin-left:5px;margin-right:5px;}--></style></head><body style='background-color: transparent'><div id=\"content\"><div class=\"main-text\">"];
    
    [allHTMLContent appendString:@"<p>Our goal at Hair Decoded Calendar is to provide a mobile content-sharing platform where users track and share hairstyles daily. Users discover new hairstyles and comment on regimens.</p><p>We only collect your username and email when you register with Hair Decoded Calendar though Facebook or Twitter. We safely keep all posted content, comments, and photos. We only use your public information for promotional items on our social networks, events, and press.</p><p>We share items online on <a href=\"http://facebook.com/hairdecoded\">http://facebook.com/hairdecoded</a>, <a href=\"http://twitter/hairdecoded\">http://twitter.com/hairdecoded</a>, <a href=\"http://instagram.com/hairdecoded\">http://instagram.com/hairdecoded</a>  and <a href=\"http://www.hairdecoded.com\">http://hairdecoded.com</a>. If you have any questions or concerns, feel free to contact us anytime. We change our privacy policy with the growth of our features. Please keep up-to-date of new changes to our policy.</p>"];
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
