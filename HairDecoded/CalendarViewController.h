//
//  CalendarViewController.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom.h"

@interface CalendarViewController : UIViewController
{
    WebServiceWrapper *pService;
    NSDate *dt;
    int followInt;
    
}

@property (nonatomic, retain) NSMutableArray *content;
@property (nonatomic, retain) NSDictionary *info;
@property (nonatomic, retain) NSMutableArray *contentPictures;
@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSString *userID;

@property (nonatomic, assign) int comesFromFollwers;

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *hairType;
@property (weak, nonatomic) IBOutlet UILabel *aboutMe;
@property (weak, nonatomic) IBOutlet UILabel *followers;
@property (weak, nonatomic) IBOutlet UILabel *following;
@property (weak, nonatomic) IBOutlet UIButton *follow;

@end
