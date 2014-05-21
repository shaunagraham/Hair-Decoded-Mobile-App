//
//  AddFriendsViewController.m
//  HairDecoded
//
//  Created by George on 28/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import "AddFriendsViewController.h"

@interface AddFriendsViewController ()

@end

@implementation AddFriendsViewController

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
    self.navigationItem.title = @"Add Friends";
    
    [self.fbFriends.layer setMasksToBounds:YES];
	[self.fbFriends.layer setCornerRadius:5.0];
    self.fbFriends.backgroundColor = [UIColor colorWithRed:59/255.0 green:85/255.0 blue:159/255.0 alpha:1.0];

    [self.twitter.layer setMasksToBounds:YES];
	[self.twitter.layer setCornerRadius:5.0];
    self.twitter.backgroundColor = [UIColor colorWithRed:0/255.0 green:171/255.0 blue:240/255.0 alpha:1.0];
   
    [self.contacts.layer setMasksToBounds:YES];
	[self.contacts.layer setCornerRadius:5.0];
    self.contacts.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];
    
    [self.invite.layer setMasksToBounds:YES];
	[self.invite.layer setCornerRadius:5.0];
    self.invite.backgroundColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
