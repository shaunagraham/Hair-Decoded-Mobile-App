//
//  FirstViewController.h
//  HairDecoded
//
//  Created by George on 23/01/14.
//  Copyright (c) 2014 Wedomobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Custom.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FirstViewController : UIViewController <FBLoginViewDelegate>
{
    WebServiceWrapper *pService;
    FBLoginView *loginview;
}
@property (retain, nonatomic) NSString *fbID;
@property (retain, nonatomic) NSString *type;
@property (retain, nonatomic) NSString *token;
@property (strong, nonatomic) FBRequestConnection *requestConnection;
@property (strong, nonatomic) NSMutableDictionary *userInfo;
@property (strong, nonatomic) NSMutableDictionary *check;
@property (assign, nonatomic) int isLoggedIn;

@end
