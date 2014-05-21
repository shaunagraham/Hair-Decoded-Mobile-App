//
//  HairTypeViewController.m
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "HairTypeViewController.h"
#import "ProfileViewController.h"

@interface HairTypeViewController ()

@end

@implementation HairTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)HairTypeSelected:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    
    ProfileViewController *create = [[ProfileViewController alloc]init];
    create.app_code = self.app_code;
    create.userInfo = self.userInfo;
    create.isInitial = 1;
    create.hairTypeSelected = btn.tag;
    [self.navigationController pushViewController:create animated:YES];
    
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    alert = [[UIAlertView alloc]initWithTitle:@"Pick Your Hair Type"  message:nil delegate:nil cancelButtonTitle:nil  otherButtonTitles:@"Ok",nil];
	[alert show];
    
    if (!IS_IPHONE_5) {
        self.l1.frame = CGRectMake(self.l1.frame.origin.x, self.l1.frame.origin.y-44, self.l1.frame.size.width, self.l1.frame.size.height);
        self.l2.frame = CGRectMake(self.l2.frame.origin.x, self.l2.frame.origin.y-44, self.l2.frame.size.width, self.l2.frame.size.height);
        self.l3.frame = CGRectMake(self.l3.frame.origin.x, self.l3.frame.origin.y-88, self.l3.frame.size.width, self.l3.frame.size.height);
        self.l4.frame = CGRectMake(self.l4.frame.origin.x, self.l4.frame.origin.y-88, self.l4.frame.size.width, self.l4.frame.size.height);
    }
    
    
   // [self performSelector:@selector(dismissAlertView) withObject:nil afterDelay:1];

}

-(void)dismissAlertView{
   [alert dismissWithClickedButtonIndex:-1 animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
